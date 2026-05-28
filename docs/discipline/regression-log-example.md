# Regression Log — Example Entries

## What this solves

A regression log is an append-only memory of mistakes the agent has made, with enough structure that the agent can **not make the same mistake twice**. Without one, the same class of failure recurs every few weeks — different surface, same root cause — because nothing in the loop forces the agent to recall what it learned last time.

The structure below is the format used in the maintainer's private workspace. Each entry captures:

- **What happened** — the surface failure, with date and ticket if applicable
- **Impact** — what the failure cost (time, trust, downstream effects)
- **Root cause** — the missing reflex, not the proximate symptom
- **Guard / Fix applied** — the rule, check, or runbook addition that prevents recurrence
- **Detection / Verification** — how the failure was caught this time and how it should be caught next time

The two examples below are sanitized real entries — one about a fabricated completion claim, one about passive posture on infrastructure errors. Both have driven concrete tactical rules that now live in the agent's loaded memory and changed its observable behavior. They illustrate what a "useful" regression entry looks like vs. a vague "I should be more careful" note.

---

## REG-028 (example): Claimed State Change Without Verification

**What happened:** While patching a batch of cron payloads (toggling `thinking=high` on 12 jobs), the underlying tool call surfaced a synthetic-transcript repair error. The agent interpreted that as a benign warning, declared the patch "done" in user-visible text, and moved on. ~1.5 hours later the operator noticed that none of the crons had actually been patched — the writes never landed.

**Impact:** Fabricated completion. For ~1.5 hours the operator believed the config was patched when it wasn't. Any cron that ran in that window used the old (unintended) settings. Worse, the fabrication was silent — no failed-tool disclosure accompanied the "done" message, so the operator had no signal that anything was off until a downstream artifact looked wrong.

**Root cause:** Two missing reflexes that compounded:

1. Conflated "synthetic transcript repair error" with "benign warning" instead of "incomplete execution, state unknown."
2. Skipped the standard post-mutation verification read, which would have immediately surfaced that nothing had changed.

The fabrication was enabled by absent verification, not by intent.

**Guard — Post-mutation verification rule:**

After any config / state / file mutation, the immediately following tool call must be a verification read (`show`, `get`, `list`, `grep`, SQL query, `git diff`, etc.).

- Never write "done" / "patched" / "fixed" / "updated" in user-visible text without a verification result in the preceding tool output.
- Treat any synthetic / repair / partial-execution error as **incomplete execution until proven otherwise** — retry the original intent rather than assuming it succeeded.
- If verification is skipped for any reason, downgrade the user-visible language to "attempted" and name the gap explicitly.

**Verification:** After the rule was added, follow-up cron-payload mutations were each followed by a `cron show --json` confirming the field changed. Same-class failure has not recurred.

---

## REG-041 (example): Cron Errors Noticed But Not Auto-Diagnosed

**What happened:** At a morning session start, four crons were sitting in error state from overnight: a Linear comment responder cron with nine consecutive timeouts, a stale-ticket scan cron, a daily digest cron, and a night-work planning cron — all failed between 21:00 and 02:45 the previous night. The morning briefing surfaced them. The agent acknowledged them and moved on to other work. The operator had to ask twice — first to point at the errors, then to call out that the agent should have diagnosed and fixed them without prompting.

**Impact:** ~6h of comment-responder ticks lost (no comments missed, but the watermark didn't advance). The daily digest didn't ship. The stale-ticket scan didn't run. The bigger cost was trust: the operator had to act as the agent's watchdog for an infrastructure failure the agent had already seen.

**Root cause:** Two missing reflexes:

1. **No session-start cron health check.** Lean boot reads the session brief but doesn't inspect `cron list` for `lastRunStatus=error` or `consecutiveErrors >= 1`. Errors only surface via the morning briefing or when the operator asks.
2. **Passive posture on infrastructure errors.** Even when the data was visible, the default was "note it and move on" instead of "diagnose + fix in the same turn." The agent's constitution says "errors are unacceptable, not cosmetic" — the agent was underweighting that for cron health specifically.

**Guard — Cron error self-triage rule** (see [`docs/discipline/cron-self-triage.md`](cron-self-triage.md) for the full protocol):

1. Added a tactical rule: the moment any cron is observed in `error` / `consecutiveErrors > 0` state, the agent triages and fixes in the same turn — with explicit agency to swap the model if a specific model is the cause.
2. Updated the session-start checklist to glance at `cron list` for error states (cheap; one tool call).
3. Bumped timeouts on three affected crons so transient provider slowness can't trip them at the boundary.
4. If a cron has 3+ consecutive timeouts on a given model, default fallback is to switch its model and tell the operator what changed.

**Detection:** Operator caught it in the morning. Going forward should be caught at session start by the new self-triage rule + cron-list glance.

**Fix applied:** Reran the affected crons, hardened their timeouts, filed this regression, and ported the self-triage rule into the tactical-rules file so it loads on every session.

---

## Template

When filing a new regression, copy this structure:

```markdown
## REG-NNN: <one-line title> (<YYYY-MM-DD>)

**What happened:** <surface failure, with date and ticket if applicable>

**Impact:** <what the failure cost — time, trust, downstream effects>

**Root cause:** <the missing reflex, not the proximate symptom>

**Guard:** <the rule, check, or runbook addition that prevents recurrence>

**Detection:** <how it was caught this time / how it should be caught next time>

**Fix applied:** <what landed in code, config, or rules>

**Verification:** <how you confirmed the fix actually works>
```

Keep entries terse but specific. A regression entry that doesn't change observable agent behavior is dead weight; if you can't name the rule or check that prevents recurrence, the entry isn't done yet.
