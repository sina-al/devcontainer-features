#!/bin/bash

# Scenario script for the 'python' scenario in scenarios.json. Verifies that:
#   - uv and uvx are installed
#   - Python 3.12 and 3.13 were pre-installed by uv
#   - 3.12 is pinned as the global default
#   - UV_PYTHON_PREFERENCE=only-managed is written to /etc/profile.d and .bashrc

set -e

source dev-container-features-test-lib

export PATH="$HOME/.local/bin:$PATH"

check "uv on PATH" command -v uv
check "uv --version" uv --version
check "uvx on PATH" command -v uvx
check "uvx --version" uvx --version

# Pre-installed Python versions are present and uv-managed
check "python 3.12 installed" uv python find 3.12
check "python 3.13 installed" uv python find 3.13

# Default is pinned to 3.12
check "default python is 3.12" bash -c "uv python pin | grep -q '3.12'"

# Enforcement env var is written to /etc/profile.d
check "profile.d has UV_PYTHON_PREFERENCE" bash -c "grep -q 'UV_PYTHON_PREFERENCE=only-managed' /etc/profile.d/uv-python.sh"

# Enforcement env var is in .bashrc
check "bashrc has UV_PYTHON_PREFERENCE" bash -c "grep -q 'UV_PYTHON_PREFERENCE=only-managed' $HOME/.bashrc"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
