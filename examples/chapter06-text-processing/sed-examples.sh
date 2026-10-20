#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
input=${1:-"$script_dir/data/authentication.log"}
[[ -r $input ]] || { printf 'error: cannot read %s\n' "$input" >&2; exit 2; }

sed -E 's/user=[^ ]+/user=[REDACTED]/; s/ip=[^ ]+/ip=[REDACTED]/' "$input"
