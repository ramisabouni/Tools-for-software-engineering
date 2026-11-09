#!/usr/bin/env python3
"""Read-only verifier starter: complete provider and capability policy as assigned."""

import csv
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def numeric_version(text: str) -> tuple[int, ...]:
    match = re.search(r"(?<!\d)(\d+(?:\.\d+)+)", text)
    if not match:
        raise ValueError("unparsable version")
    return tuple(map(int, match.group(1).split(".")))


def normalize(values: list[tuple[int, ...]]) -> list[tuple[int, ...]]:
    width = max(map(len, values))
    return [value + (0,) * (width - len(value)) for value in values]


if len(sys.argv) != 3:
    raise SystemExit(f"usage: {sys.argv[0]} MANIFEST REPORT")
manifest, report = map(Path, sys.argv[1:])
required = ["name", "command", "minimum_version", "maximum_exclusive",
            "probe_argument", "expected_provider_fragment"]
try:
    with manifest.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source, delimiter="\t")
        if reader.fieldnames != required:
            raise ValueError("manifest schema mismatch")
        rows = list(reader)
    if not rows:
        raise ValueError("empty manifest")
except (OSError, ValueError) as error:
    print(f"invalid manifest: {error}", file=sys.stderr)
    raise SystemExit(3)

records = []
for row in rows:
    selected = shutil.which(row["command"])
    candidates = [str(Path(directory) / row["command"])
                  for directory in os.environ.get("PATH", "").split(os.pathsep)
                  if directory and (Path(directory) / row["command"]).is_file()
                  and os.access(Path(directory) / row["command"], os.X_OK)]
    classification, detail, raw = "missing", "command not resolved", ""
    if selected:
        expected = row["expected_provider_fragment"]
        if expected and expected not in selected:
            classification, detail = "shadowed", "unexpected provider selected"
        else:
            try:
                result = subprocess.run([selected, row["probe_argument"]], text=True,
                                        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                        timeout=5, check=False)
                raw = result.stdout.strip().splitlines()[0] if result.stdout.strip() else ""
                if result.returncode:
                    classification, detail = "failed-capability", "probe returned nonzero"
                else:
                    observed, lower, upper = normalize([numeric_version(raw),
                        numeric_version(row["minimum_version"]),
                        numeric_version(row["maximum_exclusive"])])
                    if lower <= observed < upper:
                        classification, detail = "compatible", "constraint satisfied"
                    else:
                        classification, detail = "incompatible", "outside declared range"
            except (OSError, subprocess.TimeoutExpired):
                classification, detail = "failed-capability", "probe failed or timed out"
            except ValueError:
                classification, detail = "invalid-version", "version could not be compared"
    records.append({"name": row["name"], "selected": selected or "",
                    "candidates": candidates, "raw_version": raw,
                    "classification": classification, "detail": detail})

payload = {"schema": 1, "records": records}
report.write_text(json.dumps(payload, indent=2) + "\n")
raise SystemExit(0 if all(item["classification"] == "compatible" for item in records) else 2)
