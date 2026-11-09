#!/usr/bin/env python3
"""Check traceability and basic artifact structure; human review is still required."""

import csv
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "generated"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


manifest = json.loads((OUT / "manifest.json").read_text())
raw_count = sum(1 for _ in csv.DictReader((ROOT / "raw-benchmark.csv").open()))
accepted_count = sum(1 for _ in csv.DictReader((OUT / "accepted.csv").open()))
rejected_count = sum(1 for _ in csv.DictReader((OUT / "rejected.csv").open()))
assert raw_count == accepted_count + rejected_count
assert accepted_count == manifest["accepted_rows"] == 30
assert rejected_count == manifest["rejected_rows"] == 2
assert manifest["input_sha256"] == digest(ROOT / "raw-benchmark.csv")
for name, expected in manifest["outputs"].items():
    path = OUT / name
    assert path.stat().st_size > 0
    assert digest(path) == expected
svg = (OUT / "benchmark.svg").read_text()
for label in ("Latency (ms)", "Throughput (requests/s)", "Worker processes"):
    assert label in svg
print("Artifact structure, counts, labels, and digests verified.")
