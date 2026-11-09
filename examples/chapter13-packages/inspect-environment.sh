#!/usr/bin/env bash
set -euo pipefail

printf 'utc=%s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
printf 'kernel_arch=%s\n' "$(uname -m)"
if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    printf 'os=%s\nos_version=%s\n' "${ID:-unknown}" "${VERSION_ID:-unknown}"
fi
command -v dpkg >/dev/null 2>&1 && printf 'package_arch=%s\n' "$(dpkg --print-architecture)"
printf 'python_path=%s\n' "$(command -v python3 || printf missing)"
python3 --version 2>&1 | sed 's/^/python_version=/'
printf '\nCommand candidates:\n'
for command_name in git make dot gnuplot ssh python3; do
    type -a "$command_name" 2>/dev/null || printf '%s: missing\n' "$command_name"
done
printf '\nAPT candidates (read-only):\n'
command -v apt-cache >/dev/null 2>&1 && apt-cache policy git make graphviz gnuplot-nox 2>/dev/null || true

printf '\nThis report intentionally omits complete environment variables and credentials.\n'
