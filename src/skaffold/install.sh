#!/usr/bin/env bash
#
# Dev Container feature: skaffold
#
# Installs Skaffold from the official GitHub releases. The binary is a static
# executable installed to /usr/local/bin so it is on PATH for all users
# and all shell types (login, interactive, non-interactive).
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

REPO_OWNER="GoogleContainerTools"
REPO_NAME="skaffold"

if [ "$(id -u)" -ne 0 ]; then
  echo "skaffold: must run as root." >&2
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

check_packages curl ca-certificates

# --- Resolve version ----------------------------------------------------------
if [ "${VERSION}" = "latest" ]; then
  echo "skaffold: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "skaffold: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "skaffold: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH_SUFFIX="amd64" ;;
  aarch64|arm64)  ARCH_SUFFIX="arm64" ;;
  *) echo "skaffold: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="skaffold-linux-${ARCH_SUFFIX}"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "skaffold: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/skaffold" "${DOWNLOAD_URL}"

install -m 0755 "${TMP_DIR}/skaffold" /usr/local/bin/skaffold

rm -rf /var/lib/apt/lists/*

echo "skaffold: installed version ${VERSION} to /usr/local/bin/skaffold."
