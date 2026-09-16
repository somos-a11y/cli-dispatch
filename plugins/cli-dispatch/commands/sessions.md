---
description: List cli-dispatch worker sessions (DeepSeek)
allowed-tools: Bash
---

!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/cli-dispatch-sessions.sh" deepseek`

The session listing above already ran — do NOT run it again. Present it as-is,
newest first. Cost-conscious: it reads only `meta.json` + `status.json`;
`transcript.jsonl` is NEVER read.

To see a session's detail/live status: `/cli-dispatch:watch <id>`.
To send a follow-up (continue the same session): `/cli-dispatch:resume <id> <follow-up>`.
