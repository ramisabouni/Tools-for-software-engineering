#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
passed=0 failed=0
check() {
    local fixture=$1 expected_class=$2 expected_exit=$3 output status
    set +e
    output=$("$root/health-check.sh" --fixture "$root/fixtures/$fixture" 2>"${TMPDIR:-/tmp}/ch11-diag.$$")
    status=$?
    set -e
    if [[ $status -eq $expected_exit && ${output%%$'\t'*} == "$expected_class" ]]; then
        printf 'PASS %-22s class=%s exit=%s\n' "$fixture" "$expected_class" "$expected_exit"
        ((passed+=1))
    else
        printf 'FAIL %-22s expected %s/%s got %s/%s\n' "$fixture" "$expected_class" "$expected_exit" "${output%%$'\t'*}" "$status" >&2
        ((failed+=1))
    fi
}
trap 'rm -f -- "${TMPDIR:-/tmp}/ch11-diag.$$"' EXIT

check success.fixture ok 0
check resolution.fixture resolution 10
check connection.fixture connection 20
check tls.fixture tls 30
check http.fixture http 50
check invalid-body.fixture body 60
printf 'passed=%d failed=%d\n' "$passed" "$failed"
((failed == 0))
