# Assignment 02 — Service Analysis and Configuration Repair Toolkit

## EGEN 5209: Tools for Software Engineering

## Overview

In this assignment, you will build a reproducible command-line toolkit that investigates a simulated service incident and performs one controlled configuration repair. You will validate a supplied workspace, process logs and tabular data, preserve malformed evidence, generate deterministic summaries, use Vim to make a bounded edit, and prepare a professional incident report.

This assignment covers material from Chapters 01–07 of the course manual:

- professional use of software engineering tools;
- reproducibility, traceability, verification, and evidence;
- Linux filesystems, paths, permissions, and safe command use;
- standard input, standard output, and standard error;
- redirection, pipelines, `find`, and NUL-safe pathname handling;
- Bash arguments, functions, conditionals, loops, exit status, and temporary resources;
- regular-expression dialects, validation patterns, anchors, and boundaries;
- selection and transformation with `grep` and `sed`;
- field-aware validation, aggregation, and reporting with `awk`;
- deterministic ordering and independent checks using `sort`, `uniq`, and `cut`; and
- controlled terminal editing with Vim, confirmed substitution, and diff review.

This is an individual assignment. Complete all work independently unless the instructor explicitly states otherwise.

## Learning objectives

After completing this assignment, you should be able to:

1. validate evidence and environment assumptions before analysis;
2. design a Bash command-line interface with safe quoting and meaningful status codes;
3. document regular expressions and their limitations;
4. construct pipelines whose stages have explicit input and output contracts;
5. distinguish valid empty output from an execution failure;
6. reject malformed records before aggregation and reconcile record totals;
7. use Vim to make a narrow, confirmed change without modifying original evidence;
8. publish reports only after required validation succeeds; and
9. explain how generated evidence supports an engineering conclusion.

## Scenario

Northstar Analytics operates an internal reporting service named **Orion**. On October 20, 2026, monitoring detected repeated authentication problems, slow export requests, storage failures, and an unusually high export-row configuration value.

The operations team collected authentication, application, proxy-access, archived edge-node, performance, and configuration evidence. You have been asked to build a repeatable toolkit and investigate activity between:

```text
2026-10-20T14:00:00Z
2026-10-20T14:30:00Z
```

The default investigation includes records at severity `WARN` or higher. The legacy spelling `WARNING` has the same severity as `WARN` and must be normalized in a derived stream without changing the original log.

Do not assume that every event involving a repeated source address is malicious. Do not assume that the configuration value caused every failure. Your conclusions must be supported by the supplied evidence, and uncertainty must remain visible.

## Supplied files

```text
assignment02-service-analysis/
├── README.md
├── verify-submission.sh
├── case/
│   ├── CASE-NOTES.txt
│   ├── CHECKSUMS.sha256
│   ├── archive/
│   │   ├── edge node.log
│   │   └── previous-events.log.gz
│   ├── config/
│   │   └── service.conf
│   ├── data/
│   │   └── performance.csv
│   └── logs/
│       ├── access.log
│       ├── application.log
│       └── authentication.log
├── submission/
│   ├── awk/
│   ├── edited/
│   ├── evidence/
│   ├── patterns/
│   ├── reports/
│   └── sed/
└── templates/
    ├── analyze.sh
    ├── commands.md
    ├── findings.md
    ├── independent-check.txt
    ├── normalize-events.sed
    ├── patterns.txt
    ├── summarize-services.awk
    ├── verify-inputs.sh
    └── vim-journal.md
```

The files under `case/` are the original evidence. Do not edit them.

## Evidence contracts

### Application log

`case/logs/application.log` normally uses eight whitespace-separated fields:

```text
timestamp service severity event status duration request source
```

- One physical line represents one candidate record.
- Timestamps use UTC `YYYY-MM-DDTHH:MM:SSZ` form.
- Service names contain lowercase ASCII letters and hyphens.
- Severity is `INFO`, `WARN`, `WARNING`, or `ERROR`.
- Status is a three-digit HTTP status.
- Duration is a nonnegative integer number of milliseconds.
- Request identifiers use `req-NNNN` form.
- Source addresses use the assignment's simplified dotted-decimal IPv4 contract.
- One malformed record is included intentionally.

