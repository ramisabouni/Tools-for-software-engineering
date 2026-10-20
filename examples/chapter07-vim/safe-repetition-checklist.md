# Safe Vim repetition checklist

- Normalize the starting cursor position.
- State the structural precondition for one edit.
- Make one iteration end at the next valid starting point.
- Test once, inspect, then use a small count.
- Include an exceptional record that violates the precondition.
- Inspect the diff and run the relevant syntax check or test.
- Move recurring or parser-dependent work into a maintained tool.
