# Team workflow

1. Define roles: author owns scope and evidence; reviewer independently evaluates
   the claim; maintainer enforces policy and chooses integration.
2. Protect `main`: require pull requests, current checks, review, and auditable
   exceptions; prohibit direct and force pushes.
3. Fetch and inspect before integrating. `origin/main` is the state observed at
   the most recent fetch, not a live view of the server.
4. Create a short-lived topic from an identified base, add tests, self-review the
   complete three-dot diff, and publish with an upstream.
5. Review the contract, implementation, tests, security, operational effects, and
   rollback implications. Comments name condition, consequence, and acceptance
   evidence.
6. Resolve both textual and semantic interactions, then test the current candidate
   against the current protected base.
7. Integrate using the declared merge, squash, or rebase policy. Tag only a
   verified commit and bind the tag to build and artifact evidence.

History rewriting may be allowed for an author-owned private topic. It is not a
routine operation for `main` or a branch used by other contributors.
