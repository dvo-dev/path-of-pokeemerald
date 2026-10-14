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

RUN curl -fsSL https://gh.io/copilot-install -o /tmp/copilot-install.sh \
    && PREFIX=/usr/local bash /tmp/copilot-install.sh \
    && rm /tmp/copilot-install.sh
