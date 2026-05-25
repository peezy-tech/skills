#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_ROOT="${WORKSPACE_ROOT:-$(cd "$MARKETPLACE_ROOT/.." && pwd)}"
CODEX_FLOWS_ROOT="${CODEX_FLOWS_ROOT:-$WORKSPACE_ROOT/codex-flows}"
PATCH_MOI_ROOT="${PATCH_MOI_ROOT:-$WORKSPACE_ROOT/patch.moi}"

PUBLIC_CODEX_FLOW_PLUGINS=(
  codex-flows-author
  codex-flows-local-workspace
  codex-flows-remote-control
)

require_dir() {
  local path="$1"
  if [[ ! -d "$path" ]]; then
    echo "missing directory: $path" >&2
    exit 1
  fi
}

sync_dir() {
  local source="$1"
  local destination="$2"
  mkdir -p "$(dirname "$destination")"
  rsync -a --delete \
    --exclude '.git' \
    --exclude 'node_modules' \
    --exclude '.codex' \
    "$source/" "$destination/"
}

git_revision() {
  local repo="$1"
  git -C "$repo" rev-parse HEAD
}

git_status_short() {
  local repo="$1"
  git -C "$repo" status --short
}

marketplace_entry() {
  local plugin="$1"
  cat <<JSON
    {
      "name": "$plugin",
      "source": {
        "source": "local",
        "path": "./plugins/$plugin"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    }
JSON
}

is_public_codex_flow_plugin() {
  local candidate="$1"
  local plugin
  for plugin in "${PUBLIC_CODEX_FLOW_PLUGINS[@]}"; do
    if [[ "$candidate" == "$plugin" ]]; then
      return 0
    fi
  done
  return 1
}

require_dir "$CODEX_FLOWS_ROOT"
require_dir "$PATCH_MOI_ROOT"

mkdir -p "$MARKETPLACE_ROOT/plugins" "$MARKETPLACE_ROOT/.agents/plugins"

for plugin_path in "$MARKETPLACE_ROOT"/plugins/*; do
  [[ -d "$plugin_path" ]] || continue
  plugin="$(basename "$plugin_path")"
  if ! is_public_codex_flow_plugin "$plugin"; then
    rm -rf "$plugin_path"
  fi
done
rm -rf "$MARKETPLACE_ROOT/skills"

for plugin in "${PUBLIC_CODEX_FLOW_PLUGINS[@]}"; do
  require_dir "$CODEX_FLOWS_ROOT/plugins/$plugin"
  sync_dir "$CODEX_FLOWS_ROOT/plugins/$plugin" "$MARKETPLACE_ROOT/plugins/$plugin"
done

{
  cat <<'JSON'
{
  "name": "peezy-tech",
  "interface": {
    "displayName": "Peezy Tech"
  },
  "plugins": [
JSON
  local_first=true
  for plugin in "${PUBLIC_CODEX_FLOW_PLUGINS[@]}"; do
    if [[ "$local_first" == true ]]; then
      local_first=false
    else
      printf ',\n'
    fi
    marketplace_entry "$plugin"
  done
  cat <<'JSON'
,
    {
      "name": "patch-moi",
      "source": {
        "source": "url",
        "url": "https://github.com/peezy-tech/patch.moi.git",
        "ref": "main"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    }
  ]
}
JSON
} >"$MARKETPLACE_ROOT/.agents/plugins/marketplace.json"

cat >"$MARKETPLACE_ROOT/sources.lock.json" <<JSON
{
  "generatedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "sources": {
    "codex-flows": {
      "path": "$CODEX_FLOWS_ROOT",
      "revision": "$(git_revision "$CODEX_FLOWS_ROOT")",
      "dirty": $(if [[ -n "$(git_status_short "$CODEX_FLOWS_ROOT")" ]]; then echo true; else echo false; fi)
    },
    "patch-moi": {
      "path": "$PATCH_MOI_ROOT",
      "revision": "$(git_revision "$PATCH_MOI_ROOT")",
      "dirty": $(if [[ -n "$(git_status_short "$PATCH_MOI_ROOT")" ]]; then echo true; else echo false; fi),
      "marketplaceSource": "https://github.com/peezy-tech/patch.moi.git"
    }
  }
}
JSON

jq . "$MARKETPLACE_ROOT/.agents/plugins/marketplace.json" >/dev/null
jq . "$MARKETPLACE_ROOT/sources.lock.json" >/dev/null

echo "synced Peezy Tech marketplace at $MARKETPLACE_ROOT"
