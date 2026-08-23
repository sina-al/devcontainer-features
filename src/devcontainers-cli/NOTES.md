# Notes

## Install method

The CLI offers two install paths: an official self-contained install script
(`install.sh`, bundles its own Node runtime) or `npm install -g @devcontainers/cli`
(needs Node plus Python and a C/C++ toolchain to build a dependency).

This feature uses the **install script** because it is dependency-free and works
regardless of feature ordering. The npm path is avoided because it is heavier and
can fail without build tools.

## Why a local feature

Installing for the remote user via `su -` keeps the CLI under the user's home
(`~/.devcontainers`) and on the user's `PATH`, matching where the other tools in
this image live. A feature also makes the CLI available early in the build, so it
can be used to test sibling features (for example
`devcontainer features test .devcontainer/features/fireconnect`) inside the
sandbox.
