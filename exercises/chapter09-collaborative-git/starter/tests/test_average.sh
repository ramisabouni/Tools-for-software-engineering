#!/usr/bin/env sh
set -eu
program=${1:-./build/average}

check() {
    expected=$1
    shift
    actual=$($program "$@")
    [ "$actual" = "$expected" ] || {
        printf 'FAIL: expected %s, got %s\n' "$expected" "$actual" >&2
        exit 1
    }
}

check 4 8 2
check 3 7 2
check -2 -8 4
printf 'Executed 3 average tests.\n'
