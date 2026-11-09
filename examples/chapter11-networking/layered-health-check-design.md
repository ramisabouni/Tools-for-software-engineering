# Layered health-check contract

| Exit | Classification | First boundary represented |
|---:|---|---|
| 0 | `ok` | All required boundaries and semantic predicate passed |
| 10 | `resolution` | Configured name did not resolve |
| 20 | `connection` | Bounded connection failed or timed out |
| 30 | `tls` | Certificate, peer-name, or protected-channel validation failed |
| 50 | `http` | HTTP status or required media type failed |
| 60 | `body` | JSON syntax, required value, or freshness failed |
| 70 | `configuration` | Input, dependency, or fixture contract failed |

The checker emits exactly one tab-separated result on standard output:

```text
classification<TAB>target<TAB>selected_address<TAB>detail
```

Diagnostics go to standard error and must not contain credentials. The checker
stops at the first unexplained boundary. It never disables TLS verification,
changes server state, scans an address range, or retries permanent failures.

For SSH, host authentication precedes user authorization. Inspect effective client
configuration with `ssh -G`, verify a fingerprint through an independent approved
channel, keep agent forwarding disabled, and update only an affected known-host
entry after an authorized rotation.
