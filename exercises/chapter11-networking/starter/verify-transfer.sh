#!/usr/bin/env bash
set -euo pipefail

[[ $# -eq 3 ]] || { printf 'usage: %s LOCAL_FILE REMOTE_DIGEST RETRIEVED_FILE\n' "$0" >&2; exit 2; }
local_file=$1 remote_digest=$2 retrieved_file=$3
[[ -f $local_file && -f $retrieved_file ]] || { printf 'Both local files must exist.\n' >&2; exit 2; }
[[ $remote_digest =~ ^[0-9a-fA-F]{64}$ ]] || { printf 'Remote digest format is invalid.\n' >&2; exit 2; }
local_digest=$(shasum -a 256 "$local_file" | awk '{print $1}')
retrieved_digest=$(shasum -a 256 "$retrieved_file" | awk '{print $1}')
printf 'local=%s\nremote=%s\nretrieved=%s\n' "$local_digest" "$remote_digest" "$retrieved_digest"
[[ $local_digest == "$remote_digest" && $local_digest == "$retrieved_digest" ]] || {
    printf 'Transfer integrity verification failed.\n' >&2
    exit 1
}
printf 'All three SHA-256 digests agree.\n'
