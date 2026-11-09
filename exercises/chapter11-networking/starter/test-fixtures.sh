#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
passed=0 failed=0
test_case() {
    local scenario=$1 expected=$2 expected_exit=$3 output status diag
    diag=$(mktemp)
    set +e
    output=$("$root/test-services.sh" --fixture "$scenario" 2>"$diag")
    status=$?
    set -e
    if [[ $status -eq $expected_exit && ${output%%$'\t'*} == "$expected" ]] && \
       ! grep -Eiq '(authorization:|bearer |password=|token=)' "$diag"; then
        printf 'PASS %-14s %s/%s\n' "$scenario" "$expected" "$expected_exit"
        ((passed+=1))
    else
        printf 'FAIL %-14s expected %s/%s\n' "$scenario" "$expected" "$expected_exit" >&2
        ((failed+=1))
    fi
    rm -f -- "$diag"
}

test_case success ok 0
test_case resolution resolution 10
test_case refusal connection 20
test_case timeout connection 20
test_case tls tls 30
test_case http http 50
test_case malformed body 60
test_case missing-field body 60
test_case stale body 60
printf 'passed=%d failed=%d\n' "$passed" "$failed"
((failed == 0))
