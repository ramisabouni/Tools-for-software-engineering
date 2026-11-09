#!/usr/bin/env python3
"""Offline tests for missing, incompatible, shadowed, and failed capability."""

import os
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def stub(directory: Path, name: str, body: str) -> Path:
    path = directory / name
    path.write_text("#!/bin/sh\n" + body + "\n")
    path.chmod(path.stat().st_mode | stat.S_IXUSR)
    return path


def run_case(label: str, version_body: str | None, minimum: str, maximum: str,
             expected: str, provider: str = "") -> None:
    with tempfile.TemporaryDirectory(prefix="chapter13 path ") as value:
        directory = Path(value)
        if version_body is not None:
            stub(directory, "course-tool", version_body)
        manifest = directory / "manifest.tsv"
        manifest.write_text("name\tcommand\tminimum_version\tmaximum_exclusive\tprobe_argument\texpected_provider_fragment\n"
                            f"Tool\tcourse-tool\t{minimum}\t{maximum}\t--version\t{provider}\n")
        env = {"PATH": str(directory)}
        result = subprocess.run([sys.executable, str(ROOT / "verify-tools.py"), str(manifest)],
                                env=env, text=True, capture_output=True)
        combined = result.stdout + result.stderr
        assert f'"classification": "{expected}"' in combined, (label, combined)
        print(f"PASS {label}: {expected}")


run_case("compatible", "echo 'course-tool 2.4.1'", "2.0", "3.0", "compatible")
run_case("missing", None, "2.0", "3.0", "missing")
run_case("incompatible", "echo 'course-tool 4.0'", "2.0", "3.0", "incompatible")
run_case("failed capability", "echo failure >&2; exit 9", "2.0", "3.0", "failed-capability")
run_case("shadowed provider", "echo 'course-tool 2.4'", "2.0", "3.0", "shadowed", "/approved/")
