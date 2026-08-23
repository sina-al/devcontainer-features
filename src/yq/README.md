# yq

Installs [yq](https://github.com/mikefarah/yq) — a portable command-line YAML, JSON, XML, CSV, and properties processor.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/yq:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | yq version. `latest` installs the newest release. Otherwise a specific version like `4.53.6`. |

## Notes

The binary is installed to `/usr/local/bin/yq` (system-wide, always on PATH).
