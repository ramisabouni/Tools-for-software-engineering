# Instructor-controlled conflict variants

Create both branches from the same designated base. On
`conflict/safe-default`, replace `src/mode.conf` with `safe-mode.conf`; on
`conflict/fast-default`, replace it with `fast-mode.conf`. Commit each version.

Merging both branches produces a textual conflict. The requirements identify
`safe` as the integrated default. The `fast` implementation may remain available
only as a separately selected, tested behavior; choosing one file mechanically is
not a sufficient explanation.
