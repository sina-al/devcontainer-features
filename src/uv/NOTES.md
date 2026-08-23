# Notes

## Why the official standalone installer

uv offers several install paths: the standalone installer script, `pip install
uv`, and `pipx install uv`. This feature uses the **standalone installer**
because it ships a self-contained binary with no dependency on Python, pip, or
build tools — it works regardless of feature ordering and on minimal base images.

## Why install for the remote user (not root)

The standalone installer resolves its install directory to `$HOME/.local/bin`
by default and appends that to the user's shell rc files. A feature runs as root
at build time, so piping the installer to `sh` as root would put `uv`/`uvx` in
`/root/.local/bin` — off the sandbox user's PATH. This feature runs the installer
under `su - <user>`, so the binaries and PATH update land where the user works.

## Version pinning

The standalone installer has no `--version` flag; the version is baked into the
installer script served at `https://astral.sh/uv/install.sh` (always latest). To
pin a version, this feature fetches the **release-specific installer** published
as a release asset at
`https://github.com/astral-sh/uv/releases/download/<version>/uv-installer.sh`.
A leading `v` is stripped from the version input so GitHub-style tags (`v0.12.5`)
work too.

## Pre-installing Python at build time

`uv python install <version>` downloads a standalone Python build from the
python-build-standalone project and extracts it under
`~/.local/share/uv/python/`. Running this at image build time (via this feature's
`pythonVersions` option) bakes the interpreters into the image layer, so the
pre-built image has them ready with no runtime download. `uv python pin <version>
--global` writes `~/.config/uv/.python-version` so uv selects that version by
default for projects without their own pin.

## Python enforcement via UV_PYTHON_PREFERENCE

The key enforcement mechanism is the `UV_PYTHON_PREFERENCE` environment variable.
`only-managed` (the default) tells uv to only use uv-managed Python interpreters
and ignore any system Python — whether from the base image, the
`ghcr.io/devcontainers/features/python` feature, or a system package manager.
This means:

- `uv run python` uses a uv-managed interpreter, not `/usr/bin/python3`.
- `uv pip install` installs into a uv-managed environment, not a system one.
- If no uv-managed Python is installed, uv errors instead of falling back to
  system Python (unless `pythonPreference` is `managed`).

The variable is written to `/etc/profile.d/uv-python.sh` (sourced by login
shells) and `~/.bashrc` (sourced by interactive non-login shells), so it covers
both the VS Code terminal and `devcontainer`-launched processes.

## Why based on devcontainers-extra/features/uv

The most popular community uv feature (`ghcr.io/devcontainers-extra/features/uv`,
152 stars) models the shape: a single `version` option, `installsAfter`, and
scenario + pinned-version tests. Its `install.sh`, however, uses a "nanolayer"
meta-tool that downloads the release tarball as root into `/usr/local/bin`. This
feature instead uses Astral's official installer under `su -`, matching this
collection's convention of installing into the remote user's home, and adds
build-time Python pre-installation and enforcement that the community feature
does not offer.
