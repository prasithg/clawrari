# Linear Workflow Reference

**What this solves.** Most assistant-driven workflows treat issue trackers as a write-only dumping ground — ideas get captured, then stagnate, while live work happens in chat. This doc is the structural side of running Linear (or any ticket tracker) as a real operating system for an AI-assisted solo founder or small team: how teams, projects, states, labels, and priorities map onto the way Claw actually picks up work, files captures, and respects ownership. It pairs with `executive-ticket-protocol.md` (behavior of comments, escalation, and closeout) — together they keep the board from rotting.

> ⚡ **Read [`executive-ticket-protocol.md`](executive-ticket-protocol.md) first.** ETP defines how tickets are commented, escalated, and closed. This file covers Linear structure (teams/projects/states/labels); ETP covers the behavior that keeps the board healthy.

## Team & Identity

- **Workspace:** `<your-workspace>.linear.app`
- **Team name:** your Linear team (illustrative key below)
- **Team key:** `PRA` (ticket identifiers look like `PRA-12`) — used as the example team key throughout this doc
- **Team ID:** `<TEAM_ID>`
- **Privacy:** Private — only the owner + Claw have access. Nothing in this team leaks to the rest of the org.

## Projects

| Name | ID | Purpose |
|---|---|---|
| **Inbox** | `<EXAMPLE_PROJECT_ID>` | Raw captures, unclassified. Short-lived — triaged within 1–7 days. |
| **Work** | `<EXAMPLE_PROJECT_ID>` | Personal workstream grab-bag. Includes slow-burn initiatives not yet active enough for their own project (use title prefixes for grouping). |
| **Active build A** | `<EXAMPLE_PROJECT_ID>` | Example active project — OSS or community work currently being shipped. |
| **Active build B** | `<EXAMPLE_PROJECT_ID>` | Example active project — a separate product/build kept in its own project for focus. |

## The three gradients

Every ticket fits into one of these based on **current intent**, not ticket count:

1. **Raw capture** → Inbox / Backlog. "I haven't decided if this is real yet." Lifetime 1–7 days before the owner triages or cancels.
2. **Slow-burn / parked real-but-not-active** → Work / Backlog (or Todo if actionable). Use title prefix for grouping. No project pressure.
3. **Active build** → Dedicated project (graduate new ones as they earn focus).

## Project promotion rules

Either trigger creates a new dedicated project:

1. **Active build intent** — the owner plans to actively work on this within the next 30 days.
2. **5+ tickets accumulated** — volume alone justifies a dedicated home.

When creating, migrate existing related tickets into the new project (bulk-move via your Linear MCP `linear_edit_issue` or a script pattern).

Projects can be archived back to Work if the initiative goes dormant for 60+ days. Don't pre-create projects for hypothetical initiatives.

## Title prefix convention for slow-burn work in the Work project

Use consistent prefixes so Linear's full-text search groups them cleanly:

- `Product: ...` — tickets adjacent to an early product idea
- `Book: ...` — book / long-form writing tickets
- `Home: ...` / `Travel: ...` / etc. for personal life admin

When a prefix accumulates 5+ tickets or build intent kicks in, promote to a dedicated project and migrate.

## Team routing (pre-filter — run BEFORE the capture decision tree)

**This team is the owner's personal / Claw-builder board. It is NOT for company work.** Before filing any ticket, classify the source and route to the correct team:

| Source / topic | Team | Default project |
|---|---|---|
| Customer calls, discovery, account follow-ups | **Company Leadership team** | Customer-specific project |
| Product / FRD / market / sales / partner research | **Company Leadership team** | Product / Discovery project |
| Engineering work (FRDs, work orders, blueprints) | **Engineering team(s)** | Product project |
| Marketing, compliance, company goals, partnerships | **Company Leadership team** | Marketing / Compliance / Goals project |
| Personal ideas, Claw-infra, OSS, side builds, book, content engine, personal admin | **Personal team** (this team) | Inbox / Work / Active build A / Active build B |

**Hard rule:** If the ticket came from a company customer call or is about company product strategy — it goes to the company team, never the personal team. Ambiguous captures default to asking before filing >2 tickets in one batch.

**If you catch yourself filing 3+ related company tickets on the personal board, stop — you're on the wrong board.**

Reference IDs (placeholders):

