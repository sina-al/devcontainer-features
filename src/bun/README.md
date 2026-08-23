# Bun

Installs [Bun](https://bun.sh/) — a fast JavaScript runtime, bundler, and package manager.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/bun:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Bun version. `latest` installs the newest release. Otherwise a specific version like `1.4.0`. |

## Notes

The binary is installed to `/usr/local/bin/bun` (system-wide, always on PATH).
