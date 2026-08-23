# k9s

Installs [k9s](https://k9scli.io/) — a terminal-based UI for Kubernetes clusters.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/k9s:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | k9s version. `latest` installs the newest release. Otherwise a specific version like `0.51.0`. |

## Notes

The binary is installed to `/usr/local/bin/k9s` (system-wide, always on PATH).
