# dprint

Installs [dprint](https://dprint.dev/) — a pluggable and configurable code formatting platform.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/dprint:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | dprint version. `latest` installs the newest release. Otherwise a specific version like `0.56.1`. |

## Notes

The binary is installed to `/usr/local/bin/dprint` (system-wide, always on PATH).
