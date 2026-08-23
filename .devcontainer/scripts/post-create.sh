#!/usr/bin/env bash
set -e

echo "devcontainer CLI: $(devcontainer --version)"

# docker-in-docker starts dockerd as the container boots; it may still be
# initializing when postCreateCommand runs, so report readiness without failing.
if docker version --format '{{.Server.Version}}' >/dev/null 2>&1; then
  echo "docker daemon: $(docker version --format '{{.Server.Version}}')"
else
  echo "docker daemon: not ready yet (DinD starts on first use) — run 'dockerd' logs if a test fails."
fi
