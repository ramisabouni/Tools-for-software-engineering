#!/usr/bin/env python3
"""Offline classification tests using disposable command and manifest fixtures."""

import json
import os
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
HEADER = "name\tcommand\tminimum_version\tmaximum_exclusive\tprobe_argument\texpected_provider_fragment\n"


def executable(path: Path, body: str) -> None:
    path.write_text("#!/bin/sh\n" + body + "\n")
    path.chmod(path.stat().st_mode | stat.S_IXUSR)


def case(label: str, body: str | None, minimum: str, maximum: str,
         expected: str, provider: str = "") -> None:
    with tempfile.TemporaryDirectory(prefix="chapter13 fixture ") as value:
        directory = Path(value)
        if body is not None:
            executable(directory / "fixture-tool", body)
        manifest = directory / "manifest.tsv"
        report = directory / "report.json"
        manifest.write_text(HEADER + f"Fixture\tfixture-tool\t{minimum}\t{maximum}\t--version\t{provider}\n")
        result = subprocess.run([sys.executable, str(ROOT / "verify-environment.py"),
                                 str(manifest), str(report)],
                                env={"PATH": str(directory)}, text=True, capture_output=True)
        observed = json.loads(report.read_text())["records"][0]["classification"]
        assert observed == expected, (label, observed, result.stdout, result.stderr)
        print(f"PASS {label}: {expected}/{result.returncode}")


case("compatible", "echo 'fixture 2.4.1'", "2.0", "3.0", "compatible")
case("missing", None, "2.0", "3.0", "missing")
case("incompatible", "echo 'fixture 4.0'", "2.0", "3.0", "incompatible")
case("shadowed", "echo 'fixture 2.4'", "2.0", "3.0", "shadowed", "/approved/")
case("invalid version", "echo unknown", "2.0", "3.0", "invalid-version")
case("failed capability", "echo failed >&2; exit 8", "2.0", "3.0", "failed-capability")

with tempfile.TemporaryDirectory() as value:
    directory = Path(value)
    bad = directory / "bad.tsv"
    report = directory / "report.json"
    bad.write_text("wrong\theader\n")
    result = subprocess.run([sys.executable, str(ROOT / "verify-environment.py"),
                             str(bad), str(report)], text=True, capture_output=True)
    assert result.returncode == 3
    print("PASS malformed manifest: invalid-manifest/3")
