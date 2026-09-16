---
description: Show the DeepSeek account balance
allowed-tools: Bash
---

!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/cli-dispatch-balance.sh" --backend deepseek`

The report above already ran — do NOT run it again.

Summarize the DeepSeek `total_balance` per currency from the raw JSON and nothing more.

**Never print any key VALUE** — only the balance figure. An unconfigured or offline
backend prints a short note instead of a number; report that note as-is rather than
treating it as an error.
