#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_ROOT="${WORKSPACE_ROOT:-$(cd "$MARKETPLACE_ROOT/.." && pwd)}"
CODEX_FLOWS_ROOT="${CODEX_FLOWS_ROOT:-$WORKSPACE_ROOT/codex-flows}"
PATCH_MOI_ROOT="${PATCH_MOI_ROOT:-$WORKSPACE_ROOT/patch.moi}"

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

require_dir "$CODEX_FLOWS_ROOT"
require_dir "$PATCH_MOI_ROOT"
require_dir "$MARKETPLACE_ROOT/skills/jojo-development-flow"

mkdir -p "$MARKETPLACE_ROOT/plugins" "$MARKETPLACE_ROOT/.agents/plugins"

for plugin in \
  codex-flows \
  codex-flows-author \
  codex-flows-backend-author \
  codex-flows-local-workspace \
  codex-flows-remote-backend \
  codex-flows-remote-control \
  jojo-development-flow
do
  rm -rf "$MARKETPLACE_ROOT/plugins/$plugin"
done

mkdir -p "$MARKETPLACE_ROOT/plugins/codex-flows/.codex-plugin"
sync_dir "$CODEX_FLOWS_ROOT/.codex-plugin" "$MARKETPLACE_ROOT/plugins/codex-flows/.codex-plugin"
sync_dir "$CODEX_FLOWS_ROOT/skills" "$MARKETPLACE_ROOT/plugins/codex-flows/skills"
sync_dir "$CODEX_FLOWS_ROOT/hooks" "$MARKETPLACE_ROOT/plugins/codex-flows/hooks"

for plugin in \
  codex-flows-author \
  codex-flows-backend-author \
  codex-flows-local-workspace \
  codex-flows-remote-backend \
  codex-flows-remote-control
do
  sync_dir "$CODEX_FLOWS_ROOT/plugins/$plugin" "$MARKETPLACE_ROOT/plugins/$plugin"
done

mkdir -p \
  "$MARKETPLACE_ROOT/plugins/jojo-development-flow/.codex-plugin" \
  "$MARKETPLACE_ROOT/plugins/jojo-development-flow/skills"
sync_dir \
  "$MARKETPLACE_ROOT/skills/jojo-development-flow" \
  "$MARKETPLACE_ROOT/plugins/jojo-development-flow/skills/jojo-development-flow"
cat >"$MARKETPLACE_ROOT/plugins/jojo-development-flow/.codex-plugin/plugin.json" <<'JSON'
{
  "name": "jojo-development-flow",
  "version": "0.1.0",
  "description": "jojo.build and release operations for peezy-tech repositories.",
  "author": {
    "name": "Peezy",
    "email": "support@peezy.tech",
    "url": "https://peezy.tech/"
  },
  "homepage": "https://github.com/peezy-tech/skills",
  "repository": "https://github.com/peezy-tech/skills",
  "license": "MIT",
  "keywords": [
    "codex",
    "jojo",
    "forgejo",
    "release",
    "skills"
  ],
  "skills": "./skills/",
  "interface": {
    "displayName": "jojo development flow",
    "shortDescription": "Operate jojo.build remotes and Peezy release flows.",
    "longDescription": "jojo-development-flow installs Codex guidance for peezy-tech development flow, jojo.build operations, Codeberg mirroring, branch tracking, release validation, and npm trusted publishing.",
    "developerName": "Peezy",
    "category": "Coding",
    "capabilities": [
      "Read",
      "Write",
      "Interactive"
    ],
    "websiteURL": "https://github.com/peezy-tech/skills",
    "privacyPolicyURL": "https://peezy.tech/privacy",
    "termsOfServiceURL": "https://peezy.tech/terms",
    "defaultPrompt": [
      "Check this repo's jojo.build remotes.",
      "Prepare a Peezy release flow."
    ],
    "brandColor": "#2563EB"
  }
}
JSON

cat >"$MARKETPLACE_ROOT/.agents/plugins/marketplace.json" <<'JSON'
{
  "name": "peezy-tech",
  "interface": {
    "displayName": "Peezy Tech"
  },
  "plugins": [
    {
      "name": "codex-flows",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
    {
      "name": "codex-flows-author",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows-author"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
    {
      "name": "codex-flows-backend-author",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows-backend-author"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
    {
      "name": "codex-flows-local-workspace",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows-local-workspace"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
    {
      "name": "codex-flows-remote-backend",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows-remote-backend"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
    {
      "name": "codex-flows-remote-control",
      "source": {
        "source": "local",
        "path": "./plugins/codex-flows-remote-control"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    },
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
    },
    {
      "name": "jojo-development-flow",
      "source": {
        "source": "local",
        "path": "./plugins/jojo-development-flow"
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
