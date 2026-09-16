#!/usr/bin/env bash
# One-screen command reference for cli-dispatch (DeepSeek-only fork).
#
# Runs straight from the plugin cache via commands/help.md's `!` pre-execution
# block — it is NOT installed into ~/.local/bin, so it never goes stale relative
# to the plugin (same arrangement as cli-dispatch-status.sh).
#
# Static text only. Keep the box borders aligned when editing.

cat <<'HELP'
┌─ cli-dispatch (DeepSeek-only) ───────────────────────────────────────────────┐
│                                                                               │
│  SETUP & HEALTH                                                               │
│    /cli-dispatch:setup          Install & configure the DeepSeek backend      │
│    /cli-dispatch:status         Installation status                           │
│    /cli-dispatch:doctor         Health check — PATH, keys, auth  ✓/✗         │
│                                                                               │
│  DELEGATE (DeepSeek)                                                          │
│    /cli-dispatch:ds-run <task>  Delegate to DeepSeek (claude-ds)             │
│    Runner: /cli-dispatch:run ds "<task>" --verify '<cmd>'                    │
│    Models: deepseek-v4-pro (workhorse) · deepseek-flash (fast/cheap)         │
│                                                                               │
│  MONITOR                                                                      │
│    /cli-dispatch:sessions       List sessions                                │
│    /cli-dispatch:watch <id>     Live status of one session                   │
│    /cli-dispatch:wait <id>      Block until session finishes                 │
│    /cli-dispatch:resume <id> …  Continue a session with a follow-up          │
│    /cli-dispatch:kill <id>      Stop a running worker session                │
│    /cli-dispatch:dashboard      Open local web dashboard (port 7878)         │
│                                                                               │
│  USAGE & HOUSEKEEPING                                                         │
│    /cli-dispatch:balance        DeepSeek account balance                     │
│    /cli-dispatch:ds-balance     DeepSeek account balance                     │
│    /cli-dispatch:gain           Worker token totals                          │
│    /cli-dispatch:clean          Remove old session dirs                      │
│    /cli-dispatch:clean-schedule Schedule periodic cleanup                    │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘

[CD] in your statusline = cli-dispatch active; ▶N = N workers running right now.
HELP
