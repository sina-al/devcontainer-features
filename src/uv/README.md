# uv (dev container feature)

Installs [uv](https://docs.astral.sh/uv/) and `uvx` — Astral's extremely fast
Python package and project manager, written in Rust — via the official standalone
installer. `uv` manages Python projects, versions, and packages; `uvx` runs
isolated one-off commands. Both ship in the same release tarball, so this feature
installs both in one pass.

Optionally pre-installs uv-managed Python versions at build time and enforces uv
as the sole Python source, so a pre-built image gives a fast, uv-only-managed
Python setup with no runtime downloads.

## Example usage

Minimal — just uv, install Python yourself at runtime:

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/uv:1": {
    "version": "latest"
  }
}
```

Pre-install Python 3.12 and 3.13, pin 3.12 as default, enforce uv-managed only:

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/uv:1": {
    "version": "latest",
    "pythonVersions": "3.12,3.13",
    "defaultPython": "3.12",
    "pythonPreference": "only-managed"
  }
}
```

## Options

| Options Id | Type | Default | Description |
| --- | --- | --- | --- |
| version | string | `latest` | uv version to install. `latest` installs the newest release; otherwise a published version such as `0.12.5` (a leading `v` is stripped). |
| pythonVersions | string | `""` | Comma-separated Python versions to pre-install at build time (e.g. `3.12,3.13`). Empty installs none; install later with `uv python install`. |
| defaultPython | string | `""` | Python version to pin as the global default (e.g. `3.12`). If set, it is installed (with `--default`) and pinned via `uv python pin --global`. |
| pythonPreference | string | `only-managed` | Sets `UV_PYTHON_PREFERENCE` so uv enforces uv-managed Python. `only-managed` (the default) makes uv ignore system Python entirely; `managed` prefers uv-managed but falls back to system. |

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

When `pythonVersions` is set, runs `uv python install` for each version so the
interpreters are baked into the image layer — no runtime download needed. When
`defaultPython` is set, installs it with `--default` and pins it globally via
`uv python pin --global` (writes `~/.config/uv/.python-version`).

### Python enforcement

The feature writes `UV_PYTHON_PREFERENCE` to `/etc/profile.d/uv-python.sh` and
the user's `~/.bashrc`. With the default `only-managed`, uv ignores any system
Python (e.g. one installed by the `ghcr.io/devcontainers/features/python`
feature or the base image) and only uses uv-managed interpreters. This is
enforced whenever the feature is used, regardless of whether `pythonVersions` is
set — so even a bare `uv run python` will use a uv-managed Python, never a
system one.

To allow uv to fall back to system Python, set `pythonPreference` to `managed`.

## Usage

```bash
uv --version              # installed uv version
uv python list            # show installed uv-managed Python versions
uv python install 3.14    # install another Python at runtime
uv run python -V          # run the default (pinned) Python
uvx ruff check .          # run a tool in an isolated environment
```
