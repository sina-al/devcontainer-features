#!/usr/bin/env bash
#
# Dev Container feature: FireConnect CLI
#
# Installs FireConnect for the target (remote) user so the launcher, CLI
# checkout, and shell PATH update land in that user's home, matching how the
# vendor installer behaves when run by a real user.
#
# FireConnect requires Node.js 18+, which the `node` feature (declared in
# `installsAfter`) provides.
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
LOGIN="${LOGIN:-false}"

# --- Prerequisites ------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "fireconnect: 'git' is required." >&2; exit 1; }

# The `node` feature installs Node; make its binary visible to the target user's
# shell below by prepending its directory to PATH.
NODE_DIR=""
if NODE_BIN="$(command -v node 2>/dev/null || true)"; then
  NODE_DIR="$(dirname "${NODE_BIN}")"
fi

install_fireconnect() {
  local user="$1" version="$2" node_dir="$3"
  local branch=""
  [[ "${version}" != "latest" ]] && branch="${version}"

  su - "${user}" -s /bin/bash <<EOF
set -e
export PATH="${node_dir}:\$PATH"

# Canonical checkout location used by the vendor installer.
mkdir -p "\${HOME}/.fireconnect"
rm -rf "\${HOME}/.fireconnect/cli"

if [[ -n "${branch}" ]]; then
  echo "fireconnect: cloning ${version} ..."
  git clone --quiet --depth 1 --branch "${branch}" \
    https://github.com/fw-ai/fireconnect.git "\${HOME}/.fireconnect/cli"
else
  echo "fireconnect: cloning latest ..."
  git clone --quiet --depth 1 \
    https://github.com/fw-ai/fireconnect.git "\${HOME}/.fireconnect/cli"
fi

bash "\${HOME}/.fireconnect/cli/install.sh"
EOF
}

login_fireconnect() {
  local user="$1" node_dir="$2" token="${FIRECONNECT_TOKEN:-${FIREWORKS_API_KEY:-}}"

  if [[ -z "${token}" ]]; then
    echo "fireconnect: login=true requires FIRECONNECT_TOKEN or FIREWORKS_API_KEY." >&2
    exit 1
  fi

  su - "${user}" -s /bin/bash <<EOF
set -e
export PATH="${node_dir}:\$PATH"
# FIREWORKS_API_KEY changes how 'login' behaves (it skips the secret store and
# rejects --with-token), so it must not be set during the token flow.
unset FIREWORKS_API_KEY
printf '%s\n' "${token}" | fireconnect login --with-token
EOF
}

install_fireconnect "${USERNAME}" "${VERSION}" "${NODE_DIR}"

if [[ "${LOGIN}" == "true" ]]; then
  login_fireconnect "${USERNAME}" "${NODE_DIR}"
fi

echo "fireconnect: installed for user '${USERNAME}' (version '${VERSION}')."
