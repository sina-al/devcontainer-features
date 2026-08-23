#!/usr/bin/env bash
#
# Dev Container feature: kustomize
#
# Installs kustomize from the official GitHub releases. The binary is a
# static executable installed to /usr/local/bin so it is on PATH for all
# users and all shell types (login, interactive, non-interactive).
#
# kustomize release tags use a 'kustomize/v' prefix (e.g. 'kustomize/v5.8.1').
set -e

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"

REPO_OWNER="kubernetes-sigs"
REPO_NAME="kustomize"

if [ "$(id -u)" -ne 0 ]; then
  echo "kustomize: must run as root." >&2
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
  echo "kustomize: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"kustomize\/v?([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "kustomize: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "kustomize: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH_SUFFIX="amd64" ;;
  aarch64|arm64)  ARCH_SUFFIX="arm64" ;;
  *) echo "kustomize: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

case "${OS}" in
  linux)  PLATFORM="linux" ;;
  *) echo "kustomize: unsupported OS: ${OS}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="kustomize_v${VERSION}_${PLATFORM}_${ARCH_SUFFIX}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/kustomize/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "kustomize: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${ASSET_NAME}" "${DOWNLOAD_URL}"

tar -xzf "${TMP_DIR}/${ASSET_NAME}" -C "${TMP_DIR}"

if [ -f "${TMP_DIR}/kustomize" ]; then
  install -m 0755 "${TMP_DIR}/kustomize" /usr/local/bin/kustomize
else
  echo "kustomize: binary not found in archive." >&2
  ls -la "${TMP_DIR}"
  exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "kustomize: installed version ${VERSION} to /usr/local/bin/kustomize."
