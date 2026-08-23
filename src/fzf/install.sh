#!/usr/bin/env bash
#
# Dev Container feature: fzf
#
# Installs fzf from the official GitHub releases. The binary is a static
# executable installed to /usr/local/bin so it is on PATH for all users
# and all shell types (login, interactive, non-interactive).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

REPO_OWNER="junegunn"
REPO_NAME="fzf"

if [ "$(id -u)" -ne 0 ]; then
  echo "fzf: must run as root." >&2
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
  echo "fzf: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v?([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "fzf: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "fzf: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH_SUFFIX="amd64" ;;
  aarch64|arm64)  ARCH_SUFFIX="arm64" ;;
  *) echo "fzf: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

case "${OS}" in
  linux)  PLATFORM="linux" ;;
  *) echo "fzf: unsupported OS: ${OS}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="fzf-${VERSION}-${PLATFORM}_${ARCH_SUFFIX}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "fzf: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${ASSET_NAME}" "${DOWNLOAD_URL}"

tar -xzf "${TMP_DIR}/${ASSET_NAME}" -C "${TMP_DIR}"

install -m 0755 "${TMP_DIR}/fzf" /usr/local/bin/fzf

rm -rf /var/lib/apt/lists/*

echo "fzf: installed version ${VERSION} to /usr/local/bin/fzf."
