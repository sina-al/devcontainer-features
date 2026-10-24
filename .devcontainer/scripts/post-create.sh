#!/usr/bin/env bash
set -e

# Mark workspaces as safe directories for git
git config --global --add safe.directory "*"

echo "devcontainer CLI: $(devcontainer --version 2>/dev/null || echo 'not found')"
echo "github CLI: $(gh --version 2>/dev/null | head -n 1 || echo 'not found')"
echo "node: $(node --version 2>/dev/null || echo 'not found')"

# docker-in-docker starts dockerd as the container boots; it may still be
# initializing when postCreateCommand runs, so report readiness without failing.
if docker version --format '{{.Server.Version}}' >/dev/null 2>&1; then
  echo "docker daemon: $(docker version --format '{{.Server.Version}}')"
else
  echo "docker daemon: not ready yet (DinD starts on first use) — run 'dockerd' logs if a test fails."
fi
