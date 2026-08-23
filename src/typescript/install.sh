#!/usr/bin/env bash
#
# Dev Container feature: TypeScript
#
# Installs the TypeScript compiler globally via npm. Requires Node.js to be
# installed first (e.g. via the ghcr.io/devcontainers/features/node feature).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"

if [ "$(id -u)" -ne 0 ]; then
  echo "typescript: must run as root." >&2
  exit 1
fi

# --- Prerequisites ------------------------------------------------------------
if ! command -v npm >/dev/null 2>&1; then
  echo "typescript: npm is required (install the node feature first)." >&2
  exit 1
fi

# --- Install ------------------------------------------------------------------
echo "typescript: installing version ${VERSION}..."

if [ "${VERSION}" = "latest" ]; then
  npm install -g typescript
else
  npm install -g "typescript@${VERSION}"
fi

echo "typescript: installed version $(tsc --version)."
