#!/usr/bin/env sh
set -eu

if [ "$#" -ne 1 ]; then
    printf 'usage: %s NEW_TARGET_DIRECTORY\n' "$0" >&2
    exit 2
fi
target=$1
[ ! -e "$target" ] || { printf 'Refusing to overwrite: %s\n' "$target" >&2; exit 2; }
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cp -R "$script_dir/sample-project" "$target"
git -C "$target" init -q -b main
git -C "$target" config user.name 'Chapter 08 Demo'
git -C "$target" config user.email 'chapter08@example.invalid'
git -C "$target" add .gitignore Makefile README.md src tests
git -C "$target" commit -q -m 'Establish tested analyzer baseline'

git -C "$target" switch -q -c feature/reject-empty
python3 - "$target/src/analyzer.c" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text().replace('    puts(classify(argv[1]));', '''    if (argv[1][0] == '\\0') {
        fputs("message must not be empty\\n", stderr);
        return 3;
    }
    puts(classify(argv[1]));''')
p.write_text(s)
PY
git -C "$target" add src/analyzer.c
git -C "$target" commit -q -m 'Reject empty analyzer input'

git -C "$target" switch -q main
git -C "$target" switch -q -c feature/normalize-input
python3 - "$target/src/analyzer.c" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text().replace('    puts(classify(argv[1]));', '''    const char *message = argv[1];
    while (*message == ' ') ++message;
    puts(classify(message));''')
p.write_text(s)
PY
git -C "$target" add src/analyzer.c
git -C "$target" commit -q -m 'Ignore leading spaces in analyzer input'

git -C "$target" switch -q main
git -C "$target" merge -q --no-ff feature/reject-empty -m 'Merge empty-input validation'
set +e
git -C "$target" merge --no-ff feature/normalize-input >/dev/null 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'Expected conflict did not occur.\n' >&2; exit 1; }

printf 'Prepared a controlled conflict at %s\n' "$target"
printf '%s\n' \
  'Requirements for the semantic resolution:' \
  '1. Remove leading spaces before classification.' \
  '2. Reject input that is empty after leading spaces are removed.' \
  '3. Do not choose one branch mechanically.' \
  '' 'Inspect with:' \
  "  git -C '$target' status" \
  "  git -C '$target' diff --cc" \
  "  git -C '$target' log --oneline --graph --decorate --all"
