# Chapter 6 sample code — Processing Text and Structured Data

Run these examples from any directory. Each script locates its supplied data relative to its own location.

| Chapter topic | File to run | Main supplied input |
|---|---|---|
| Selecting records with `grep` | `./grep-examples.sh` | `data/application.log` |
| Transforming streams with `sed` | `./sed-examples.sh` | `data/authentication.log` |
| Validating and aggregating with `awk` | `./awk-examples.sh` | `data/measurements.csv` |
| Complete worked example | `./log-report.sh` | `data/service.log` |
| All non-destructive demonstrations | `./run-examples.sh` | files under `data/` |

The small files under `data/` support the literal commands printed in the chapter. They are synthetic and contain no production data. The examples deliberately use simple, documented formats; they are not general CSV or configuration-file parsers.

The complete worked example writes its results to a directory supplied as its second argument:

```bash
./log-report.sh data/service.log output
```

It creates `service-summary.csv`, `rejected-records.txt`, and `manifest.txt`. To see the validation policy reject bad input, run it with `data/service-malformed.log`.
