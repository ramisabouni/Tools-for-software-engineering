#!/usr/bin/env sh
set -eu

if [ "$#" -ne 1 ] || [ ! -d "$1/.git" ]; then
    printf 'usage: %s GIT_REPOSITORY\n' "$0" >&2
    exit 2
fi
repo=$(CDPATH= cd -- "$1" && pwd)
stage_dir=$(mktemp -d)
cleanup() { rm -rf -- "$stage_dir"; }
trap cleanup EXIT HUP INT TERM

tree=$(git -C "$repo" write-tree)
git -C "$repo" archive --format=tar "$tree" | tar -xf - -C "$stage_dir"
printf 'Testing staged tree %s in %s\n' "$tree" "$stage_dir"
make -C "$stage_dir" clean test
