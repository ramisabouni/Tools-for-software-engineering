#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    printf 'usage: %s AUTHORIZED_HTTPS_URL\n' "$0" >&2
    exit 2
fi
url=$1
[[ $url == https://* ]] || { printf 'Only HTTPS URLs are accepted.\n' >&2; exit 2; }

work=$(mktemp -d)
cleanup() { rm -f -- "$work/body" "$work/headers" "$work/meta"; rmdir "$work" 2>/dev/null || true; }
trap cleanup EXIT HUP INT TERM

curl --silent --show-error --location --max-redirs 3 \
  --connect-timeout 5 --max-time 15 \
  --request GET --header 'Accept: application/json' \
  --dump-header "$work/headers" --output "$work/body" \
  --write-out 'status=%{http_code}\nremote_ip=%{remote_ip}\ncontent_type=%{content_type}\ntime_total=%{time_total}\n' \
  "$url" >"$work/meta"

cat "$work/meta"
printf 'body_sha256=%s\n' "$(shasum -a 256 "$work/body" | awk '{print $1}')"
printf 'Response body retained only in the protected temporary workspace.\n' >&2
