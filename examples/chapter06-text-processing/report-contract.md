# Service-summary report contract

- Input is a UTF-8, line-oriented, space-delimited synthetic log.
- Each record has exactly five fields: timestamp, severity, service, status, and duration in milliseconds.
- Severity is one of `INFO`, `WARN`, or `ERROR`.
- Service names contain no whitespace or commas.
- Status is exactly three decimal digits; duration is a non-negative decimal value.
- Output is simple, unquoted CSV with service, error count, and average duration fields.
- Output has no header and is ordered by descending count, then service under `LC_ALL=C`.
- Input reconciles as accepted plus rejected; summarized counts reconcile with accepted errors.
- Any malformed record causes a nonzero result and preserves the prior summary.
