#!/usr/bin/env sh
set -eu

mode=$(sed -n 's/^default_mode=//p' src/mode.conf)
case "$mode" in
    balanced|safe) ;;
    *) printf 'Unsupported integrated default: %s\n' "$mode" >&2; exit 1 ;;
esac
printf 'Integration policy test passed.\n'
