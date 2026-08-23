# Dev Container CLI (dev container feature)

Installs the official [Dev Container CLI](https://github.com/devcontainers/cli)
(`devcontainer`), the reference implementation that builds and configures dev
containers and helps author and test dev container features and templates.

## Example usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:1": {
    "version": "latest"
  }
}
```

## Options

| Options Id | Type | Default | Description |
| --- | --- | --- | --- |
| version | string | `latest` | CLI version to install. `latest` installs the newest release; otherwise a published version such as `0.88.0` (a leading `v` is stripped). |

## Useful commands

```sh
devcontainer features test --features fireconnect .              # run a feature's tests
devcontainer features package src/fireconnect                    # package a feature to OCI format
devcontainer build --workspace-folder .                          # build the devcontainer image
devcontainer up --workspace-folder .                             # create and run the container
```

See the [feature testing docs](https://github.com/devcontainers/cli/blob/main/docs/features/test.md)
and `devcontainer --help`.

## Install details

The feature installs for the target (remote) user using the official
self-contained installer, which bundles a Node.js runtime — so it needs no
pre-installed Node and no build tools. It lands at `~/.devcontainers/bin` and is
added to the user's `PATH`.
