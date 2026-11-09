#!/usr/bin/env python3
"""Complete this representative capability using only declared packages."""

from pathlib import Path
import pandas as pd

source = Path(__file__).with_name("measurements.csv")
data = pd.read_csv(source)
required = {"timestamp", "sensor", "value", "unit"}
if set(data.columns) != required or data.isna().any().any():
    raise SystemExit("invalid measurement schema or missing value")
summary = data.groupby(["sensor", "unit"], sort=True)["value"].agg(["count", "mean", "min", "max"])
print(summary.round(2).to_string())
