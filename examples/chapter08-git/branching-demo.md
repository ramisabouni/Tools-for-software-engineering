# Branching and conflict demonstration

Start from a clean committed copy of `sample-project/`.

1. Create `feature/reject-empty`, add an empty-input check and a test, then make
   one focused commit.
2. Return to `main`, create `feature/trim-input`, and change the same input-handling
   region so leading and trailing whitespace is removed.
3. Merge `feature/reject-empty` into `main`, then merge `feature/trim-input`.
4. Use `git status` and the conflict markers to locate the textual conflict.
5. Construct a combined implementation that both trims input and rejects a result
   that is empty. Do not blindly choose `--ours` or `--theirs`.
6. Search for remaining markers and test before completing the merge:

```bash
grep -R -n -E '^(<<<<<<<|=======|>>>>>>>)' src tests || true
git diff
git add src/analyzer.c tests/test_analyzer.sh
git diff --staged
make test
git commit
git log --oneline --graph --decorate --all
```

The correct resolution is determined by the two behavioral requirements, not by
which branch was created first.
