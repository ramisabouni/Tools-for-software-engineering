#!/usr/bin/env bash
set -euo pipefail

binary=${1:-build/debug/telemetry-analyzer}
output=$(mktemp)
trap 'rm -f "$output"' EXIT

set +e
"$binary" data/telemetry.csv > "$output"
status=$?
set -e
[[ $status -eq 1 ]] || { echo "FAIL: expected data-quality exit status 1" >&2; exit 1; }

for expected in accepted=6 rejected=1 minimum=18.70 maximum=24.10 mean=21.48; do
    grep -Fxq "$expected" "$output" || { echo "FAIL: missing $expected" >&2; exit 1; }
done
echo "PASS: command-line output and exit status are correct"
