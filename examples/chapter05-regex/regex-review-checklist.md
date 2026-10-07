# Regex review checklist

- State the input record, dialect, locale, anchoring, normalization, and error policy.
- Trace every pattern component to a written requirement.
- Test valid boundaries, just-outside values, one-rule violations, and long nonmatches.
- Report false positives and false negatives separately.
- Use a structured parser when nesting, quoting, escaping, or semantics exceed the regex model.
