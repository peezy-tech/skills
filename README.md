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
codex plugin add codex-flows-remote-control@peezy-tech
codex plugin add codex-flows-local-workspace@peezy-tech
codex plugin add patch-moi@peezy-tech
codex plugin add jojo-development-flow@peezy-tech
```

## Marketplace Contents

| Plugin | Source | Purpose |
| --- | --- | --- |
| `codex-flows` | synced from `../codex-flows` | Full compatibility install for codex-flows skills and hooks. |
| `codex-flows-author` | synced from `../codex-flows` | Flow package and Bun step authoring. |
| `codex-flows-backend-author` | synced from `../codex-flows` | Flow backend design and implementation. |
| `codex-flows-local-workspace` | synced from `../codex-flows` | Local workspace backend setup, operation, delegation, and hooks. |
| `codex-flows-remote-backend` | synced from `../codex-flows` | Remote backend setup and operation without local hooks. |
| `codex-flows-remote-control` | synced from `../codex-flows` | Local Codex App control of a remote backend over SSH/Tailscale. |
| `patch-moi` | Git source `peezy-tech/patch.moi` | Patch stack maintenance skills and MCP runtime. |
| `jojo-development-flow` | local shared skill | jojo.build and release operations for peezy-tech repos. |

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
../codex-flows
../patch.moi
```

It refreshes `plugins/`, `.agents/plugins/marketplace.json`, and
`sources.lock.json`.

## Layout

```text
.agents/plugins/marketplace.json
plugins/
  codex-flows*/
  jojo-development-flow/
skills/
  jojo-development-flow/
scripts/
  sync-marketplace.sh
sources.lock.json
```

## Checks

```bash
./scripts/sync-marketplace.sh
python3 /home/peezy/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/codex-flows
for plugin in plugins/*; do python3 /home/peezy/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py "$plugin"; done
jq . .agents/plugins/marketplace.json >/dev/null
```
