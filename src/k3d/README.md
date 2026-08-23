# k3d

Installs [k3d](https://k3d.io/) — a lightweight wrapper to run k3s in Docker.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/k3d:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | k3d version. `latest` installs the newest release. Otherwise a specific version like `5.9.0`. |

## Notes

The binary is installed to `/usr/local/bin/k3d` (system-wide, always on PATH).