### Performance data

`case/data/performance.csv` uses this restricted contract:

```text
sample,service,metric,value
```

It has one header row. Quoted commas, embedded newlines, and escaped quotes are not permitted in this assignment subset. State why this limitation matters when selecting a processing tool.

## Rules and constraints

- Complete the assignment in your private course repository under:

  ```text
  student-work/assignments/assignment02/
  ```

- Do not modify any supplied file under `case/`.
- Do not run assignment commands with `sudo`.
- Use Bash and command-line tools covered in Chapters 01–07.
- Do not use Python, Perl, Ruby, spreadsheet software, databases, or external analysis services to generate the required evidence or reports.
- You may use an editor to complete Markdown documents. The configuration repair in Part 7 must be performed in terminal Vim.
- Use relative paths wherever practical so another person can reproduce the work from the assignment root.
- Quote expansions and pathnames correctly. Your workflow must safely handle `case/archive/edge node.log`.
- Keep data output on standard output and actionable diagnostics on standard error.
- Do not suppress unexpected diagnostics or present unreadable input as an empty valid result.
- Do not overwrite an existing valid report set during a failed run.
- Do not include access tokens, passwords, private keys, or other credentials in submitted files.
- The final archive must contain only `submission/`.

## Getting started

From the root of your private repository, copy the assignment into your student-work directory:

```bash
mkdir -p student-work/assignments
cp -r assignments/assignment02-service-analysis \
  student-work/assignments/assignment02
cd student-work/assignments/assignment02
```

Confirm your location:

```bash
pwd
ls
```

Create the required working files from the templates:

```bash
cp templates/analyze.sh submission/analyze.sh
cp templates/verify-inputs.sh submission/verify-inputs.sh
cp templates/commands.md submission/commands.md
cp templates/findings.md submission/findings.md
cp templates/patterns.txt submission/patterns/patterns.txt
cp templates/summarize-services.awk submission/awk/summarize-services.awk
cp templates/normalize-events.sed submission/sed/normalize-events.sed
cp templates/independent-check.txt submission/evidence/independent-check.txt
cp templates/vim-journal.md submission/evidence/vim-journal.md
chmod u+x submission/analyze.sh submission/verify-inputs.sh
```

Record your name, student number, GitHub username, completion date, and assistance declaration in both `submission/commands.md` and `submission/findings.md`.

## Part 1 — Preserve and inspect the evidence (10 marks)

### Task 1.1: Verify integrity and tools

Complete `submission/verify-inputs.sh`. It must accept the case directory as its only positional operand, check required tools, verify every supplied checksum, report archived-file types and configuration permissions, separate normal and diagnostic output, and return nonzero when required evidence or tooling is invalid.

Record the exact verification command, result, and reason for verifying evidence before analysis in `submission/commands.md`.

### Task 1.2: Create a safe file inventory

Create:

```text
submission/evidence/file-inventory.txt
```

It must contain every regular file under `case/`, one relative pathname per line, sorted deterministically. Use a NUL-safe workflow involving `find -print0` and `xargs -0`. The complete pathname `case/archive/edge node.log` must appear on one line. Explain every pipeline stage in `submission/commands.md`.

## Part 2 — Bash interface and execution safety (15 marks)

Complete `submission/analyze.sh` so it supports:

```bash
./submission/analyze.sh \
  --input case \
  --output submission/reports \
  --start 2026-10-20T14:00:00Z \
  --end 2026-10-20T14:30:00Z \
  --minimum-severity WARN
```

Required options:

| Option | Purpose |
|---|---|
| `--input DIR` | Evidence directory |
| `--output DIR` | Final report directory |
| `--start TIME` | Inclusive start timestamp |
| `--end TIME` | Inclusive end timestamp |
| `--minimum-severity LEVEL` | `INFO`, `WARN`, or `ERROR` |
| `--help` | Display usage and exit successfully |

