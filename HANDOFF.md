# Handoff — `devcontainer-features`

A plan (informed by the `sina-al/sandbox` session) to stand up a **public, canonical
collection of self-authored dev container features** so I have full trust and confidence
in the features I use across my different devcontainers — and a devcontainer for working on
that collection itself, via DevPod.

---

## 1. Why

I rely on dev container features for my canonical dev setup (`sina-al/sandbox`). Today I
mix off-the-shelf third-party features (`dhoeric/google-cloud-cli`, `jsburckhardt/opencode`,
…) with two features I already authored locally in the sandbox (`fireconnect`,
`devcontainers-cli`). Owning the features I depend on removes the trust gap: I control the
install code, the versions, the tests, and the published artifacts. This repo is that
collection.

## 2. Canonical approach (official tooling only)

- **Start from the official template**: [`devcontainers/feature-template`](https://github.com/devcontainers/feature-template)
  — a self-authoring *collection* template (examples `hello`, `color`), with the correct
  `src/` layout and a `release.yaml` that publishes to GHCR.
- **Official CLI**: [`devcontainers/cli`](https://github.com/devcontainers/cli) (`@devcontainers/cli`,
  binary `devcontainer`) — `devcontainer features test`, `features package`, `features publish`.
- **Official publish Action**: [`devcontainers/action`](https://github.com/devcontainers/action)
  (used by the template's `release.yaml`).
- **Spec**: [Feature distribution spec](https://containers.dev/implementors/features-distribution/)
  and [Feature reference](https://containers.dev/implementors/features/).

Do **not** hand-roll the structure or the publish workflow — derive them from the template.

## 3. Repo identity

- **Name**: `devcontainer-features` (owner `sina-al`) → `sina-al/devcontainer-features`.
- **Visibility**: public.
- **Local path**: `~/Development/devcontainer-features` (this directory).
- **Registry namespace** (GHCR): `ghcr.io/sina-al/devcontainer-features/<feature>:<version>`
  (the template prefixes features with `<owner>/<repo>`).
  - Example: `ghcr.io/sina-al/devcontainer-features/fireconnect:1`.

## 4. Target structure

```
devcontainer-features/
├── .devcontainer/                 # work on this repo in DevPod (see §7)
│   ├── devcontainer.json
│   └── Dockerfile
├── .github/
│   └── workflows/
│       ├── test.yaml              # devcontainer features test on PR
│       └── release.yaml           # devcontainers/action → publish to GHCR on tag
├── src/
│   ├── fireconnect/
│   │   ├── devcontainer-feature.json
│   │   ├── install.sh
│   │   ├── README.md
│   │   └── NOTES.md
│   ├── devcontainers-cli/
│   │   ├── devcontainer-feature.json
│   │   ├── install.sh
│   │   ├── README.md
│   │   └── NOTES.md
│   └── …                          # more features over time
├── test/
│   ├── fireconnect/
│   │   ├── scenarios.json
│   │   └── test.sh
│   └── devcontainers-cli/
│       ├── scenarios.json
│       └── test.sh
├── AGENTS.md
├── README.md
└── LICENSE
```

## 5. Execution steps

1. **Create the repo from the template.**
   ```sh
   gh repo create sina-al/devcontainer-features \
     --template devcontainers/feature-template --public --clone
   cd devcontainer-features
   ```
2. **Strip the examples** (`src/hello`, `src/color`, their `test/` dirs) but **keep** the
   `release.yaml` workflow and `.github/` scaffolding.
3. **Migrate the two features I already authored** from `sina-al/sandbox`:
   `fireconnect` and `devcontainers-cli` (under `sandbox/.devcontainer/features/`). Move each
   folder into `src/<feature>/`, bump the feature `version` to a real semver (e.g. `0.1.0`),
   and bring its `README.md`/`NOTES.md`/`LICENSE`.
4. **Add tests** under `test/<feature>/`:
   - `scenarios.json` — one or more scenarios (base image + options).
   - `test.sh` — assertions the feature worked (binary on PATH, `--version` matches, etc.).
   - Run locally: `devcontainer features test --features fireconnect` from the repo root.
5. **CI workflows**:
   - `test.yaml` — on PR: `devcontainer features test` for changed/all features.
   - `release.yaml` — from the template: on tag/release, `devcontainers/action` publishes
     each feature to GHCR and emits a metadata package.
6. **Enable workflow permissions**: repo Settings → Actions → General → *Workflow permissions*,
   allow Actions to create/approve PRs (for auto-generated `README.md`).
7. **Mark GHCR packages public** — they default to private. For each feature, flip visibility
   to public at the package settings page so they're usable on the free tier / by anyone.
8. **(Optional) Index**: to appear on [containers.dev/features](https://containers.dev/features),
   PR `collection-index.yml` in `devcontainers/devcontainers.github.io`.
9. **Reuse from the sandbox**: replace the local feature paths in `sina-al/sandbox` with the
   published references:
   ```jsonc
   "ghcr.io/sina-al/devcontainer-features/fireconnect:1": { "version": "latest", "login": false },
   "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:1": { "version": "latest" }
   ```
   (and delete the local `.devcontainer/features/` copies from the sandbox once published).

## 6. Conventions carried over from the sandbox session

These are proven patterns from the two features I already authored — bake them into every
feature here:

- **Install as the remote user** via `su - "${_REMOTE_USER:-${_CONTAINER_USER:-vscode}}"`,
  so launchers, `~/.local/bin`, and `PATH` updates land in the user's home, not `/root`.
- **Pin everything.** `version` option for the tool; feature `version` is semver; reference
  `:1` (major) from consumers.
- **No secrets in features.** Auth/login is a runtime step (e.g. `fireconnect login`), not
  build-time, unless an explicit opt-in (`login: true` + token env) for CI.
- **AGENTS.md** describing conventions + security posture for agents editing the repo.
- **Gotcha burned this session**: relative feature paths in `devcontainer.json` resolve
  relative to the **`.devcontainer/` folder**, not the repo root. Inside *this* repo's own
  devcontainer that doesn't apply (features live in `src/` and are referenced by id after
  publish), but it matters for any local-feature references in consumer repos.

## 7. This repo's own devcontainer (work on it in DevPod)

To author and test features I need, inside the workspace: **Docker** (the CLI builds dev
container images to run feature tests) and the **devcontainer CLI**, plus Node (the CLI's
runtime). Reuse the sandbox's pinned-feature approach:

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "devcontainer-features",
  "build": { "dockerfile": "Dockerfile" },
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:4": { "version": "29.7.2", "dockerDashComposeVersion": "v2" },
    "ghcr.io/devcontainers/features/node:2": { "version": "24.19.0" },
    "ghcr.io/devcontainers/features/github-cli:1": { "version": "2.98.0" },
    "ghcr.io/sina-al/devcontainer-features/devcontainers-cli:1": { "version": "latest" }
  },
  "forwardAgent": true,
  "remoteUser": "vscode",
  "postCreateCommand": "bash .devcontainer/scripts/post-create.sh"
}
```

> Bootstrap note: until `devcontainers-cli` is published from this repo, install the CLI
> directly in the Dockerfile (`npm i -g @devcontainers/cli`) or via the official install
> script, then switch to the self-published feature once `:1` exists. Docker-in-Docker is the
> hard requirement — `devcontainer features test` won't work without a Docker daemon.

Run it the same way as the sandbox:

```sh
devpod up .                       # local
devpod up . --provider gcloud     # remote on GCP
devpod ssh .
# inside:
devcontainer features test --features fireconnect
```

## 8. First features to include

1. **`fireconnect`** — migrate from sandbox (installs FireConnect CLI for the remote user,
   version-pinned, opt-in non-interactive `login`).
2. **`devcontainers-cli`** — migrate from sandbox (installs the official devcontainer CLI
   via the self-contained installer).
3. *(Later, as trust needs grow)* own copies of other features I depend on — e.g. a
   `gcloud` feature pinned to a specific SDK version, an `opencode` feature — so I'm not
   dependent on third-party maintainers for my canonical setup.

## 9. Open decisions

- **Namespace/visibility**: `ghcr.io/sina-al/devcontainer-features/<feature>` vs a shorter
  org namespace. Recommend keeping `sina-al/devcontainer-features` to start.
- **Sandbox linkage**: publish here, then reference the GHCR images from `sina-al/sandbox`
   (recommended) vs keeping local copies duplicated. Recommend publish-and-reference.
- **Versioning cadence**: tag per-feature or repo-level releases. The template publishes on
  repo tags; consider per-feature tags if release cadences diverge.

## 10. Next action

Execute §5: create the repo from the template, migrate `fireconnect` + `devcontainers-cli`,
add tests + CI, add the repo's own devcontainer (§7), then create the public repo and push.
