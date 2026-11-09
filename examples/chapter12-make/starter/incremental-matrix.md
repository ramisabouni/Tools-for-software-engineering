# Incremental-build evidence

| Experiment | Changed input | Expected recipes | Observed recipes | Status | Explanation |
|---|---|---|---|---|---|
| Clean debug build | empty output tree |  |  |  |  |
| Debug no-op | none | none |  |  |  |
| Implementation change | `src/converter.c` |  |  |  |  |
| Private-header change | `src/converter_internal.h` |  |  |  |  |
| Public-header change | `include/converter.h` |  |  |  |  |
| Delete one object | one `.o` |  |  |  |  |
| Delete one dependency file | one `.d` |  |  |  |  |
| Parallel build | empty output tree |  |  |  |  |
| Compile failure | controlled source defect | no final target |  |  |  |
| Test failure | controlled expected-value defect | nonzero test |  |  |  |
| Debug → release | no cleaning | separate outputs |  |  |  |
| Release → debug | no cleaning | no cross-mode reuse |  |  |  |
| Clean reference comparison | identical inputs/mode | equivalent behavior |  |  |  |
