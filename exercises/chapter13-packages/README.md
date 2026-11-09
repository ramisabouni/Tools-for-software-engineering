# Laboratory 13 — Environment Reconstruction

Perform system-changing phases only in the instructor-approved disposable Ubuntu
environment. The verifier and fixture tests are read-only. Do not submit `.venv`,
package caches, credentials, private repository URLs, or complete environment dumps.

## Part A — Baseline and manifest

Copy `starter/` into your course-work area. Record supported OS release, package and
kernel architectures, user, relevant disk space, approved repositories, and all
candidates for required commands. Complete `capabilities.tsv` and validate its
schema before using it. Define behavioral equivalence; do not demand irrelevant
byte identity between platforms.

## Part B — Inspect and preview system packages

Map capabilities to supported Ubuntu packages. Inspect installed and candidate
versions, architecture, repository source, and provider. Refresh metadata only when
authorized and simulate the complete transaction before installation. Record added,
upgraded, and removed packages. Elevate only the reviewed package-manager command.

## Part C — Project Python environment

Review `requirements.in` as the direct declaration and the supplied example lock as
one tested resolution. Use `setup.sh` to create project-owned `.venv`; invoke its
Python explicitly. Install only during the authorized phase. Run `pip check`, imports,
and `analyze.py`. Record interpreter path/version, direct and transitive inventory,
native providers, and representative output. Never commit `.venv`.

## Part D — Capability verification

Complete `verify-environment.py`. For every capability, record selected command,
all PATH candidates, raw version, declared range, provider expectation, capability
probe, and classification: compatible, missing, incompatible, shadowed,
invalid-version, or failed-capability. Emit a stable JSON report and nonzero status
for unmet requirements. Do not install from the verifier.

## Part E — Idempotency

Run setup twice. Compare planned transactions, configuration, ownership, lock,
inventory, and verifier reports. A second run may inspect again but must not append
duplicates, reset unrelated state, change selected versions unexpectedly, or make
project files root-owned.

## Part F — Controlled failures

Complete `test-verifier.py` using temporary PATH directories, including one path
containing spaces. Test compatible, missing, incompatible, shadowed, unparsable
version, failed capability, and malformed manifest cases. Restore normal context.

## Part G — Reconstruct and update

Delete only the disposable `.venv`, reconstruct from reviewed inputs, rerun checks,
and compare with the equivalence contract. Complete `update-policy.md`: minimal
declaration change, resolver/source/hash diff, clean reconstruction, representative
tests, migration notes, and forward rollback by restoring the former reviewed
declaration and resolution.

## Deliverables

- Direct requirements, reviewed resolution, capability manifest, setup phases,
  read-only verifier, and fixture tests.
- Sanitized baseline, package-plan, environment, idempotency, and verification reports.
- Completed analysis, update policy, verification matrix, and `NOTES.md`.

## Acceptance criteria

Declaration, resolution, inventory, command selection, and capability evidence are
distinct; package changes are previewed and narrowly authorized; setup converges;
fixtures exercise every classification; reconstruction succeeds; reports omit
secrets and machine-specific noise; and system/interpreter/native/ambient boundaries
outside the language lock are explicitly documented.
