# zellij

Installs [zellij](https://zellij.dev) — a terminal workspace with panes, tabs, layouts, and a built-in layout system.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/zellij:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | zellij version. `latest` installs the newest release. Otherwise a specific version like `0.45.0`. |

## Notes

The binary is installed to `/usr/local/bin/zellij` (system-wide, always on PATH).
