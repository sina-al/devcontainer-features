# opencode

Installs [opencode](https://opencode.ai) — an AI coding agent built for the terminal. Open-source alternative to Claude Code with support for multiple LLM providers.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/opencode:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | opencode version. `latest` installs the newest release. Otherwise a specific version like `1.18.21`. |

## Notes

The binary is installed to `/usr/local/bin/opencode` (system-wide, always on PATH). Pair with the `fireconnect` feature to route opencode through Fireworks AI models.
