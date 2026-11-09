# Laboratory 12 — Multi-File Build

Work in a copy of `starter/`; do not build inside the instructor-managed course
copy. Generated outputs must remain under `build/` and `bin/`.

## Part A — Inventory the graph

Complete `dependency-graph.dot` before recipes. Identify source, public and private
headers, objects, dependency files, program, test program, compiler, and test
execution. Document direct and transitive edges and configuration-sensitive outputs.

## Part B — Define the interface

Complete the Makefile with a useful default and phony `all`, `test`, `debug`,
`release`, `config`, `help`, and `clean` targets. `test` must depend on the correct
program and propagate failure. `config` reports selected values and variable origins.

Use conventional compiler, preprocessor, linker, and library variables. Permit
documented overrides while retaining required language and warning policy. Reject
unsupported modes before creating output.

## Part C — Generalize compilation

Derive mode-specific objects from the source list and use a pattern rule with
automatic variables. Create exact output directories through order-only
prerequisites. Do not make directories normal prerequisites or make objects depend
on phony action targets.

## Part D — Header dependencies

Generate `.d` files during compilation with options such as `-MMD -MP`; store them
beside matching objects and include them without failing on the first build. Explain
one generated file's target, prerequisites, and placeholder entries.

## Part E — Incremental experiments

Complete `incremental-matrix.md` using `make --trace` or equivalent evidence:

1. clean build and immediate no-op build;
2. meaningful change to `converter.c`;
3. change to private `converter_internal.h`;
4. change to public `converter.h`;
5. deletion of one object and one dependency file;
6. controlled compile failure and repair; and
7. controlled test failure and repair.

For every experiment, predict recipes before running them. Compare one incremental
result with a clean reference from identical source and configuration.

## Part F — Parallel and configuration behavior

Run repeated clean `make -j4` builds. Alternate debug and release without cleaning;
verify separate objects, dependencies, binaries, and flags. Run tests in both modes
and demonstrate that release checks remain active under `-DNDEBUG`.

Demonstrate a command-line override and use `$(origin VARIABLE)` in `config` to
identify its source. Explain Make-time versus shell-time expansion in `NOTES.md`.

## Part G — Cleanup audit

Review or dry-run cleanup. It may remove only fixed `build/` and `bin/` roots and
must remain safe if optional variables are empty. Confirm maintained files survive
and version-control status contains no generated artifacts.

## Deliverables

- Makefile, dependency graph source/rendering, and selected generated `.d` evidence.
- `incremental-matrix.md`, `build-evidence.md`, `failure-recovery.md`, and `NOTES.md`.
- No compiled object, dependency file, executable, or generated output directory.

## Acceptance criteria

The graph declares all relevant inputs; no-op runs no transformation; source and
header changes rebuild exactly the necessary outputs; parallel builds succeed;
configurations never mix; tests remain active in release; failures propagate
without a valid-looking final target; clean and incremental behavior agree; and
cleanup is bounded to regenerable project output.
