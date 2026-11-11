# Chapter 08 slide-by-slide lecture file map

This map refers to Slides 34–83 of the combined **Advanced Vim Workflows and
Version Control with Git** lecture.

## Before the lecture

From the course-repository root:

```bash
examples=examples/chapter08-git
cp -R "$examples/sample-project" /tmp/ch08-basic
"$examples/prepare-three-state-demo.sh" /tmp/ch08-three-state
"$examples/prepare-conflict-demo.sh" /tmp/ch08-conflict
"$examples/prepare-remote-demo.sh" /tmp/ch08-remotes
```

Initialize the basic workspace:

```bash
cd /tmp/ch08-basic
git init -b main
git config user.name "Chapter 08 Demo"
git config user.email "chapter08@example.invalid"
make test
git add .gitignore Makefile README.md src tests
git commit -m "Establish tested analyzer baseline"
```

Use new target names if these directories already exist. The scripts refuse to
overwrite existing directories.

## Slide-by-slide alignment

| Slide | Slide title | File to use | Command or action |
|---:|---|---|---|
| 34 | **Chapter 08 title** | `README.md` | Introduce the example folder; no command. |
| 35 | **Chapter 08 learning objectives** | `README.md`; `exercises/chapter08-git/README.md` | Relate objectives to the examples and laboratory. |
| 36 | **Why version control matters** | `repository-walkthrough.md` | In `/tmp/ch08-basic`, run `git status`. |
| 37 | **Version control as engineering memory** | `/tmp/ch08-basic` | `git log --oneline --decorate` |
| 38 | **Distributed does not mean backed up** | `/tmp/ch08-basic` | `git remote -v`; explain that no remote means no independent copy. |
| 39 | **Git's snapshot model** | `/tmp/ch08-basic` | `git log --oneline --graph --decorate --all` |
| 40 | **Core Git objects** | `/tmp/ch08-basic` | `git cat-file -t HEAD`; `git cat-file -p HEAD`; `git ls-tree -r HEAD` |
| 41 | **Objects and references** | `/tmp/ch08-basic` | `git show-ref`; `git rev-parse main`; `git rev-parse HEAD^{tree}` |
| 42 | **Names move; commits do not** | `/tmp/ch08-basic` | Record `git rev-parse HEAD`, make a small commit, then compare the new identifier. |
| 43 | **Reachability and retention** | `/tmp/ch08-basic` | `git branch --contains HEAD`; `git tag --contains HEAD`; avoid pruning commands. |
| 44 | **The three working areas** | `/tmp/ch08-three-state`; `prepare-three-state-demo.sh` | `git status --short`; identify `HEAD`, index, and working tree. |
| 45 | **One path can have three versions** | `/tmp/ch08-three-state` | `git show HEAD:src/analyzer.c`; `git show :src/analyzer.c`; `sed -n '1,120p' src/analyzer.c` |
| 46 | **Creating a repository** | `sample-project/`; `repository-walkthrough.md` | In a fresh copy: `git init -b main`; `git status`. |
| 47 | **Configure identity** | Fresh disposable repository | `git config user.name ...`; `git config user.email ...`; `git config --local --list --show-origin` |
| 48 | **Orientation before action** | `/tmp/ch08-basic` | `git status`; `git branch --show-current`; `git log -1 --oneline --decorate`; `git remote -v` |
| 49 | **Reading short status** | `/tmp/ch08-three-state` | `git status --short`; explain ` M` versus `M `. |
| 50 | **The three important diffs** | `/tmp/ch08-three-state` | `git diff`; `git diff --staged`; `git diff HEAD` |
| 51 | **Staging is proposal construction** | `/tmp/ch08-three-state` | `git diff --staged -- tests/test_analyzer.sh` |
| 52 | **Patch staging** | Separate copy of `sample-project/` | Make two changes; run `git add -p src/analyzer.c`, `git diff`, and `git diff --staged`. |
| 53 | **Risk of partial staging** | `/tmp/ch08-three-state` | `make clean test` passes using unstaged implementation; inspect both diffs again. |
| 54 | **Testing the exact proposed snapshot** | `test-staged-snapshot.sh`; `staged-snapshot-checklist.md` | `"$examples/test-staged-snapshot.sh" /tmp/ch08-three-state`; failure is expected. |
| 55 | **Creating a focused commit** | `repository-walkthrough.md`; `/tmp/ch08-basic` | `git add PATHS`; `git diff --staged`; `git commit -m "Describe changed behavior"` |
| 56 | **Commit-message design** | `/tmp/ch08-basic` | `git log -3 --format='%h %s'`; compare purposeful and vague messages. |
| 57 | **Ignoring generated and local files** | `sample-project/.gitignore` | `cat .gitignore`; `make`; `git status --short`; `git check-ignore -v build/analyzer` |
| 58 | **What `.gitignore` does not provide** | `sample-project/.gitignore` | `git ls-files`; discuss tracked content, history, access control, and secrets. |
| 59 | **Reading history** | `/tmp/ch08-basic` | Graph log; `git show HEAD`; `git log -- src/analyzer.c`; `git blame src/analyzer.c` |
| 60 | **Branches** | `branching-demo.md`; `/tmp/ch08-basic` | `git switch -c feature/input-validation`; `git branch -vv` |
| 61 | **Branch starting points** | `/tmp/ch08-basic` | `git switch -c feature/from-main main`; `git merge-base main feature/from-main` |
| 62 | **Fast-forward integration** | Disposable topic in `/tmp/ch08-basic` | Commit on topic while `main` is unchanged; switch to main; `git merge --ff-only BRANCH`. |
| 63 | **Merge-commit integration** | `branching-demo.md` | Integrate another topic with `git merge --no-ff BRANCH -m "Merge focused topic"`; inspect graph. |
| 64 | **Merge conflicts** | `/tmp/ch08-conflict`; `prepare-conflict-demo.sh` | `git status`; `git diff --cc`; search `src/analyzer.c` for conflict markers. |
| 65 | **Conflict-resolution workflow** | `/tmp/ch08-conflict`; `branching-demo.md` | Resolve source, search markers, `git add`, `git diff --staged`, `make test`, `git commit`. |
| 66 | **Semantic conflicts** | `/tmp/ch08-conflict` | Require both leading-space removal and rejection of input empty after trimming. |
| 67 | **Undoing uncommitted changes** | `recovery-and-stash-demo.md` | Demonstrate `git restore README.md` and, separately, `git restore --staged README.md`. |
| 68 | **Revert, reset, and reflog** | `recovery-and-stash-demo.md` | Run the revert example and `git reflog`; explain reset without destructive live use. |
| 69 | **Stashes** | `recovery-and-stash-demo.md` | `git stash push -m "WIP lecture demo"`; list, show, and apply the stash. |
| 70 | **Remotes** | `/tmp/ch08-remotes`; `prepare-remote-demo.sh` | `git -C /tmp/ch08-remotes/student remote -v` |
| 71 | **Remote-tracking references** | `/tmp/ch08-remotes/student` | Before fetch: graph log and `git branch -vv`; `origin/main` is intentionally stale. |
| 72 | **Fetch before integration** | `/tmp/ch08-remotes/NEXT-STEPS.md` | Fetch; graph log; `git log HEAD..origin/main --oneline`; `git diff --stat HEAD...origin/main`. |
| 73 | **Credential safety** | No file required | Discussion. No example requires a token; never put one in URLs, scripts, files, or screenshots. |
| 74 | **Worked example: focused change** | `sample-project/`; both walkthrough documents | Create `fix/reject-empty-input`, edit source/tests, test, stage coherent paths, inspect, commit. |
| 75 | **Verify the committed result** | Focused-change repository | `git show --stat HEAD`; `git show HEAD`; `git status`; graph log; `make test` |
| 76 | **Repository lifecycle laboratory** | `exercises/chapter08-git/README.md`; `starter/` | Introduce Parts A–F. Students copy `starter/`; never initialize inside the course repository. |
| 77 | **Laboratory acceptance criteria** | `exercises/chapter08-git/README.md` | Review the acceptance-criteria section; no command. |
| 78 | **Common Git mistakes** | `staged-snapshot-checklist.md`; `recovery-and-stash-demo.md` | Connect each mistake to its prevention or inspection command. |
| 79 | **Case study: the emergency commit** | No live secret fixture | Discussion only; never commit a real credential for demonstration. |
| 80 | **Emergency response priorities** | No file required | Discuss revoke/rotate, preserve evidence, assess, remediate through policy, and add controls. |
| 81 | **Chapter 08 summary** | `README.md`; `repository-walkthrough.md` | Revisit status, the three diffs, staging, commit, and graph log. |
| 82 | **Final discussion** | `/tmp/ch08-three-state` | Re-run status, diffs, working-tree test, and staged-snapshot test as students answer. |
| 83 | **Looking ahead** | No Chapter 08 command | Preview Chapter 09 collaboration, review, CI, integration policy, and releases. |

## Important precautions

- Never initialize Git in the root of the instructor-managed course repository.
- Keep demonstrations in the four disposable workspaces.
- Never use a real credential as a fixture.
- Do not demonstrate destructive reset or cleanup on student work.
- The Slide 54 staged-snapshot failure is intentional.
- The conflict remains unresolved until Slides 65–66.
