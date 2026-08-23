#!/usr/bin/env bash
#
# Dev Container feature: Google Cloud CLI
#
# Installs the gcloud CLI via the official Google Cloud SDK apt repository.
# Supports version pinning and the GKE gcloud auth plugin.
set -e

# --- Feature inputs -----------------------------------------------------------
GCLOUD_VERSION="${VERSION:-latest}"
INSTALL_GKE_PLUGIN="${INSTALLGKEGCLOUDAUTHPLUGIN:-false}"

if [ "$(id -u)" -ne 0 ]; then
  echo "gcloud-cli: must run as root." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# --- Helpers ------------------------------------------------------------------
apt_get_update() {
  echo "gcloud-cli: apt-get update..."
  apt-get update -y
}

check_packages() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    if [ "$(find /var/lib/apt/lists/* 2>/dev/null | wc -l)" = "0" ]; then
      apt_get_update
    fi
    apt-get -y install --no-install-recommends "$@"
  fi
}

apt_cache_version_soft_match() {
  local variable_name="$1"
  local requested_version="${!variable_name}"
  local package_name="$2"

  . /etc/os-release
  local architecture
  architecture="$(dpkg --print-architecture)"

  local dot_escaped="${requested_version//./\\.}"
  local dot_plus_escaped="${dot_escaped//+/\\+}"
  local version_regex="^(.+:)?${dot_plus_escaped}([\\.\\+ ~:-]|$)"

  set +e
  local fuzzy_version
  fuzzy_version="$(apt-cache madison "${package_name}" | awk -F'|' '{print $2}' | sed -e 's/^[ \t]*//' | grep -E -m 1 "${version_regex}")"
  set -e

  if [ -z "${fuzzy_version}" ]; then
    echo "gcloud-cli: no match for '${requested_version}' in apt-cache." >&2
    echo "Available versions:"
    apt-cache madison "${package_name}" | awk -F'|' '{print $2}' | grep -oP '^(.+:)?\K.+'
    exit 1
  fi

  declare -g "${variable_name}="="${fuzzy_version}"
}

# --- Install ------------------------------------------------------------------
rm -rf /var/lib/apt/lists/*

check_packages apt-transport-https curl ca-certificates gnupg python3

# Import Google Cloud signing key (modern signed-by format)
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
  > /etc/apt/sources.list.d/google-cloud-sdk.list

apt_get_update

if [ "${GCLOUD_VERSION}" = "latest" ]; then
  GCLOUD_VERSION=""
else
  apt_cache_version_soft_match GCLOUD_VERSION "google-cloud-cli"
fi

if [ -n "${GCLOUD_VERSION}" ]; then
  apt-get install -yq "google-cloud-cli=${GCLOUD_VERSION}"
else
  apt-get install -yq "google-cloud-cli"
fi

if [ "${INSTALL_GKE_PLUGIN}" = "true" ]; then
  echo "gcloud-cli: installing GKE gcloud auth plugin..."
  check_packages google-cloud-sdk-gke-gcloud-auth-plugin
fi

rm -rf /var/lib/apt/lists/*

echo "gcloud-cli: installed (version '${GCLOUD_VERSION:-latest}', gke-plugin '${INSTALL_GKE_PLUGIN}')."
