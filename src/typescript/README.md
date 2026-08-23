# TypeScript

Installs the [TypeScript](https://www.typescriptlang.org/) compiler globally via npm.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/typescript:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | TypeScript version. `latest` installs the newest release. Otherwise a specific version like `7.0.2`. |

## Notes

Requires Node.js (install the `ghcr.io/devcontainers/features/node` feature first).
