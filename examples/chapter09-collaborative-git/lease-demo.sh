#!/usr/bin/env sh
set -eu

root=$(mktemp -d)
remote="$root/remote.git"
git init -q --bare "$remote"
git clone -q "$remote" "$root/author"
git -C "$root/author" config user.name Author
git -C "$root/author" config user.email author@example.invalid
printf 'base\n' > "$root/author/topic.txt"
git -C "$root/author" add topic.txt
git -C "$root/author" commit -q -m 'Create private topic'
git -C "$root/author" branch -M topic
git -C "$root/author" push -q -u origin topic
git --git-dir="$remote" symbolic-ref HEAD refs/heads/topic
git clone -q "$remote" "$root/other"
git -C "$root/other" config user.name Other
git -C "$root/other" config user.email other@example.invalid
printf 'unseen update\n' >> "$root/other/topic.txt"
git -C "$root/other" commit -qam 'Advance remote topic'
git -C "$root/other" push -q

printf 'author rewrite\n' >> "$root/author/topic.txt"
git -C "$root/author" commit -qam 'Rewrite local topic'
set +e
git -C "$root/author" push --force-with-lease >"$root/lease-output.txt" 2>&1
status=$?
set -e
cat "$root/lease-output.txt"
[ "$status" -ne 0 ] || { printf 'Expected lease rejection did not occur.\n' >&2; exit 1; }
printf '\nLease correctly rejected an unseen update. Fetch and inspect; do not weaken it.\n'
printf 'Disposable demonstration retained at: %s\n' "$root"
