#!/usr/bin/env bash
#
# Dev Container feature: OpenTofu, Terragrunt & TFLint
#
# Installs OpenTofu (tofu), Terragrunt, and TFLint from their official GitHub
# releases. All binaries are static executables installed to /usr/local/bin
# so they are on PATH for all users and all shell types.
set -e

# --- Feature inputs -----------------------------------------------------------
TOFU_VERSION="${TOFUVERSION:-latest}"
TOFU_VERSION="${TOFU_VERSION#v}"

TERRAGRUNT_VERSION="${TERRAGRUNTVERSION:-latest}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION#v}"

TFLINT_VERSION="${TFLINTVERSION:-latest}"
TFLINT_VERSION="${TFLINT_VERSION#v}"

if [ "$(id -u)" -ne 0 ]; then
  echo "opentofu: must run as root." >&2
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

# --- Detect platform ----------------------------------------------------------
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64)   ARCH_SUFFIX="amd64" ;;
  aarch64|arm64)  ARCH_SUFFIX="arm64" ;;
  *) echo "opentofu: unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

# --- Resolve latest versions --------------------------------------------------
if [ "${TOFU_VERSION}" = "latest" ]; then
  echo "opentofu: resolving latest tofu version..."
  TOFU_VERSION=$(curl -fsSL "https://api.github.com/repos/opentofu/opentofu/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "${TOFU_VERSION}" ]; then
    echo "opentofu: failed to resolve latest tofu version." >&2
    exit 1
  fi
fi

if [ "${TERRAGRUNT_VERSION}" = "latest" ]; then
  echo "opentofu: resolving latest terragrunt version..."
  TERRAGRUNT_VERSION=$(curl -fsSL "https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "${TERRAGRUNT_VERSION}" ]; then
    echo "opentofu: failed to resolve latest terragrunt version." >&2
    exit 1
  fi
fi

if [ "${TFLINT_VERSION}" = "latest" ]; then
  echo "opentofu: resolving latest tflint version..."
  TFLINT_VERSION=$(curl -fsSL "https://api.github.com/repos/terraform-linters/tflint/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "${TFLINT_VERSION}" ]; then
    echo "opentofu: failed to resolve latest tflint version." >&2
    exit 1
  fi
fi

# --- Install OpenTofu (tofu) --------------------------------------------------
echo "opentofu: installing tofu ${TOFU_VERSION}..."

TOFU_VERSION_NO_V="${TOFU_VERSION#v}"
TOFU_ASSET="tofu_${TOFU_VERSION_NO_V}_linux_${ARCH_SUFFIX}.tar.gz"
TOFU_URL="https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION_NO_V}/${TOFU_ASSET}"

curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/tofu.tar.gz" "${TOFU_URL}"
tar -xzf "${TMP_DIR}/tofu.tar.gz" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/tofu" /usr/local/bin/tofu

echo "opentofu: installed tofu ${TOFU_VERSION} to /usr/local/bin/tofu."

# --- Install Terragrunt -------------------------------------------------------
echo "opentofu: installing terragrunt ${TERRAGRUNT_VERSION}..."

TERRAGRUNT_ASSET="terragrunt_linux_${ARCH_SUFFIX}"
TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/${TERRAGRUNT_ASSET}"

curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/terragrunt" "${TERRAGRUNT_URL}"
install -m 0755 "${TMP_DIR}/terragrunt" /usr/local/bin/terragrunt

echo "opentofu: installed terragrunt ${TERRAGRUNT_VERSION} to /usr/local/bin/terragrunt."

# --- Install TFLint -----------------------------------------------------------
echo "opentofu: installing tflint ${TFLINT_VERSION}..."

TFLINT_ASSET="tflint_linux_${ARCH_SUFFIX}.zip"
TFLINT_URL="https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/${TFLINT_ASSET}"

curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/tflint.zip" "${TFLINT_URL}"
unzip -o "${TMP_DIR}/tflint.zip" -d "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/tflint" /usr/local/bin/tflint

echo "opentofu: installed tflint ${TFLINT_VERSION} to /usr/local/bin/tflint."

rm -rf /var/lib/apt/lists/*

echo "opentofu: done (tofu ${TOFU_VERSION}, terragrunt ${TERRAGRUNT_VERSION}, tflint ${TFLINT_VERSION})."
