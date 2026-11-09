#!/usr/bin/env python3
"""Validate repeated benchmark data and render reproducible evidence."""

from __future__ import annotations

import hashlib
import json
import platform
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw-benchmark.csv"
OUT = ROOT / "generated"
REQUIRED = ["implementation", "workers", "run", "collection_order",
            "latency_ms", "requests_per_s"]
IMPLEMENTATIONS = ["baseline", "candidate"]
WORKERS = [1, 2, 4]
EXPECTED_REPETITIONS = 5


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_and_validate() -> tuple[pd.DataFrame, pd.DataFrame]:
    raw = pd.read_csv(RAW, dtype=str, keep_default_na=False)
    if list(raw.columns) != REQUIRED:
        raise SystemExit(f"schema mismatch: expected {REQUIRED}, got {list(raw.columns)}")

    accepted: list[dict[str, object]] = []
    rejected: list[dict[str, str]] = []
    seen: set[tuple[str, int, int]] = set()
    for row_number, row in enumerate(raw.to_dict("records"), start=2):
        try:
            implementation = row["implementation"]
            workers = int(row["workers"])
            run = int(row["run"])
            order = int(row["collection_order"])
            latency = float(row["latency_ms"])
            throughput = float(row["requests_per_s"])
            key = (implementation, workers, run)
            if implementation not in IMPLEMENTATIONS:
                raise ValueError("unknown implementation")
            if workers not in WORKERS:
                raise ValueError("unexpected worker count")
            if key in seen:
                raise ValueError("duplicate observation key")
            if latency <= 0 or throughput <= 0:
                raise ValueError("measurements must be positive")
            seen.add(key)
            accepted.append({"implementation": implementation, "workers": workers,
                             "run": run, "collection_order": order,
                             "latency_ms": latency, "requests_per_s": throughput})
        except (TypeError, ValueError) as error:
            rejected.append({"row": str(row_number), "reason": str(error), **row})

    good = pd.DataFrame(accepted)
    bad = pd.DataFrame(rejected)
    if len(good) + len(bad) != len(raw):
        raise SystemExit("row reconciliation failed")
    if good.duplicated(["implementation", "workers", "run"]).any():
        raise SystemExit("duplicate accepted observation key")
    return good, bad


def analyse(data: pd.DataFrame) -> tuple[pd.DataFrame, pd.DataFrame]:
    coverage = (data.groupby(["implementation", "workers"], sort=True)
                    .size().rename("observations").reset_index())
    expected = {(name, workers) for name in IMPLEMENTATIONS for workers in WORKERS}
    observed = set(zip(coverage["implementation"], coverage["workers"]))
    if observed != expected or not (coverage["observations"] == EXPECTED_REPETITIONS).all():
        raise SystemExit(f"unbalanced coverage:\n{coverage.to_string(index=False)}")

    summary = (data.groupby(["implementation", "workers"], sort=True)
                   .agg(n=("run", "size"),
                        median_latency_ms=("latency_ms", "median"),
                        median_requests_per_s=("requests_per_s", "median"),
                        throughput_q1=("requests_per_s", lambda x: x.quantile(0.25)),
                        throughput_q3=("requests_per_s", lambda x: x.quantile(0.75)))
                   .reset_index())
    return coverage, summary


def render(data: pd.DataFrame, summary: pd.DataFrame) -> None:
    colors = {"baseline": "#0072B2", "candidate": "#D55E00"}
    markers = {"baseline": "o", "candidate": "s"}
    lines = {"baseline": "-", "candidate": "--"}
    fig, axes = plt.subplots(1, 2, figsize=(10, 4.4))

    for name in IMPLEMENTATIONS:
        observations = data[data["implementation"] == name]
        stats = summary[summary["implementation"] == name]
        axes[0].scatter(observations["workers"], observations["latency_ms"],
                        color=colors[name], marker=markers[name], alpha=0.55,
                        label=f"{name} observations")
        axes[0].plot(stats["workers"], stats["median_latency_ms"],
                     color=colors[name], marker=markers[name], linestyle=lines[name],
                     label=f"{name} median")
        axes[1].scatter(observations["workers"], observations["requests_per_s"],
                        color=colors[name], marker=markers[name], alpha=0.55)
        axes[1].plot(stats["workers"], stats["median_requests_per_s"],
                     color=colors[name], marker=markers[name], linestyle=lines[name],
                     label=f"{name} median")

    axes[0].set(xlabel="Worker processes", ylabel="Latency (ms)", xticks=WORKERS)
    axes[1].set(xlabel="Worker processes", ylabel="Throughput (requests/s)", xticks=WORKERS)
    for axis in axes:
        axis.grid(alpha=0.25)
        axis.legend(fontsize=8)
    fig.suptitle("Repeated benchmark observations and medians (n=5 per condition)")
    fig.tight_layout()
    fig.savefig(OUT / "benchmark.svg", metadata={"Date": None})
    fig.savefig(OUT / "benchmark.png", dpi=160, metadata={"Software": "chapter10 benchmark.py"})
    plt.close(fig)


def main() -> None:
    OUT.mkdir(exist_ok=True)
    accepted, rejected = load_and_validate()
    coverage, summary = analyse(accepted)
    accepted.to_csv(OUT / "accepted.csv", index=False)
    rejected.to_csv(OUT / "rejected.csv", index=False)
    coverage.to_csv(OUT / "coverage.csv", index=False)
    summary.to_csv(OUT / "summary.csv", index=False)
    render(accepted, summary)

    outputs = ["accepted.csv", "rejected.csv", "coverage.csv", "summary.csv",
               "benchmark.svg", "benchmark.png"]
    manifest = {
        "question": "How do latency and throughput change with workers for baseline and candidate?",
        "experimental_unit": "one identified benchmark run",
        "raw_rows": len(accepted) + len(rejected),
        "accepted_rows": len(accepted),
        "rejected_rows": len(rejected),
        "input_sha256": digest(RAW),
        "command": "python3 benchmark.py",
        "python": platform.python_version(),
        "pandas": pd.__version__,
        "matplotlib": matplotlib.__version__,
        "outputs": {name: digest(OUT / name) for name in outputs},
        "caption": ("Latency and throughput for baseline and candidate across 1, 2, and 4 "
                    "workers; points are individual runs and lines are medians, n=5 per "
                    "condition. One extreme candidate run is retained. Results describe "
                    "one synthetic environment and do not establish causation."),
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"accepted={len(accepted)} rejected={len(rejected)} plotted={len(accepted)}")


if __name__ == "__main__":
    main()
