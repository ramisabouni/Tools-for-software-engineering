#!/usr/bin/env bash

###############################################################################
#
# verify-course.sh
#
# Tools for Software Engineering
# Environment Verification Script
#
# Author: Dr. Rami Sabouni
#
###############################################################################

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

PASS=0
FAIL=0

print_header() {
    echo
    echo "==============================================================="
    echo "      Tools for Software Engineering"
    echo "      Environment Verification"
    echo "==============================================================="
    echo
}

check_command() {
    TOOL="$1"
    VERSION_COMMAND="$2"
    INSTALL_COMMAND="$3"

    printf "%-15s" "$TOOL"

    if command -v "$TOOL" >/dev/null 2>&1; then
        LOCATION=$(command -v "$TOOL")
        VERSION=$(eval "$VERSION_COMMAND" 2>&1 | head -n 1)

        printf "${GREEN}[OK]${NC}\n"
        echo "    Location : $LOCATION"

        if [ -n "$VERSION" ]; then
            echo "    Version  : $VERSION"
        fi

        PASS=$((PASS + 1))
    else
        printf "${RED}[MISSING]${NC}\n"

        if [ -n "$INSTALL_COMMAND" ]; then
            echo -e "    ${YELLOW}Fix:${NC}"
            echo "    $INSTALL_COMMAND"
        fi

        FAIL=$((FAIL + 1))
    fi

    echo
}

check_python_package() {
    PACKAGE="$1"

    printf "%-15s" "$PACKAGE"

    if python3 -c "import $PACKAGE" >/dev/null 2>&1; then
        VERSION=$(python3 -c \
            "import $PACKAGE; print(getattr($PACKAGE, '__version__', 'installed'))" \
            2>/dev/null)

        printf "${GREEN}[OK]${NC}\n"
        echo "    Version  : $VERSION"

        PASS=$((PASS + 1))
    else
        printf "${RED}[MISSING]${NC}\n"
        echo -e "    ${YELLOW}Fix:${NC}"
        echo "    ~/course-venv/bin/pip install $PACKAGE"

        FAIL=$((FAIL + 1))
    fi

    echo
}

print_header

###############################################################################
# System Information
###############################################################################

echo "System Information"
echo "---------------------------------------------------------------"

echo "User          : $(whoami)"
echo "Hostname      : $(hostname)"
echo "Architecture  : $(uname -m)"
echo "Kernel        : $(uname -r)"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Operating Sys.: $PRETTY_NAME"
fi

echo
echo "Disk Space"
df -h / | tail -n 1

echo
echo "Memory"
free -h | head -n 2

###############################################################################
# Command Verification
###############################################################################

echo
echo "==============================================================="
echo "Required Tools"
echo "==============================================================="
echo

check_command \
    bash \
    "bash --version" \
    "sudo apt install -y bash"

check_command \
    gcc \
    "gcc --version" \
    "sudo apt install -y build-essential"

check_command \
    g++ \
    "g++ --version" \
    "sudo apt install -y build-essential"

check_command \
    make \
    "make --version" \
    "sudo apt install -y build-essential"

check_command \
    gdb \
    "gdb --version" \
    "sudo apt install -y gdb"

check_command \
    git \
    "git --version" \
    "sudo apt install -y git"

check_command \
    vim \
    "vim --version" \
    "sudo apt install -y vim"

check_command \
    grep \
    "grep --version" \
    "sudo apt install -y grep"

check_command \
    sed \
    "sed --version" \
    "sudo apt install -y sed"

check_command \
    awk \
    "awk --version" \
    "sudo apt install -y gawk"

check_command \
    curl \
    "curl --version" \
    "sudo apt install -y curl"

check_command \
    wget \
    "wget --version" \
    "sudo apt install -y wget"

check_command \
    ssh \
    "ssh -V" \
    "sudo apt install -y openssh-client"

check_command \
    scp \
    "scp -V" \
    "sudo apt install -y openssh-client"

check_command \
    telnet \
    "telnet --help" \
    "sudo apt install -y telnet"

check_command \
    dot \
    "dot -V" \
    "sudo apt install -y graphviz"

check_command \
    gnuplot \
    "gnuplot --version" \
    "sudo apt install -y gnuplot-nox"

check_command \
    python3 \
    "python3 --version" \
    "sudo apt install -y python3"

check_command \
    pip3 \
    "pip3 --version" \
    "sudo apt install -y python3-pip"

###############################################################################
# Python Packages
###############################################################################

echo
echo "==============================================================="
echo "Python Packages"
echo "==============================================================="
echo

if [ -x "$HOME/course-venv/bin/python" ]; then
    PYTHON="$HOME/course-venv/bin/python"
    PIP="$HOME/course-venv/bin/pip"

    echo "Using course virtual environment:"
    echo "    $HOME/course-venv"
    echo
else
    PYTHON="python3"
    PIP="pip3"

    echo -e "${YELLOW}WARNING:${NC} Course Python virtual environment not found."
    echo
    echo "Recommended fix:"
    echo
    echo "    sudo apt install -y python3-venv"
    echo "    python3 -m venv ~/course-venv"
    echo "    ~/course-venv/bin/pip install matplotlib numpy pandas requests"
    echo
fi

check_python_venv_package() {
    PACKAGE="$1"

    printf "%-15s" "$PACKAGE"

    if "$PYTHON" -c "import $PACKAGE" >/dev/null 2>&1; then
        VERSION=$(
            "$PYTHON" -c \
            "import $PACKAGE; print(getattr($PACKAGE, '__version__', 'installed'))" \
            2>/dev/null
        )

        printf "${GREEN}[OK]${NC}\n"
        echo "    Version  : $VERSION"
        PASS=$((PASS + 1))
    else
        printf "${RED}[MISSING]${NC}\n"
        echo -e "    ${YELLOW}Fix:${NC}"
        echo "    $PIP install $PACKAGE"
        FAIL=$((FAIL + 1))
    fi

    echo
}

