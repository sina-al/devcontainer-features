#!/bin/bash

# This test file is executed against the auto-generated devcontainer.json that
# includes the 'uv' Feature with no options (so 'version' falls back to its
# default, 'latest'). It is also the fallback for scenarios without their own
# per-scenario script.
#
# uv installs binaries to ~/.local/bin. The feature adds ~/.local/bin to PATH
# via /etc/profile.d so that login/SSH shells (e.g. DevPod) can find it. Tests
# must NOT manually prepend ~/.local/bin to PATH — that masks real bugs.
# Instead, checks run inside a login shell (bash -l -c) to simulate the real
# DevPod experience.
#
# Run locally (from the repo root):
#    devcontainer features test --features uv .
#
# See https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI.
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Test that uv is on PATH in a login shell (simulates DevPod SSH)
check "uv on PATH (login shell)" bash -l -c 'command -v uv'
check "uv --version" bash -l -c 'uv --version'
check "uvx on PATH (login shell)" bash -l -c 'command -v uvx'
check "uvx --version" bash -l -c 'uvx --version'
check "UV_PYTHON_PREFERENCE set" bash -l -c 'echo $UV_PYTHON_PREFERENCE | grep -q only-managed'

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
