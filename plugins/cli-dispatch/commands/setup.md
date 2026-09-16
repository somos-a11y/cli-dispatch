---
description: Install and configure the cli-dispatch DeepSeek worker backend
allowed-tools: Bash, AskUserQuestion
---

# cli-dispatch setup (DeepSeek-only fork)

This is a DeepSeek-only fork of cli-dispatch (see FORK-NOTES.md). The Antigravity/Gemini,
Codex/OpenAI, OpenCode/OpenRouter and GitHub Copilot backends have been removed — the only
worker installed here is **DeepSeek** (`claude-ds`).

| Backend | Worker CLI it wraps | Auth | Installs |
|---|---|---|---|
| **DeepSeek** | `claude` (Claude Code) pointed at DeepSeek's API | DeepSeek API key | `claude-ds`, `claude-ds-stream`, `ds-agent` |

Follow these steps:

1. **Detect the base CLI:**
   ```bash
   command -v claude >/dev/null 2>&1 && echo "claude: found" || echo "claude: MISSING"
   command -v node   >/dev/null 2>&1 && echo "node: found"   || echo "node: MISSING (stream parser needs it)"
   ```
   If `claude` is MISSING, offer to install it — `npm i -g @anthropic-ai/claude-code`
   (fallback: `curl -fsSL https://claude.ai/install.sh | bash`). State plainly that the
   `curl` fallback downloads and executes a vendor script from `claude.ai`; this approval is
   per-run only. Never auto-install without an explicit yes.

2. **Run the installer** — resolve the plugin root at runtime (never hardcode a versioned
   cache path):

   - **macOS / Linux / WSL / Git Bash**:
     ```bash
     PLUGIN_ROOT="$(bash "${CLAUDE_PLUGIN_ROOT}/scripts/resolve-plugin-root.sh" "${CLAUDE_PLUGIN_ROOT}")"
     bash "$PLUGIN_ROOT/scripts/install.sh" --backends deepseek
     ```
   - **Native Windows (PowerShell)**:
     ```powershell
     $PluginRoot = & powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/resolve-plugin-root.ps1" -SessionRoot "${CLAUDE_PLUGIN_ROOT}"
     powershell -NoProfile -ExecutionPolicy Bypass -File "$PluginRoot/scripts/install.ps1" -Backends deepseek
     ```

   Wrappers go to `~/.local/bin`; parsers to `~/.local/share/cli-dispatch/`. A shared config
   skeleton is created at `~/.config/cli-dispatch/config` if missing (existing configs are
   never clobbered).

   > Note: the stream variant requires `node` for its parser (claude-code already runs in a node environment).

3. **Configure the DeepSeek API key** — the installer prints the config path; ask the user to
   paste their key into the `DEEPSEEK_API_KEY=""` line in `~/.config/cli-dispatch/config`.
   **You (Claude) must NEVER write/paste the API key** — only the user enters it. The two
   models are pre-set in the config: `DS_MODEL="deepseek-v4-pro"` (workhorse) and
   `DS_FLASH_MODEL="deepseek-flash"` (fast/cheap).

4. **Optional smoke test** (as a background task, after the key is added):
   ```bash
   claude-ds -p "Reply with exactly: OK"
   ```

5. **Configure per-session policy injection (optional).** Instead of hand-editing CLAUDE.md,
   cli-dispatch can auto-inject its delegation policy at every session start (including after
   compaction and in forked sessions) via a `SessionStart` hook that reads
   `~/.config/cli-dispatch/policy.json`. Ask the user (via `AskUserQuestion`):

   1. **header "Policy injection"** — *"Enable per-session policy injection? A SessionStart
      hook auto-injects the cli-dispatch delegation policy at every session start."* Options:
      **"Enable (recommended)"** (`recommended: true`), **"Skip"**.
   2. **header "CLAUDE.md block"** — *"Also write the policy as a static CLAUDE.md block? NOT
      recommended when the hook is enabled — it double-injects."* Options: **"No, hook only
      (recommended)"** (`recommended: true`), **"Yes, also add CLAUDE.md block"**, **"Skip both"**.

   If injection is enabled, write `~/.config/cli-dispatch/policy.json` (this is NOT a secret;
   read-and-confirm before overwriting an existing one):
   ```bash
   CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli-dispatch"
   mkdir -p "$CFG_DIR"
   VERSION="$(node -e 'process.stdout.write(require(process.argv[1]).version)' \
     "${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json" 2>/dev/null || echo unknown)"
   NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
   cat > "$CFG_DIR/policy.json" <<JSON
   {
     "schemaVersion": 1,
     "enabled": true,
     "issueReminder": false,
     "claudeMdBlock": false,
     "pluginVersionAtSetup": "$VERSION",
     "updatedAt": "$NOW"
   }
   JSON
   ```
   If the user chose **Skip**, either don't write `policy.json`, or set an existing one's
   `enabled` to `false` while preserving the other fields.

6. **Report** which files were written/updated and the injection status. If the user skipped
   everything, say so and make no changes.
