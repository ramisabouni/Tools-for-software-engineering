# Laboratory 10 — Architecture and Performance Evidence

Work in a copy of `starter/`; do not edit the instructor-managed course copy.
Generated artifacts belong under `generated/`.

## Learning objectives

- Encode architecture and state behavior in reviewable DOT source.
- Validate repeated measurements before analysis or plotting.
- Communicate individual observations, summaries, and uncertainty honestly.
- Produce accessible artifacts with traceable inputs, commands, and digests.

## Part A — Questions and contracts

Complete `contracts.md`: one question per visual, node and edge meanings,
experimental unit, schema, allowed values, ranges, planned coverage, missing-value
and exclusion policies, declared summary, and uncertainty interpretation.

## Part B — Architecture

Complete `architecture.dot` using stable identifiers, readable labels, one edge
meaning, and documented subsystem clusters. Generate an overview and a filtered
analysis-subsystem view in SVG and PNG. Explain any omitted detail.

## Part C — State machine

Complete `state-machine.dot` with initial and terminal states, event labels,
failure, timeout, cancellation, retry guard, and retry exhaustion. Document one
invalid event and confirm every nonterminal state has an appropriate outgoing path.

## Part D — Validate benchmark data

Preserve `benchmark-raw.csv`. Complete and run the validation workflow before
plotting. Validate exact schema, types, allowed treatments, ranges, duplicate
observation keys, planned coverage, and repetitions. Produce `accepted.csv`,
`rejected.csv`, `coverage.csv`, and `data-audit.md`, reconciling:

```text
raw rows = accepted rows + rejected rows
accepted rows = observations represented by the quantitative figures
```

The extreme valid observation must remain visible unless a predeclared defensible
rule and sensitivity analysis justify exclusion.

## Part E — Quantitative figures

Complete `plot-template.py` to generate latency and throughput figures that show
individual observations plus a declared summary and uncertainty layer. Use shared
units, honest scales, deterministic order, and color plus marker/line redundancy.
Reproduce the throughput summary with `performance.gnuplot`; explain visual
differences in `NOTES.md`.

## Part F — Reproduce and verify

Complete the `Makefile` so `make clean all verify` regenerates everything. Export
vector publication artifacts and PNG previews. Inspect final size and grayscale.
Create `manifest.json` containing input, source, and output digests; tool versions;
generation command; counts; parameters; and captions. Captions must state system,
workload, units, statistic, uncertainty, sample size, and limitation.

## Deliverables

- `contracts.md`, authoritative DOT sources, Python and gnuplot sources.
- Raw, accepted, rejected, coverage, and summary tables.
- Architecture overview/subsystem views, state machine, latency, and throughput in
  required vector and preview formats.
- `data-audit.md`, `captions.md`, `manifest.json`, and `NOTES.md`.

## Acceptance criteria

Source and field contracts are explicit; validation and coverage are complete;
counts reconcile; output names and series order are deterministic; figures remain
readable without color; scales and aggregation are honest; captions define the
evidence; digests connect every artifact to its inputs; and the workflow succeeds
from a clean course environment.
