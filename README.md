# peezy-tech Codex marketplace

Shared Codex plugin marketplace for Peezy projects.

This repo is the single marketplace that people add to Codex App. Product repos
still own their source plugin and skill definitions; this repo publishes the
installable marketplace surface.

## Install

From Codex App, add this marketplace:

```bash
codex plugin marketplace add peezy-tech/skills --ref main
```

Then install the plugin for the job:

```bash
codex plugin add codex-toys-author@peezy-tech
codex plugin add codex-toys-remote-control@peezy-tech
codex plugin add codex-toys-local-workspace@peezy-tech
codex plugin add patch-moi@peezy-tech
```

## Marketplace Contents

| Plugin | Source | Purpose |
| --- | --- | --- |
| `codex-toys-author` | synced from `../codex-toys` | Turn automation authoring guidance. |
| `codex-toys-local-workspace` | synced from `../codex-toys` | Local workspace runtime operation guidance. |
| `codex-toys-remote-control` | synced from `../codex-toys` | Local Codex App control of remote workspaces over SSH/Tailscale. |
| `patch-moi` | Git source `peezy-tech/patch.moi` | Patch stack maintenance skills and MCP runtime. |

`patch-moi` intentionally stays a Git-backed plugin entry instead of a copied
bundle because its MCP server expects the product repo runtime, scripts, and
workspace layout.

## Sync From Product Repos

Run this from the marketplace repo after changing product-owned plugin or skill
definitions:

```bash
./scripts/sync-marketplace.sh
```

The script expects sibling checkouts:

```text
../codex-toys
../patch.moi
```

It refreshes `plugins/`, `.agents/plugins/marketplace.json`, and
`sources.lock.json`.

## Layout

```text
.agents/plugins/marketplace.json
plugins/
  codex-toys-author/
  codex-toys-local-workspace/
  codex-toys-remote-control/
scripts/
  sync-marketplace.sh
sources.lock.json
```

## Checks

```bash
./scripts/sync-marketplace.sh
for plugin in plugins/*; do python3 /home/peezy/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py "$plugin"; done
jq . .agents/plugins/marketplace.json >/dev/null
jq . sources.lock.json >/dev/null
```
