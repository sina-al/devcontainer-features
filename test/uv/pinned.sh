#!/bin/bash

# Scenario script for the 'pinned' scenario in scenarios.json. Asserts the
# installed uv matches the pinned version (0.12.5).

set -e

source dev-container-features-test-lib

export PATH="$HOME/.local/bin:$PATH"

check "uv on PATH" command -v uv
check "uv --version" uv --version
check "uvx on PATH" command -v uvx
check "uvx --version" uvx --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
