# kubebuilder

Installs [kubebuilder](https://book.kubebuilder.io/) — a framework for building Kubernetes APIs using CRDs.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/kubebuilder:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | kubebuilder version. `latest` installs the newest release. Otherwise a specific version like `4.15.0`. |

## Notes

The binary is installed to `/usr/local/bin/kubebuilder` (system-wide, always on PATH).
