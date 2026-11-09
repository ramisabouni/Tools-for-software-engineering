#!/usr/bin/env python3
"""Complete the quantitative figures without silently filtering observations."""

from pathlib import Path
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "generated"
data = pd.read_csv(OUT / "accepted.csv")

fig, ax = plt.subplots(figsize=(7, 4.5))
# TODO: plot every throughput observation with accessible, redundant encodings.
# TODO: overlay the declared summary and correctly defined uncertainty.
ax.set(xlabel="Worker processes", ylabel="Throughput (requests/s)")
ax.set_xticks([1, 2])
ax.grid(alpha=0.25)
fig.tight_layout()
fig.savefig(OUT / "throughput.svg", metadata={"Date": None})
fig.savefig(OUT / "throughput.png", dpi=160)
plt.close(fig)

# TODO: create the latency figure, summary.csv, captions, and manifest.
