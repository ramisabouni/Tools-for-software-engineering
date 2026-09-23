FROM mcr.microsoft.com/devcontainers/universal:2-linux

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bc \
        build-essential \
        curl \
        file \
        findutils \
        gawk \
        gdb \
        git \
        gnuplot-nox \
        graphviz \
        grep \
        gzip \
        jq \
        less \
        ltrace \
        make \
        nano \
        openssh-client \
        python3 \
        python3-matplotlib \
        python3-networkx \
        python3-pip \
        ripgrep \
        sed \
        shellcheck \
        strace \
        tar \
        tree \
        unzip \
        valgrind \
        vim \
        xz-utils \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER codespace
