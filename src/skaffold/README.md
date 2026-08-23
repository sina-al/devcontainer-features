# skaffold

Installs [Skaffold](https://skaffold.dev/) — a tool for continuous development of Kubernetes applications.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/skaffold:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Skaffold version. `latest` installs the newest release. Otherwise a specific version like `2.24.0`. |

## Notes

The binary is installed to `/usr/local/bin/skaffold` (system-wide, always on PATH).
