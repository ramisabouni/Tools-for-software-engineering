#!/usr/bin/env bash
set -euo pipefail
pattern="${1:-^[[:alpha:]_][[:alnum:]_]*$}"
file="${2:-../../datasets/text/identifiers.txt}"
grep -En -- "$pattern" "$file" || true
