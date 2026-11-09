# Evidence-based code-review checklist

## Contract and correctness

- State the behavior claimed by the change before reading implementation details.
- Check boundaries, error policy, invariants, compatibility, and failure behavior.
- Inspect surrounding code when the invariant crosses the diff boundary.

## Tests as programs

- Confirm discovery ran the intended suites and expected number of tests.
- Ask whether the regression test fails against the defective revision.
- Check determinism, isolation, meaningful assertions, and untested branches.

## Security and operations

- Review input trust, permissions, credential handling, logging, dependencies,
  deployment, migration, rollback, and observable failure.

## Actionable comments

Use this structure: **condition → consequence → requested evidence**.

> If `count` is zero, integer division terminates the program before a result is
> returned. Define the error behavior and add a zero-count test that demonstrates it.

Mark blockers, questions, and optional suggestions distinctly. Approval applies to
a specific revision; inspect new commits before renewing it.
