# Chapter 13 examples — Packages and Reproducible Environments

- `inspect-environment.sh` records relevant platform, APT, command, and Python
  evidence without changing the machine.
- `manifest.tsv` declares command capabilities and compatible version ranges.
- `verify-tools.py` classifies commands as compatible, missing, incompatible,
  shadowed, invalid-manifest, or failed-capability.
- `test-verifier.py` uses temporary PATH fixtures; it never changes installed state.
- `create-venv.sh` creates or reuses a project-owned environment and invokes its
  interpreter explicitly. Installation is an explicit optional phase.

The examples distinguish project intent (`requirements.in`), one reviewed example
resolution (`requirements-lock.example.txt`), observed inventory, command resolution,
and representative capability evidence.
