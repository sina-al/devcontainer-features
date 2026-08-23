#!/usr/bin/env bash
#
# Dev Container feature: zellij
#
# Installs zellij from the official GitHub releases. The binary is a static
# musl executable installed to /usr/local/bin so it is on PATH for all
# users and all shell types (login, interactive, non-interactive).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

REPO_OWNER="zellij-org"
REPO_NAME="zellij"

if [ "$(id -u)" -ne 0 ]; then
  echo "zellij: must run as root." >&2
  exit 1
fi

# --- Prerequisites ------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive

check_packages() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    if [ "$(find /var/lib/apt/lists/* 2>/dev/null | wc -l)" = "0" ]; then
      apt-get update -y
    fi
    apt-get -y install --no-install-recommends "$@"
  fi
}

check_packages curl ca-certificates tar

# --- Resolve version ----------------------------------------------------------
if [ "${VERSION}" = "latest" ]; then
  echo "zellij: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v?([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "zellij: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "zellij: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   TARGET="x86_64-unknown-linux-musl" ;;
  aarch64|arm64)  TARGET="aarch64-unknown-linux-musl" ;;
  *) echo "zellij: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

case "${OS}" in
  linux)  ;;
  *) echo "zellij: unsupported OS: ${OS}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="zellij-${TARGET}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "zellij: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${ASSET_NAME}" "${DOWNLOAD_URL}"

tar -xzf "${TMP_DIR}/${ASSET_NAME}" -C "${TMP_DIR}"

if [ -f "${TMP_DIR}/zellij" ]; then
  install -m 0755 "${TMP_DIR}/zellij" /usr/local/bin/zellij
else
  echo "zellij: binary not found in archive." >&2
  ls -la "${TMP_DIR}"
  exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "zellij: installed version ${VERSION} to /usr/local/bin/zellij."
