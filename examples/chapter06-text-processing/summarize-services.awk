# Input: timestamp severity service status duration_ms (exactly five fields)
# Output: service,error_count,average_duration_ms (no header)
BEGIN {
    rejected = 0
    accepted_errors = 0
    if (rejected_file == "") rejected_file = "/dev/stderr"
    if (stats_file == "") stats_file = "/dev/stderr"
}
NF != 5 {
    print NR ":field_count:" $0 > rejected_file
    rejected++
    next
}
$2 !~ /^(INFO|WARN|ERROR)$/ {
    print NR ":severity:" $0 > rejected_file
    rejected++
    next
}
$4 !~ /^[0-9][0-9][0-9]$/ || $5 !~ /^[0-9]+([.][0-9]+)?$/ {
    print NR ":numeric_field:" $0 > rejected_file
    rejected++
    next
}
{
    accepted++
}
$2 == "ERROR" {
    count[$3]++
    duration[$3] += $5
    accepted_errors++
}
END {
    for (service in count)
        printf "%s,%d,%.2f\n", service, count[service], duration[service] / count[service]
    print "accepted=" accepted > stats_file
    print "accepted_errors=" accepted_errors >> stats_file
    print "rejected=" rejected >> stats_file
}
