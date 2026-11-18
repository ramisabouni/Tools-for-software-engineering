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

# Stage a changed expectation without its implementation.
python3 - "$target/tests/test_analyzer.sh" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
path.write_text(path.read_text().replace(
    "check OTHER 'DEBUG retry scheduled'",
    "check DEBUG 'DEBUG retry scheduled'"))
PY
git -C "$target" add tests/test_analyzer.sh

# Add the required implementation only to the working tree.
python3 - "$target/src/analyzer.c" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text()
text = text.replace('if (strncmp(message, "INFO", 4) == 0) return "INFO";',
                    'if (strncmp(message, "INFO", 4) == 0) return "INFO";\n'
                    '    if (strncmp(message, "DEBUG", 5) == 0) return "DEBUG";')
path.write_text(text)
PY

printf 'Prepared %s\n\n' "$target"
printf '%s\n' 'Expected state:' \
  '- HEAD: baseline analyzer and baseline tests' \
  '- Index: baseline analyzer plus a staged DEBUG test' \
  '- Working tree: DEBUG implementation plus the staged test' \
  '' 'Run:' \
  "  git -C '$target' status --short" \
  "  git -C '$target' diff" \
  "  git -C '$target' diff --staged" \
  "  make -C '$target' clean test"
