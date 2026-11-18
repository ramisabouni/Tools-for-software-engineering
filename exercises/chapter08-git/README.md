# Laboratory 08 — Repository Lifecycle

Work in a copy of `starter/`; do not initialize Git in the instructor-managed
course repository.

## Learning objectives

- Distinguish the working tree, index, commits, and references.
- Construct focused commits and verify the exact staged snapshot.
- Isolate work with branches and resolve a conflict semantically.
- Investigate history and mark a verified result with an annotated tag.

## Part A — Initialize and classify

1. Copy `starter/` into your course-work area and initialize a `main` branch.
2. Configure repository-local course identity if required.
3. Run `make test`. Classify source, tests, documentation, generated output, and
   `.course-local`. Complete `.gitignore` with narrow rules.
4. Use `git check-ignore -v` to explain why each excluded path is ignored.

## Part B — Initial snapshot

Stage only source, tests, build instructions, documentation, and `.gitignore`.
Review both filenames and the staged diff, run the tests, then create an
explanatory initial commit.

## Part C — Two focused commits

Create `feature/subtraction`. In one working session:

- implement `subtract(int, int)` and add a test; and
- correct the deliberate typo in `README.md`.

Use `git add -p` to create two focused commits. At each boundary, inspect
`git diff`, `git diff --staged`, and `git status`. Use the exact-snapshot method
from the Chapter 08 example checklist before committing the program change.

## Part D — Investigate history

Create `investigation.md` containing commands and evidence that answer:

1. Which commit introduced subtraction?
2. Which commits affected `calculator.c`?
3. Who last changed the subtraction return statement according to `git blame`?
4. Why does blame not necessarily identify who invented the idea?

Include `git show`, a path-limited log, and blame evidence. Save
`git log --oneline --graph --decorate --all` as `history.txt`.

## Part E — Controlled conflict

From the initial commit, create `feature/multiplication-a` and implement
multiplication using repeated addition. From the same initial commit, create
`feature/multiplication-b` and implement multiplication with the `*` operator.
Merge both branches into `main` so the second merge conflicts. Resolve it by
retaining the direct implementation and adding the required multiplication test.
Search for conflict markers, inspect the staged resolution, and run `make test`
before completing the merge.

## Part F — Tag and verify

Create the annotated tag `chapter08-lab-v1` only after all tests pass. Confirm
that the feature commits are reachable, refresh `history.txt`, and create
`NOTES.md` with assumptions, exact verification commands, and a short explanation
of the conflict resolution.

## Deliverables

Submit an approved repository bundle or archive that preserves `.git`, plus:

- `.gitignore`, `Makefile`, `calculator.c`, `test_calculator.sh`, and `README.md`;
- `history.txt`, `investigation.md`, and `NOTES.md`; and
- the annotated tag and complete commit graph.

Do not submit credentials, `.course-local`, generated binaries, editor files, or
unrelated artifacts.

## Acceptance criteria

The work is complete when ignore rules are narrow and explainable; commits are
coherent; staged and unstaged changes are separately inspected; the semantic
resolution preserves the stated behavior; the integrated tree passes tests; the
annotated tag names the verified commit; and the repository opens cleanly in a
new location.