- Company Leadership team: `<EXAMPLE_TEAM_ID>`
  - Todo state: `<EXAMPLE_TODO_STATE_ID>`
  - Canceled state: `<EXAMPLE_CANCELED_STATE_ID>`
- Example external projects: `<EXAMPLE_PROJECT_ID>`

## Capture decision tree

When Claw captures a new ticket from chat or a briefing channel (**after team routing above**):

```
Is this a direct instruction ("do X")?
  yes → Does a dedicated project exist for it?
         yes → that project / Todo / priority from urgency language
         no  → Work / Todo / priority from urgency language
               (prefix title if it belongs to a slow-burn initiative)
  no  (it's an idea/speculation) →
        Is it clearly scoped to an active project?
          yes → that project / Backlog
          no  → Inbox / Backlog for the owner to triage
```

Agents that create follow-up tickets mid-work (Symphony pattern) default to the same project as the parent ticket, Backlog status.

## Statuses (state machine)

| State | ID | Meaning |
|---|---|---|
| **Backlog** | `<BACKLOG_STATE_ID>` | Captured but not triaged. Claw files ideas here by default. |
| **Todo** | `<TODO_STATE_ID>` | Triaged and ready for Claw (or the owner) to pick up. **Signal that Claw can act.** |
| **In Progress** | `<IN_PROGRESS_STATE_ID>` | Actively being worked on (agent spawned, or the owner working on it). |
| **In Review** | `<IN_REVIEW_STATE_ID>` | Proof-of-work delivered. Awaiting accept/reject. |
| **Done** | `<DONE_STATE_ID>` | Accepted by the owner. Shipped. |
| **Canceled** | `<CANCELED_STATE_ID>` | Not doing this. |
| **Duplicate** | `<DUPLICATE_STATE_ID>` | Already covered by another ticket. |

## Labels

| Name | ID | Use |
|---|---|---|
| **`blocked`** | `<BLOCKED_LABEL_ID>` | Single team-scoped label. Apply when waiting on external input or info. Claw does NOT pick up `blocked` tickets. |

**No other custom labels for MVP.** Workspace-scoped labels inherited from the parent workspace — ignore them. Don't apply them to personal tickets.

## Priority field (drives timing)

Linear priorities: `0` (No priority), `1` (Urgent), `2` (High), `3` (Medium), `4` (Low).

| Priority | When Claw acts |
|---|---|
| **1 Urgent** | Immediately — during any main session, heartbeat, or cron run |
| **2 High** | Next main session when the owner is active |
| **3 Medium** | Night-work queue (picked up by Night Work 1) |
| **4 Low** | Night-work queue (eligible, low rank) |
| **0 No priority** | Night-work queue (only if higher-priority queue is empty) |

## Capture flow (how tickets get created)

Claw files tickets when the owner:

- Says "idea: X" or drops something interesting in chat → new issue in **Inbox**, status **Backlog**, no priority
- Says "do X" or a direct actionable instruction → new issue in appropriate project, status **Todo**, priority inferred from urgency language
- Posts to a briefing channel with ideas/instructions (picked up by an hourly RLHF cron) → same rules apply
- Agents spawn follow-up tickets during work (Symphony pattern: "I noticed Y while doing X — filing a new ticket") → new issue in the same project as parent, status **Backlog**, linked as related

