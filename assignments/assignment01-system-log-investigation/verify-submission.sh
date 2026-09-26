#!/usr/bin/env bash

set -u

submission_dir="submission"
errors=0

required_files=(
  "$submission_dir/commands.md"
  "$submission_dir/findings.md"
  "$submission_dir/evidence/application-errors.txt"
  "$submission_dir/evidence/auth-failures.txt"
  "$submission_dir/evidence/diagnostics.log"
  "$submission_dir/evidence/error-code-summary.txt"
  "$submission_dir/evidence/file-inventory.txt"
  "$submission_dir/evidence/listing-output.txt"
  "$submission_dir/evidence/status-summary.txt"
  "$submission_dir/evidence/suspect-access.txt"
  "$submission_dir/evidence/timeline.txt"
)

printf '%s\n' \
  '=======================================================' \
  'Assignment 01 Submission Verification' \
  '======================================================='

for required_file in "${required_files[@]}"; do
  if [[ ! -e "$required_file" ]]; then
    printf '[MISSING] %s\n' "$required_file"
    errors=$((errors + 1))
  elif [[ ! -s "$required_file" && "$required_file" != *"diagnostics.log" ]]; then
    printf '[EMPTY]   %s\n' "$required_file"
    errors=$((errors + 1))
  else
    printf '[OK]      %s\n' "$required_file"
  fi
done

if [[ -f "$submission_dir/commands.md" ]] && \
   grep -q 'Replace this comment' "$submission_dir/commands.md"; then
  printf '[INCOMPLETE] submission/commands.md still contains template instructions.\n'
  errors=$((errors + 1))
fi

if [[ -f "$submission_dir/findings.md" ]] && \
   grep -Eq '\[NAME\]|\[STUDENT NUMBER\]|describe here' "$submission_dir/findings.md"; then
  printf '[INCOMPLETE] submission/findings.md contains declaration placeholders.\n'
  errors=$((errors + 1))
fi

if find "$submission_dir" -type l -print -quit | grep -q .; then
  printf '[UNSAFE] Submission contains one or more symbolic links.\n'
  errors=$((errors + 1))
fi

printf '\n'
if (( errors == 0 )); then
  printf '%s\n' \
    'SUBMISSION STRUCTURE PASSED' \
    'You must still inspect the report contents and final archive manually.'
  exit 0
fi

printf 'SUBMISSION STRUCTURE FAILED: %d issue(s) found.\n' "$errors"
exit 1
