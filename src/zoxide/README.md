# zoxide

Installs [zoxide](https://github.com/ajeetdsouza/zoxide) — a smarter cd command that learns your habits.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/zoxide:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | zoxide version. `latest` installs the newest release. Otherwise a specific version like `0.10.0`. |

## Notes

The binary is installed to `/usr/local/bin/zoxide` (system-wide, always on PATH). Shell integration can be set up via `zoxide init bash` (or `zsh`/`fish`) in your dotfiles.