Reject missing operands, unknown options, invalid timestamps, a reversed interval, unsupported severity, unreadable input, and unsafe output placement. Use focused functions, safe quoting, meaningful status codes, narrowly scoped temporary resources, and validation before publication. Do not delete an existing valid report set merely because a replacement run begins.

In `submission/commands.md`, document the normal run, `--help`, and at least four rejected invocations representing different failure classes.

## Part 3 — Regular-expression contracts (10 marks)

Complete `submission/patterns/patterns.txt` with patterns for timestamp shape, simplified IPv4 address, service name, HTTP status, request identifier, severity, and the exact `maximum_export_rows` assignment.

For every pattern, record its dialect, full pattern, one accepted example, one rejected example, and an important limitation. Test the patterns with commands recorded in `submission/commands.md`. Shape validation does not automatically prove semantic validity.

## Part 4 — Select and normalize event evidence (12 marks)

Create:

```text
submission/evidence/selected-events.txt
submission/evidence/normalized-events.txt
```

Complete `submission/sed/normalize-events.sed` so the complete legacy severity field `WARNING` becomes `WARN` in a derived stream. Do not modify the original log or change unrelated longer fields.

`selected-events.txt` must preserve complete source records, use the inclusive interval and selected minimum severity after normalization, retain the malformed `ERROR` candidate for validation, be chronological, and distinguish valid empty output from execution failure.

Record and explain the selection and transformation commands in `submission/commands.md`.

## Part 5 — Validate and summarize records with Awk (15 marks)

Complete `submission/awk/summarize-services.awk`. Validate structure and types before aggregation. Write every rejected record with source line number, original line, and reason to:

```text
submission/evidence/rejected-records.txt
```

Use `next` so rejected records cannot enter later aggregation rules.

Create:

```text
submission/reports/service-summary.csv
submission/reports/status-summary.txt
```

`service-summary.csv` must contain `service,accepted_event_count,average_duration_ms`, sorted by count descending and service ascending. Use two decimal places. `status-summary.txt` must contain one status and count per line, sorted numerically by status.

Report first and last accepted timestamps and reconcile:

```text
selected candidates = accepted records + rejected records
```

Record the result in `submission/findings.md`.

## Part 6 — Independent frequency check (6 marks)

Use a separate workflow involving `cut`, `sort`, and `uniq` to calculate service frequencies where the documented whitespace contract makes these tools valid.

Complete `submission/evidence/independent-check.txt` with the counting unit, field assumption, exact commands, frequencies, corresponding Awk result, and comparison. Investigate and explain any disagreement rather than altering output to force agreement.

## Part 7 — Controlled configuration repair with Vim (8 marks)

Create a working copy:

```bash
cp case/config/service.conf submission/edited/service.conf
```

Open only the working copy in terminal Vim. Change:

```text
maximum_export_rows=250000
```

to:

```text
maximum_export_rows=100000
```

This similar line must remain unchanged:

```text
previous_maximum_export_rows=250000
```

Search for the exact assignment, count candidates without replacement, use a confirmed substitution, save the copy, search old and new exact forms, and compare the copy with the original.

Create `submission/evidence/configuration.diff` and complete `submission/evidence/vim-journal.md` with exact commands, candidate count, confirmation decision, recovery boundary, and verification results.

## Part 8 — Incident findings and provenance (14 marks)

### Task 8.1: Findings

Complete `submission/findings.md`. Include a 500–700 word narrative distinguishing observed facts, conclusions supported by multiple evidence files, and uncertainties the supplied evidence cannot resolve.

Answer:

1. How many selected candidates were processed?
2. How many records were accepted and rejected?
3. Which services had the most accepted warning/error events?
4. Which HTTP statuses occurred among accepted records?
5. What were the first and last accepted timestamps?
6. What evidence connects authentication and application activity?
7. What does the evidence not prove about identity, intent, or causation?
8. Which two additional evidence sources would most improve the investigation?

### Task 8.2: Manifest

Create `submission/reports/manifest.txt` containing input and output paths and digests, parameters, locale, relevant tool versions, selected/accepted/rejected counts, first and last accepted timestamps, generation time, and final validation status.

