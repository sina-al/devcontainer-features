
# Google Cloud CLI (gcloud-cli)

Installs the Google Cloud CLI (gcloud) via the official Google Cloud SDK apt repository. Optionally installs the GKE gcloud auth plugin.

## Example Usage

```json
"features": {
    "ghcr.io/sina-al/devcontainer-features/gcloud-cli:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | gcloud CLI version to install. 'latest' installs the newest version in the apt repo. Otherwise a specific version such as '531.0.0'. | string | latest |
| installGkeGcloudAuthPlugin | If true, also installs google-cloud-sdk-gke-gcloud-auth-plugin for kubectl auth. | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sina-al/devcontainer-features/blob/main/src/gcloud-cli/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
