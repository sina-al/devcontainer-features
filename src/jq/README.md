# jq

Installs [jq](https://jqlang.github.io/jq/) — a lightweight and flexible command-line JSON processor.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/jq:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | jq version. `latest` installs the newest release. Otherwise a specific version like `1.8.2`. |

## Notes

The binary is installed to `/usr/local/bin/jq` (system-wide, always on PATH).
