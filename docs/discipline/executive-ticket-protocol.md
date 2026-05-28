# Executive Ticket Protocol (ETP)

**What this solves.** A ticket board run by an AI assistant tends to fail in the same five ways: night-work artifacts ship but no closing comment lands, owner comments go unanswered, "low-agency" recommendations replace clear calls, tickets dangle pointers at external `reports/*.md` files instead of summarizing in-place, and migrated idea-dumps become permanent grab-bag tickets. This protocol mechanically removes all five with a self-contained comment rule, a Decision Card format, lifecycle gates with auto-actions, a default-to-execute rule for reversible work, and a no-dangling-promises convention. Pair it with [`linear-workflow.md`](linear-workflow.md), which covers the structural side (teams, projects, states, labels).

**Status:** Active (2026-05-10). Supersedes the proof-of-work comment section in [`linear-workflow.md`](linear-workflow.md).

**One-line rule:** Every ticket either ships to Done/Canceled or carries a self-contained Decision Card that lets the owner decide in <30 seconds. No "see reports/xxx.md" dangling references. No "proof-of-work will follow" promises. No ticket sits In Progress for 48h without a state change.

---

## Why this exists

A real board review surfaced 14 In Progress / 3 In Review / 5 Todo with stale comments, orphaned night-work, and tickets that referenced `reports/*.md` files instead of summarizing the work in the ticket. Root causes:

1. **Night-work crons start, agents deliver artifacts, but nobody files the closing Linear comment.** The ticket stays In Progress forever.
2. **The owner's Linear comments go unanswered** because no cron or main-session trigger watches for them.
3. **Low-agency pattern** — "here's the research, let me know what you think" instead of "here's the research, here's the call, here's the deadline for your override."
4. **File-reference anti-pattern** — tickets point at `reports/foo.md`, forcing the owner to context-switch to understand status.
5. **Grab-bag tickets** — migrated idea-dump entries get treated as single tickets and never resolve.

ETP fixes all five.

---

## The five rules

### 1. Self-contained comment rule

A ticket comment must be readable **without opening any other file, report, or link**. If a report exists, paste the exec summary (TL;DR + key findings + recommendations) into the comment. Link to the report as a supplement, not a substitute.

✅ Good:
> **Done:** CLI upgraded 2.1.123 → 2.1.133. Wrapper now sets `CLAUDE_CODE_SESSION_ID` + `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1` by default. RoutineSpec v0 shipped as a YAML schema with 3 worked examples.
> **Impact:** Night-work runs now have traceable session IDs and clean log output. RoutineSpec gives us a lint target for the 16 cron jobs.
> **Full details (supplement):** `reports/claude-dev-day-claw-improvements-2026-05-07.md`

❌ Bad:
> Night work done. See `reports/claude-dev-day-claw-improvements-2026-05-07.md`.

### 2. Decision Card pattern

Any ticket that needs owner input uses this exact structure as the most recent comment. No variation.

```markdown
## 🎯 Decision needed — PRA-XX

**Ask:** [One sentence. "Approve X?" / "Pick A or B?" / "Cancel this?"]

**Recommendation:** [Default action I'm taking unless overridden]

**Auto-action if no response by [DATE]:** [What happens with silence]

**Why it matters:** [1–2 sentences — what's at stake]

**Options:**
- **A. [option]** — [one-line tradeoff] `[recommended]`
- **B. [option]** — [one-line tradeoff]
- **C. Cancel this ticket** — [one-line reason it's defensible to drop]

**What's been done:** [30–60 words. What I built, what I learned, what's the artifact.]

**How to answer:** React 👍 (approve recommendation), comment with letter (A/B/C), or just reply with a veto.
```

The Decision Card is simultaneously:

