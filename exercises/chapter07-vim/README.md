# Exercise 7 — Terminal-Only Editing

Copy `starter/` into your own repository and perform the work in terminal Vim. The supplied project builds before editing so each change can be checked independently.

## Project map

- `include/metrics.h`: declarations and the serialized compatibility-name contract.
- `src/metrics.c`: implementation containing marked functions and deliberate formatting defects.
- `tests/test_metrics.c`: focused tests and identifier references.
- `records.txt`: controlled macro input with one boundary record.
- `Makefile`: `make check` builds and runs the tests.
- `edit-evidence-template.md`: required editing journal structure.

The older `poorly-formatted.c` and `repetitive-text.txt` files are optional introductory practice and are not graded.

## Required editing goals

1. Record `git status`, `vim --version | head -n 1`, and whether you used your normal configuration or `vim -Nu NONE`.
2. Open the header, implementation, and test as buffers; show the implementation and test in split windows.
3. Change the user-facing string `pending metrics summary` to `metrics summary` with a text object.
4. Move the complete `print_summary` definition below `calculate_average` using named register `a`. Use the black-hole register for the marked disposable comment without changing register `a`.
5. Inventory and rename the C function `old_count` to `record_count` using a confirmed, bounded substitution. Do not change `old_counter` or the compatibility string `"old_count"`.
6. Correct the four `total+=values[i];` defects using one deliberate change followed by dot repetition.
7. Transform only matching `name=value` records in `records.txt` into `name = value;` with a macro. The macro must stop safely at `STOP: malformed record`.
8. Inspect the diff, search for remaining and unexpected identifiers, run `make check`, and document the results.

## Deliverables

- edited `include/metrics.h`, `src/metrics.c`, `tests/test_metrics.c`, and `records.txt`;
- completed `edit-evidence.md` based on the template;
- `verification.txt` containing the final status, diff summary, search results, and `make check` output.

## Acceptance criteria

- Only intended files differ and no modified buffer remains unsaved.
- The project builds without warnings and all tests pass.
- `record_count` is used as the function name; `old_counter` and the compatibility string remain unchanged.
- Neither moved function is duplicated or lost.
- Named-register, black-hole-register, text-object, confirmed-substitution, dot, and macro evidence is documented.
- The macro precondition, ending position, boundary behaviour, and stopping rule are explicit.
- The journal is organized by editing goal rather than listing every keystroke.