Data output must follow its declared contract. Warnings, rejected-record summaries, and progress information belong on standard error.

## Part 9 — Package and verify the submission (10 marks)

Complete the declarations in `submission/commands.md` and `submission/findings.md`, then run:

```bash
./verify-submission.sh submission
```

Resolve every reported problem. Create a gzip-compressed tar archive containing only `submission/`:

```text
A02_LASTNAME_STUDENTNUMBER.tar.gz
```

List the archive contents without extracting it and inspect the result. Do not create new evidence inside `submission/` after packaging unless you recreate and reverify the archive.

## Required submission structure

```text
submission/
├── analyze.sh
├── commands.md
├── findings.md
├── verify-inputs.sh
├── awk/
│   └── summarize-services.awk
├── edited/
│   └── service.conf
├── evidence/
│   ├── configuration.diff
│   ├── file-inventory.txt
│   ├── independent-check.txt
│   ├── normalized-events.txt
│   ├── rejected-records.txt
│   ├── selected-events.txt
│   └── vim-journal.md
├── patterns/
│   └── patterns.txt
├── reports/
│   ├── manifest.txt
│   ├── service-summary.csv
│   └── status-summary.txt
└── sed/
    └── normalize-events.sed
```

Do not include original evidence, templates, temporary candidates, editor swap files, generated archives, or unrelated files inside `submission/`.

## Brightspace submission

Submit exactly one file to the Assignment 02 submission folder:

```text
A02_LASTNAME_STUDENTNUMBER.tar.gz
```

Before uploading, run the verifier, inspect the archive, confirm the required structure, confirm the evidence is excluded, and check your filename. After uploading, download the Brightspace copy and verify it. The Brightspace copy is the official submission.

Pushing work to your private GitHub repository provides backup and version-control practice; **it does not constitute submission.**

## Git workflow expectations

Commit and push regularly. For example:

```bash
git status
git add student-work/assignments/assignment02
git commit -m "Implement validated service summary"
git push
```

Do not commit the Brightspace archive if repository instructions exclude generated archives.

## Grading rubric

| Category | Marks |
|---|---:|
| Environment and evidence verification | 10 |
| Bash interface and execution safety | 15 |
| Regular-expression contracts | 10 |
| Selection and normalization | 12 |
| Awk validation and reporting | 15 |
| Independent frequency check | 6 |
| Controlled Vim repair | 8 |
| Incident findings and provenance | 14 |
| Reproducibility, packaging, and professionalism | 10 |
| **Total** | **100** |

Correct-looking reports without reproducible supporting commands may receive limited credit. Unsafe pathname handling, modified original evidence, silent rejection of malformed records, or partial publication may also lose marks.

## Academic integrity and permitted assistance

Follow course and university requirements. Unless the instructor states otherwise:

- you may consult the manual, slides, command documentation, and your notes;
- you may discuss general concepts with classmates;
- you may not share scripts, commands, patterns, evidence, findings, or completed archives; and
- you must disclose permitted external assistance in both declarations.

You remain responsible for every submitted command, script, pattern, result, and conclusion.

## Final checklist

- [ ] I worked inside `student-work/assignments/assignment02/`.
- [ ] The supplied checksums passed before analysis.
- [ ] I did not modify anything under `case/`.
- [ ] The spaced pathname appears correctly in the inventory.
- [ ] `analyze.sh --help` succeeds and invalid invocations fail clearly.
- [ ] Every pattern identifies its dialect, fixtures, and limitations.
- [ ] Selection uses the inclusive interval and minimum severity.
- [ ] The original application log remains unchanged.
- [ ] Rejected records cannot enter aggregation.
- [ ] Selected, accepted, and rejected totals reconcile.
- [ ] The independent count is documented and compared with Awk.
- [ ] Only the intended configuration assignment changed.
- [ ] `commands.md` contains the exact commands used.
- [ ] `findings.md` separates observation, inference, and uncertainty.
- [ ] The manifest contains parameters, versions, counts, and digests.
- [ ] `./verify-submission.sh submission` reports success.
- [ ] I inspected the final archive and the uploaded Brightspace copy.

