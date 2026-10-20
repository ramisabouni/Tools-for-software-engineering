#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
input=${1:-"$script_dir/data/application.log"}
[[ -r $input ]] || { printf 'error: cannot read %s\n' "$input" >&2; exit 2; }

printf '%s\n' 'Warning and error evidence (with source line numbers):'
if grep -En ' (WARN|ERROR) ' -- "$input"; then
    :
else
    status=$?
    if (( status == 1 )); then
        printf '%s\n' 'No warning or error records were found.' >&2
    else
        exit "$status"
    fi
fi
