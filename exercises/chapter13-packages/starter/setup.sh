#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
venv="$root/.venv"
mode=${1:---inspect}

inspect() {
    printf 'python=%s\n' "$(command -v python3 || printf missing)"
    python3 --version 2>&1 || true
    [[ ! -x $venv/bin/python ]] || "$venv/bin/python" -m pip --version
}

case $mode in
    --inspect) inspect ;;
    --create)
        [[ -x $venv/bin/python ]] || python3 -m venv "$venv"
        "$venv/bin/python" -m pip --version ;;
    --install)
        [[ -x $venv/bin/python ]] || python3 -m venv "$venv"
        "$venv/bin/python" -m pip install --requirement "$root/requirements-lock.example.txt"
        "$venv/bin/python" -m pip check ;;
    --verify)
        python3 "$root/verify-environment.py" "$root/capabilities.tsv" "$root/environment-report.json" ;;
    *) printf 'usage: %s {--inspect|--create|--install|--verify}\n' "$0" >&2; exit 2 ;;
esac
