# Recovery and stash demonstrations

Use only a disposable prepared repository. Before every operation, inspect
`git status`, `git diff`, and the graph. Predict the working tree, index, and branch
state that should remain afterward.

## Restore an unstaged edit

```bash
printf '\nTemporary note\n' >> README.md
git diff -- README.md
git restore README.md
```

`restore` discards this working-tree edit. Do not run it on work you need to keep.

## Unstage while retaining the edit

```bash
printf '\nDocumentation note\n' >> README.md
git add README.md
git diff --staged -- README.md
git restore --staged README.md
git diff -- README.md
```

## Revert a published-style commit

```bash
git add README.md
git commit -m 'Document temporary behavior'
git revert HEAD
git log -2 --oneline
```

Revert adds a new inverse commit and preserves ancestry.

## Inspect reflog after moving a private disposable branch

```bash
git branch recovery-before-reset
git reset --mixed HEAD^
git reflog -5
git reset --hard recovery-before-reset
```

This reset demonstration is intentionally limited to a disposable repository with
a recovery branch. Reflogs are local and temporary, not a backup policy.

## Stash a context switch

```bash
printf '\nWork in progress\n' >> README.md
git stash push -m 'WIP documentation'
git stash list
git stash show -p stash@{0}
git stash apply stash@{0}
```

Inspect the result before dropping the stash. Untracked and ignored files are not
included by default, and stashes are not pushed to a remote.
