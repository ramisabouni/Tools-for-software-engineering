#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s --input DIR --output DIR --start TIME --end TIME --minimum-severity LEVEL\n' "${0##*/}"
}

# TODO: parse and validate arguments.
# TODO: create a temporary candidate directory in the output parent.
# TODO: select and normalize records without modifying case evidence.
# TODO: run the Awk report, reconcile counts, build a manifest, and validate outputs.
# TODO: publish the complete candidate only after validation succeeds.

usage >&2
exit 2

