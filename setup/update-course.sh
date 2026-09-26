#!/usr/bin/env bash

# Update instructor-managed course files in a student's private repository.
# Student work under student-work/ is never modified by this script.

set -Eeuo pipefail

UPSTREAM_NAME="${COURSE_UPSTREAM_NAME:-upstream}"
UPSTREAM_URL="${COURSE_UPSTREAM_URL:-https://github.com/ramisabouni/Tools-for-software-engineering.git}"
UPSTREAM_BRANCH="${COURSE_UPSTREAM_BRANCH:-Fall2026}"

# Only these paths are controlled by the instructor and replaced by updates.
# Do not add student-work to this list.
MANAGED_PATHS=(
  ".devcontainer"
  "datasets"
  "examples"
  "exercises"
  "scripts"
  "setup"
  "LICENSE"
  "README.md"
)

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || die "Git is not installed."
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || \
  die "Run this script from inside your student repository."

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

printf '%s\n' \
  '=======================================================' \
  'Course-Material Update' \
  '=======================================================' \
  "Student repository: $REPO_ROOT" \
  "Instructor source:  $UPSTREAM_URL" \
  "Course branch:      $UPSTREAM_BRANCH" \
  ''

# Protect deliberate or accidental edits to instructor-managed files. Students
# should keep all personal work under student-work/.
if ! git diff --quiet -- "${MANAGED_PATHS[@]}" || \
   ! git diff --cached --quiet -- "${MANAGED_PATHS[@]}"; then
  git status --short -- "${MANAGED_PATHS[@]}"
  die "Instructor-managed files contain changes. Commit, discard, or move those changes into student-work before updating."
fi

UNTRACKED="$(git ls-files --others --exclude-standard -- "${MANAGED_PATHS[@]}")"
if [[ -n "$UNTRACKED" ]]; then
  printf '%s\n' 'Untracked files were found in instructor-managed folders:' "$UNTRACKED" >&2
  die "Move these files into student-work before updating."
fi

if git remote get-url "$UPSTREAM_NAME" >/dev/null 2>&1; then
  CURRENT_UPSTREAM="$(git remote get-url "$UPSTREAM_NAME")"
  case "$CURRENT_UPSTREAM" in
    "$UPSTREAM_URL"|"${UPSTREAM_URL%.git}") ;;
    *) die "Remote '$UPSTREAM_NAME' points to an unexpected URL: $CURRENT_UPSTREAM" ;;
  esac
else
  git remote add "$UPSTREAM_NAME" "$UPSTREAM_URL"
fi

printf 'Downloading current course materials...\n'
git fetch --no-tags "$UPSTREAM_NAME" "$UPSTREAM_BRANCH"
SOURCE_REF="$UPSTREAM_NAME/$UPSTREAM_BRANCH"

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_DIR"' EXIT

# Determine tracked managed files removed by the instructor. `git restore`
# updates and adds files but does not reliably remove every formerly tracked
# path when template repositories have independent histories.
git ls-files -- "${MANAGED_PATHS[@]}" | LC_ALL=C sort >"$TEMP_DIR/local-files"
git ls-tree -r --name-only "$SOURCE_REF" -- "${MANAGED_PATHS[@]}" | \
  LC_ALL=C sort >"$TEMP_DIR/upstream-files"

while IFS= read -r removed_file; do
  [[ -n "$removed_file" ]] || continue
  rm -f -- "$REPO_ROOT/$removed_file"
done < <(comm -23 "$TEMP_DIR/local-files" "$TEMP_DIR/upstream-files")

git restore --source="$SOURCE_REF" --worktree -- "${MANAGED_PATHS[@]}"

printf '\n%s\n' \
  'Course materials have been updated.' \
  'The student-work directory was not modified.' \
  '' \
  'Review the update:' \
  '  git status' \
  '  git diff --stat' \
  '' \
  'Then save the update in your private repository:' \
  '  git add .devcontainer datasets examples exercises scripts setup LICENSE README.md' \
  '  git commit -m "Update course materials"' \
  '  git push' \
  '' \
  'If .devcontainer changed, rebuild the Codespace container.'
