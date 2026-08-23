#!/usr/bin/env bash
#
# Dev Container feature: Dev Container CLI
#
# Installs the official `devcontainer` CLI via its self-contained installer,
# which bundles a Node.js runtime (no dependency on the `node` feature or build
# tools). Installs for the target (remote) user under ~/.devcontainers and adds
# that to the user's PATH.
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
# The installer expects a bare version (e.g. "0.88.0"); strip a leading "v"
# since GitHub release tags are prefixed with one (e.g. "v0.88.0").
VERSION="${VERSION#v}"

INSTALL_SCRIPT="https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh"

su - "${USERNAME}" -s /bin/bash <<EOF
set -e
echo "devcontainers-cli: downloading official installer ..."
curl -fsSL "${INSTALL_SCRIPT}" -o /tmp/devcontainers-cli-install.sh

if [[ "${VERSION}" == "latest" ]]; then
  bash /tmp/devcontainers-cli-install.sh --prefix "\${HOME}/.devcontainers"
else
  echo "devcontainers-cli: installing version ${VERSION} ..."
  bash /tmp/devcontainers-cli-install.sh --version "${VERSION}" --prefix "\${HOME}/.devcontainers"
fi
rm -f /tmp/devcontainers-cli-install.sh

# Ensure the CLI prefix is on PATH for interactive/logged-in shells.
if ! grep -q 'devcontainers/bin' "\${HOME}/.bashrc" 2>/dev/null; then
  echo 'export PATH="\${HOME}/.devcontainers/bin:\$PATH"' >> "\${HOME}/.bashrc"
fi
EOF

echo "devcontainers-cli: installed for user '${USERNAME}' (version '${VERSION}')."