check_python_venv_package matplotlib
check_python_venv_package numpy
check_python_venv_package pandas
check_python_venv_package requests

###############################################################################
# C Compilation Test
###############################################################################

echo
echo "==============================================================="
echo "C Compiler Test"
echo "==============================================================="
echo

if command -v gcc >/dev/null 2>&1; then

    TMPDIR_TEST=$(mktemp -d)

    cat > "$TMPDIR_TEST/test.c" <<'EOF'
#include <stdio.h>

int main(void)
{
    printf("C compiler test successful.\n");
    return 0;
}
EOF

    if gcc \
        -Wall \
        -Wextra \
        "$TMPDIR_TEST/test.c" \
        -o "$TMPDIR_TEST/test" \
        >/dev/null 2>&1; then

        OUTPUT=$("$TMPDIR_TEST/test")

        echo -e "${GREEN}[OK] Compilation succeeded${NC}"
        echo "    Output: $OUTPUT"

        PASS=$((PASS + 1))
    else
        echo -e "${RED}[FAILED] Unable to compile test program${NC}"
        echo
        echo "Try:"
        echo "    sudo apt update"
        echo "    sudo apt install -y build-essential"

        FAIL=$((FAIL + 1))
    fi

    rm -rf "$TMPDIR_TEST"

else
    echo -e "${RED}[SKIPPED] gcc is not installed${NC}"
    echo
    echo "Fix:"
    echo "    sudo apt install -y build-essential"

    FAIL=$((FAIL + 1))
fi

###############################################################################
# Graphviz Test
###############################################################################

echo
echo "==============================================================="
echo "Graphviz Test"
echo "==============================================================="
echo

if command -v dot >/dev/null 2>&1; then

    TMPDIR_GRAPH=$(mktemp -d)

    cat > "$TMPDIR_GRAPH/test.dot" <<'EOF'
digraph G {
    Start -> Finish;
}
EOF

    if dot \
        -Tpng \
        "$TMPDIR_GRAPH/test.dot" \
        -o "$TMPDIR_GRAPH/test.png" \
        >/dev/null 2>&1; then

        echo -e "${GREEN}[OK] Graphviz generated a PNG successfully${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}[FAILED] Graphviz execution failed${NC}"
        echo
        echo "Try:"
        echo "    sudo apt install --reinstall -y graphviz"

        FAIL=$((FAIL + 1))
    fi

    rm -rf "$TMPDIR_GRAPH"

else
    echo -e "${RED}[SKIPPED] Graphviz is not installed${NC}"
    echo
    echo "Fix:"
    echo "    sudo apt install -y graphviz"

    FAIL=$((FAIL + 1))
fi

###############################################################################
# Gnuplot Test
###############################################################################

echo
echo "==============================================================="
echo "gnuplot Test"
echo "==============================================================="
echo

if command -v gnuplot >/dev/null 2>&1; then

    TMPDIR_GNUPLOT=$(mktemp -d)

    cat > "$TMPDIR_GNUPLOT/test.gnuplot" <<EOF
set terminal png
set output '$TMPDIR_GNUPLOT/test.png'
plot sin(x)
EOF

    if gnuplot "$TMPDIR_GNUPLOT/test.gnuplot" >/dev/null 2>&1 \
        && [ -s "$TMPDIR_GNUPLOT/test.png" ]; then

        echo -e "${GREEN}[OK] gnuplot generated a PNG successfully${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}[FAILED] gnuplot execution failed${NC}"
        echo
        echo "Try:"
        echo "    sudo apt install --reinstall -y gnuplot-nox"

        FAIL=$((FAIL + 1))
    fi

    rm -rf "$TMPDIR_GNUPLOT"

else
    echo -e "${RED}[SKIPPED] gnuplot is not installed${NC}"
    echo
    echo "Fix:"
    echo "    sudo apt install -y gnuplot-nox"

    FAIL=$((FAIL + 1))
fi

###############################################################################
# Final Summary
###############################################################################

echo
echo "==============================================================="
echo "Final Summary"
echo "==============================================================="
echo

echo "Passed checks : $PASS"
echo "Failed checks : $FAIL"

echo

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}===============================================================${NC}"
    echo -e "${GREEN} ENVIRONMENT VERIFICATION PASSED${NC}"
    echo -e "${GREEN} Your system is ready for Tools for Software Engineering.${NC}"
    echo -e "${GREEN}===============================================================${NC}"
    exit 0
else
    echo -e "${RED}===============================================================${NC}"
    echo -e "${RED} ENVIRONMENT VERIFICATION FAILED${NC}"
    echo -e "${RED} Please fix the missing or failed items shown above.${NC}"
    echo -e "${RED}===============================================================${NC}"

    echo
    echo "A common repair command is:"
    echo
    echo "    sudo apt update"
    echo "    sudo apt install -y \\"
    echo "        build-essential \\"
    echo "        gdb \\"
    echo "        git \\"
    echo "        vim \\"
    echo "        curl \\"
    echo "        wget \\"
    echo "        openssh-client \\"
    echo "        telnet \\"
    echo "        graphviz \\"
    echo "        gnuplot-nox \\"
    echo "        python3 \\"
    echo "        python3-pip \\"
    echo "        python3-venv"

    exit 1
fi
