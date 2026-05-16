# Night-Work Setup Recipe

How to configure Clawrari's autonomous night-work system so your AI works while you sleep — and you wake up to results, not surprises.

## The Problem

Day sessions are for thinking with your AI. Night sessions are for background execution: coding, research, maintenance, and personal-project progress. Without a structured setup, night work either doesn't happen or runs without guardrails.

## What You Need Before Starting

1. **OpenClaw installed and running** with a working agent configuration
2. **Cron daemon enabled** (OpenClaw's cron system, not system crontab)
3. **At least one coding agent** configured: Claude Code (`scripts/run-claude-code.sh`) or Codex (`scripts/run-codex.sh`)
4. **Workspace directory** with the standard Clawrari file layout

## Setup Steps

### Step 1: Create the Task Queue

Create `tasks/queue.md` in your workspace. This is the handoff point:

```markdown
# Task Queue — Night of YYYY-MM-DD

## Status: READY

### TASK A — <title>
- Goal: <what done looks like>
- Inputs: <files / links / context>
- Constraints: <anything to avoid>
- Expected output: <artifact path>
- Verification: <how to know it worked>
```

Keep it to 1–3 concrete tasks per night. Vague themes don't execute well.

### Step 2: Configure Cron Sessions

In your OpenClaw cron config, create 3–5 staggered sessions through the night:

```json
[
  {
    "schedule": "0 23 * * *",
    "task": "Night Work 1 — Read tasks/queue.md, spawn workers for first 1–2 tasks. Log to memory/YYYY-MM-DD.md.",
    "label": "night-1"
  },
  {
    "schedule": "0 1 * * *",
    "task": "Night Work 2 — Check progress on running tasks. Spawn next queued item if previous finished. Rotate personal-project standing slot if queue empty.",
    "label": "night-2"
  },
  {
    "schedule": "0 3 * * *",
    "task": "Night Work 3 — Final pass. Mark completed tasks. Run maintenance if queue empty. Log summary to daily notes.",
    "label": "night-3"
  }
]
```

Adjust times to your timezone. The key is: check-in, not continuous running.

### Step 3: Set Up the Personal Project Standing Slot

In `tasks/queue.md`, add this standing directive:

```markdown
## Standing Slot: Personal Project Night Work

At least 1 night-work session per night is dedicated to a personal project,
even when the queue is empty.

Rotation rule: pick the oldest `lastTouched` entry from
`memory/personal-projects-ledger.md` that has a valid autonomous task.
Good autonomous tasks:
- Market / competitive scans
- Naming sprints
- ExecPlan drafts
- Content drafts
- Repo/site scaffolding

After the session: log outcome in daily notes + update the ledger's `lastTouched`.
Do NOT send externally, purchase, or voice-call.
```

### Step 4: Configure Coding Agent Wrappers

Create wrapper scripts that handle auth and prompt piping:

**`scripts/run-claude-code.sh`:**
```bash
#!/bin/bash
WORKDIR="${1:-$HOME/.openclaw/workspace}"
cd "$WORKDIR" || exit 1
ANTHROPIC_API_KEY= claude --permission-mode bypassPermissions
```

**`scripts/run-codex.sh`:**
```bash
#!/bin/bash
WORKDIR="${1:-$HOME/.openclaw/workspace}"
cd "$WORKDIR" || exit 1
codex
```

**Critical:** Always pipe prompts via stdin. Never inline. Shell quoting breaks with complex prompts:

```bash
# ✅ Correct
echo 'Implement the feature described in docs/feature-spec.md' | ./scripts/run-claude-code.sh ~/my-project

# ❌ Wrong — quoting breaks
./scripts/run-claude-code.sh ~/my-project "Implement the feature..."
```

### Step 5: Set Up Logging

Every night session must log to:

1. **`memory/YYYY-MM-DD.md`** — what ran, what finished, what failed
2. **`memory/subagent-ledger.md`** — track spawned agents (status: 🔄 running → ✅ done / ❌ failed)

### Step 6: Safety Valves

Configure these limits in your AGENTS.md or SOUL.md:

| Rule | Value | Why |
|------|-------|-----|
| Max consecutive failures | 3 | Stop retrying a broken task |
| Respawn cooldown | 60s | Don't tight-loop on failures |
| Coding agent failover | Switch Claude ↔ Codex | Don't double-down on one agent |
| Max tasks per session | 3 | Quality over quantity |
| No external sends | Always | Night work never emails/posts |

## Verification

After your first night, check:

- [ ] `memory/YYYY-MM-DD.md` has entries with timestamps
- [ ] `memory/subagent-ledger.md` has rows for spawned agents with final status
- [ ] Tasks in `tasks/queue.md` are marked done or annotated with blockers
- [ ] No external actions were taken (no emails sent, no posts published)

## Common Issues

**Queue stays empty:** You're not filling it before bed. Make it a habit — 2 minutes before sleep, drop 1–3 tasks.

**Tasks fail silently:** Check the subagent ledger. If agents error within 60s, the prompt may be malformed. Switch from inline to piped prompts.

**Nothing autonomous happens:** Cron daemon may not be running. Verify with `openclaw gateway status` and check cron logs.

**Personal projects get ignored:** The standing slot only fires if you maintain `memory/personal-projects-ledger.md` with `lastTouched` dates. Keep it current.
