# Staged snapshot checklist

- `git status` identifies staged, unstaged, and untracked scope.
- `git diff` reviews worktree changes not staged.
- `git diff --staged` reviews the proposed commit.
- The commit has one coherent purpose and explains why.
- No credential, generated output, local configuration, or unrelated formatting
  has entered the snapshot.

To test the exact index without disturbing the current working tree, create a
temporary archive of the staged tree:

```bash
stage_dir="$(mktemp -d)"
git write-tree | xargs git archive --format=tar | tar -xf - -C "$stage_dir"
make -C "$stage_dir" test
rm -rf "$stage_dir"
```

Run the removal only after confirming that `stage_dir` contains the temporary
directory created by `mktemp`. This procedure tests tracked staged content; it
also exposes a proposed commit that accidentally depends on unstaged files.
