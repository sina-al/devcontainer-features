# OpenTofu, Terragrunt & TFLint

Installs [OpenTofu](https://opentofu.org/) (tofu), [Terragrunt](https://terragrunt.gruntwork.io/),
and [TFLint](https://github.com/terraform-linters/tflint) — an IaC toolchain for
Terraform-compatible workflows.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/opentofu:0.1": {
    "tofuVersion": "latest",
    "terragruntVersion": "latest",
    "tflintVersion": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `tofuVersion` | string | `latest` | OpenTofu (tofu) version. `latest` installs the newest release. Otherwise a specific version like `1.12.6`. |
| `terragruntVersion` | string | `latest` | Terragrunt version. `latest` installs the newest release. Otherwise a specific version like `1.1.3`. |
| `tflintVersion` | string | `latest` | TFLint version. `latest` installs the newest release. Otherwise a specific version like `0.64.0`. |

## Notes

All three binaries are installed to `/usr/local/bin/` (system-wide, always on PATH).
The three tools are bundled into one feature because they form a cohesive IaC toolchain
that is typically used together.
