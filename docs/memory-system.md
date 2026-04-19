# Memory System

Clawrari uses files first, retrieval second.

The goal is continuity without mystery: the assistant should remember what matters, but every durable fact should still live in a file you can open, diff, and edit.

## Core Layout

```text
workspace/
├── IDENTITY.md
├── SOUL.md
├── USER.md
├── MEMORY.md
└── memory/
    ├── session-brief.md
    ├── subagent-ledger.md
    ├── YYYY-MM-DD.md
    ├── projects.md
    ├── people.md
    ├── preferences.md
    ├── regressions.md
    ├── rules-constitutional.md
    ├── rules-tactical.md
    ├── context-holds.md
    ├── predictions.md
    └── reference/
```

## What Each File Does

`IDENTITY.md`
- One-screen orientation: name, vibe, creature, emoji, operating principles.

`SOUL.md`
- Personality and stable behavior.
- Where the assistant learns how direct, concise, opinionated, and proactive it should be.

`USER.md`
- The human profile: priorities, writing style, approval model, preferences, and risk boundaries.

`MEMORY.md`
- Index of the memory system.
- Explains where each category of knowledge lives.

`memory/session-brief.md`
- The most important file in the whole system.
- Tight, current, high-signal context only.
- Think active priorities, recent decisions, blocked items, expiring holds, runtime state.

`memory/subagent-ledger.md`
- Append-only log of delegated tasks.
- Lets the main assistant recover from background work that stalled, finished, or went sideways.

`memory/YYYY-MM-DD.md`
- Raw daily notes.
- Recent activity gets written here before it deserves promotion elsewhere.

Thematic files
- `projects.md`, `people.md`, `preferences.md`, `regressions.md`, `rules-*`, `context-holds.md`, `predictions.md`.
- These hold durable patterns, not session chatter.

## Startup Discipline

The memory system only works if the assistant loads it in the right order.

Recommended load order:

1. `SOUL.md`
2. `USER.md`
3. `memory/session-brief.md`
4. `memory/subagent-ledger.md`
5. today and yesterday in `memory/YYYY-MM-DD.md`
6. `MEMORY.md` for main sessions

That order gives you:

- identity
- user context
- active priorities
- background continuity
- recency
- broader archival orientation

## Promotion Model

Do not dump everything into long-term memory.

Use a graduated path:

1. Raw event lands in the daily log.
2. If it still matters tomorrow, it belongs in the session brief.
3. If it matters next month, promote it into the correct thematic file.
4. If it should change future behavior, capture it as a regression, rule, or preference.

## Regressions and Guardrails

`memory/regressions.md` is one of Clawrari's strongest patterns.

Use it for mistakes worth preventing twice:

- repeated bad prompt behavior
- tool misuse
- stale config drift
- unsafe defaults
- workflow failures that need an explicit guardrail

Each regression should record:

- name
- failure pattern
- context
- fix or guardrail
- status

## Context Holds

Some instructions should persist temporarily, not forever.

`memory/context-holds.md` is for things like:

- "optimize for shipping this week"
- "treat task X as blocked until decision Y"
- "use draft-only mode for public content until Friday"

Every hold should have an expiry or review condition.

## Local Semantic Retrieval

Clawrari supports local semantic indexing over the markdown memory store.

Important distinction:

- The markdown files are the truth.
- The index is just a lookup accelerator.

That keeps the system:

- auditable
- cheap
- portable
- recoverable after failures

## Rules of Thumb

- Keep `session-brief.md` aggressively small.
- Append to the daily log freely; promote sparingly.
- Create new thematic files only when the category is stable.
- Search first, then read targeted sections.
- Prefer rewriting summaries over letting them grow indefinitely.
