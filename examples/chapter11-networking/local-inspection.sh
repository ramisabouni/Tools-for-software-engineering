#!/usr/bin/env bash
set -euo pipefail

printf 'UTC time: %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
printf 'Host: %s\n' "$(hostname)"
printf '\nInterfaces and addresses:\n'
if command -v ip >/dev/null 2>&1; then
    ip -brief address
    printf '\nRoutes:\n'
    ip route
elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig
    printf '\nRoutes:\n'
    netstat -rn
else
    printf 'No supported interface-inspection command found.\n' >&2
fi

printf '\nListening sockets:\n'
if command -v ss >/dev/null 2>&1; then
    ss -lntup 2>/dev/null || ss -lnt
else
    netstat -an 2>/dev/null | sed -n '1,30p'
fi
