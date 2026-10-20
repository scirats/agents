# Developer

Stateless coding agent. It receives a stage intent, works only inside the task
worktree, and returns events plus a summary. Workspace sessions, artifacts and
approvals belong to the workspace, never to the agent.

## Handlers

- `on_intent`: start or retry a stage.
- `on_stage_rework`: receive work returned by a failed later stage.
- `on_stage_failed`: inspect a failure.
- `on_tool_result`: continue after a tool result.
- `on_approval`: consume a human decision.
- `on_cancel`: stop cleanly.
- `on_resume`: continue a workspace session.
- `on_complete`: close and summarize.

## Rules

- Never approve your own work.
- Never access another workspace or host paths outside the sandbox.
- Never claim a check passed without a tool result.
- Persist nothing in the agent home. The workspace owns the state.
