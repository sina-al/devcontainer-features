#!/bin/bash

# This test file is executed against the auto-generated devcontainer.json that
# includes the 'uv' Feature with no options (so 'version' falls back to its
# default, 'latest'). It is also the fallback for scenarios without their own
# per-scenario script.
#
# uv installs the binaries at ~/.local/bin and appends that to the user's
# .bashrc. Non-interactive shells do not source .bashrc, so ~/.local/bin is
# prepended to PATH explicitly below. Both 'uv' and 'uvx' ship in the same
# tarball, so both are asserted.
#
# Run locally (from the repo root):
#    devcontainer features test --features uv .
#
# See https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI.
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

export PATH="$HOME/.local/bin:$PATH"

check "uv on PATH" command -v uv
check "uv --version" uv --version
check "uvx on PATH" command -v uvx
check "uvx --version" uvx --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
