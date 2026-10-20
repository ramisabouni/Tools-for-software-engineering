#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
input=${1:-"$script_dir/data/service.log"}
output_dir=${2:-"$script_dir/output"}
summary="$output_dir/service-summary.csv"
rejected="$output_dir/rejected-records.txt"
manifest="$output_dir/manifest.txt"

[[ -r $input ]] || { printf 'error: cannot read %s\n' "$input" >&2; exit 2; }
mkdir -p -- "$output_dir"

candidate=$(mktemp "$output_dir/.service-summary.XXXXXX") || exit 1
stats=$(mktemp "$output_dir/.service-stats.XXXXXX") || { rm -f -- "$candidate"; exit 1; }
rejected_candidate=$(mktemp "$output_dir/.service-rejected.XXXXXX") || {
    rm -f -- "$candidate" "$stats"
    exit 1
}
cleanup() { rm -f -- "$candidate" "$stats" "$rejected_candidate"; }
trap cleanup EXIT HUP INT TERM

LC_ALL=C awk -v rejected_file="$rejected_candidate" -v stats_file="$stats" \
    -f "$script_dir/summarize-services.awk" "$input" |
    LC_ALL=C sort -t',' -k2,2nr -k1,1 > "$candidate"

rejected_count=$(awk -F= '$1 == "rejected" { print $2 }' "$stats")
accepted_errors=$(awk -F= '$1 == "accepted_errors" { print $2 }' "$stats")
summary_errors=$(awk -F',' '{ total += $2 } END { print total + 0 }' "$candidate")

if [[ $rejected_count != 0 ]]; then
    cp -- "$rejected_candidate" "$rejected"
    printf 'error: %s malformed record(s); prior report preserved\n' "$rejected_count" >&2
    exit 1
fi
if [[ $summary_errors != "$accepted_errors" ]]; then
    printf 'error: reconciliation failed (%s summarized, %s accepted)\n' \
        "$summary_errors" "$accepted_errors" >&2
    exit 1
fi
awk -F',' 'NF != 3 || $2 !~ /^[0-9]+$/ || $3 !~ /^[0-9]+[.][0-9][0-9]$/ { exit 1 }' "$candidate" || {
    printf '%s\n' 'error: candidate report violates its output contract' >&2
    exit 1
}

mv -- "$candidate" "$summary"
: > "$rejected"
input_digest=$(sha256sum "$input" | awk '{print $1}')
output_digest=$(sha256sum "$summary" | awk '{print $1}')
{
    printf 'input=%s\n' "$input"
    printf 'input_sha256=%s\n' "$input_digest"
    printf 'output_sha256=%s\n' "$output_digest"
    printf 'locale=LC_ALL=C\n'
    cat "$stats"
    printf 'summary_error_total=%s\n' "$summary_errors"
    printf 'validation=passed\n'
} > "$manifest"

printf 'Created %s\nCreated %s\nCreated %s\n' "$summary" "$rejected" "$manifest"
