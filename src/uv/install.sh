#!/usr/bin/env bash
#
# Dev Container feature: uv (and uvx)
#
# Installs uv and uvx — Astral's extremely fast Python package and project
# manager — via the official standalone installer, which bundles a
# self-contained binary (no Python or build tools required). Installs for the
# target (remote) user so the binaries and PATH update land in that user's home,
# not /root.
#
# Both `uv` and `uvx` ship in the same release tarball, so a single installer
# run produces both.
set -e

# --- Resolve the user to install for -----------------------------------------
USERNAME="${_REMOTE_USER:-${_CONTAINER_USER:-}}"
if [[ -z "${USERNAME}" ]] || ! id -u "${USERNAME}" >/dev/null 2>&1; then
  if id -u vscode >/dev/null 2>&1; then
    USERNAME="vscode"
  else
    USERNAME="root"
  fi
fi

# --- Feature inputs -----------------------------------------------------------
VERSION="${VERSION:-latest}"
# Release-specific installer URLs are tagged without a "v" prefix (e.g.
# "0.12.5"), so strip a leading "v" if the user passed one.
VERSION="${VERSION#v}"

# --- Prerequisites ------------------------------------------------------------
# The standalone installer needs a downloader and TLS certificates. The base
# devcontainer image ships curl, but guard for minimal images.
if ! command -v curl >/dev/null 2>&1; then
  echo "uv: 'curl' is required." >&2
  exit 1
fi

install_uv() {
  local user="$1" version="$2"

  local installer_url
  if [[ "${version}" == "latest" ]]; then
    installer_url="https://astral.sh/uv/install.sh"
  else
    installer_url="https://github.com/astral-sh/uv/releases/download/${version}/uv-installer.sh"
  fi

  su - "${user}" -s /bin/bash <<EOF
set -e
echo "uv: downloading standalone installer (${version}) ..."
curl -LsSf "${installer_url}" | sh
EOF
}

install_uv "${USERNAME}" "${VERSION}"

echo "uv: installed for user '${USERNAME}' (version '${VERSION}')."
