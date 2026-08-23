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

## Why based on devcontainers-extra/features/uv

The most popular community uv feature (`ghcr.io/devcontainers-extra/features/uv`,
152 stars) models the shape: a single `version` option, `installsAfter`, and
scenario + pinned-version tests. Its `install.sh`, however, uses a "nanolayer"
meta-tool that downloads the release tarball as root into `/usr/local/bin`. This
feature instead uses Astral's official installer under `su -`, matching this
collection's convention of installing into the remote user's home.
