#!/usr/bin/env bash
set -euo pipefail

exit_code() {
    case $1 in
        ok) printf 0 ;; resolution) printf 10 ;; connection) printf 20 ;;
        tls) printf 30 ;; http) printf 50 ;; body) printf 60 ;;
        configuration) printf 70 ;; *) return 1 ;;
    esac
}

die_config() {
    printf 'configuration\t-\t-\t%s\n' "$1"
    printf 'Configuration failure: %s\n' "$1" >&2
    exit 70
}

[[ ${1:-} == --fixture && $# -eq 2 ]] || die_config 'use --fixture PATH for this safe example'
fixture=$2
[[ -r $fixture ]] || die_config 'fixture is not readable'

classification= target= selected_address=- detail= http_status= content_type= body_file=
while IFS='=' read -r key value; do
    [[ -z $key || $key == \#* ]] && continue
    case $key in
        classification|target|selected_address|detail|http_status|content_type|body_file)
            printf -v "$key" '%s' "$value" ;;
        *) die_config "unknown fixture key: $key" ;;
    esac
done <"$fixture"

[[ -n $classification && -n $target ]] || die_config 'fixture lacks classification or target'
exit_code "$classification" >/dev/null || die_config 'unknown classification'

if [[ $classification == ok || $classification == body ]]; then
    [[ $http_status == 200 ]] || { classification=http; detail='unexpected HTTP status'; }
    [[ $content_type == application/json* ]] || { classification=http; detail='unexpected media type'; }
fi

if [[ $classification == ok || $classification == body ]]; then
    body_path=$(dirname -- "$fixture")/$body_file
    if [[ ! -r $body_path ]]; then
        classification=configuration; detail='body fixture is not readable'
    elif python3 - "$body_path" <<'PY'
import json, sys
try:
    value = json.load(open(sys.argv[1], encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    raise SystemExit(1)
raise SystemExit(0 if value.get("status") == "ok" else 1)
PY
    then
        [[ $classification == ok ]] || detail='fixture expected body failure but predicate passed'
    else
        classification=body
        detail='required health value missing or invalid JSON'
    fi
fi

[[ -n $detail ]] || detail='all required checks passed'
printf '%s\t%s\t%s\t%s\n' "$classification" "$target" "$selected_address" "$detail"
printf 'Checked target=%s boundary=%s without printing credentials.\n' "$target" "$classification" >&2
exit "$(exit_code "$classification")"
