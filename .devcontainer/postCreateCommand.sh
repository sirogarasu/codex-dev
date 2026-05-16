#!/usr/bin/env bash

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
    echo ""
fi
