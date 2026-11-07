#!/usr/bin/env bash
set -uo pipefail

submission=${1:-submission}
failures=0

required=(
  analyze.sh
  commands.md
  findings.md
  verify-inputs.sh
  patterns/patterns.txt
  awk/summarize-services.awk
  sed/normalize-events.sed
  edited/service.conf
  evidence/file-inventory.txt
  evidence/selected-events.txt
  evidence/normalized-events.txt
  evidence/rejected-records.txt
  evidence/independent-check.txt
  evidence/configuration.diff
  evidence/vim-journal.md
  reports/service-summary.csv
  reports/status-summary.txt
  reports/manifest.txt
)

for relative in "${required[@]}"; do
  if [[ -s "$submission/$relative" ]]; then
    printf '[OK] %s\n' "$relative"
  else
    printf '[MISSING OR EMPTY] %s\n' "$relative" >&2
    failures=$((failures + 1))
  fi
done

if [[ -f "$submission/findings.md" ]] && grep -Eq 'student number \*\*[0-9]+\*\*|Student number:[[:space:]]*[0-9]+' "$submission/findings.md"; then
  printf '[OK] student information\n'
else
  printf '[INCOMPLETE] student number in findings.md\n' >&2
  failures=$((failures + 1))
fi

if grep -R -E 'REPLACE WITH|Replace this line|# Add exact|TODO' "$submission/commands.md" "$submission/findings.md" >/dev/null 2>&1; then
  printf '[INCOMPLETE] template instructions remain in reports\n' >&2
  failures=$((failures + 1))
else
  printf '[OK] report templates completed\n'
fi

if (( failures )); then
  printf 'SUBMISSION STRUCTURE FAILED: %d problem(s)\n' "$failures" >&2
  exit 1
fi

printf 'SUBMISSION STRUCTURE PASSED\n'

