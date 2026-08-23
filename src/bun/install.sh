#!/usr/bin/env bash
#
# Dev Container feature: Bun
#
# Installs Bun from the official GitHub releases. The binary is a static
# executable installed to /usr/local/bin so it is on PATH for all users
# and all shell types (login, interactive, non-interactive).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#bun-v}"
VERSION="${VERSION#v}"

REPO_OWNER="oven-sh"
REPO_NAME="bun"

if [ "$(id -u)" -ne 0 ]; then
  echo "bun: must run as root." >&2
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

check_packages curl ca-certificates unzip

# --- Resolve version ----------------------------------------------------------
if [ "${VERSION}" = "latest" ]; then
  echo "bun: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"bun-v([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "bun: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "bun: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH_SUFFIX="x64" ;;
  aarch64|arm64)  ARCH_SUFFIX="aarch64" ;;
  *) echo "bun: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="bun-linux-${ARCH_SUFFIX}.zip"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/bun-v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "bun: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/bun.zip" "${DOWNLOAD_URL}"

unzip -o "${TMP_DIR}/bun.zip" -d "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/bun-${ARCH_SUFFIX}/bun" /usr/local/bin/bun

rm -rf /var/lib/apt/lists/*

echo "bun: installed version ${VERSION} to /usr/local/bin/bun."
