# Architecture

Clawrari is a three-layer operating model for OpenClaw.

## Layer 1: Memory

This layer gives the assistant continuity across sessions without turning the workspace into a hidden black box.

Core files:

- `SOUL.md`: durable personality, operating principles, and non-negotiable behavior
- `USER.md`: who the assistant is helping, preferences, constraints, and approval boundaries
- `IDENTITY.md`: short identity card used for quick orientation
- `MEMORY.md`: index of long-term memory files
- `memory/session-brief.md`: the 50-line preconscious buffer loaded first
- `memory/subagent-ledger.md`: append-only record of delegated work
- `memory/YYYY-MM-DD.md`: daily notes and raw recency capture
- `memory/*.md`: thematic long-term files for projects, people, preferences, regressions, rules, holds, and predictions

Key idea: files remain the source of truth. Semantic indexing can accelerate retrieval, but it should never replace direct editability.

## Layer 2: Behavioral

This layer tells the assistant how to behave, not just what to remember.

Core files:

- `AGENTS.md`: startup sequence, safety rules, working norms
- `HEARTBEAT.md`: recurring health checks, RLHF scan, freshness routines, connector drift checks
- `reference/model-playbook/`: routing table plus model-specific overlays and prompting rules

The behavioral layer is what turns a collection of prompts into an operating system.

Recommended startup order:

1. Read `SOUL.md`
2. Read `USER.md`
3. Read `memory/session-brief.md`
4. Scan `memory/subagent-ledger.md`
5. Read today and yesterday from `memory/YYYY-MM-DD.md`
6. In the main session, read `MEMORY.md`

## Layer 3: Skills and Connectors

This layer does the work.

Representative skill categories:

- daily operations: morning briefing, responsive check, meeting debrief
- research and content: research, daily digest, content engine, publish pipeline
- execution: coding agent, night work, self-improving agent
- integrations: Slack, GitHub, Linear, Figma, Google Workspace, browser tooling

Clawrari treats skills as reusable workflows, not one-off scripts.

## Supporting Runtime

The layers run on top of a standard OpenClaw installation with:

- a local gateway
- a browser profile the agent can drive safely
- local-first memory storage
- optional local semantic search over markdown files
- model routing across premium, research, and background execution models

## System Diagram

```text
                  +-----------------------------+
                  |         OpenClaw           |
                  |   runtime / sessions /     |
                  |   cron / browser / tools   |
                  +--------------+--------------+
                                 |
        +------------------------+------------------------+
        |                         |                        |
        v                         v                        v
 +-------------+          +---------------+        +---------------+
 |   Memory    |          |  Behavioral   |        |    Skills     |
 | files + QMD |          | instructions  |        | + connectors   |
 +------+------+          +-------+-------+        +-------+-------+
        |                         |                        |
        v                         v                        v
 session-brief            AGENTS / HEARTBEAT      briefings / coding
 daily logs               model overlays          research / Slack
 regressions              approval rules          GitHub / GWS / etc.
 context holds
```

## Why This Split Works

- Memory without behavior becomes a messy vault.
- Behavior without memory feels stateless.
- Skills without either become disconnected tricks.

Clawrari works because each layer stays narrow and inspectable.
