# Task Management

Structured async task execution for personal AI systems.

Most AI setups have a "tell it to do something" workflow. Clawrari extends this with a proper task system: structured queue, sub-agent tracking, failure visibility, and goal ancestry. Borrowed from company orchestration platforms (like Paperclip), distilled down to what a personal AI actually needs.

---

## The Core Problem

Without structure, AI task management degrades fast:

- Sub-agents fail silently — results never appear, no one knows why
- Tasks start from scratch every session — no context carries forward
- Two heartbeat sessions spawn duplicate sub-agents for the same task
- Locally-correct/globally-wrong decisions — agents don't know the "why"
- Failed work disappears — no record of what was attempted, what errored

Clawrari's task management system fixes all of these.

---

## Queue Format

Every task in `tasks/queue.md` follows a structured format:

```markdown
### [P1] Task Name
- **Type:** code | research | ops | content
- **Goal context:** Why this matters. Traces back to a meaningful objective.
- **Acceptance criteria:** Observable done condition — testable, not vague.
- **Sub-tasks:** (optional)
  - [ ] Step A
  - [ ] Step B
- **Status:** pending
- **Agent label:** (filled when claimed)
- **Started:** (timestamp when claimed)
```

### Why Goal Context Matters

The `goal context` field is the most important field. Without it, agents optimize locally. With it, they understand tradeoffs and make decisions aligned with the actual objective.

Example of a locally-correct/globally-wrong decision: an agent implements the fastest solution to a task that turns out to violate an operating rule the agent didn't know about. Goal context + a reference to operating constraints prevents this.

---

## Task State Machine

Tasks progress through explicit states:

```
pending → claimed → in_progress → done
                              ↘ failed
                              ↘ blocked
```

| Status | Meaning |
|--------|---------|
| `pending` | Not yet picked up |
| `claimed` | Agent is about to spawn for this — prevents duplicate spawning |
| `in_progress` | Sub-agent actively working |
| `done` | ✅ Completed, output confirmed |
| `failed` | ❌ Failed — see `systems/failures/` |
| `blocked` | Waiting on something external |
| `skipped` | Intentionally deferred |

### Atomic Claiming

Before spawning a sub-agent, write `claimed (agent-label, timestamp)` to the Status field. This prevents two heartbeat sessions from spawning duplicate agents for the same task.

---

## Sub-Agent Ledger

`memory/subagent-ledger.md` — an append-only record of every sub-agent spawned.

```markdown
| Date | Label | Task | Expected Output | Status |
|------|-------|------|-----------------|--------|
| 2026-03-08 09:47 | community-scan | Weekly community scan | reports/community-2026-03-08.md | ❌ FAILED |
| 2026-03-08 10:16 | research-agent | Research task X | reports/research-2026-03-08.md | ✅ DONE |
```

**Session start protocol:**
1. Scan ledger for any 🔄 IN PROGRESS rows
2. Check if the Expected Output file exists
3. If missing and >2h old: mark ⏳ STALE, add to open loops in session-brief.md

**Before spawning:**
1. Write the ledger row first
2. Include the exact expected output file path

This turns "silent failure discovered 4 sessions later" into "stale flag surfaced at next session start."

---

## Failure Artifacts

When a sub-agent fails or a task goes wrong, write a structured record.

`systems/failures/YYYY-MM-DD-task-slug.md`:

```markdown
# Failure: task-slug
- **Task:** Task description
- **Agent label:** agent-label
- **Attempted:** YYYY-MM-DD HH:MM TZ
- **Failure mode:** What went wrong
- **What was completed:** Steps that succeeded
- **What was lost:** Steps that failed
- **Retry plan:** What needs to change to retry successfully
- **Status:** needs-retry | resolved | abandoned
```

Key principle (from Paperclip): **Surface problems, don't hide them.** Automatic recovery hides failures. Explicit failure records mean every failure is visible, learnable-from, and retryable.

---

## Session Brief Integration

The `memory/session-brief.md` preconscious buffer ties task management to session startup:

```markdown
## Active State
- Active sub-agents: agent-label (task-description)

## Open Loops
- community-scan failed silently — needs re-run
```

The session brief is read FIRST at session start. Any stale sub-agents or failed tasks surface immediately — not buried in 13KB of daily logs.

---

## Priority Levels

| Level | Meaning |
|-------|---------|
| P1 | High priority — should run next available background session |
| P2 | Medium priority — run after P1s are clear |
| P3 | Low priority / backlog — run when nothing else is queued |

P1 items should have full goal context and acceptance criteria before being added. P2/P3 items can be less structured initially.

---

## What Makes a Good Task

**Good task:**
```markdown
### [P1] Build user export script
- **Type:** code
- **Goal context:** Finance needs monthly billing reconciliation. This unblocks the Q1 finance close.
- **Acceptance criteria:** `npx ts-node scripts/export-users.ts` produces CSV with correct columns, no errors, handles empty result gracefully.
- **Status:** pending
```

**Bad task:**
```markdown
### [P1] Fix the export thing
- Status: todo
```

The bad version will produce worse results because the agent doesn't know what "export thing" means, what "fix" means, or why it matters.

---

## Relationship to Heartbeat

The heartbeat (periodic background session) should:

1. **Read session-brief.md** for active context
2. **Scan subagent-ledger.md** for stale/failed agents
3. **Scan tasks/queue.md** for pending P1 tasks
4. **Claim + spawn** sub-agents for eligible tasks
5. **Check systems/failures/** for unresolved failure records

Don't spawn for already-claimed or in-progress tasks. The claim field prevents duplicate work.
