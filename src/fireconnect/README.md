
# FireConnect CLI (fireconnect)

Installs the FireConnect CLI, which routes coding agents (OpenCode, Claude Code, Codex, and others) through Fireworks AI models.

## Example Usage

```json
"features": {
    "ghcr.io/sina-al/devcontainer-features/fireconnect:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | FireConnect version to install. 'latest' clones the default branch. Otherwise a git tag or commit SHA (for example 'v0.10.4'). | string | latest |
| login | If true, signs in non-interactively at build time using the FIRECONNECT_TOKEN (or FIREWORKS_API_KEY) environment variable. Keep false for personal sandboxes and sign in at runtime with 'fireconnect login' instead. | boolean | false |

# Notes

## Why install for the remote user (not root)

The FireConnect installer writes everything under `$HOME` (`~/.fireconnect/cli`,
`~/.local/bin`, and a `PATH` entry in the shell config). A feature runs as root at
build time, so running the installer as-is would put the CLI in `/root` and it
would never be on the sandbox user's `PATH`. This feature detects the target user
(via `_REMOTE_USER` / `_CONTAINER_USER`, falling back to `vscode`) and runs the
installer under `su - <user>`, so the launcher and `PATH` land where the user
actually works.

## Why login is off by default

`fireconnect login` is interactive and stores a credential in the OS keychain.
Running it at build time would require a token and would bake it into the image
layer. For a personal sandbox the right place is the runtime `post-create.sh`
seam. The `login` option exists only for reproducible, non-interactive builds
(CI), and is documented as such.

## Version pinning

The vendor installer always clones the default branch. To support reproducible
builds the feature instead clones the repo at an explicit tag/commit when
`version` is not `latest`, then runs that checkout's `install.sh`. The default
`latest` matches the vendor's behavior.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sina-al/devcontainer-features/blob/main/src/fireconnect/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
