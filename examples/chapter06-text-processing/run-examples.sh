#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
printf '%s\n' '=== grep ==='
"$script_dir/grep-examples.sh"
printf '%s\n' '=== sed ==='
"$script_dir/sed-examples.sh"
printf '%s\n' '=== awk ==='
"$script_dir/awk-examples.sh"
printf '%s\n' '=== complete report ==='
"$script_dir/log-report.sh" "$script_dir/data/service.log" "$script_dir/output"
