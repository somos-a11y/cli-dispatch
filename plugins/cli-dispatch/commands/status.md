---
description: Check the cli-dispatch installation status (DeepSeek)
allowed-tools: Bash
---

!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/cli-dispatch-status.sh" --backend deepseek "${CLAUDE_PLUGIN_ROOT}"`

The status report above already ran — do NOT run it again.

Present it to the user as-is. Keep it compact; add no prose beyond what the report says.
The report never prints a key VALUE, only whether one is set — keep it that way.

If everything is in place, suggest an optional smoke test (as a background task):
`claude-ds -p "Reply with exactly: OK"`.
