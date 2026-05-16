# TOOLS.md — Example

This is an example `TOOLS.md` showing the kind of entries that make a Clawrari workspace self-documenting. Copy this to your workspace root and fill in your own details.

Keep it under ~100 lines. Verbose reference material goes in `reference/tools-reference.md`.

## Google Workspace (gws CLI)

- **Account:** you@domain.com (OAuth, keyring)
- **Works:** Calendar, Drive, Gmail, Sheets, Docs, Slides, Tasks, Chat, Meet, Forms, Keep
- **Common commands:**
  ```bash
  gws calendar events list --days 7
  gws gmail messages list --max 10
  gws drive files list --query "name contains 'report'"
  gws sheets values get <sheetId> Sheet1!A1:D10
  ```
- **Gotchas:** Output is JSON. Use `gws schema <service>.<resource>.<method>` to inspect params.

## GitHub (gh CLI)

- **Account:** your-handle
- **Scopes:** repo, read:org, workflow
- **Common commands:**
  ```bash
  gh pr list --repo org/repo
  gh issue create --title "Bug" --body "Description"
  gh run list --limit 5
  ```

## Coding Agents

- **Claude Code:** `scripts/run-claude-code.sh [workdir]` — pipes prompt via stdin
- **Codex CLI:** `scripts/run-codex.sh [workdir]` — pipes prompt via stdin
- **Priority:** Claude Code (Max plan) → Codex (Pro) → sessions_spawn (real $)
- **Never** spawn raw `codex exec "..."` or `claude "..."` with inline prompts — shell quoting breaks. Always pipe.

## Browser Automation

- **Primary:** OpenClaw `browser` tool (CDP, persistent session)
- **For coding agents:** Playwright headless via `agent-browser` CLI
- **Research:** `web_search` for general web, `browser` for logged-in sites

## Search

- `rg` (ripgrep) for local file search
- `web_search` (Perplexity Sonar) for web queries

---

Add entries as you connect new tools. Keep each entry to: account, auth, common commands, gotchas.
