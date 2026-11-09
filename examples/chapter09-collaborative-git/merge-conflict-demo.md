# Textual and semantic conflict demonstration

Create two branches from one verified base. Let both edit the same default-mode
line so Git produces markers. Before resolving, write both behavioral requirements.
Construct the combined behavior, review the staged resolution, search for remaining
markers, and run focused plus integration tests.

```bash
git status
git diff --cc
grep -R -n -E '^(<<<<<<<|=======|>>>>>>>)' src tests || true
git add src tests
git diff --staged
make test
git commit
```

Then demonstrate a semantic conflict: one branch changes a valid mode name while
another test or configuration still uses the old name. Git may merge without a
marker, yet the combined system fails. Textual cleanliness is not integration
correctness.
