#!/usr/bin/env bash
#
# Dev Container feature: rtk (Rust Token Killer)
#
# Installs rtk from the official GitHub releases. The binary is a static
# executable installed to /usr/local/bin so it is on PATH for all users and
# all shell types. When the `agent` option is set, runs `rtk init --global
# --agent <agent>` as the remote user so the auto-rewrite hook is active
# from the first shell session.
set -e

# --- Resolve the user to install for -----------------------------------------
USERNAME="${_REMOTE_USER:-${_CONTAINER_USER:-}}"
if [[ -z "${USERNAME}" ]] || ! id -u "${USERNAME}" >/dev/null 2>&1; then
  if id -u sandbox >/dev/null 2>&1; then
    USERNAME="sandbox"
  else
    USERNAME="root"
  fi
fi

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
VERSION="${VERSION#v}"
AGENT="${AGENT:-}"

REPO_OWNER="rtk-ai"
REPO_NAME="rtk"

if [ "$(id -u)" -ne 0 ]; then
  echo "rtk: must run as root." >&2
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
  echo "rtk: resolving latest version..."
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v?([^"]+)".*/\1/')
  if [ -z "${VERSION}" ]; then
    echo "rtk: failed to resolve latest version." >&2
    exit 1
  fi
fi

echo "rtk: installing version ${VERSION}..."

# --- Detect platform ----------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH="x86_64" ;;
  aarch64|arm64)  ARCH="aarch64" ;;
  *) echo "rtk: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

case "${OS}" in
  linux)
    case "${ARCH}" in
      x86_64)   TARGET="x86_64-unknown-linux-musl" ;;
      aarch64)  TARGET="aarch64-unknown-linux-gnu" ;;
    esac
    ;;
  darwin) TARGET="${ARCH}-apple-darwin" ;;
  *) echo "rtk: unsupported OS: ${OS}" >&2; exit 1 ;;
esac

# --- Download and install -----------------------------------------------------
ASSET_NAME="rtk-${TARGET}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ASSET_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "rtk: downloading from ${DOWNLOAD_URL}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${ASSET_NAME}" "${DOWNLOAD_URL}"

tar -xzf "${TMP_DIR}/${ASSET_NAME}" -C "${TMP_DIR}"

if [ -f "${TMP_DIR}/rtk" ]; then
  install -m 0755 "${TMP_DIR}/rtk" /usr/local/bin/rtk
else
  echo "rtk: binary not found in archive." >&2
  ls -la "${TMP_DIR}"
  exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "rtk: installed version ${VERSION} to /usr/local/bin/rtk."

# --- Init (optional) ----------------------------------------------------------
if [[ -n "${AGENT}" ]]; then
  echo "rtk: initializing for agent '${AGENT}'..."
  su - "${USERNAME}" -s /bin/bash -c "rtk init --global --agent ${AGENT}" || {
    echo "rtk: init failed — you can run 'rtk init --global --agent ${AGENT}' manually after startup." >&2
  }
  echo "rtk: init complete for agent '${AGENT}'."
else
  echo "rtk: init skipped (agent not set). Run 'rtk init --global --agent <name>' to activate."
fi

echo "rtk: done (version '${VERSION}', agent '${AGENT:-none}')."
