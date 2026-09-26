#!/usr/bin/env bash

# Tools for Software Engineering
# Ubuntu 24.04 / GitHub Codespaces environment installer

set -Eeuo pipefail

trap 'printf "\nERROR: Setup failed at line %s.\n" "$LINENO" >&2' ERR

printf '%s\n' \
  '=======================================================' \
  'Tools for Software Engineering' \
  'Environment Setup' \
  '======================================================='

# The course package list is written for Ubuntu/Debian systems.
if ! command -v apt-get >/dev/null 2>&1; then
  printf '%s\n' \
    'ERROR: apt-get was not found.' \
    'This installer requires an Ubuntu/Debian Codespace.' \
    'Check /etc/os-release and the image in .devcontainer/devcontainer.json.' >&2
  exit 1
fi

# If invoked with sudo, install software as root but create personal files for
# the user who invoked sudo. Otherwise, use the current user.
COURSE_USER="${SUDO_USER:-$(id -un)}"
if [[ "$COURSE_USER" == "root" && -n "${CODESPACE_NAME:-}" ]] && id codespace >/dev/null 2>&1; then
  COURSE_USER="codespace"
fi

COURSE_HOME="$(getent passwd "$COURSE_USER" | cut -d: -f6)"
if [[ -z "$COURSE_HOME" || ! -d "$COURSE_HOME" ]]; then
  printf 'ERROR: Could not determine the home directory for %s.\n' "$COURSE_USER" >&2
  exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
  SUDO=()
else
  if ! command -v sudo >/dev/null 2>&1; then
    printf '%s\n' 'ERROR: Run this installer as root or install sudo.' >&2
    exit 1
  fi
  SUDO=(sudo)
fi

run_as_course_user() {
  if [[ "$EUID" -eq 0 && "$COURSE_USER" != "root" ]]; then
    runuser -u "$COURSE_USER" -- "$@"
  else
    "$@"
  fi
}

export DEBIAN_FRONTEND=noninteractive

printf '\n[1/5] Updating Ubuntu package information...\n'
"${SUDO[@]}" apt-get update

printf '\n[2/5] Installing required course tools...\n'
"${SUDO[@]}" apt-get install -y --no-install-recommends \
  bash \
  build-essential \
  ca-certificates \
  curl \
  dnsutils \
  findutils \
  gawk \
  gdb \
  git \
  gnuplot-nox \
  graphviz \
  grep \
  gzip \
  iputils-ping \
  jq \
  make \
  netcat-openbsd \
  openssh-client \
  python3 \
  python3-pip \
  python3-venv \
  sed \
  tar \
  telnet \
  traceroute \
  tree \
  unzip \
  vim \
  wget \
  zip

VENV_DIR="$COURSE_HOME/course-venv"

printf '\n[3/5] Creating the Python virtual environment at %s...\n' "$VENV_DIR"
if [[ -e "$VENV_DIR" && ! -x "$VENV_DIR/bin/python" ]]; then
  printf '%s\n' \
    "ERROR: $VENV_DIR exists but is not a valid Python virtual environment." \
    'Rename or remove that directory, then run setup.sh again.' >&2
  exit 1
fi

if [[ ! -d "$VENV_DIR" ]]; then
  run_as_course_user python3 -m venv "$VENV_DIR"
fi

printf '\n[4/5] Installing the required Python packages...\n'
run_as_course_user "$VENV_DIR/bin/python" -m pip install --upgrade pip setuptools wheel
run_as_course_user "$VENV_DIR/bin/python" -m pip install --upgrade \
  matplotlib \
  numpy \
  pandas \
  requests

# Make the course environment available in new interactive shells without
# automatically activating it. Existing terminals can run: source ~/course-venv/bin/activate
COURSE_PROFILE="$COURSE_HOME/.course-env"
cat >"$COURSE_PROFILE" <<EOF
# course environment
export COURSE_VENV="$VENV_DIR"
export PATH="\$COURSE_VENV/bin:\$PATH"
EOF

BASHRC="$COURSE_HOME/.bashrc"
PROFILE_LINE='[[ -f "$HOME/.course-env" ]] && source "$HOME/.course-env"'
touch "$BASHRC"
if ! grep -Fqx "$PROFILE_LINE" "$BASHRC"; then
  printf '\n%s\n' "$PROFILE_LINE" >>"$BASHRC"
fi

if [[ "$EUID" -eq 0 ]]; then
  chown "$COURSE_USER":"$(id -gn "$COURSE_USER")" "$COURSE_PROFILE" "$BASHRC"
fi

printf '\n[5/5] Verifying installed commands and Python imports...\n'
required_commands=(bash gcc g++ make gdb git vim grep sed awk curl wget ssh scp telnet dot gnuplot python3)
for command_name in "${required_commands[@]}"; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'ERROR: Required command was not installed: %s\n' "$command_name" >&2
    exit 1
  fi
done

run_as_course_user "$VENV_DIR/bin/python" - <<'PY'
import matplotlib
import numpy
import pandas
import requests

print("Python imports succeeded:")
print(f"  matplotlib {matplotlib.__version__}")
print(f"  numpy      {numpy.__version__}")
print(f"  pandas     {pandas.__version__}")
print(f"  requests   {requests.__version__}")
PY

printf '\n%s\n' \
  '=======================================================' \
  'ENVIRONMENT SETUP COMPLETED SUCCESSFULLY' \
  '=======================================================' \
  "Course user: $COURSE_USER" \
  "Python environment: $VENV_DIR" \
  '' \
  'Open a new terminal, or activate it now with:' \
  '  source ~/course-venv/bin/activate' \
  '' \
  'Run verification as your normal user, without sudo:' \
  '  ./setup/verify-course.sh'
