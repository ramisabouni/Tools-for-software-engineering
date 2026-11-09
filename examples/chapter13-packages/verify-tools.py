#!/usr/bin/env python3
"""Read-only, manifest-driven capability verifier using simple numeric versions."""

from __future__ import annotations

import csv
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

EXIT_OK, EXIT_UNMET, EXIT_MANIFEST, EXIT_INTERNAL = 0, 2, 3, 4


def version_tuple(text: str) -> tuple[int, ...]:
    match = re.search(r"(?<!\d)(\d+(?:\.\d+)+)", text)
    if not match:
        raise ValueError("unparsable version")
    return tuple(int(part) for part in match.group(1).split("."))


def padded(value: tuple[int, ...], width: int) -> tuple[int, ...]:
    return value + (0,) * (width - len(value))


def classify(row: dict[str, str]) -> dict[str, object]:
    command = row["command"]
    selected = shutil.which(command)
    candidates = [str(path) for directory in os.environ.get("PATH", "").split(os.pathsep)
                  if directory and (path := Path(directory) / command).is_file()
                  and os.access(path, os.X_OK)]
    record: dict[str, object] = {"name": row["name"], "command": command,
                                 "selected": selected or "", "candidates": candidates}
    if selected is None:
        return {**record, "classification": "missing", "detail": "command not resolved"}
    expected = row.get("expected_provider_fragment", "")
    if expected and expected not in selected:
        return {**record, "classification": "shadowed", "detail": "unexpected provider selected"}
    try:
        completed = subprocess.run([selected, row["probe_argument"]], text=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   timeout=5, check=False)
    except (OSError, subprocess.TimeoutExpired) as error:
        return {**record, "classification": "failed-capability", "detail": str(error)}
    raw = completed.stdout.strip().splitlines()[0] if completed.stdout.strip() else ""
    record["raw_version"] = raw
    if completed.returncode != 0:
        return {**record, "classification": "failed-capability", "detail": "probe returned nonzero"}
    try:
        observed = version_tuple(raw)
        lower = version_tuple(row["minimum_version"])
        upper = version_tuple(row["maximum_exclusive"])
    except ValueError as error:
        return {**record, "classification": "invalid-version", "detail": str(error)}
    width = max(map(len, (observed, lower, upper)))
    if not (padded(lower, width) <= padded(observed, width) < padded(upper, width)):
        return {**record, "classification": "incompatible", "detail": "outside declared range"}
    return {**record, "classification": "compatible", "detail": "version and provider accepted"}


def main() -> int:
    if len(sys.argv) not in (2, 3):
        print(f"usage: {sys.argv[0]} MANIFEST [REPORT]", file=sys.stderr)
        return EXIT_MANIFEST
    manifest = Path(sys.argv[1])
    report = Path(sys.argv[2]) if len(sys.argv) == 3 else None
    required = {"name", "command", "minimum_version", "maximum_exclusive",
                "probe_argument", "expected_provider_fragment"}
    try:
        with manifest.open(newline="", encoding="utf-8") as source:
            reader = csv.DictReader(source, delimiter="\t")
            if set(reader.fieldnames or []) != required:
                raise ValueError("manifest schema mismatch")
            rows = list(reader)
        if not rows or any(not row["command"] for row in rows):
            raise ValueError("manifest contains an empty requirement")
    except (OSError, ValueError) as error:
        print(f"invalid manifest: {error}", file=sys.stderr)
        return EXIT_MANIFEST
    records = [classify(row) for row in rows]
    result = {"schema": 1, "records": records,
              "summary": {name: sum(r["classification"] == name for r in records)
                          for name in sorted({str(r["classification"]) for r in records})}}
    text = json.dumps(result, indent=2) + "\n"
    if report:
        report.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return EXIT_OK if all(r["classification"] == "compatible" for r in records) else EXIT_UNMET


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"verifier failure: {error}", file=sys.stderr)
        raise SystemExit(EXIT_INTERNAL)
