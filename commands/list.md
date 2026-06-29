---
description: List all active background subagents in this session
---

List every active background subagent in the current session as a markdown table.

For each subagent include:
- **Name** — the human-friendly name you assigned when launching it
- **Type** — the agent type (runner, explore, review, etc.)
- **Task** — a concise description of what it is working on (50 chars max)
- **Status** — current state (running, completed, or the result of `task_status`)

Use `task_status` on each known `task_id` to poll current state.

Format as a clean markdown table with aligned columns.

Remove any subagents that have already completed from the list or mark them explicitly as done.
