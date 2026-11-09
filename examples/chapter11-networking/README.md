# Chapter 11 examples — Networking Tools

These examples separate observations by boundary and keep machine-readable results
on standard output while sending sanitized diagnostics to standard error.

- `local-inspection.sh` records interfaces, routes, listeners, and client versions.
- `curl-metadata.sh` performs one explicitly authorized, bounded, read-only request.
- `health-check.sh` implements the chapter's layered result contract and supports
  deterministic fixtures without network access.
- `test-health-check.sh` exercises every documented fixture outcome.
- `ssh-config.example` demonstrates restrictive reusable SSH configuration.

Do not run the live examples against a destination unless it is explicitly approved
for the course exercise. Fixture tests require no network access.
