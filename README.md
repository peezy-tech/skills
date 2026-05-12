# peezy-tech skills

Shared Codex skills for peezy-tech development workflows.

This repo is intentionally small: one catalog, one folder per skill, and enough
metadata for Codex to load each skill without extra setup.

## Available Skills

| Skill | Use When |
| --- | --- |
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
