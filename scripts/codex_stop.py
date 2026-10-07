#!/usr/bin/env python3
"""Codex Stop protocol adapter: check once, then surface remaining blockers."""

import json
import os
from pathlib import Path
import signal
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
CHECK_TIMEOUT = 480


def handle(event):
    if not isinstance(event, dict) or event.get("hook_event_name") != "Stop":
        return {"systemMessage": "Quality hook received an invalid Stop event; quality was not checked."}
    if type(event.get("stop_hook_active")) is not bool:
        return {"systemMessage": "Quality hook requires boolean stop_hook_active; quality was not checked."}
    if event["stop_hook_active"]:
        return {"systemMessage": "Automatic quality retry skipped to prevent a Stop loop. Report any unresolved check; run mise run quality manually after fixing it."}
    process = subprocess.Popen(
        [sys.executable, "-B", str(ROOT / "scripts/quality.py")],
        cwd=ROOT, stdout=sys.stderr, stderr=sys.stderr, start_new_session=True,
    )
    try:
        status = process.wait(timeout=CHECK_TIMEOUT)
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGKILL)
        process.wait()
        return {"decision": "block", "reason": "Quality check timed out. Report the limitation and run a focused check; do not claim it passed. Automatic retry is disabled on the continuation."}
    if status:
        return {"decision": "block", "reason": "Local quality checks failed or prerequisites are missing. Inspect the diagnostic, fix within authorized scope or report the blocker. Run mise run quality manually to verify; automatic retry is disabled on the continuation."}
    return {}


def main():
    try:
        # Only parse the event; never read transcripts or run input-provided code.
        event = json.loads(sys.stdin.read(1024 * 1024 + 1))
        result = handle(event)
    except (ValueError, OSError) as error:
        print(f"Quality hook could not run: {type(error).__name__}", file=sys.stderr)
        result = {"systemMessage": "Quality hook could not run. Report quality as unverified and use mise run quality manually."}
    print(json.dumps(result))
    return 0


if __name__ == "__main__":
    sys.exit(main())
