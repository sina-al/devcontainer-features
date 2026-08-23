
# OpenTofu, Terragrunt & TFLint (opentofu)

Installs OpenTofu (tofu), Terragrunt, and TFLint — an IaC toolchain for Terraform-compatible workflows.

## Example Usage

```json
"features": {
    "ghcr.io/sina-al/devcontainer-features/opentofu:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| tofuVersion | OpenTofu (tofu) version. 'latest' installs the newest release. Otherwise a specific version like '1.12.6' (a leading 'v' is stripped). | string | latest |
| terragruntVersion | Terragrunt version. 'latest' installs the newest release. Otherwise a specific version like '1.1.3' (a leading 'v' is stripped). | string | latest |
| tflintVersion | TFLint version. 'latest' installs the newest release. Otherwise a specific version like '0.64.0' (a leading 'v' is stripped). | string | latest |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sina-al/devcontainer-features/blob/main/src/opentofu/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
