#!/usr/bin/env bash
set -euo pipefail

case_dir=${1:-case}

# TODO: check required tools.
# TODO: validate the case directory and checksum manifest.
# TODO: report archive types and service.conf permissions.
# TODO: create a sorted NUL-safe inventory that preserves the spaced filename.

printf 'verification not implemented for %s\n' "$case_dir" >&2
exit 2

