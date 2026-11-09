# Integration requirements

1. The average of valid integer observations is reported deterministically.
2. A zero count must return a nonzero status and a diagnostic; it must not divide.
3. The integrated default mode is `safe`, even if another branch optimizes a
   separately selectable `fast` mode.
4. If decimal output is introduced, all public examples and integration tests must
   use the documented two-decimal format.
5. Release evidence must identify the exact tested commit and artifact digest.
