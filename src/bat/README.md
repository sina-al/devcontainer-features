# bat

Installs [bat](https://github.com/sharkdp/bat) — a cat clone with syntax highlighting and Git integration.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/bat:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | bat version. `latest` installs the newest release. Otherwise a specific version like `0.26.1`. |

## Notes

The binary is installed to `/usr/local/bin/bat` (system-wide, always on PATH).
