# Chapter 08 examples — Version Control with Git

These examples support the demonstrations in Chapter 08.

| File or folder | Purpose |
|---|---|
| `repository-walkthrough.md` | Working tree, index, commits, diffs, ignore rules, and tags |
| `branching-demo.md` | Branches, deliberate merge commits, and semantic conflict resolution |
| `staged-snapshot-checklist.md` | Pre-commit review and exact-snapshot verification |
| `sample-project/` | Small buildable and testable project used by the walkthroughs |
| `lecture-file-map.md` | Slide-by-slide file and demonstration map |
| `prepare-three-state-demo.sh` | Creates staged and unstaged versions that behave differently |
| `test-staged-snapshot.sh` | Tests the exact index in an isolated temporary directory |
| `prepare-conflict-demo.sh` | Creates a repository stopped at a controlled merge conflict |
| `prepare-remote-demo.sh` | Creates a local bare remote and two clones with stale knowledge |
| `recovery-and-stash-demo.md` | Safe restore, revert, reflog, reset, and stash exercises |

Always copy `sample-project/` to a disposable directory before a demonstration.
Do not initialize Git inside the instructor-managed course repository.

The preparation scripts refuse to overwrite an existing target. A convenient
lecture workspace is a new directory under `/tmp` or the student's course-work
area. All configured email addresses use the reserved `.invalid` domain.
