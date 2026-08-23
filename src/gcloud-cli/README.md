# gcloud-cli

Installs the Google Cloud CLI (`gcloud`) via the official Google Cloud SDK apt repository.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/gcloud-cli:0.1": {
    "version": "latest",
    "installGkeGcloudAuthPlugin": true
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | gcloud CLI version. `latest` installs the newest in the apt repo. Otherwise a specific version like `531.0.0`. |
| `installGkeGcloudAuthPlugin` | boolean | `false` | If true, also installs `google-cloud-sdk-gke-gcloud-auth-plugin` for `kubectl` auth. |

## Notes

Authentication is a runtime step — run `gcloud auth login` after the container starts. Do not bake credentials into the image.
