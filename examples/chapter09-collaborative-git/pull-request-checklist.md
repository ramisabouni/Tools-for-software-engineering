# Pull-request readiness checklist

- [ ] The title describes one observable change.
- [ ] The description states problem, intended behavior, design, scope, risks,
      limitations, migration or rollback considerations, and linked requirement.
- [ ] The topic began from an identified base and is synchronized according to
      team policy.
- [ ] The complete `origin/main...HEAD` diff was self-reviewed.
- [ ] A regression test fails on the defective revision and passes on the topic.
- [ ] Required jobs ran against the current candidate and expected test counts.
- [ ] Documentation and operational effects are addressed.
- [ ] No credential, generated artifact, local configuration, or unrelated change
      appears in commits, URLs, logs, or screenshots.
- [ ] Conversations are resolved through a change or reasoned technical response.
- [ ] Material updates trigger fresh checks and rereview where policy requires it.
