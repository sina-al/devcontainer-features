# Deno

Installs [Deno](https://deno.com/) — a modern JavaScript, TypeScript, and WebAssembly runtime.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/deno:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Deno version. `latest` installs the newest release. Otherwise a specific version like `2.9.5`. |

## Notes

The binary is installed to `/usr/local/bin/deno` (system-wide, always on PATH).
