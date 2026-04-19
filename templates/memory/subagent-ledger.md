# Subagent Ledger

Append-only tracking table for all spawned subagents. Check this at session start.

## Ledger

| Date | Label | Task Summary | Expected Output Path | Status | Validation | Result Notes |
|------|-------|--------------|----------------------|--------|------------|--------------|
| YYYY-MM-DD HH:MM | example-agent | Example research task | reports/example-report.md | 🔄 running | ⏭️ skipped | Add the row before you spawn the agent. |

## Status Rules

- `🔄 running` — in progress, output not verified yet
- `✅ done` — output exists and is usable
- `❌ stale` — no output after the expected window
- `⚠️ failed` — agent completed but failed acceptance criteria

## Protocol

1. Add a row before spawning a subagent.
2. At session start, scan for stale rows and surface them in `memory/session-brief.md`.
3. For coding tasks, run validation before marking the task done.
