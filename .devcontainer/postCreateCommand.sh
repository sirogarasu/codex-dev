#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOURCE_CONFIG="${PROJECT_ROOT}/.codex/config.toml"
CODEX_HOME="${HOME}/.codex"
TARGET_CONFIG="${CODEX_HOME}/config.toml"

echo ""
echo "=== Codex Setup ==="
echo ""

if ! command -v codex >/dev/null 2>&1; then
    echo "ERROR: Codex CLI is not installed."
    exit 1
fi

echo "Codex:"
codex --version
echo ""

mkdir -p "${CODEX_HOME}"

if [ -f "${SOURCE_CONFIG}" ]; then
    cp "${SOURCE_CONFIG}" "${TARGET_CONFIG}"
    chmod 600 "${TARGET_CONFIG}"

    echo "Codex config copied:"
    echo "  ${SOURCE_CONFIG}"
    echo "    ->"
    echo "  ${TARGET_CONFIG}"
else
    echo "WARNING: Codex config not found:"
    echo "  ${SOURCE_CONFIG}"
fi

echo ""
echo "=== Codex Login Check ==="

if codex login status >/dev/null 2>&1; then
    echo "Codex already logged in."
else
    echo ""
    echo "Codex is NOT logged in."
    echo ""
    echo "Run:"
    echo "  codex login --device-auth"
fi

echo ""

if [ -f "${TARGET_CONFIG}" ]; then
    if grep -q '^sandbox_mode *= *"danger-full-access"' "${TARGET_CONFIG}"; then
        echo "Sandbox mode:"
        echo "  danger-full-access"
    else
        echo "WARNING:"
        echo "  sandbox_mode is not danger-full-access."
        echo "  bwrap may fail inside this devcontainer."
    fi
fi

echo ""
echo "=== Setup complete ==="
