FROM mcr.microsoft.com/devcontainers/base:1-ubuntu-24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        binutils-arm-none-eabi \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        git \
        libpng-dev \
        libelf1t64 \
        pkg-config \
        python3 \
    && rm -rf /var/lib/apt/lists/*
