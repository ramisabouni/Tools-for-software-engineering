#!/usr/bin/env sh
set -eu
program=${1:-./build/analyzer}

check() {
    expected=$1
    message=$2
    actual=$($program "$message")
    [ "$actual" = "$expected" ] || {
        printf 'FAIL: %s: expected %s, got %s\n' "$message" "$expected" "$actual" >&2
        exit 1
    }
}

check INFO 'INFO service started'
check WARNING 'WARNING disk nearly full'
check ERROR 'ERROR database unavailable'
check OTHER 'DEBUG retry scheduled'
printf 'All analyzer tests passed.\n'
