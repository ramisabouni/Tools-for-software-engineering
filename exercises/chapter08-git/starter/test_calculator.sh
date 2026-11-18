#!/usr/bin/env sh
set -eu
program=${1:-./build/calculator}

check() {
    expected=$1
    shift
    actual=$($program "$@")
    [ "$actual" = "$expected" ] || {
        printf 'FAIL: expected %s, got %s\n' "$expected" "$actual" >&2
        exit 1
    }
}

check 7 add 5 2
check 0 add -3 3
printf 'All calculator tests passed.\n'
