# Laboratory 11 — Remote Service Investigation

Use only instructor-authorized SSH and HTTP destinations. Fixture tests are the
default and require no network. Never scan an address range or include a password,
private key, token, cookie, or complete sensitive configuration in submitted work.

## Part A — Investigation record

Work in a copy of `starter/`. Record UTC start time, execution context, relevant
tool versions, approved names and ports, and expected contracts in `notes.md` and
`commands.txt`. Preserve commands but sanitize diagnostics before submission.

## Part B — Naming, addressing, and routing

Resolve the approved hostname through the normal system resolver. Record every
answer, available address families, the address actually selected by the client,
and a route lookup for one address. If a second authorized context is available,
compare results without assuming they must match.

## Part C — SSH identity and configuration

Complete `ssh-config.example`, leaving agent forwarding disabled. Inspect effective
options with `ssh -G`. Obtain the instructor-published host-key fingerprint through
the independent course channel before first acceptance. Run only the assigned
read-only commands. Sanitize verbose output.

A changed key requires stopping and independent verification. Never delete all of
`known_hosts`; after an approved rotation, update only the affected entry.

## Part D — Transfer and integrity

Create a synthetic fixture with no personal data. Before transfer, state source,
direction, destination host, and destination path. Compare local, remote, and
retrieved SHA-256 digests with `verify-transfer.sh`. Remove only the authorized
remote artifact and record cleanup evidence.

## Part E — HTTP endpoint

Complete `test-services.sh`. Live mode must accept only reviewed configuration,
retain TLS verification, use connection and total timeouts, separate body,
metadata, and diagnostics, and validate status, media type, JSON syntax, required
health value, and freshness. Standard output follows the documented stable schema;
sanitized diagnostics go to standard error.

## Part F — Controlled failures

First run `test-fixtures.sh`. Extend the fixture table and tests to cover resolution,
refusal, timeout, TLS identity, HTTP error, redirect policy, malformed JSON, missing
field, stale response, success, missing dependency, cleanup interruption, paths
with spaces, and redaction. Complete `failure-matrix.md` with the first failed
boundary, decisive evidence, safe next action, and an unjustified action.

## Deliverables

- `test-services.sh`, fixtures, automated tests, and secret-free configuration.
- Sanitized `notes.md`, `commands.txt`, `network-report.txt`, HTTP metadata/body
  validation evidence, fixture results, transfer verification, and failure matrix.
- `NOTES.md` explaining assumptions, exit codes, timeout/retry policy, cleanup,
  redaction, and one initial assumption corrected by evidence.

## Acceptance criteria

All operations stay in authorized scope; timeouts are bounded; TLS and SSH identity
checks remain enabled; resolver answers and selected address are distinguished;
transport, protocol, authentication, and application evidence are separate; every
decision branch has a deterministic test; transfer digests agree; cleanup is
narrow; stdout remains machine-readable; stderr is sanitized; and no credential
appears in files, commands, URLs, screenshots, or history.
