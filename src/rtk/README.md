
# rtk (Rust Token Killer) (rtk)

Installs rtk, a CLI tool that compresses command outputs before they reach the AI context window. Reduces token usage by 60-90% with zero config changes. Optionally runs rtk init to activate the auto-rewrite hook for a specific AI agent.

## Example Usage

```json
"features": {
    "ghcr.io/sina-al/devcontainer-features/rtk:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | rtk version to install. 'latest' installs the newest release. Otherwise a published version such as '0.45.0' (a leading 'v' is stripped). | string | latest |
| agent | AI agent to configure rtk for at build time via 'rtk init --global'. Empty skips init (run it manually later). Supported agents: opencode, claude-code, cursor, aider, gemini-cli, codex, windsurf, cline, copilot. | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sina-al/devcontainer-features/blob/main/src/rtk/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
