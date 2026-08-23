# Devcontainer Features

Self-authored [dev container features](https://containers.dev/features) published
to GHCR as `ghcr.io/sina-al/devcontainer-features/<feature>:<version>`. Derived
from the official [`feature-starter`](https://github.com/devcontainers/feature-starter)
template. See `AGENTS.md` for conventions.

## Features

| Feature | Description |
| --- | --- |
| [`fireconnect`](src/fireconnect/README.md) | Routes coding agents through Fireworks AI models via the [FireConnect](https://github.com/fw-ai/fireconnect) CLI. |
| [`devcontainers-cli`](src/devcontainers-cli/README.md) | Installs the official `devcontainer` CLI. |
| [`uv`](src/uv/README.md) | Installs [uv](https://docs.astral.sh/uv/) and `uvx`, with optional pre-installed Python and uv-managed enforcement. |

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/fireconnect:1": { "version": "latest", "login": false },
  "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/uv:1": { "version": "latest", "pythonVersions": "3.12,3.13", "defaultPython": "3.12" }
}
```

The `:1` suffix pins the feature to a major version. See each feature's README for its options.

## Work on this repo

The devcontainer provides Docker-in-Docker and the `devcontainer` CLI for testing.

```sh
devpod up .
devpod ssh .
# inside:
devcontainer features test --features uv .
```

## Publishing

Actions → "Release dev container features & Generate Documentation" → Run workflow
from `main`. Uses [`devcontainers/action`](https://github.com/devcontainers/action)
to publish to GHCR. Flip each package to **public** after the first release.

## License

Apache-2.0. Derived from `devcontainers/feature-starter` (MIT).
