# Devcontainer Features

Self-authored [dev container features](https://containers.dev/features) published
to GHCR as `ghcr.io/sina-al/devcontainer-features/<feature>:<version>`. Derived
from the official [`feature-starter`](https://github.com/devcontainers/feature-starter)
template. See `AGENTS.md` for conventions.

## Features

| Feature | Description |
| --- | --- |
| [`fireConnect`](src/fireconnect/README.md) | Routes coding agents through Fireworks AI models via the [FireConnect](https://github.com/fw-ai/fireconnect) CLI. |
| [`devcontainers-cli`](src/devcontainers-cli/README.md) | Installs the official `devcontainer` CLI. |
| [`uv`](src/uv/README.md) | Installs [uv](https://docs.astral.sh/uv/) and `uvx`, with optional pre-installed Python and uv-managed enforcement. |
| [`gcloud-cli`](src/gcloud-cli/README.md) | Installs the Google Cloud CLI (`gcloud`) via the official apt repository. |
| [`opencode`](src/opencode/README.md) | Installs [opencode](https://opencode.ai), an AI coding agent for the terminal. |
| [`rtk`](src/rtk/README.md) | Installs [rtk](https://www.rtk-ai.app), compresses CLI output to save AI context tokens. |
| [`jq`](src/jq/README.md) | Installs [jq](https://jqlang.github.io/jq/), a command-line JSON processor. |
| [`yq`](src/yq/README.md) | Installs [yq](https://github.com/mikefarah/yq), a command-line YAML/JSON/XML/CSV processor. |
| [`fzf`](src/fzf/README.md) | Installs [fzf](https://github.com/junegunn/fzf), a command-line fuzzy finder. |
| [`bat`](src/bat/README.md) | Installs [bat](https://github.com/sharkdp/bat), a cat clone with syntax highlighting. |
| [`eza`](src/eza/README.md) | Installs [eza](https://github.com/eza-community/eza), a modern replacement for ls. |
| [`zoxide`](src/zoxide/README.md) | Installs [zoxide](https://github.com/ajeetdsouza/zoxide), a smarter cd command. |
| [`zellij`](src/zellij/README.md) | Installs [zellij](https://zellij.dev), a terminal workspace with panes and tabs. |
| [`kustomize`](src/kustomize/README.md) | Installs [kustomize](https://kubectl.docs.kubernetes.io/), a Kubernetes config management tool. |
| [`dprint`](src/dprint/README.md) | Installs [dprint](https://dprint.dev/), a pluggable code formatting platform. |
| [`k3s`](src/k3s/README.md) | Installs [k3s](https://k3s.io/), a lightweight Kubernetes distribution. |
| [`k3d`](src/k3d/README.md) | Installs [k3d](https://k3d.io/), a lightweight wrapper to run k3s in Docker. |
| [`zizmor`](src/zizmor/README.md) | Installs [zizmor](https://docs.zizmor.sh/), a static analysis tool for GitHub Actions. |
| [`k9s`](src/k9s/README.md) | Installs [k9s](https://k9scli.io/), a terminal-based UI for Kubernetes clusters. |
| [`skaffold`](src/skaffold/README.md) | Installs [Skaffold](https://skaffold.dev/), a tool for continuous development of Kubernetes applications. |
| [`bun`](src/bun/README.md) | Installs [Bun](https://bun.sh/), a fast JavaScript runtime, bundler, and package manager. |
| [`deno`](src/deno/README.md) | Installs [Deno](https://deno.com/), a modern JavaScript, TypeScript, and WebAssembly runtime. |
| [`typescript`](src/typescript/README.md) | Installs the [TypeScript](https://www.typescriptlang.org/) compiler globally via npm. |
| [`kubebuilder`](src/kubebuilder/README.md) | Installs [kubebuilder](https://book.kubebuilder.io/), a framework for building Kubernetes APIs using CRDs. |
| [`opentofu`](src/opentofu/README.md) | Installs [OpenTofu](https://opentofu.org/) (tofu), [Terragrunt](https://terragrunt.gruntwork.io/), and [TFLint](https://github.com/terraform-linters/tflint) — an IaC toolchain. |

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/fireconnect:0.1": { "version": "latest", "login": false },
  "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/uv:0.2": { "version": "latest", "pythonVersions": "3.12,3.13", "defaultPython": "3.12" },
  "ghcr.io/sina-al/devcontainer-features/gcloud-cli:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/opencode:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/rtk:0.1": { "version": "latest", "agent": "opencode" },
  "ghcr.io/sina-al/devcontainer-features/jq:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/yq:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/fzf:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/bat:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/eza:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/zoxide:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/zellij:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/kustomize:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/dprint:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/k3s:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/k3d:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/zizmor:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/k9s:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/skaffold:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/bun:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/deno:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/typescript:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/kubebuilder:0.1": { "version": "latest" },
  "ghcr.io/sina-al/devcontainer-features/opentofu:0.1": { "tofuVersion": "latest", "terragruntVersion": "latest", "tflintVersion": "latest" }
}
```

The `:1` suffix pins the feature to a major version. See each feature's README for its options.

## Work on this repo

The devcontainer provides Docker-in-Docker and the `devcontainer` CLI for testing.

```sh
devpod up .
devpod ssh .
# inside:
devcontainer features test --features uv .
```

## Publishing

Actions → "Release dev container features & Generate Documentation" → Run workflow
from `main`. Uses [`devcontainers/action`](https://github.com/devcontainers/action)
to publish to GHCR. Flip each package to **public** after the first release.

## License

Apache-2.0. Derived from `devcontainers/feature-starter` (MIT).
