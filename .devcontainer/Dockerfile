FROM mcr.microsoft.com/devcontainers/base:3-noble

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        binutils-arm-none-eabi \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        ca-certificates \
        curl \
        git \
        libpng-dev \
        libelf1t64 \
        pkg-config \
        python3 \
    && rm -rf /var/lib/apt/lists/*

COPY github-auth.sh /usr/local/share/devcontainer/github-auth.sh

RUN printf '\nsource /usr/local/share/devcontainer/github-auth.sh\n' \
    >> /home/vscode/.bashrc
