#!/usr/bin/env bash
set -euo pipefail

venv=${1:-.venv}
mode=${2:---create-only}
[[ $venv != / && $venv != "$HOME" ]] || { printf 'Unsafe environment path.\n' >&2; exit 2; }
if [[ ! -x $venv/bin/python ]]; then
    python3 -m venv "$venv"
fi
"$venv/bin/python" -m pip --version
case $mode in
    --create-only) ;;
    --install)
        "$venv/bin/python" -m pip install --requirement "$(dirname "$0")/requirements-lock.example.txt"
        "$venv/bin/python" -m pip check ;;
    *) printf 'mode must be --create-only or --install\n' >&2; exit 2 ;;
esac
