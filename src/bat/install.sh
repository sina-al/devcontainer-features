#!/usr/bin/env bash
#
# Dev Container feature: bat
#
# Installs bat from the official GitHub releases. The binary is a static
# musl executable installed to /usr/local/bin so it is on PATH for all
# users and all shell types (login, interactive, non-interactive).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

REPO_OWNER="sharkdp"
REPO_NAME="bat"

if [ "$(id -u)" -ne 0 ]; then
  echo "bat: must run as root." >&2
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
  echo "bat: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v?([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "bat: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "bat: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   TARGET="x86_64-unknown-linux-musl" ;;
  aarch64|arm64)  TARGET="aarch64-unknown-linux-musl" ;;
  *) echo "bat: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

case "${OS}" in
  linux)  ;;
  *) echo "bat: unsupported OS: ${OS}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="bat-v${VERSION}-${TARGET}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "bat: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${ASSET_NAME}" "${DOWNLOAD_URL}"

tar -xzf "${TMP_DIR}/${ASSET_NAME}" -C "${TMP_DIR}"

if [ -f "${TMP_DIR}/bat-v${VERSION}-${TARGET}/bat" ]; then
  install -m 0755 "${TMP_DIR}/bat-v${VERSION}-${TARGET}/bat" /usr/local/bin/bat
elif [ -f "${TMP_DIR}/bat" ]; then
  install -m 0755 "${TMP_DIR}/bat" /usr/local/bin/bat
else
  echo "bat: binary not found in archive." >&2
  ls -la "${TMP_DIR}"
  exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "bat: installed version ${VERSION} to /usr/local/bin/bat."
