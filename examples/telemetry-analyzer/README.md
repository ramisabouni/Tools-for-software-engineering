# Telemetry Analyzer

This is the canonical, runnable example behind the **telemetry analyzer** references in the course manual and lecture slides. It uses synthetic sensor readings; no real operational data or credentials are included.

## Learning map

- Chapters 2–3: inspect the project tree, permissions, pipelines, archives, and checksums.
- Chapters 4–6: study the shell scripts, regular expressions, `awk`, and input validation.
- Chapters 7–9: edit the project and practise local and collaborative Git workflows.
- Chapter 10: generate a Graphviz architecture diagram and a Matplotlib plot.
- Chapter 11: run the optional HTTPS health check safely.
- Chapter 12: build and test the multi-file C program with Make.
- Chapter 13: create and verify a source package.
- Chapter 14: run the complete build, analysis, test, visualization, and packaging workflow.

## Quick start

From this directory, run:

    make
    make test
    make analyze

The sample dataset deliberately contains one malformed record. The analyzer reports six accepted records and one rejected record. That rejection is an expected test condition, not a setup failure.

Optional targets:

    make diagram       # requires Graphviz
    make plot          # requires Python and Matplotlib
    make package

Generated files are written below `build/`, `reports/`, `output/`, and `dist/`. Use `make clean` to remove them.

The health-check script requires an explicit HTTPS URL:

    scripts/health-check.sh https://example.com

It applies connection and total timeouts and does not store tokens, passwords, or private URLs.
