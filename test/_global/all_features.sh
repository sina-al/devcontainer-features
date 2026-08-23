#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single
# feature. This script is executed against a running container constructed from
# the 'all_features' scenario in test/_global/scenarios.json, which installs all
# features together (with the 'node' feature fireconnect requires) to verify
# they coexist in one image.
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
check "uv on PATH" command -v uv
check "uv --version" uv --version
check "uvx on PATH" command -v uvx
check "uvx --version" uvx --version
check "gcloud on PATH" command -v gcloud
check "opencode on PATH" command -v opencode
check "rtk on PATH" command -v rtk
check "jq on PATH" command -v jq
check "jq --version" jq --version
check "yq on PATH" command -v yq
check "yq --version" yq --version
check "fzf on PATH" command -v fzf
check "fzf --version" fzf --version
check "bat on PATH" command -v bat
check "bat --version" bat --version
check "eza on PATH" command -v eza
check "eza --version" eza --version
check "zoxide on PATH" command -v zoxide
check "zoxide --version" zoxide --version
check "zellij on PATH" command -v zellij
check "zellij --version" zellij --version
check "kustomize on PATH" command -v kustomize
check "kustomize version" kustomize version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
