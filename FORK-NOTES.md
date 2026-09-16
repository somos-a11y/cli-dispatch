# FORK-NOTES

`somos-a11y/cli-dispatch` is a fork of [`rbinar/cli-dispatch`](https://github.com/rbinar/cli-dispatch),
trimmed to the **DeepSeek backend only** for [oncahistorias.org](https://oncahistorias.org).

## Why

Upstream cli-dispatch is a five-backend delegation hub (DeepSeek, Antigravity/Gemini, Codex/OpenAI,
OpenCode/OpenRouter, GitHub Copilot). In practice this project delegates to **DeepSeek only**.
Exposing the other backends caused Claude to get confused and reach for OpenAI / OpenCode / Google
models during delegation. This fork removes every backend except DeepSeek from the surface Claude
reads, so delegation is unambiguous.

## What diverges from upstream

Kept intentionally small and mechanical so it stays syncable.

**Removed (the confusers):**
- `plugins/cli-dispatch/commands/{ag,cx,oc,cp}-{run,balance,sessions,status}.md` — the 16
  per-backend command markdowns for Antigravity, Codex, OpenCode and Copilot. Deleting these
  removes them from the `/cli-dispatch:*` slash-command menu.

**Rewritten to DeepSeek-only:**
- `plugins/cli-dispatch/skills/ds-delegate/SKILL.md` — the always-loaded delegation skill. Its
  description, triggers, body and command list no longer mention the other backends. **This is the
  highest-leverage change** (the skill is what steered Claude toward OpenAI/etc.).
- `plugins/cli-dispatch/scripts/cli-dispatch-help.sh` — the `/cli-dispatch:help` reference box.
- `plugins/cli-dispatch/commands/{balance,status,sessions}.md` — the aggregate diagnostics now pass
  `--backend deepseek` (or the `deepseek` slug) so only DeepSeek surfaces.
- `plugins/cli-dispatch/commands/run.md` — the deterministic runner only accepts backend `ds`.
- `plugins/cli-dispatch/commands/setup.md` — installs/configures the DeepSeek backend only.
- `.claude-plugin/marketplace.json`, `plugins/cli-dispatch/.claude-plugin/plugin.json` — DeepSeek-only
  descriptions + keywords; owner/homepage/repository point at the fork.
- `README.md`, `CLAUDE.md` — fork banner + DeepSeek-only opening.
- `plugins/cli-dispatch/scripts/__tests__/preexec-commands.test.mjs` — dropped the rows for the
  deleted command markdowns.

**Left UNTOUCHED on purpose (not surfaced to Claude; keeps the diff small):**
- The shared diagnostic scripts `cli-dispatch-{status,doctor,balance,sessions}.sh` stay
  internally 5-backend-capable. The aggregate command markdowns just scope them to DeepSeek.
  `/cli-dispatch:doctor` therefore still lists the other backends as "not installed" — it is a
  health check, not a delegation trigger.
- The `{ag,cx,oc,cp}-agent`, `*-stream`, `*-worktree-run.sh`, `*-stream-parse.mjs` plumbing and
  their unit tests. Removing them would mean rewriting the upstream test suite; leaving them costs
  nothing since no command or skill references them any more.

The plugin `version` is deliberately kept at upstream's `4.27.0` (no CHANGELOG churn / version-sync
break). The fork is identified by its repo, not its version.

## Syncing with upstream

```bash
# one-time
git remote add upstream https://github.com/rbinar/cli-dispatch.git

# to pull upstream changes
git fetch upstream
git merge upstream/main        # or: gh repo sync somos-a11y/cli-dispatch
# re-apply this prune if upstream re-adds any backend surface; conflicts, if any,
# will be in the files listed above.
```

After updating the fork, refresh the installed plugin so Claude Code loads the new content:

```bash
claude plugin marketplace update cli-dispatch
claude plugin update cli-dispatch@cli-dispatch
```

## Tests

```bash
node --test plugins/cli-dispatch/scripts/__tests__/*.test.mjs
```

Note: `takeover-integration.test.mjs` is a PTY/`script`-dependent integration test that can fail in
sandboxed/headless environments — unrelated to this fork.
