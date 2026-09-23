#!/usr/bin/env bash

# Complete non-destructive initialization of the Tools For Software Engineering Course Codespace.

set -u
set -o pipefail

printf '%s\n' 'Configuring the EGEN 5209 course workspace...'

mkdir -p \
    Exercises \
    Projects

for script in \
    setup.sh \
    update-course.sh \
    verify-course.sh
do
    if [[ -f $script ]]; then
        chmod u+x -- "$script"
    fi
done

printf '%s\n' 'Checking required commands...'

required_commands=(
    bash
    git
    gcc
    g++
    make
    python3
    curl
    ssh
    awk
    sed
    grep
    find
    tar
    gzip
    zip
    unzip
    shellcheck
    dot
    gnuplot
)

missing=0

for command_name in "${required_commands[@]}"; do
    if command -v "$command_name" >/dev/null 2>&1; then
        printf 'OK      %s\n' "$command_name"
    else
        printf 'MISSING %s\n' "$command_name" >&2
        missing=$((missing + 1))
    fi
done

if (( missing > 0 )); then
    printf '%d required command(s) are missing.\n' \
        "$missing" >&2
    exit 1
fi

if [[ -x ./verify-course.sh ]]; then
    printf '%s\n' 'Running the course verification script...'

    if ! ./verify-course.sh; then
        printf '%s\n' \
            'The course verification script reported a problem.' >&2
        exit 1
    fi
fi

printf '%s\n' 'Tools For Software Engineering Codespace configuration completed.'
