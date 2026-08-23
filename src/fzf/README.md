# fzf

Installs [fzf](https://github.com/junegunn/fzf) — a general-purpose command-line fuzzy finder.

## Usage

```jsonc
"features": {
  "ghcr.io/sina-al/devcontainer-features/fzf:0.1": {
    "version": "latest"
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | fzf version. `latest` installs the newest release. Otherwise a specific version like `0.74.3`. |

## Notes

The binary is installed to `/usr/local/bin/fzf` (system-wide, always on PATH). Shell keybindings and completions can be set up via `fzf --bash`, `fzf --zsh`, or `fzf --fish` in your dotfiles.
