# container-structure-test

Installs [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) — a framework to validate the structure of container images.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/container-structure-test:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | container-structure-test version. `latest` installs the newest release. Otherwise a specific version like `1.22.1`. |

## Notes

The binary is installed to `/usr/local/bin/container-structure-test` (system-wide, always on PATH).
