# FireConnect (dev container feature)

Installs the [FireConnect](https://github.com/fw-ai/fireconnect) CLI, which routes
coding agents — OpenCode, Claude Code, Codex, Pi, Cursor, VS Code, and the DeepSeek
Harness — through [Fireworks AI](https://fireworks.ai) models.

## Example usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/fireconnect:1": {
    "version": "latest",
    "login": false
  }
}
```

## Options

| Options Id | Type | Default | Description |
| --- | --- | --- | --- |
| version | string | `latest` | Version to install. `latest` clones the default branch; otherwise a git tag or commit SHA (for example `v0.10.4`). |
| login | boolean | `false` | If true, signs in non-interactively at build time using `FIRECONNECT_TOKEN` (or `FIREWORKS_API_KEY`). |

## Install details

The feature runs as root at image build time and installs FireConnect for the
target (remote) user:

- Clones the CLI to `~/.fireconnect/cli` and runs its `install.sh`.
- Drops the launcher at `~/.local/bin/fireconnect`.
- Appends `~/.local/bin` to the user's `PATH` in their shell config.

Requires Node.js 18+ (declare `installsAfter: ghcr.io/devcontainers/features/node`).

## Signing in

`login` is interactive and stores a credential in the OS keychain (or a fallback
secret store on Linux), so it is a **runtime** step for a personal sandbox:

```bash
fireconnect login    # browser sign-in, or paste a fw_… / fpk_… key
fireconnect opencode # route opencode through Fireworks
fireconnect status   # verify sign-in state
```

For automated (non-interactive) builds you can opt in with the `login` option and
a token:

```bash
# at build, with login=true
export FIRECONNECT_TOKEN="fw_..."
```

> Security: `login=true` bakes the token into the image layer and the feature's
> output. Prefer `login=false` (the default) for personal or shared sandboxes and
> sign in at runtime.
