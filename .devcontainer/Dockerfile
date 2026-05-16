FROM mcr.microsoft.com/devcontainers/javascript-node:1-22-bookworm

RUN apt-get update && apt-get install -y \
    bubblewrap \
    git \
    curl \
    ripgrep \
    jq \
    unzip \
    python3 \
    python3-pip \
    php-cli \
    composer \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

WORKDIR /workspace
