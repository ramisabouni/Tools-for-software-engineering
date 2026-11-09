# Chapter 10 examples — Engineering Visualization

The examples separate authoritative source, validation, analysis, rendering, and
artifact review.

```bash
make diagrams
make matplotlib
make gnuplot       # when gnuplot is installed
make verify
```

`benchmark.py` validates every raw row, writes accepted/rejected/coverage/summary
tables, renders SVG and PNG, and creates a digest manifest. `performance.gnuplot`
renders the same summary specification with redundant line and point encodings.

Generated files go under `generated/` and should not replace their sources.
