# CI and review evidence checklist

## Candidate identity

- Record the exact commit and base tested.
- Confirm required checks apply to the current pull-request head or current-base
  integration candidate, not an earlier revision.
- Fetch before interpreting ahead, behind, or diverged status.

## Test evidence

- Record command, suite, expected and executed counts, failures, skips, duration,
  environment, and artifact identifiers.
- Fail if discovery executes fewer tests than the declared minimum.
- Demonstrate a regression test failing before and passing after the correction.
- Treat a flaky result as a defect with an owner, not an invitation to retry until green.

## Automation safety

- Grant the job only required permissions and secrets.
- Do not expose privileged secrets to untrusted pull-request code.
- Pin or verify external automation components according to project policy.
- Protect pipeline configuration and retain useful failure diagnostics.

A green check is evidence only for the assertions it actually executed.
