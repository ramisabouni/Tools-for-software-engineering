#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
dist="$root/dist"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

mkdir -p "$dist" "$stage/telemetry-analyzer"/{include,src,tests,scripts,data,docs}
cp "$root/Makefile" "$root/README.md" "$root/requirements.txt" "$stage/telemetry-analyzer/"
cp "$root/include/telemetry.h" "$stage/telemetry-analyzer/include/"
cp "$root/src/"*.c "$stage/telemetry-analyzer/src/"
cp "$root/tests/"*.c "$root/tests/"*.sh "$stage/telemetry-analyzer/tests/"
cp "$root/scripts/"*.sh "$root/scripts/"*.py "$stage/telemetry-analyzer/scripts/"
cp "$root/data/telemetry.csv" "$stage/telemetry-analyzer/data/"
cp "$root/docs/architecture.dot" "$stage/telemetry-analyzer/docs/"

(
    cd "$stage/telemetry-analyzer"
    find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS
)

archive="$dist/telemetry-analyzer-source.tar.gz"
tar -czf "$archive" -C "$stage" telemetry-analyzer
verify="$stage/verify"
mkdir "$verify"
tar -xzf "$archive" -C "$verify"
(cd "$verify/telemetry-analyzer" && sha256sum --check SHA256SUMS && make test)
sha256sum "$archive" > "$archive.sha256"
printf 'created %s\n' "$archive"
