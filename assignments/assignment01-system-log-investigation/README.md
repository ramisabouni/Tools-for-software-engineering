# Assignment 01 — System Log Investigation Pipeline

## EGEN 5209: Tools for Software Engineering

## Overview

In this assignment, you will investigate a simulated service incident using Linux command-line tools. You will inspect a supplied workspace, search several logs, construct command pipelines, preserve evidence, and prepare a reproducible incident report.

This assignment covers material from Chapters 01–03 from the course manual:

- professional use of software engineering tools;
- reproducibility, traceability, and evidence;
- Linux filesystems, paths, permissions, and safe command use;
- standard input, standard output, and standard error;
- redirection and pipelines;
- filters such as `grep`, `sort`, `uniq`, `cut`, `head`, and `tail`;
- locating files with `find`;
- safe argument handling with `find -print0` and `xargs -0`; and
- creating and verifying compressed archives.

This is an individual assignment. Complete all work independently unless the instructor explicitly states otherwise.

## Learning objectives

After completing this assignment, you should be able to:

1. investigate a multi-file technical incident using Linux tools;
2. construct pipelines whose stages have clear input and output contracts;
3. distinguish data output from diagnostic output;
4. process filenames safely, including names containing spaces;
5. preserve a traceable record of commands and conclusions;
6. create and verify a portable evidence archive; and
7. explain how command output supports an engineering conclusion.

## Scenario

Northstar Analytics operates an internal reporting service named **Orion**. On September 18, 2026, users reported slow responses and failed export requests. The operations team collected application, authentication, proxy-access, and archived edge-node logs from the affected environment.

You have been asked to determine what happened between:

```text
2026-09-18T14:00:00Z
2026-09-18T14:30:00Z
```

The investigation begins with the following reported indicators:

```text
Suspected source address: 203.0.113.77
Service: Orion reporting service
Primary host: orion-api-01
```

Do not assume that every event involving the suspected address is malicious. Your conclusions must be supported by evidence from the supplied files.

## Supplied files

```text
assignment01-system-log-investigation/
├── README.md
├── case/
│   ├── CASE-NOTES.txt
│   ├── CHECKSUMS.sha256
│   ├── archive/
│   │   ├── edge node.log
│   │   └── previous-day.log.gz
│   ├── config/
│   │   ├── logging.conf
│   │   └── service.conf
│   └── logs/
│       ├── access.log
│       ├── application.log
│       └── authentication.log
├── submission/
│   └── evidence/
├── templates/
│   ├── commands.md
│   └── findings.md
└── verify-submission.sh
```

The files under `case/` are the original evidence. Do not edit them.

## Rules and constraints

- Complete the assignment in your private course repository under:

  ```text
  student-work/assignments/assignment01/
  ```

- Do not modify the supplied `case/` files.
- Use command-line tools covered in Chapters 01–03.
- Do not submit a Bash script as a replacement for the required command record.
- Do not use Python, Perl, Ruby, spreadsheet software, databases, or external log-analysis services to produce the required evidence.
- You may use an editor to complete the Markdown reports.
- Commands must use relative paths wherever practical so another person can repeat them from the assignment root.
- Do not run assignment commands with `sudo`.
- Do not include personal access tokens, passwords, or other credentials in submitted files.

## Getting started

From the root of your private repository, copy the assignment into your student-work directory.

```bash
mkdir -p student-work/assignments
cp -r assignments/assignment01-system-log-investigation \
  student-work/assignments/assignment01
cd student-work/assignments/assignment01
```

Confirm your location:

```bash
pwd
ls
```

Create working copies of the report templates:

```bash
cp templates/commands.md submission/commands.md
cp templates/findings.md submission/findings.md
```

Record your name, student number, and GitHub username in both files.

## Part 1 — Preserve and inspect the evidence (10 marks)

### Task 1.1: Verify integrity

From the assignment root, use the supplied checksum manifest to verify the original evidence.

Record:

- the exact command;
- whether every checksum passed; and
- why integrity verification should occur before analysis.

### Task 1.2: Create a file inventory

Create:

```text
submission/evidence/file-inventory.txt
```

It must contain every regular file below `case/`, one relative pathname per line, sorted alphabetically. Include files whose names contain spaces.

Use a NUL-safe workflow involving `find -print0` and `xargs -0`. Record and explain the command in `submission/commands.md`.

### Task 1.3: Inspect metadata

In `submission/findings.md`, record:

- the file type reported for each file under `case/archive/`;
- the permissions of `case/config/service.conf`; and
- the difference between the archived files based on their detected types.

## Part 2 — Authentication analysis (20 marks)

Analyze `case/logs/authentication.log` for the investigation window.

Create:

```text
submission/evidence/auth-failures.txt
```

This file must contain all failed authentication events associated with `203.0.113.77` during the investigation window, in chronological order.

In `submission/findings.md`, answer:

1. How many failed authentication events came from the suspected address?
2. Which account names were targeted?
3. Was a successful authentication later recorded from that address?
4. If so, identify the timestamp, account, authentication method, and session identifier.
5. What evidence supports the conclusion that the success is related to the earlier failures?

Your command record must show how you produced the evidence and calculated counts without manually counting displayed lines.

## Part 3 — Application analysis (20 marks)

Analyze `case/logs/application.log`.

Create:

```text
submission/evidence/application-errors.txt
submission/evidence/error-code-summary.txt
```

`application-errors.txt` must contain all `ERROR` events during the investigation window, sorted chronologically.

`error-code-summary.txt` must contain one error code per line with its occurrence count, sorted from the highest count to the lowest. When counts are equal, sort by the error code.

