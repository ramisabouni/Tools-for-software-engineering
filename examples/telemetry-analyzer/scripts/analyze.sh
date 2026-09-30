#!/usr/bin/env bash
set -euo pipefail

input=${1:-data/telemetry.csv}
output=${2:-reports/by-sensor.csv}
mkdir -p "$(dirname "$output")"

awk -F, '
BEGIN { OFS=","; print "sensor,count,mean" }
NR == 1 { next }
$3 ~ /^-?[0-9]+([.][0-9]+)?$/ {
    count[$2]++; sum[$2] += $3; accepted++; next
}
{ rejected++; printf "rejected line %d: %s\n", NR, $0 > "/dev/stderr" }
END {
    for (sensor in count) print sensor, count[sensor], sprintf("%.2f", sum[sensor]/count[sensor])
    printf "accepted=%d rejected=%d\n", accepted, rejected > "/dev/stderr"
    if (rejected > 0) exit 1
}
' "$input" | sort -t, -k1,1 > "$output"
