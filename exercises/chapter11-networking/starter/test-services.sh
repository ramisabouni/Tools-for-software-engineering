#!/usr/bin/env bash
set -euo pipefail

# Stable exits: 0 success, 10 resolution, 20 connection, 30 TLS,
# 50 HTTP/media type, 60 body/schema/freshness, 70 configuration.
exit_code() {
    case $1 in
        ok) printf 0 ;; resolution) printf 10 ;; connection) printf 20 ;;
        tls) printf 30 ;; http) printf 50 ;; body) printf 60 ;;
        configuration) printf 70 ;; *) return 1 ;;
    esac
}

emit() {
    local class=$1 target=$2 address=$3 detail=$4
    printf '%s\t%s\t%s\t%s\n' "$class" "$target" "$address" "$detail"
    printf 'target=%s class=%s detail=%s\n' "$target" "$class" "$detail" >&2
    exit "$(exit_code "$class")"
}

[[ ${1:-} == --fixture && $# -eq 2 ]] || emit configuration - - 'fixture mode required in starter'
scenario=$2
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
row=$(awk -F '\t' -v name="$scenario" 'NR > 1 && $1 == name {print; found=1} END {if (!found) exit 1}' "$root/fixture-table.tsv") \
    || emit configuration - - 'unknown fixture scenario'
IFS=$'\t' read -r _ target address resolution transport tls status content_type body <<<"$row"

[[ $resolution == ok ]] || emit resolution "$target" "$address" 'no resolver answer'
[[ $transport == ok ]] || emit connection "$target" "$address" "$transport"
[[ $tls == ok ]] || emit tls "$target" "$address" 'peer identity validation failed'
[[ $status == 200 ]] || emit http "$target" "$address" "HTTP $status"
[[ $content_type == application/json ]] || emit http "$target" "$address" 'unexpected media type'

body_path="$root/fixtures/$body"
[[ -r $body_path ]] || emit configuration "$target" "$address" 'missing body fixture'
if python3 - "$body_path" <<'PY'
import json, sys
try:
    document = json.load(open(sys.argv[1], encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    raise SystemExit(1)
raise SystemExit(0 if document.get("status") == "ok" and document.get("fresh") is True else 1)
PY
then
    emit ok "$target" "$address" 'contract satisfied'
else
    emit body "$target" "$address" 'invalid JSON, health value, or freshness'
fi
