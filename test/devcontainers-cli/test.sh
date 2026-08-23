#!/bin/bash

# This test file is executed against an auto-generated devcontainer.json that
# includes the 'devcontainers-cli' Feature with no options (so 'version' falls
# back to its default, 'latest'). It is also used as the fallback script for the
# 'latest' scenario in scenarios.json.
#
# The self-contained installer bundles its own Node runtime and lands the CLI at
# ~/.devcontainers/bin, which is appended to the user's .bashrc by install.sh.
# Non-interactive shells do not source .bashrc, so the CLI prefix is prepended to
# PATH explicitly below.
#
# These scripts run as 'root' by default (auto-generated case) or as the
# scenario's 'remoteUser' ('vscode'). Both install under $HOME, so $HOME is used.
#
# Run locally (from the repo root):
#    devcontainer features test --features devcontainers-cli .
#
# See https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI.
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

export PATH="$HOME/.devcontainers/bin:$PATH"

check "devcontainer on PATH" command -v devcontainer
check "devcontainer --version" devcontainer --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
