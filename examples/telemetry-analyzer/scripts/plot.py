#!/usr/bin/env python3
import argparse
import csv
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Plot synthetic telemetry readings")
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    import matplotlib

    matplotlib.use("Agg")
    from matplotlib import pyplot as plt

    values: dict[str, list[float]] = {}
    rejected = 0
    with args.input.open(newline="", encoding="utf-8") as stream:
        for row in csv.DictReader(stream):
            try:
                values.setdefault(row["sensor"], []).append(float(row["value"]))
            except (KeyError, TypeError, ValueError):
                rejected += 1

    if not values:
        raise SystemExit("no valid telemetry records")
    for sensor, readings in sorted(values.items()):
        plt.plot(range(1, len(readings) + 1), readings, marker="o", label=sensor)
    plt.xlabel("Reading number")
    plt.ylabel("Value")
    plt.title("Synthetic telemetry readings")
    plt.grid(alpha=0.25)
    plt.legend()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    plt.tight_layout()
    plt.savefig(args.output, dpi=160)
    print(f"wrote {args.output}; rejected={rejected}")
    return 1 if rejected else 0


if __name__ == "__main__":
    raise SystemExit(main())
