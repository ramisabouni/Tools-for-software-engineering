# Repository walkthrough

Work in a disposable copy of `sample-project/`.

```bash
cp -R sample-project /tmp/ch08-walkthrough
cd /tmp/ch08-walkthrough
git init -b main
git config user.name "Course Student"
git config user.email "student@example.invalid"
```

## Classify and commit

Run `make test`; this creates `build/`, which is intentionally ignored. Diagnose
the rule, inspect the proposed snapshot, and create the first commit.

```bash
make test
git status --short
git check-ignore -v build/analyzer
git add .gitignore Makefile README.md src tests
git diff --staged --stat
git diff --staged
git commit -m "Establish tested analyzer baseline"
```

## Compare the three states

Change the program, stage it, then change the same file again. Compare:

```bash
git status
git diff                 # working tree versus index
git diff --staged        # index versus HEAD
git diff HEAD            # working tree versus HEAD
```

Use `git add -p` to select coherent hunks. Before committing, test the exact
staged snapshot with the procedure in `staged-snapshot-checklist.md`.

## Inspect objects and history

```bash
git log --oneline --graph --decorate --all
git show --stat HEAD
git ls-tree -r HEAD
git cat-file -t HEAD
git log --follow -- src/analyzer.c
git blame src/analyzer.c
```

After a verified integration, create and inspect an annotated tag:

```bash
git tag -a chapter08-lab-v1 -m "Verified Chapter 08 result"
git show chapter08-lab-v1
```

The configured name and email are metadata; they do not authenticate a person.
