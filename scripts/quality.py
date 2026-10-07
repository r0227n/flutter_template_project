#!/usr/bin/env python3
"""Shared, non-fixing quality checks for the current Dart workspace."""

import argparse
import json
import os
from pathlib import Path
import shutil
import shlex
import subprocess
import sys
from urllib.parse import unquote, urljoin, urlparse

ROOT = Path(__file__).resolve().parents[1]
FORMAT_SUFFIXES = {".md", ".yaml", ".yml", ".toml", ".css"}
DART_CONFIGS = {"pubspec.yaml", "pubspec_overrides.yaml", "pubspec.lock", "analysis_options.yaml", "build.yaml"}
DPRINT_CONFIGS = {"dprint.json", "dprint.jsonc", ".dprint.json", ".dprint.jsonc"}


def git_paths(root, *args):
    result = subprocess.run(
        ["git", *args], cwd=root, check=True, stdout=subprocess.PIPE
    )
    return {os.fsdecode(path) for path in result.stdout.split(b"\0") if path}


def changed_paths(root, base=None, head=None):
    if base is not None:
        # Compare the PR's merge base, keeping removals and both rename sides.
        return git_paths(root, "diff", "--name-only", "--no-renames", "-z", f"{base}...{head}", "--")
    return (
        git_paths(root, "diff", "--name-only", "--no-renames", "-z", "--")
        | git_paths(root, "diff", "--cached", "--name-only", "--no-renames", "-z", "--")
        | git_paths(root, "ls-files", "--others", "--exclude-standard", "-z")
    )


def plan(paths, all_files=False):
    dart = all_files or any(
        Path(path).suffix == ".dart"
        or path.endswith(".i18n.json")
        or Path(path).name in DART_CONFIGS
        or path == ".mise.toml"
        or path.startswith(("scripts/", ".github/"))
        or path.startswith("app/assets/")
        for path in paths
    )
    formatting = all_files or any(
        Path(path).suffix in FORMAT_SUFFIXES or Path(path).name in DPRINT_CONFIGS
        for path in paths
    )
    tooling = all_files or any(
        path.startswith(("scripts/", ".codex/", ".agents/", ".github/"))
        or path in ("AGENTS.md", "CLAUDE.md", ".mise.toml")
        for path in paths
    )
    return {"dart_required": dart, "format_required": formatting, "tooling_required": tooling}


def package_binary(root, name):
    config = root / ".dart_tool/package_config.json"
    resolution = json.loads(config.read_text())
    if resolution.get("configVersion") != 2:
        raise RuntimeError("Unsupported package config; prepare the workspace explicitly.")
    for package in resolution.get("packages", []):
        if package.get("name") == name:
            uri = urlparse(urljoin(config.as_uri(), package["rootUri"]))
            if uri.scheme != "file" or uri.netloc not in ("", "localhost"):
                raise RuntimeError("Package config must reference local prepared packages.")
            binary = Path(unquote(uri.path)) / "bin" / f"{name}.dart"
            if binary.is_file():
                return binary
    raise RuntimeError(f"Prepared package executable is missing: {name}. Follow README setup.")


def vm_command(root, name):
    # Bypass dart run's executable resolver, which can implicitly run pub get.
    binary = package_binary(root, name)
    if name == "melos":
        binary = ROOT / "scripts/melos_entrypoint.dart"
    return ["dart", "--disable-dart-dev", f"--packages={root / '.dart_tool/package_config.json'}", str(binary)]


def run_checks(root, paths, checks="all", all_files=False):
    selected = plan(paths, all_files)
    dart = selected["dart_required"] and checks in ("all", "dart")
    formatting = selected["format_required"] and checks in ("all", "format")
    tools = (["dart", "flutter"] if dart else []) + (["dprint"] if formatting else [])
    missing = [tool for tool in tools if shutil.which(tool) is None]
    if missing:
        raise RuntimeError("Missing tools: " + ", ".join(missing) + ". Follow README setup; no tools were installed.")
    if dart and not (root / ".dart_tool/package_config.json").is_file():
        raise RuntimeError("Workspace dependencies are not prepared. Follow README setup; no pub get was run.")
    if dart:
        # Dependency changes require an explicit refresh of the prepared config.
        config = root / ".dart_tool/package_config.json"
        manifests = [root / name for name in ("pubspec.yaml", "pubspec_overrides.yaml", "pubspec.lock")]
        manifests.extend(root.glob("app/pubspec*.yaml"))
        manifests.extend(root.glob("packages/*/pubspec*.yaml"))
        if any(path.is_file() and path.stat().st_mtime_ns > config.stat().st_mtime_ns for path in manifests):
            raise RuntimeError("Workspace dependency resolution is stale. Run the authorized locked setup explicitly; no pub get was run.")
    environment = dict(os.environ, MISE_AUTO_INSTALL="0", MISE_NOT_FOUND_AUTO_INSTALL="0")
    commands = []
    if selected["tooling_required"] and checks == "all":
        commands.append([sys.executable, "-B", "-m", "unittest", "discover", "-s", "scripts/tests", "-v"])
    if dart:
        melos = vm_command(root, "melos")
        slang = shlex.join(vm_command(root, "slang") + ["analyze"])
        try:
            dart_test = shlex.join(vm_command(root, "test"))
        except RuntimeError:
            dart_test = 'echo "Pure Dart test package is not prepared" >&2; exit 1'
        commands.extend([
            melos + ["exec", "--", "dart format --output=none --set-exit-if-changed ."],
            melos + ["exec", "--", "dart analyze --fatal-infos"],
            melos + ["exec", "--depends-on=slang", "--", slang],
            melos + ["exec", "--fail-fast", "--concurrency=1", "--dir-exists=test", "--",
                     f'if grep -q "flutter:" pubspec.yaml; then flutter test --no-pub; else {dart_test}; fi'],
        ])
    if formatting:
        # Full configured formatting avoids treating literal filenames as globs.
        commands.append(["dprint", "check"])
    for command in commands:
        print("Quality:", " ".join(command), flush=True)
        subprocess.run(command, cwd=root, check=True, env=environment)
    print("Quality checks passed." if commands else "No applicable quality checks.", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base")
    parser.add_argument("--head")
    parser.add_argument("--all", action="store_true", dest="all_files")
    parser.add_argument("--plan", action="store_true")
    parser.add_argument("--checks", choices=("all", "dart", "format"), default="all")
    args = parser.parse_args()
    if bool(args.base) != bool(args.head) or (args.all_files and args.base):
        parser.error("Use --base and --head together, or --all, or local changes.")
    try:
        paths = set() if args.all_files else changed_paths(ROOT, args.base, args.head)
        if args.plan:
            for key, value in plan(paths, args.all_files).items():
                print(f"{key}={str(value).lower()}")
        else:
            run_checks(ROOT, paths, args.checks, args.all_files)
    except (RuntimeError, ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        print(f"Quality check failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
