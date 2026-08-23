
# Dev Container CLI (devcontainers-cli)

Installs the official Dev Container CLI (devcontainer), used to build, run, and test dev containers and author/tests dev container features and templates.

## Example Usage

```json
"features": {
    "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Dev Container CLI version to install. 'latest' installs the newest release. Otherwise a published version such as '0.88.0' (a leading 'v' is stripped). | string | latest |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sina-al/devcontainer-features/blob/main/src/devcontainers-cli/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
