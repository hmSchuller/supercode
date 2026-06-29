---
description: Send a message directly to a background subagent
---

Parse the user's message for a target and prompt:
- If the first argument starts with `@` (e.g. `@runner`), treat it as an agent type lookup.
- Otherwise, treat it as the assigned human name of a running background subagent.
- Everything after the target is the message to forward.

Rules:
1. Find the matching background subagent by type or assigned name and send the full user message to its `task_id` using the `task` tool.
2. Do not analyze, interpret, rephrase, or perform the task yourself.
3. Do not wait for the subagent's response or poll its status.
4. If the message is exactly `stop`, signal the subagent to abort — prefer sending `stop` as the message to its `task_id`.

If no matching subagent is found by type, launch a new background subagent of that type with the user's prompt.

Usage:
- `/tell @runner update the login form validation`
- `/tell Amber revise items 1 and 3 from the plan`
- `/tell Amber stop`
