# peezy-tech skills

Shared Codex skills for peezy-tech development workflows.

This repo is intentionally small: one catalog, one folder per skill, and enough
metadata for Codex to load each skill without extra setup.

## Available Skills

| Skill | Use When |
| --- | --- |
| [`bun-flow-author`](./skills/bun-flow-author/SKILL.md) | Writing or reviewing Bun-based flow step scripts that read flow context from stdin and emit `FLOW_RESULT`. |
| [`code-mode-flow-author`](./skills/code-mode-flow-author/SKILL.md) | Writing or reviewing Code Mode flow snippets that execute through `thread/codeMode/execute`. |
| [`delegation-orchestrator`](./skills/delegation-orchestrator/SKILL.md) | Coordinating delegated Codex threads from the main workspace operator using `codex_workspace` tools. |
| [`flow-backend-author`](./skills/flow-backend-author/SKILL.md) | Designing or implementing flow backend adapters, run state, idempotent dispatch, retries, and worker/app-server handoff. |
| [`flow-operator`](./skills/flow-operator/SKILL.md) | Operating, inspecting, debugging, retrying, or replaying Codex flow events and runs in live or local backends. |
| [`flow-package-author`](./skills/flow-package-author/SKILL.md) | Creating or updating portable flow bundles with `flow.toml`, schemas, exec snippets, fixtures, and result contracts. |
| [`jojo-development-flow`](./skills/jojo-development-flow/SKILL.md) | Working on `peezy-tech/codex-flows` remotes, jojo.build operations, Codeberg mirroring, jojo Actions, branch tracking, release validation, or npm trusted publishing. |

## Layout

```text
skills/
  <skill-name>/
    SKILL.md
    agents/
    references/
    scripts/
    assets/
```

Only `SKILL.md` is required. The optional directories are used when a skill
needs agent metadata, supporting reference material, executable helpers, or
assets.

## Checks

List the available skills:

```bash
./scripts/list-skills.sh
```
