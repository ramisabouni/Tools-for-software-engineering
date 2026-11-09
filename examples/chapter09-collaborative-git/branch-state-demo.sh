#!/usr/bin/env sh
set -eu

root=$(mktemp -d)
remote="$root/remote.git"
git init -q --bare "$remote"
git clone -q "$remote" "$root/alice"
git -C "$root/alice" config user.name Alice
git -C "$root/alice" config user.email alice@example.invalid
printf 'base\n' > "$root/alice/state.txt"
git -C "$root/alice" add state.txt
git -C "$root/alice" commit -q -m 'Establish base'
git -C "$root/alice" branch -M main
git -C "$root/alice" push -q -u origin main
git --git-dir="$remote" symbolic-ref HEAD refs/heads/main
git clone -q "$remote" "$root/bob"
git -C "$root/bob" config user.name Bob
git -C "$root/bob" config user.email bob@example.invalid

printf 'alice remote change\n' >> "$root/alice/state.txt"
git -C "$root/alice" commit -qam 'Add remote change'
git -C "$root/alice" push -q

printf '\nBOB BEFORE FETCH: origin/main is stale; working tree is unchanged.\n'
git -C "$root/bob" status --short --branch
git -C "$root/bob" fetch -q origin
printf '\nBEHIND AFTER FETCH:\n'
git -C "$root/bob" status --short --branch

printf 'bob local change\n' >> "$root/bob/state.txt"
git -C "$root/bob" commit -qam 'Add local change'
printf '\nDIVERGED GRAPH:\n'
git -C "$root/bob" log --oneline --graph --decorate --all
printf '\nRemote-only commits:\n'
git -C "$root/bob" log --oneline HEAD..origin/main
printf 'Local-only commits:\n'
git -C "$root/bob" log --oneline origin/main..HEAD
printf '\nDisposable demonstration retained at: %s\n' "$root"
