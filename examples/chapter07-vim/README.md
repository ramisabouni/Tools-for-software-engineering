# Chapter 7 sample files — Efficient Text Editing with Vim

These synthetic files support the commands and editing concepts in Chapter 7.

- `practice.txt`: basic navigation, search, and confirmed substitution.
- `macros-practice.txt`: uniform records for initial macro practice.
- `macros-boundary.txt`: normal records plus a deliberately nonmatching boundary record.
- `example-vimrc`: small, explainable course configuration.
- `worked-example/`: the C identifier-renaming example, including longer identifiers and compatibility text that must not be changed blindly.
- `src/`, `tests/`, `docs/`, and `file.txt`: inputs named by the chapter's opening, buffer, and controlled-startup examples.

To inspect the worked example without personal configuration:

```bash
cd worked-example
vim -Nu NONE -n src/analyzer.c
```

Inventory `old_count` before using the confirmed Vim substitution from the chapter. Build and test after the edit with `make check`.
