#!/usr/bin/env bash
set -euo pipefail

url=${1:-}
if [[ ! $url =~ ^https:// ]]; then
    printf 'usage: %s https://host/path\n' "$0" >&2
    exit 2
fi

status=$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' \
    --connect-timeout 5 --max-time 15 "$url")
printf 'HTTP status: %s\n' "$status"
[[ $status =~ ^2[0-9][0-9]$ ]]
