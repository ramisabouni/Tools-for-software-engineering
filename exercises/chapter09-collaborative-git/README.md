# Laboratory 09 — Team Integration

Work in teams of three or four using an instructor-approved shared repository. If
hosting is unavailable, use a local bare repository and separate clones. Never
place a password or access token in a URL, command transcript, screenshot, or file.

## Learning objectives

- Interpret remote-tracking references and branch divergence after fetching.
- Create and review focused pull-request candidates with traceable evidence.
- Resolve textual and semantic conflicts according to requirements.
- Evaluate CI evidence and bind a verified release to an immutable revision.

## Part A — Establish policy

Copy `starter/` into the team repository. Complete `repository-policy.md` before
coding: roles, protected branch, naming, required checks, review count, integration
strategy, rewrite rule, conflict owner, and auditable emergency exception. Record
how actual hosting settings match the policy or identify a local simulation.

## Part B — Create reviewable topics

Each author fetches `main`, records its commit identifier, and creates one topic:

- `feature/safe-average`: define zero-count behavior and add its regression test;
- `feature/decimal-average`: add decimal output and tests; or
- `docs/error-contract`: document the public error contract.

Keep topics focused, self-review `origin/main...HEAD`, run `make ci`, and publish
with an upstream. Complete one copy of `pull-request.md` per topic.

## Part C — Review

Review another participant's current revision using `review.md`. Provide at least
one substantive observation using condition, consequence, and acceptance evidence.
The author records the response and resulting commit or a reasoned technical reply.

## Part D — Controlled divergence and conflicts

The instructor introduces the supplied `conflict/safe-default` and
`conflict/fast-default` changes to the same configuration line. Fetch and draw the
graph before integrating. Resolve according to the written requirement in
`requirements.md`, not by choosing a side mechanically.

Next detect the marker-free semantic interaction: decimal formatting changes the
output contract used by an older integration test. Update authoritative code and
tests consistently. Inspect the staged resolution and run `make ci` against the
current candidate.

## Part E — Integrate and release

Integrate only through the declared strategy after current checks and approval.
Verify `main`, create annotated tag `chapter09-lab-v1`, and complete
`release-manifest.md` with commit, tag target, test evidence, artifact digest, and
integration decision. Refresh `graph.txt` from all references.

## Deliverables

- Completed policy, pull-request, review, conflict-resolution, CI-evidence, and
  release-manifest documents.
- Source, tests, build/CI definitions, `graph.txt`, and `NOTES.md`.
- Repository history containing reviewable topics, controlled integration, and the
  annotated release tag.

## Acceptance criteria

The written policy matches actions; each topic identifies its base and stays
focused; descriptions and comments contain actionable evidence; author responses
are traceable; conflict resolution preserves both intended behaviors; current
candidate checks pass; integration follows policy; the tag names the verified
commit; and no private credential appears anywhere in submitted evidence.
