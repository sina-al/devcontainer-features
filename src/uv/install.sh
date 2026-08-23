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
#
# When `pythonVersions` is set, pre-installs those uv-managed Python versions at
# build time so they are baked into the image. When `defaultPython` is set, pins
# it as the global default. Writes UV_PYTHON_PREFERENCE so uv enforces
# uv-managed Python (ignoring any system Python) — this is the default and is
# enforced whenever the feature is used.
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

PYTHON_VERSIONS="${PYTHONVERSIONS:-}"
DEFAULT_PYTHON="${DEFAULTPYTHON:-}"
PYTHON_PREFERENCE="${PYTHONPREFERENCE:-only-managed}"

# --- Prerequisites ------------------------------------------------------------
if ! command -v curl >/dev/null 2>&1; then
  echo "uv: 'curl' is required." >&2
  exit 1
fi

# --- Helper: run a command as the remote user with uv on PATH -----------------
run_as_user() {
  su - "${USERNAME}" -s /bin/bash -c "export PATH=\"\${HOME}/.local/bin:\$PATH\"; $1"
}

# --- 1. Install uv ------------------------------------------------------------
install_uv() {
  local installer_url
  if [[ "${VERSION}" == "latest" ]]; then
    installer_url="https://astral.sh/uv/install.sh"
  else
    installer_url="https://github.com/astral-sh/uv/releases/download/${VERSION}/uv-installer.sh"
  fi

  su - "${USERNAME}" -s /bin/bash <<EOF
set -e
echo "uv: downloading standalone installer (${VERSION}) ..."
curl -LsSf "${installer_url}" | sh
EOF
}

install_uv

# --- 2. Pre-install Python versions ------------------------------------------
if [[ -n "${PYTHON_VERSIONS}" ]]; then
  IFS=',' read -ra _VERSIONS <<< "${PYTHON_VERSIONS}"
  for _v in "${_VERSIONS[@]}"; do
    _v="$(echo "${_v}" | xargs)"
    [[ -z "${_v}" ]] && continue
    echo "uv: pre-installing Python ${_v} ..."
    run_as_user "uv python install ${_v}"
  done
fi

# --- 3. Set default Python ---------------------------------------------------
if [[ -n "${DEFAULT_PYTHON}" ]]; then
  echo "uv: setting default Python to ${DEFAULT_PYTHON} ..."
  run_as_user "uv python install ${DEFAULT_PYTHON} --default"
  run_as_user "uv python pin ${DEFAULT_PYTHON} --global"
fi

# --- 4. Enforce uv-managed Python preference ---------------------------------
# Write UV_PYTHON_PREFERENCE system-wide so every shell and process honors it.
# only-managed (the default) makes uv ignore system Python entirely; all Python
# must come from uv. This is enforced whenever the feature is used, regardless
# of whether pythonVersions is set.
echo "uv: setting UV_PYTHON_PREFERENCE=${PYTHON_PREFERENCE} ..."

cat >/etc/profile.d/uv-python.sh <<EOF
export UV_PYTHON_PREFERENCE=${PYTHON_PREFERENCE}
export PATH="\${HOME}/.local/bin:\${PATH}"
EOF
chmod 0644 /etc/profile.d/uv-python.sh

run_as_user "grep -q 'UV_PYTHON_PREFERENCE' \"\${HOME}/.bashrc\" 2>/dev/null || echo 'export UV_PYTHON_PREFERENCE=${PYTHON_PREFERENCE}' >> \"\${HOME}/.bashrc\""

echo "uv: installed for user '${USERNAME}' (version '${VERSION}', preference '${PYTHON_PREFERENCE}')."
