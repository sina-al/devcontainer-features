# kustomize

Installs [kustomize](https://kubectl.docs.kubernetes.io/) — a Kubernetes configuration management tool that customizes raw, template-free YAML files for multiple purposes.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/kustomize:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | kustomize version. `latest` installs the newest release. Otherwise a specific version like `5.8.1`. |

## Notes

The binary is installed to `/usr/local/bin/kustomize` (system-wide, always on PATH).
