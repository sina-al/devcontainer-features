# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Bootstrap: install the official devcontainer CLI via the self-contained
# installer (bundles its own Node runtime, so no build tools or `node` feature
# are required) so `devcontainer features test` works inside this devcontainer.
#
# Once the self-published `ghcr.io/sina-al/devcontainer-features/devcontainers-cli:1`
# feature exists, replace this block with that feature in devcontainer.json and
# delete the lines below.
RUN curl -fsSL https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh \
      -o /tmp/devcontainers-cli-install.sh \
 && bash /tmp/devcontainers-cli-install.sh --prefix /usr/local/devcontainers \
 && rm -f /tmp/devcontainers-cli-install.sh \
 && ln -s /usr/local/devcontainers/bin/devcontainer /usr/local/bin/devcontainer
