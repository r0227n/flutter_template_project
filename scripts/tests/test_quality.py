"""Small fixtures: no Flutter SDK, package download, or native build."""

import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[2]


def load(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


quality = load("quality")
stop = load("codex_stop")


class PlanTests(unittest.TestCase):
    def test_dependency_and_configuration_changes_check_all_consumers(self):
        for path in (
            "pubspec.lock", "pubspec.yaml", "pubspec_overrides.yaml", "analysis_options.yaml", ".mise.toml",
            "packages/renamed-directory/pubspec.yaml", "app/build.yaml",
            "packages/design_system/lib/token.dart", "app/assets/i18n/ja.i18n.json",
            ".github/workflows/check-pr.yml", "scripts/quality.py",
        ):
            with self.subTest(path=path):
                self.assertTrue(quality.plan({path})["dart_required"])

    def test_docs_do_not_require_flutter(self):
        result = quality.plan({"docs/guide with spaces.md", ".agents/skills/example/SKILL.md"})
        self.assertFalse(result["dart_required"])
        self.assertTrue(result["format_required"])

    def test_empty_change_and_format_config(self):
        self.assertFalse(any(quality.plan(set()).values()))
        self.assertTrue(quality.plan({"dprint.json"})["format_required"])
        self.assertTrue(all(quality.plan(set(), all_files=True).values()))


class GitFixtureTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="template quality ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.git("init", "-q")
        self.git("config", "user.name", "Fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        self.write("app/old name.dart", "old\n")
        self.write("README.md", "base\n")
        self.git("add", ".")
        self.git("commit", "-qm", "fixture base")
        self.base = self.git("rev-parse", "HEAD")

    def git(self, *args):
        return subprocess.check_output(["git", *args], cwd=self.root, text=True).strip()

    def write(self, path, contents):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(contents)

    def test_staged_unstaged_untracked_removal_and_rename(self):
        self.git("mv", "app/old name.dart", "app/new name.dart")
        self.write("README.md", "changed\n")
        self.write("docs/space\nnewline.md", "untracked\n")
        paths = quality.changed_paths(self.root)
        self.assertEqual(paths, {"app/old name.dart", "app/new name.dart", "README.md", "docs/space\nnewline.md"})
        self.assertTrue(quality.plan(paths)["dart_required"])
        self.git("commit", "-qm", "fixture rename")
        self.git("rm", "app/new name.dart")
        self.assertIn("app/new name.dart", quality.changed_paths(self.root))

    def test_clean_worktree_and_pr_commit_range(self):
        self.assertEqual(quality.changed_paths(self.root), set())
        self.write("pubspec.lock", "fixture\n")
        self.git("add", ".")
        self.git("commit", "-qm", "fixture lock")
        paths = quality.changed_paths(self.root, self.base, "HEAD")
        self.assertEqual(paths, {"pubspec.lock"})

    def test_invalid_revision_is_failure(self):
        with contextlib.redirect_stderr(io.StringIO()):
            with self.assertRaises(subprocess.CalledProcessError):
                quality.changed_paths(self.root, self.base, "does-not-exist")


class RunnerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def prepare(self):
        packages = []
        for name in ("melos", "slang", "test"):
            package = self.root / "prepared" / name
            (package / "bin").mkdir(parents=True)
            (package / "bin" / f"{name}.dart").write_text("fixture executable")
            packages.append({"name": name, "rootUri": package.as_uri() + "/"})
        config = self.root / ".dart_tool/package_config.json"
        config.parent.mkdir()
        config.write_text(json.dumps({"configVersion": 2, "packages": packages}))
        return config

    def test_missing_tool_and_unprepared_dependencies_do_not_run_commands(self):
        with mock.patch.object(quality.shutil, "which", return_value=None), mock.patch.object(quality.subprocess, "run") as run:
            with self.assertRaisesRegex(RuntimeError, "Missing tools"):
                quality.run_checks(self.root, {"app/lib/a.dart"})
            run.assert_not_called()
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/tool"), mock.patch.object(quality.subprocess, "run") as run:
            with self.assertRaisesRegex(RuntimeError, "not prepared"):
                quality.run_checks(self.root, {"app/lib/a.dart"})
            run.assert_not_called()

    def test_all_workspace_commands_do_not_fix_or_bootstrap(self):
        self.prepare()
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/tool"), mock.patch.object(quality.subprocess, "run") as run, contextlib.redirect_stdout(io.StringIO()):
            quality.run_checks(self.root, {"packages/design_system/lib/a.dart"}, checks="dart")
        commands = [call.args[0] for call in run.call_args_list]
        self.assertIn("--output=none --set-exit-if-changed", commands[0][-1])
        self.assertIn("dart analyze --fatal-infos", commands[1][-1])
        self.assertIn("--depends-on=slang", commands[2])
        self.assertIn("--disable-dart-dev", commands[2][-1])
        self.assertTrue(all(command[:2] == ["dart", "--disable-dart-dev"] for command in commands))
        self.assertIn("--dir-exists=test", commands[3])
        self.assertIn("flutter test --no-pub", commands[3][-1])
        self.assertFalse(any("--scope" in arg for command in commands for arg in command))
        self.assertFalse(any("bootstrap" in command or "get" in command or "install" in command for command in commands))

    def test_failure_stops_later_checks(self):
        self.prepare()
        failure = subprocess.CalledProcessError(1, ["melos", "run", "ci:format"])
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/tool"), mock.patch.object(quality.subprocess, "run", side_effect=failure) as run, contextlib.redirect_stdout(io.StringIO()):
            with self.assertRaises(subprocess.CalledProcessError):
                quality.run_checks(self.root, {"app/lib/a.dart"})
        self.assertEqual(run.call_count, 1)

    def test_stale_dependency_resolution_does_not_launch_tools(self):
        config = self.prepare()
        os.utime(config, ns=(1, 1))
        (self.root / "pubspec.lock").write_text("updated resolution\n")
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/shim"), mock.patch.object(quality.subprocess, "run") as run:
            with self.assertRaisesRegex(RuntimeError, "stale"):
                quality.run_checks(self.root, {"pubspec.lock"})
            run.assert_not_called()

    def test_new_override_is_stale(self):
        config = self.prepare()
        os.utime(config, ns=(1, 1))
        (self.root / "pubspec_overrides.yaml").write_text("dependency_overrides: {}\n")
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/tool"), mock.patch.object(quality.subprocess, "run") as run:
            with self.assertRaisesRegex(RuntimeError, "stale"):
                quality.run_checks(self.root, {"pubspec_overrides.yaml"})
            run.assert_not_called()

    def test_missing_sdk_shim_cannot_autoinstall(self):
        self.prepare()
        binary = self.root / "bin"
        binary.mkdir()
        shim = binary / "dart"
        shim.write_text('#!/bin/sh\nif [ "$MISE_AUTO_INSTALL" = 0 ] && [ "$MISE_NOT_FOUND_AUTO_INSTALL" = 0 ]; then exit 42; fi\ntouch "$INSTALL_MARKER"\n')
        shim.chmod(0o755)
        marker = self.root / "installed"
        env = dict(os.environ, PATH=str(binary), INSTALL_MARKER=str(marker))
        with mock.patch.dict(os.environ, env, clear=True), mock.patch.object(quality.shutil, "which", return_value=str(shim)), contextlib.redirect_stdout(io.StringIO()):
            with self.assertRaises(subprocess.CalledProcessError) as failure:
                quality.run_checks(self.root, {"app/lib/a.dart"}, checks="dart")
        self.assertEqual(failure.exception.returncode, 42)
        self.assertFalse(marker.exists())

    def test_glob_filenames_cannot_skip_dprint(self):
        with mock.patch.object(quality.shutil, "which", return_value="/fixture/tool"), mock.patch.object(quality.subprocess, "run") as run, contextlib.redirect_stdout(io.StringIO()):
            quality.run_checks(self.root, {"docs/[draft].md"}, checks="format")
        self.assertEqual(run.call_args.args[0], ["dprint", "check"])


class StopTests(unittest.TestCase):
    def test_success_and_failure_are_valid_json_decisions(self):
        for status in (0, 1):
            with self.subTest(status=status), mock.patch.object(stop.subprocess, "Popen") as popen:
                popen.return_value.wait.return_value = status
                result = stop.handle({"hook_event_name": "Stop", "stop_hook_active": False, "cwd": "/untrusted", "last_assistant_message": "ignored"})
                self.assertEqual(json.loads(json.dumps(result)), result)
                self.assertEqual(result.get("decision"), "block" if status else None)
                self.assertEqual(popen.call_args.kwargs["cwd"], stop.ROOT)
                self.assertEqual(popen.call_args.kwargs["stdout"], sys.stderr)

    def test_continuation_never_reexecutes(self):
        with mock.patch.object(stop.subprocess, "Popen") as popen:
            result = stop.handle({"hook_event_name": "Stop", "stop_hook_active": True})
            popen.assert_not_called()
            self.assertNotIn("decision", result)
            self.assertIn("skipped", result["systemMessage"])

    def test_invalid_event_never_runs_input(self):
        for event in ([], {}, {"hook_event_name": "Stop", "stop_hook_active": "false"}, {"hook_event_name": "Other", "stop_hook_active": False}):
            with self.subTest(event=event), mock.patch.object(stop.subprocess, "Popen") as popen:
                result = stop.handle(event)
                popen.assert_not_called()
                self.assertIn("systemMessage", result)

    def test_timeout_kills_process_group(self):
        with mock.patch.object(stop.subprocess, "Popen") as popen, mock.patch.object(stop.os, "killpg") as killpg:
            popen.return_value.pid = 1234
            popen.return_value.wait.side_effect = [subprocess.TimeoutExpired("quality", 480), 0]
            result = stop.handle({"hook_event_name": "Stop", "stop_hook_active": False})
            killpg.assert_called_once_with(1234, stop.signal.SIGKILL)
            self.assertEqual(result["decision"], "block")

    def test_hook_command_from_nested_directory_with_spaces(self):
        config = json.loads((ROOT / ".codex/hooks.json").read_text())
        command = config["hooks"]["Stop"][0]["hooks"][0]["command"]
        with tempfile.TemporaryDirectory(prefix="template hook ") as temp:
            root = Path(temp)
            scripts = root / "scripts"
            scripts.mkdir()
            shutil.copyfile(ROOT / "scripts/codex_stop.py", scripts / "codex_stop.py")
            (scripts / "quality.py").write_text("import sys\nprint('fixture log')\nsys.exit(1)\n")
            nested = root / "app/sub dir"
            nested.mkdir(parents=True)
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            env = dict(os.environ, PATH=str(Path(sys.executable).parent) + os.pathsep + os.environ["PATH"])
            event = {"hook_event_name": "Stop", "stop_hook_active": False}
            result = subprocess.run(["bash", "-c", command], cwd=nested, env=env, input=json.dumps(event), text=True, capture_output=True, check=True)
            self.assertEqual(json.loads(result.stdout)["decision"], "block")
            self.assertIn("fixture log", result.stderr)
            event["stop_hook_active"] = True
            continued = subprocess.run(["bash", "-c", command], cwd=nested, env=env, input=json.dumps(event), text=True, capture_output=True, check=True)
            self.assertNotIn("decision", json.loads(continued.stdout))
            self.assertEqual(continued.stderr, "")


if __name__ == "__main__":
    unittest.main()
