#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single
# feature. This script is executed against a running container constructed from
# the 'cli_and_fireconnect' scenario in test/_global/scenarios.json, which
# installs both features together (with the 'node' feature fireconnect requires)
# to verify they coexist in one image.
#
# Run locally (from the repo root):
#    devcontainer features test --global-scenarios-only .

set -e

# Optional: Import test library bundled with the devcontainer CLI.
source dev-container-features-test-lib

export PATH="$HOME/.devcontainers/bin:$HOME/.local/bin:$PATH"

check "devcontainer on PATH" command -v devcontainer
check "devcontainer --version" devcontainer --version
check "fireconnect on PATH" command -v fireconnect
check "fireconnect help" fireconnect help

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
