#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
input=${1:-"$script_dir/data/measurements.csv"}
[[ -r $input ]] || { printf 'error: cannot read %s\n' "$input" >&2; exit 2; }

LC_ALL=C awk -F',' '
BEGIN { OFS="," }
NR == 1 {
    if ($0 != "sample,host,metric,value") {
        print "unexpected header" > "/dev/stderr"
        exit 2
    }
    next
}
NF != 4 { print NR ": field count: " $0 > "/dev/stderr"; rejected++; next }
$4 !~ /^[0-9]+([.][0-9]+)?$/ {
    print NR ": invalid value: " $0 > "/dev/stderr"; rejected++; next
}
{ total[$3] += $4; count[$3]++; accepted++ }
END {
    for (metric in count)
        printf "%s,%d,%.2f\n", metric, count[metric], total[metric] / count[metric]
    printf "accepted=%d rejected=%d\n", accepted, rejected > "/dev/stderr"
    if (rejected) exit 1
}' "$input" | LC_ALL=C sort -t',' -k1,1
