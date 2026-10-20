# Exercise 6 — Log and CSV Analysis

Work in a copy of `starter/`; do not edit the instructor-managed course copy. All supplied records are synthetic.

## Supplied files

- `application.log`: controlled whitespace-delimited records with timestamp, severity, service, status, and duration fields. The legacy severity `WARNING` must be normalized to `WARN` in a new stream.
- `performance.csv`: a documented simple CSV subset with one header and no quoting or embedded commas.
- `contract-template.md`: a required starting point for documenting both input contracts.
- `analyze.sh`: a starter entry command. Complete it without changing its interface.
- `access.log` and `sales.csv`: optional practice fixtures retained for earlier examples; they are not required by this laboratory.

## Required work

1. Record each required input's SHA-256 digest, byte count, line count, header policy, delimiter, field grammar, encoding assumption, and missing-value policy.
2. Use `grep` to create line-numbered warning/error evidence. Treat no matches as a valid empty result and operational errors as failures.
3. Use `sed` to normalize `WARNING` to `WARN` in a generated stream. Never modify `application.log`.
4. Use `awk` to validate required fields, quarantine rejected records with a reason and source line number, count accepted application events by service, and calculate average valid duration.
5. Use `cut`, `sort`, and `uniq` to create an independent service-frequency check from data for which the documented delimiter model is valid.
6. Reconcile input records as accepted plus rejected and reconcile grouped totals with accepted records.
7. Write candidates in the destination directory, validate them, and only then publish final output.

## Required outputs

Running the following command must reproduce the submission:

```bash
./analyze.sh application.log performance.csv output
```

The `output/` directory must contain:

- `selected-events.txt`
- `normalized-application.log`
- `service-summary.csv`
- `performance-summary.csv`
- `frequency-check.txt`
- `rejected-records.txt`
- `analysis-report.txt`
- `analysis-manifest.txt`

## Acceptance criteria

- Original inputs remain unchanged.
- Ordering is deterministic under a declared locale.
- Rejections are preserved with reason labels.
- Empty valid input has documented behaviour; malformed required input does not silently succeed.
- A filename and output directory containing spaces work correctly.
- Normal output and diagnostics are separate.
- Another student can reproduce every output with the one command above.

Submit `analyze.sh`, the completed contract, all generated outputs, and a short `NOTES.md` describing assumptions and tests.
