# k3s

Installs [k3s](https://k3s.io/) — a lightweight Kubernetes distribution.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/k3s:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | k3s version. `latest` installs the newest release. Otherwise a specific version like `v1.36.3+k3s1`. |

## Notes

The binary is installed to `/usr/local/bin/k3s` (system-wide, always on PATH).
