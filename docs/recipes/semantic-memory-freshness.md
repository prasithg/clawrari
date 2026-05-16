# Semantic Memory Freshness Recipe

Keeping memory accurate over time requires active maintenance. This recipe describes the freshness protocol used in Clawrari.

## The Problem

Memory files drift. Daily logs accumulate stale entries. Predictions expire without resolution. Context holds linger past their relevance. Without active curation, the memory system degrades into noise.

## Protocol

### 1. Session Brief (every session start)

`memory/session-brief.md` is the 50-line preconscious buffer. It should:
- Reflect the **current** state, not historical state
- Be updated at the end of every session that changes context
- Never exceed 50 lines — if it's too long, something isn't being archived properly

### 2. Daily Log Rotation

- Write to `memory/YYYY-MM-DD.md` during the session
- At session end, archive completed items (don't delete — just stop re-listing them)
- If a daily file exceeds 200 lines, it's time to extract summaries

### 3. Weekly Memory Audit (cron or manual)

Once per week, review:

| File | Check | Action |
|------|-------|--------|
| `MEMORY.md` | Stale entries? Wrong dates? | Update or remove |
| `memory/session-brief.md` | Reflects current reality? | Rewrite if stale |
| `memory/subagent-ledger.md` | Rows >48h old with no output? | Flag as stale, mark complete or kill |
| `memory/predictions.md` | Any predictions past their resolution date? | Resolve them |
| `memory/regressions.md` | Old regressions still relevant? | Close if fixed |
| `tasks/queue.md` | Stale tasks? | Clear completed, flag blocked |

### 4. Staleness Nudge Rule

For personal projects and active tasks: if `lastTouched` is >2 days old, surface it in the next main-session reply. This is the staleness nudge from `SOUL.md`.

Implement by tracking dates in `memory/personal-projects-ledger.md` (or any tracking file) and checking on session start.

### 5. Archive Cadence

- Daily logs older than 30 days → keep as-is (don't auto-delete, they're valuable for recall)
- `MEMORY.md` should be curated, not accumulated. Extract long-form content to `reports/` or project-specific files.

## Implementation

No code required — this is a protocol enforced through `AGENTS.md` and `SOUL.md`. The session-start routine naturally checks freshness as part of the bootstrap sequence.

If you want automated checks, add a cron entry:

```json
{
  "schedule": "0 3 * * 0",
  "task": "Weekly memory audit. Check session-brief, subagent-ledger, predictions, regressions for staleness. Report findings to daily notes."
}
```

## Anti-Patterns to Avoid

- **Never auto-delete memory files.** Old context is valuable for recall.
- **Never let session-brief grow unbounded.** 50 lines is the hard cap.
- **Never skip the session-start read of session-brief.** It exists so you don't re-scan everything.
- **Don't over-structure.** If you need 15 tracking files, the system is too complex. 4-6 files is the sweet spot.
