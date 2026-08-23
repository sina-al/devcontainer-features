# rtk

Installs [rtk](https://www.rtk-ai.app) (Rust Token Killer) — a CLI tool that compresses command outputs before they reach the AI context window. Reduces token usage by 60-90% with zero config changes.

## Usage

Minimal — just rtk, init manually later:

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/rtk:0.1": {
    "version": "latest"
  }
}
```

Pre-configure rtk for opencode at build time:

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/rtk:0.1": {
    "version": "latest",
    "agent": "opencode"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | rtk version. `latest` installs the newest release. Otherwise a specific version like `0.45.0`. |
| `agent` | string | `""` | AI agent to configure via `rtk init --global --agent <agent>`. Empty skips init. Supported: `opencode`, `claude-code`, `cursor`, `aider`, `gemini-cli`, `codex`, `windsurf`, `cline`, `copilot`. |

## Notes

The binary is installed to `/usr/local/bin/rtk` (system-wide, always on PATH).

When `agent` is set, `rtk init --global --agent <agent>` runs as the remote user at build time so the auto-rewrite hook is active from the first shell session. If init fails (e.g. the agent's config directory doesn't exist yet), you can run it manually after startup.
