# uv (dev container feature)

Installs [uv](https://docs.astral.sh/uv/) and `uvx` — Astral's extremely fast
Python package and project manager, written in Rust — via the official standalone
installer. `uv` manages Python projects, versions, and packages; `uvx` runs
isolated one-off commands. Both ship in the same release tarball, so this feature
installs both in one pass.

## Example usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/uv:1": {
    "version": "latest"
  }
}
```

## Options

| Options Id | Type | Default | Description |
| --- | --- | --- | --- |
| version | string | `latest` | uv version to install. `latest` installs the newest release; otherwise a published version such as `0.12.5` (a leading `v` is stripped). |

## Install details

The feature runs as root at image build time and installs uv for the target
(remote) user:

- Downloads and runs Astral's [official standalone installer](https://docs.astral.sh/uv/getting-started/installation/),
  which ships a self-contained binary (no Python or build tools required).
- For `latest`, fetches `https://astral.sh/uv/install.sh`; for a pinned version,
  fetches the release-specific installer at
  `https://github.com/astral-sh/uv/releases/download/<version>/uv-installer.sh`.
- Lands `uv` and `uvx` at `~/.local/bin` and appends that to the user's `PATH`
  in their shell config (the installer handles this itself).

## Usage

```bash
uv --version          # installed version
uv python install 3.12 # install a Python interpreter
uvx ruff check .       # run a tool in an isolated environment
```
