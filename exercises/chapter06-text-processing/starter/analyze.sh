#!/usr/bin/env bash
set -euo pipefail

application_log=${1:-application.log}
performance_csv=${2:-performance.csv}
output_dir=${3:-output}

# TODO: validate arguments and create candidates in output_dir.
# TODO: select evidence with grep and normalize WARNING with sed.
# TODO: validate, quarantine, aggregate, sort, reconcile, and publish.
# TODO: write analysis-report.txt and analysis-manifest.txt.

printf 'Complete analyze.sh for %s and %s; write results to %s\n' \
    "$application_log" "$performance_csv" "$output_dir" >&2
exit 1
