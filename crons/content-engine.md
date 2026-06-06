# Content Engine — Cron / Routine Spec

How to schedule the draft generator (`scripts/content-engine.sh`) so weekly and
monthly content drafts appear automatically for review.

> **Scope:** this doc *specifies* the schedule. Registering the cron is a manual
> step in your own crontab or OpenClaw gateway config. The generator is
> **draft-only** — it writes markdown into `drafts/` and never sends or posts.

## Intended Schedule

| Cadence | When | Command |
|---------|------|---------|
| Weekly  | Friday 09:00 local | `scripts/content-engine.sh --weekly` |
| Monthly | 1st of month 09:00 local | `scripts/content-engine.sh --monthly` |

Friday gives you a "what shipped this week" pack to review before the weekend.
The 1st-of-month run produces a broader rollup of the prior period.

## Option A — system crontab

Run the generator directly. Replace `/path/to/clawrari` with your checkout.

```cron
# Weekly content pack — Fridays 09:00
0 9 * * 5  cd /path/to/clawrari && ./scripts/content-engine.sh --weekly  >> drafts/.content-engine.log 2>&1

# Monthly rollup — 1st of month 09:00
0 9 1 * *  cd /path/to/clawrari && ./scripts/content-engine.sh --monthly >> drafts/.content-engine.log 2>&1
```

## Option B — OpenClaw gateway routine

If you want the agent to generate the draft and then surface it for review,
register a cron in your OpenClaw gateway config (see `crons/examples.jsonc` for
the shape). The payload tells the agent to run the script and report the path —
it does **not** publish.

```jsonc
[
  {
    "name": "Content Engine — Weekly Pack",
    "schedule": { "kind": "cron", "expr": "0 9 * * 5", "tz": "America/New_York" },
    "sessionTarget": "main",
    "payload": {
      "kind": "systemEvent",
      "text": "[content-engine] Friday 09:00 — run `scripts/content-engine.sh --weekly`, then summarize the new draft under drafts/weekly/ in the morning briefing. Draft only; do not publish."
    }
  },
  {
    "name": "Content Engine — Monthly Rollup",
    "schedule": { "kind": "cron", "expr": "0 9 1 * *", "tz": "America/New_York" },
    "sessionTarget": "main",
    "payload": {
      "kind": "systemEvent",
      "text": "[content-engine] 1st of month 09:00 — run `scripts/content-engine.sh --monthly`, then summarize the new draft under drafts/monthly/. Draft only; do not publish."
    }
  }
]
```

## After the run

1. A new file lands in `drafts/weekly/` or `drafts/monthly/`.
2. Review it through the content engine's human approval gate
   (see [`docs/components/content-engine.md`](../docs/components/content-engine.md)).
3. Approve, edit, or hold. Publishing stays manual and explicit.

## Verification

- The cron command exits 0 and prints the draft path.
- A dated draft file exists under the configured output dir.
- Nothing was sent anywhere — the generator makes no network calls.
