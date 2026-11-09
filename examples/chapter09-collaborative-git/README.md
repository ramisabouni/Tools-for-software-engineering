# Chapter 09 examples — Collaborative Development with Git

| Resource | Purpose |
|---|---|
| `team-workflow.md` | Roles, protected-main invariant, and lifecycle |
| `pull-request-checklist.md` | Author readiness and evidence |
| `code-review-checklist.md` | Contract-first, test, security, and operational review |
| `ci-review-evidence.md` | Candidate identity and false-green prevention |
| `merge-conflict-demo.md` | Textual and semantic conflict resolution |
| `branch-state-demo.sh` | Reproducible ahead, behind, and diverged graphs |
| `lease-demo.sh` | Reproducible stale `--force-with-lease` rejection |

The scripts create their own temporary local repositories and print the retained
location. They never contact GitHub or modify the course repository.
