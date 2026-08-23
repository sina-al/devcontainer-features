# zizmor

Installs [zizmor](https://docs.zizmor.sh/) — a static analysis tool for GitHub Actions.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/zizmor:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | zizmor version. `latest` installs the newest release. Otherwise a specific version like `1.29.0`. |

## Notes

The binary is installed to `/usr/local/bin/zizmor` (system-wide, always on PATH).
