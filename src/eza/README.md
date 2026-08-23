# eza

Installs [eza](https://github.com/eza-community/eza) — a modern, maintained replacement for ls with colors, icons, git status, and more.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/eza:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | eza version. `latest` installs the newest release. Otherwise a specific version like `0.23.5`. |

## Notes

The binary is installed to `/usr/local/bin/eza` (system-wide, always on PATH).
