#!/usr/bin/env python3
"""Starter validator: extend its audit and manifest reporting as directed."""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "generated"
REQUIRED = ["implementation", "workers", "run", "collection_order",
            "latency_ms", "requests_per_s"]

raw = pd.read_csv(ROOT / "benchmark-raw.csv", dtype=str, keep_default_na=False)
if list(raw.columns) != REQUIRED:
    raise SystemExit("unexpected schema")

accepted = []
rejected = []
seen = set()
for number, row in enumerate(raw.to_dict("records"), start=2):
    try:
        key = (row["implementation"], int(row["workers"]), int(row["run"]))
        latency = float(row["latency_ms"])
        throughput = float(row["requests_per_s"])
        if row["implementation"] not in {"baseline", "candidate"}:
            raise ValueError("unknown implementation")
        if key[1] not in {1, 2} or latency <= 0 or throughput <= 0:
            raise ValueError("value outside contract")
        if key in seen:
            raise ValueError("duplicate observation key")
        seen.add(key)
        accepted.append({**row, "workers": key[1], "run": key[2],
                         "collection_order": int(row["collection_order"]),
                         "latency_ms": latency, "requests_per_s": throughput})
    except (TypeError, ValueError) as error:
        rejected.append({"row": number, "reason": str(error), **row})

good = pd.DataFrame(accepted)
bad = pd.DataFrame(rejected)
coverage = (good.groupby(["implementation", "workers"]).size()
                .rename("observations").reset_index())
expected = {("baseline", 1), ("baseline", 2), ("candidate", 1), ("candidate", 2)}
if set(zip(coverage.implementation, coverage.workers)) != expected:
    raise SystemExit("missing treatment combination")
if not (coverage.observations == 3).all():
    raise SystemExit("unequal repetition count")
if len(good) + len(bad) != len(raw):
    raise SystemExit("row reconciliation failed")

OUT.mkdir(exist_ok=True)
good.to_csv(OUT / "accepted.csv", index=False)
bad.to_csv(OUT / "rejected.csv", index=False)
coverage.to_csv(OUT / "coverage.csv", index=False)
print(f"raw={len(raw)} accepted={len(good)} rejected={len(bad)}")
print("TODO: write data-audit.md with contracts, counts, and extreme-value investigation")
