# Architecture

How the pieces of a Clawrari setup connect.

## Workspace Structure

```
~/.openclaw/workspace/
├── SOUL.md          # AI personality, values, operating principles
├── USER.md          # Human context: who they are, priorities, permissions
├── AGENTS.md        # Session protocol: what to read, how to behave
├── HEARTBEAT.md     # Cron definitions: health checks, briefings, periodic tasks
├── MEMORY.md        # Memory index: points to focused memory files
├── IDENTITY.md      # AI identity: name, birthdate, setup version
├── TOOLS.md         # Environment-specific tool notes
│
├── memory/          # Persistent memory
│   ├── YYYY-MM-DD.md    # Daily logs (raw, append-only)
│   ├── projects.md      # Active project tracking
│   ├── people.md        # Relationship context
│   ├── preferences.md   # Human's patterns and preferences
│   └── operating-rules.md  # Learned rules and corrections
│
├── tasks/           # Async work queue
│   └── queue.md     # Night work, background tasks
│
├── drafts/          # Content awaiting review
├── reports/         # Generated analysis and research
├── ideas/           # Quick capture inbox
└── systems/         # Internal automation (annotation loop, etc.)
```

## Information Flow

```
Human Input (chat, annotations, Slack feedback)
    │
    ▼
┌─────────────────────┐
│  Session Bootstrap   │  ← Reads SOUL + USER + MEMORY + daily notes
│  (every conversation)│
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Task Execution     │  ← Uses skills (Slack, GitHub, Gmail, etc.)
│                      │  ← Spawns sub-agents for complex work
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Memory Write-back  │  ← Updates daily notes, long-term memory
│                      │  ← Logs decisions and outcomes
└─────────────────────┘
```

## Feedback Loops

1. **RLHF Channel** — Human reacts/replies to AI output → corrections applied to behavior
2. **Annotation Loop** — Human edits workspace files with inline feedback → AI processes and learns
3. **Self-Audit** — Daily cron reviews own performance → updates operating rules
4. **Memory Curation** — Stale info archived, not deleted. Relevance scoring over time.

## Security Model

- **Local-first** — All data stays on the machine
- **Permission tiers** — Internal actions (free) vs. external actions (require approval)
- **Weekly audits** — Automated permission and anomaly review
- **No data exfiltration** — Hard rule, no exceptions
