---
name: code-mode-flow-author
description: Use when writing or reviewing Code Mode flow step snippets that execute through a Codex app-server with thread/codeMode/execute, use injected flow context, call tools from JavaScript, and emit FLOW_RESULT.
---

# Code Mode Flow Author

Use this skill for `runner = "code-mode"` flow steps.

## Runtime Contract

- The runner starts or connects to a Codex app-server with Code Mode enabled.
- The runner injects `flow` and `result(value)` before the `.code-mode.js` body.
- The snippet runs through raw `thread/codeMode/execute`.
- The snippet must call `result(...)` once; the runner converts it to `FLOW_RESULT`.
- Code Mode execution should be feature-flagged by the runtime or backend, not isolated on a separate branch.

## Available Shape

```js
text("starting");
const config = flow.config || {};

const status = await tools.exec_command({
  cmd: "git status --short",
  workdir: flow.cwd,
  yield_time_ms: 1000,
  max_output_tokens: 4000
});

result({
  status: "completed",
  artifacts: { status }
});
```

## Rules

- Use `tools.exec_command` for host actions; include `workdir` explicitly when touching repos.
- Use `text(...)` for concise progress and collected context.
- Preserve external recovery state on conflicts or partial integrations, then return `needs_intervention`.
- Do not assume generated client types include fork-only methods. The runner can call raw `thread/codeMode/execute`.
- Keep the same flow package usable from `main`; use runtime/backend flags such as `CODEX_FLOWS_ENABLE_CODE_MODE=1` for Code Mode availability.
- Avoid global installs unless the flow package explicitly requires them.
- Keep project-specific release/remotes policy in flow README or referenced guidance skills.