**Claw never creates tickets in engineering team queues** (that's company engineering work, not personal). Exception: if the owner explicitly says "file this as a company ticket on the engineering team."

## Workflow (Symphony-style state machine)

```
Owner drops idea in chat
         │
         ▼
   Inbox / Backlog
         │
         │ Owner triages, promotes
         ▼
   Project / Todo
         │
         │ Claw picks up (timing by priority)
         │ — sets status=In Progress
         │ — spawns agent
         │ — posts proof-of-work comment
         ▼
   In Review (awaits owner)
         │
         ├─ Owner approves → Done
         ├─ Small tweaks needed → comment + Todo (retry async) or open session live
         └─ Not doing → Canceled
```

Blocker detour: any ticket in Todo or In Progress can get `blocked` label applied. Claw reads `blocked` and skips it. When the owner removes the label, Claw can pick it up again.

## Standard proof-of-work comment (when moving to In Review or Done)

**See [`executive-ticket-protocol.md`](executive-ticket-protocol.md) §"Proof-of-work template" for the canonical version.** Rule: self-contained (don't make the owner open a file to understand status), includes TL;DR, acceptance criteria grading, shipped artifacts, verification, and what the ticket unlocks. The old template pointed at `reports/*.md` files; the ETP version pastes the summary into the ticket.

## Cron Linear query patterns

All via `mcporter call linear.*`. Team ID placeholder: `<TEAM_ID>`.

**Pick tickets for night-work:**
```bash
mcporter call linear.linear_search_issues '{"teamIds":["<TEAM_ID>"],"states":["Todo"]}'
# Then filter out: any ticket with `blocked` label; Inbox project tickets (those are for triage, not execution)
# Rank by priority (Urgent > High > Medium > Low > No priority)
# Pick 2–4 based on scope
```

**Flag stale tickets (for Linear Stale Ticket Scan cron):**
```bash
# Todo tickets updated >3 days ago
# In Progress tickets updated >48h ago (agent crashed or stuck)
# Blocked tickets with no activity >7 days (ping the owner about unblocking)
```

**Create a ticket from chat capture:**
```bash
mcporter call linear.linear_create_issue '{"teamId":"<TEAM_ID>","title":"...","description":"...","labelIds":[]}'
# Then linear_edit_issue to set projectId, stateId, priority
```

**Move to In Progress:**
```bash
mcporter call linear.linear_edit_issue '{"issueId":"<uuid>","stateId":"<IN_PROGRESS_STATE_ID>"}'
```

**Move to In Review with proof-of-work:**
```bash
mcporter call linear.linear_edit_issue '{"issueId":"<uuid>","stateId":"<IN_REVIEW_STATE_ID>"}'
mcporter call linear.linear_create_comment '{"issueId":"<uuid>","body":"## Proof of work ..."}'
```

## Decision Cards & recommendation-in-comment

Any ticket that needs the owner's decision uses the **Decision Card** format defined in [`executive-ticket-protocol.md`](executive-ticket-protocol.md) §2. Summary: one-line ask, recommendation + auto-action-if-silent, options with tradeoffs, 30–60 word context, clear reply path (👍 or `PRA-XX:A/B/C`). Decision Cards are simultaneously posted to the ticket AND aggregated into the daily Decision Queue digest.

### Recommendation-in-comment protocol (always on)

When a Linear ticket is in an **Awaiting Decision** state — In Review, or Todo with open questions that need the owner's call — and that ticket has research / evaluation / proof-of-work produced by an agent (night-work, subagent, or main-session spike):

1. Write the **synthesis + explicit recommendation** as a comment on the ticket *first*. Structure: one-line recommendation (go / no-go / defer), 2–4 supporting signals with evidence, proposed next steps.
2. *Then* surface the same synthesis in chat for the real-time decision.
3. Never answer "what do you recommend?" or "should we proceed?" in chat-only without the same answer landing in the ticket comment thread.

The ticket is the permanent record; chat is the real-time channel. Both get the recommendation. Applies to evaluations, research spikes, bug diagnoses, architecture proposals, cost/benefit analyses — any artifact whose next step is a human decision. Does NOT apply to pure build work where the PR + proof-of-work comment already captures the decision.

## Triage protocol (Inbox cleanup)

When the owner asks for triage, or Claw does it passively in a main-session idle moment:

1. Read all **Inbox / Backlog** tickets.
2. For each:
   - Can it be consolidated with an existing ticket? (duplicate → link and mark)
   - Is it actionable now? (promote to Todo in the right project)
   - Is it a speculative idea? (leave in Backlog but add a 1-line take or related-context comment)
   - Is it stale / obsolete? (propose Canceled, don't auto-cancel)
3. Surface proposed moves for the owner's approval before executing (unless the move is obvious like consolidation).

## Deprecated (what this replaces)

- **`ideas/inbox.md`** — old idea capture file. One-time migration converts existing entries to Linear Inbox / Backlog tickets. New ideas go to Linear, not this file.
- **`tasks/queue.md`** — old night-work queue. One-time migration converts active items to Linear / Todo tickets. New tasks go to Linear.
- **`memory/personal-projects-ledger.md`** — kept for now as an overview log, but the authoritative state is Linear project health.

## Changelog

- 2026-05-10 — Linked `executive-ticket-protocol.md` (ETP) as the behavior spec. Proof-of-work template moved to ETP (self-contained rule). Decision Card format introduced. Lifecycle gates now mechanically enforced.
- 2026-05-03 — Initial creation. Team structure, state machine, Symphony-style orchestration pattern adopted. Inspired by [OpenAI Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/).