In `submission/findings.md`, answer:

1. Which application error code occurred most frequently?
2. Which request identifiers are connected to export failures?
3. Which application event first mentions the authenticated session identified in Part 2?
4. What configuration-related event occurred shortly before the export failures?
5. Does the application log alone prove who caused the incident? Explain the limitation.

## Part 4 — Proxy and edge-node analysis (20 marks)

Analyze:

```text
case/logs/access.log
case/archive/edge node.log
```

Create:

```text
submission/evidence/suspect-access.txt
submission/evidence/status-summary.txt
```

`suspect-access.txt` must contain every proxy or edge-node request from `203.0.113.77` during the investigation window, sorted chronologically.

`status-summary.txt` must summarize HTTP response-status frequencies for those requests, sorted by status code.

In `submission/findings.md`, answer:

1. Which requested path transferred the largest response body?
2. What was its HTTP status?
3. Which request identifier links proxy activity to an application event?
4. What difference do you observe between the primary proxy log and the edge-node log?
5. Why must the filename `edge node.log` be quoted or transported using a safe delimiter?

## Part 5 — Correlated incident timeline (15 marks)

Create:

```text
submission/evidence/timeline.txt
```

The timeline must:

- combine relevant authentication, application, proxy, and edge-node events;
- contain only events related to the suspected activity;
- be sorted chronologically;
- preserve the original log lines without rewriting them; and
- include at least one relevant event from each of the four sources.

In `submission/findings.md`, provide a concise incident narrative of approximately 250–400 words. Clearly distinguish:

- directly observed facts;
- conclusions supported by multiple logs; and
- uncertainties that the supplied evidence cannot resolve.

## Part 6 — Streams and diagnostics (5 marks)

From the assignment root, run one command that attempts to list both:

```text
case/logs
case/logs/not-present.log
```

Redirect normal output to:

```text
submission/evidence/listing-output.txt
```

Redirect diagnostic output to:

```text
submission/evidence/diagnostics.log
```

Record the exact command and explain why the two outputs are stored separately.

## Part 7 — Package and verify the submission (10 marks)

Complete the declaration in `submission/findings.md`, then run:

```bash
./verify-submission.sh
```

Resolve every reported problem before continuing.

From the assignment root, create a gzip-compressed tar archive containing only the `submission/` directory. Use this filename:

```text
A01_LASTNAME_STUDENTNUMBER.tar.gz
```

Replace `LASTNAME` and `STUDENTNUMBER` with your own information. Do not include spaces in the archive filename.

List the final archive contents without extracting it and inspect the output carefully. Do not redirect this listing into the `submission/` directory because doing so would change the directory after the archive had been created.

## Required submission structure

Your final archive must contain:

```text
submission/
├── commands.md
├── findings.md
└── evidence/
    ├── application-errors.txt
    ├── auth-failures.txt
    ├── diagnostics.log
    ├── error-code-summary.txt
    ├── file-inventory.txt
    ├── listing-output.txt
    ├── status-summary.txt
    ├── suspect-access.txt
    └── timeline.txt
```

Do not place the original `case/` directory inside the submission archive.

## Brightspace submission

Submit exactly one file to the Assignment 01 submission folder in Brightspace:

```text
A01_LASTNAME_STUDENTNUMBER.tar.gz
```

Before uploading:

1. run `./verify-submission.sh`;
2. list the final archive contents;
3. confirm the archive contains the required `submission/` structure;
4. confirm it does not contain the original evidence or unrelated files; and
5. confirm the filename contains your correct last name and student number.

After uploading, download the submitted archive from Brightspace and verify that it opens and contains the expected files. The Brightspace copy is the official submission.

Your private GitHub repository is used for backup and version-control practice; **pushing work to GitHub does not constitute submission.**

## Git workflow expectations

Commit and push your assignment work regularly. For example:

```bash
git status
git add student-work/assignments/assignment01
git commit -m "Complete authentication investigation"
git push
```

Do not commit your final Brightspace archive if the course repository instructions exclude generated archives.

## Grading rubric

| Category | Marks |
|---|---:|
| Evidence integrity, inventory, and metadata | 10 |
| Authentication analysis | 20 |
| Application analysis | 20 |
| Proxy and edge-node analysis | 20 |
| Correlated timeline and incident narrative | 15 |
| Stream and diagnostic handling | 5 |
| Reproducibility, documentation, packaging, and professionalism | 10 |
| **Total** | **100** |

Correct conclusions without reproducible supporting commands may receive limited credit. Commands that produce correct-looking results by relying on unsafe pathname handling may also lose marks.

## Academic integrity and permitted assistance

Follow the course and university academic-integrity requirements. Unless the instructor states otherwise:

- you may consult the course manual, lecture slides, command documentation, and your own notes;
- you may discuss general command concepts with classmates;
- you may not share commands, evidence files, findings, or completed archives; and
- you must disclose any permitted external assistance in the declaration section of `findings.md`.

## Final checklist

- [ ] I worked inside `student-work/assignments/assignment01/`.
- [ ] The supplied checksums passed before analysis.
- [ ] I did not modify anything under `case/`.
- [ ] Every required evidence file exists and is non-empty where appropriate.
- [ ] `commands.md` contains the exact commands used.
- [ ] `findings.md` answers every question and distinguishes facts from inference.
- [ ] `./verify-submission.sh` reports success.
- [ ] The final archive follows the required filename format.
- [ ] I inspected the final archive contents.
- [ ] I uploaded the archive to Brightspace and checked the uploaded copy.
