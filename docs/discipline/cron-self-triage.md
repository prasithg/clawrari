# Cron Error Self-Triage

## What this solves

An agent runs against a fleet of scheduled jobs — morning briefings, digests, content drafts, comment responders, stale-ticket scans, etc. Without an explicit rule, the default behavior is **passive**: the agent notices a cron in error state, surfaces it in a briefing, and moves on. The operator becomes the watchdog for the agent's own infrastructure.

The rule below flips that. The moment the agent observes a cron in error, it triages and fixes in the same turn — with explicit agency to change model, timeout, or payload. The operator only sees the diagnosis + fix, not a "heads-up, your crons are broken" note.

This is a behavioral spec, not a tool. The trigger is recognition, not a notification webhook.

---

## The rule

When a cron is in error state — `lastRunStatus=error`, `consecutiveErrors >= 1`, or repeated `cron: job execution timed out` — act in the same turn. **Don't surface and stop. Don't wait to be asked.**

### Trigger points (any of)

- Session-start `cron list` glance shows a job with `lastRunStatus=error` or `consecutiveErrors >= 1`.
- Morning briefing or system-health report surfaces a failing cron.
- The operator mentions a cron is broken.
- The agent notices a job that should have run hasn't produced its expected artifact (digest didn't post, draft didn't land, watermark didn't advance).

### Self-triage flow

1. **Pull the run history** (`cron runs <jobId>` or equivalent) for the failing job(s). Look for the failure mode: timeout vs API error vs validation vs stuck-in-progress.
2. **Check the time window** — did multiple crons fail in the same window? (provider slowness, infra blip) — or is one specifically broken? (config / prompt issue, allowlist drift).
3. **Smoke-check the dependency** if relevant: model endpoint, tool MCP, browser CDP, chat channel id, downstream API.
4. **Form a verdict** — provider slow window, model rejection, allowlist drift, prompt drift, downstream API hang, payload schema mismatch, etc.
5. **Apply a fix** with full agency:
   - Bump timeout if the provider was momentarily slow.
   - **Switch model** if a specific model is consistently failing. Operator agency for this is granted in advance — use it, and tell the operator what changed afterward.
   - Repair prompt / payload if the cron itself drifted.
   - File a regression in the regression log if it's a new failure class.
6. **Rerun** the failed crons immediately — except any class the operator has flagged as "schedule-only" (typically jobs with side effects on external state).
7. **Report** the diagnosis + fix in one message — what failed, why, what changed, what's running now. No "will follow when done" promises.

### Hard exclusions

- **Don't disable a cron without asking.** Only the operator does that.
- **Don't change a cron's schedule without asking.** Timeout, model, and prompt changes are fair game; cadence isn't.
- **Don't rerun side-effect crons during the day** unless the operator says so — typically night-work jobs that mutate external state (ticket comments, scheduled posts, calendar holds) should only fire on schedule, even if they failed.

### Failover heuristic for repeated timeouts

If a cron has **three or more consecutive timeouts on the same model**, default action is to fail it over to the more-reliable scheduled-job route for your stack and bump the timeout enough to match the job budget. Don't keep retrying the same broken path. Tell the operator what you changed.

A two-timeout streak on a preview / experimental provider is the same signal — route off it.

---

## Why this works

Two reasons the rule changes observable behavior:

1. **It removes the "surface and stop" off-ramp.** Without an explicit rule, the agent's default for ambiguous infra signals is to mention them and wait. The rule replaces that default with "diagnose + fix in the same turn."
2. **It pre-authorizes the actions.** Switching models, bumping timeouts, repairing payloads all involve mutating live infrastructure. Without pre-authorization, the agent will hedge ("should I switch the model?") instead of acting. The rule grants agency in advance for the specific axes that matter — model, timeout, payload — while preserving guardrails on the axes that don't (schedule, enabled/disabled state).

---

## Companion: session-start cron glance

A one-tool-call glance at `cron list` belongs in the agent's session-start checklist. It's cheap, it catches overnight failures before any other work starts, and it gives the self-triage rule a deterministic trigger point. Without it, error states only surface when a downstream briefing happens to run — which means the agent may miss several hours of broken crons every morning.