- A Linear comment on the ticket (permanent record)
- A row in the daily Decision Queue digest (the owner's review surface)

### 3. Lifecycle gates (mechanical)

These are enforced by the `Linear Board Hygiene` cron (runs every 4 hours) and the Night Work close-out step. No human discretion — tickets move automatically.

| State | Max dwell time | What happens at expiry |
|---|---|---|
| **In Progress** (no work landed) | 48h | Force-move to Todo + `blocked` label + Decision Card asking if this should still be a ticket. |
| **In Progress** (artifacts exist) | 24h after artifact timestamp | Force-close with proof-of-work comment → In Review. |
| **In Review** | 3 days | Auto-accept → Done. Post a digest entry: "I'm accepting PRA-XX unless you reply in the next 24h." |
| **Todo + `blocked`** | 7 days | Decision Card re-pinged in the digest. 14 days with no response → Cancel with "stale, no input" comment. |
| **Backlog** | 30 days | Cancel with "stale idea, not picking up" comment. The owner can reopen. |
| **Todo** (unblocked) | 10 days | Night-work must pick up OR demote to Backlog. |

### 4. Default-to-execute rule

Before escalating to the owner, run this self-audit:

1. **Is this reversible?** (can be undone in <10 min) → Just do it.
2. **Is this destructive/external/financial?** (emails, public posts, spending) → Must escalate.
3. **Is the downside bounded?** (worst case is "we redo it") → Just do it, label the decision `[claw-decision]` in the ticket so the owner can veto.
4. **Is the uncertainty intellectual?** (taste, strategy, voice) → Make the call with labeled confidence. The owner can override.

If any escalation reaches the owner, the next comment on that ticket must answer: **"Could I have made this decision myself? If no, why not?"** This prevents escalation creep.

### 5. No dangling promises

Remove the "proof-of-work comment will follow when done" pattern entirely. Replace with:

- **Kickoff comment** (only if the ticket wasn't already In Progress):
  > 🤖 Starting. Agent: [x]. Expected artifacts: [brief list]. **Completion comment by [time]** or I'll post a blocker update.

- **Close-out comment** (mandatory, same run):
  > **Done/Partial/Failed.** [2–4 bullets of what shipped]. **Next:** [specific next action OR Decision Card].

If the agent run fails, the **run's wrapper must still post the failure comment with the error** — no orphaning. This is enforced by the night-work cron and wrapper scripts.

---

## Ticket scope discipline

- **One ticket = one resolvable outcome.** If it's a grab-bag, split it.
- Title starts with an active verb and names the outcome ("Ship X", "Research Y", "Decide Z").
- Description includes acceptance criteria. Without ACs, it's not a ticket — it's a note. Route notes to Backlog/Inbox.
- "Idea dump" migrations (from `ideas/inbox.md` etc.) → break up at migration time, don't create one mega-ticket.

---

## Proof-of-work template (evolution of the old template)

Used when moving a ticket to In Review or Done. Replaces the old version in [`linear-workflow.md`](linear-workflow.md).

```markdown
## ✅ Proof of work — PRA-XX

**TL;DR (1 sentence):** [What shipped, in human language.]

**Acceptance criteria:**
- [x] [AC 1] — [evidence in 1 line]
- [x] [AC 2] — [evidence]
- [ ] [AC 3 not done] — [why, if applicable]

**Shipped:**
- [artifact] — [1-line impact]
- [artifact] — [1-line impact]

**Verification:** [test command + output OR screenshot path OR "verified by [agent]"]

**What this unlocks:** [Next thing now possible because this is done.]

**Cost/time:** [approx $ + wall clock]

**Full details (supplement):** [report path, PR, branch]

**For the owner:** [One sentence — what, if anything, you need to do. Default: "Nothing. Moving to Done unless you reject within 5 days."]
```

---

## Daily Decision Queue (chat/digest surface)

The `Linear Board Hygiene` cron posts one consolidated message to the owner's briefing channel at 08:00 local time daily:

```
🎯 Decision Queue — YYYY-MM-DD

High-priority decisions (react 👍/👎 or reply with PRA-XX:A/B/C):

1. PRA-48 — Productize life with AI brand (example)
   Ask: Approve brand thesis doc direction?
   Auto-action in 3 days: Accept draft as v1 and start publishing.
   [link]

2. PRA-59 — Codex /goal adoption (example)
   Ask: Run calibration on PRA-13 (small ticket) or skip straight to night-work?
   Auto-action in 2 days: Run calibration on PRA-13.
   [link]

(N tickets expiring in 24h) (M in blocked>7d)
```

Reactions + `PRA-XX:A` replies route back into the main session via the existing RLHF cron.

---

## Night-work close-out discipline (changes to `night-work` skill)

Every night-work agent that touches a Linear ticket **must**:

1. On kickoff: file the Kickoff comment (§5).
2. On completion OR failure: file the Close-out comment (§5) **before the cron exits**. Not after. Not "when done" in a separate run.
3. On timeout: the wrapper's `trap EXIT` handler files a "TIMED OUT at $(date), partial work preserved at [path]" comment automatically.
4. If artifacts shipped without a close-out comment in the same run (agent crashed), the next-morning `Night Work Completion Sweep` finds the orphan, reads the artifact, and files a catch-up close-out comment.

---

## Hygiene / escalation crons

| Cron | Schedule | Job |
|---|---|---|
| **Linear Board Hygiene** | every 4h | Enforce lifecycle gates (§3). Move expired tickets. Post daily Decision Queue at 08:00. |
| **Night Work Completion Sweep** | 06:00 local time daily | Find In Progress tickets from last night's work without close-out comments. Read the artifact. File catch-up comment. Move state. |
| **Comment Responder** | every 15 min during waking hours | Detect new owner comments on tickets without a Claw response. Wake main session with the context. |

---

## Linear Comment Responder cron (closes the comment loop)

Implemented as `scripts/linear-comment-responder.mjs`, registered as cron `Linear Comment Responder`. Runs every 15 min during waking hours. This is the cron that converts owner comments into Claw actions — without it, every owner comment is invisible until the next human-initiated session.

### What it does each tick

1. Reads `memory/heartbeat-state.json.lastChecks.linear_comments_ts` as the high-water mark. Anything ≤ that timestamp is skipped. Anything older than 48h is also skipped (no backlog rehydration).
2. Pulls personal-team tickets updated in the last 24h via `mcporter call linear.linear_search_issues`.
3. For each ticket, fetches comments and keeps only ones authored by the owner (matched by Linear user ID `<OWNER_USER_ID>` or the owner's display name, case-insensitive). Bot/cron/agent comments are ignored.
4. Classifies each comment into one of four buckets (see below).
5. Applies the matching action.
6. Appends a line to `memory/linear-comment-responder.log.md`.
7. Advances `lastChecks.linear_comments_ts` to the newest comment timestamp processed.

### Classifier rules (precedence order)

1. **`approval`** — comment matches `PRA-\d+:[ABC]` (case-insensitive) OR is a bare `👍`.
2. **`urgent-question`** — comment ends with `?`, OR contains a question word (`where/when/why/what/who/how/which`) plus a `?`.
3. **`instruction`** — first sentence starts with an imperative verb (`do/run/move/cancel/close/reopen/start/stop/kill/pause/resume/ship/build/fix/investigate/check/deploy/delete/create/update/change/switch/push/merge/revert`). FYI markers (`fyi`, `nb`, `note:`, `heads up`, `btw`) downgrade to informational.
4. **`informational`** — fallthrough.

### Actions per classification

- **`urgent-question` / `instruction`** → fires `openclaw system event --mode now --text "<context>"` to wake the main session with the ticket URL + comment body. No comment posted back (the main session will follow up).
- **`approval` with option A** → finds the most recent Decision Card (`## 🎯 Decision needed` header), confirms `A` matches a parsed option, posts an `## ✅ Auto-applying option A` comment, and — only if the ticket is currently In Progress — moves it to **In Review**. The cron **never** moves anything to Done; that gate stays with the owner or the Board Hygiene 3-day auto-accept.
- **`approval` with option B or C** → posts a clarification comment asking whether to execute the option verbatim or wait for a fuller plan. No state change. We never guess on non-default paths.
- **`approval` with no Decision Card found** → posts a "no card to anchor against" follow-up. No state change.
- **`informational`** → log line only. (Slack reaction wire isn't built yet; revisit when there is a Linear-comment → chat-ts mapping.)

### Hard rules baked into the script

- Only the owner's comments trigger action.
- Comments > 48h old are skipped silently.
- The cron **cannot** move tickets to Done or Canceled. It can move In Progress → In Review and post comments.
- All side effects (comments + state changes) are gated by a `--dry-run` flag for local testing.
- No external sends, no DMs, no public posts. Optional chat alerts go to a single configured channel via `openclaw message send`.

### Unit tests

`tests/linear-comment-responder.test.mjs` covers the classifier (8+ fixture comments), `parseApprovalOption`, `parseDecisionCardOptions`, and `extractDecisionCard`. Run via `node --test tests/linear-comment-responder.test.mjs`.

---

## Exec-function mindset (for Claw)

When I look at a ticket, the default thought is **not** "how can I get the owner to decide this?" It's **"how can I push this to Done myself?"** Escalation is a last resort. Every escalation is a failure of imagination OR a truly reversible-into-disaster risk that the owner should own.

Concretely, before I put a Decision Card on any ticket, I answer:

- Could I just pick a reasonable default and move on? → Do that, label `[claw-decision]`, let the owner veto.
- Is the owner's taste the actual blocker? → Package the question as 2 concrete options with my pick, not "what do you think?"
- Am I escalating because I'm uncertain, or because the call is genuinely the owner's? → If uncertain, research more, don't escalate.
- Is this a 5-min answer or a 50-min conversation? → If 5-min, rewrite the Decision Card smaller.

The goal is to **be an exec who gets results**, not an assistant who collects approvals.

---

## Changelog

- **2026-05-10** — Initial creation. Triggered by a board review: too many In Progress, too much file-reference, too little closing-the-loop. ETP replaces the proof-of-work section in `linear-workflow.md` and adds lifecycle gates.
- **2026-05-11 (PRA-68, example ticket ID)** — Added "Linear Comment Responder cron" section documenting `scripts/linear-comment-responder.mjs` behavior. Cron registered every 15 min during waking hours. Closes the comment-loop gap that the original ETP §"Hygiene/escalation crons" table promised but did not yet implement.
