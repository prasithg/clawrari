# Content Engine — Cron / Routine Spec (PRA-122)

How the weekly and monthly Clawrari content drafts are generated, gated, and
surfaced for review automatically.

> **Pipeline (one wrapper, three steps):**
> `scripts/content-engine-run.sh [--weekly|--monthly]` chains
> **generate** (`scripts/content-engine.sh`) → **AWDS v0.1 gate**
> (`avoid-ai-writing`) → **Slack preview** to `#prasclaw-content`.
>
> **Hard rules (baked into the wrapper, not configurable):**
> - **Draft-only. No external publish.** Never X, LinkedIn, email, or web.
> - **Slack `#prasclaw-content` is the only destination.** The post is a draft
>   preview + human approval request, mirroring the Content Morning Batch
>   pattern (draft → Slack preview → human approves). Publishing stays manual.
> - **The AWDS gate runs before any Slack post.** If the gate cannot run, the
>   wrapper refuses to notify and exits non-zero.
> - **Idempotent.** If a draft for the period already exists, the wrapper skips
>   generation and the Slack post (no double-posting) unless `--force`.

## Schedule

| Cadence | When (ET) | Cron expr | Wrapper command | Output |
|---------|-----------|-----------|-----------------|--------|
| Weekly  | Friday 09:00 | `0 9 * * 5`  | `scripts/content-engine-run.sh --weekly`  | `docs/content-engine/drafts/<YYYY-MM-DD>-weekly.md` |
| Monthly | Last Friday 09:15 | `15 9 * * 5` | `scripts/content-engine-run.sh --monthly` | `docs/content-engine/drafts/<YYYY-MM>-monthly.md` |

Friday morning gives Prasith a "what shipped this week" pack to review before the
weekend (matches `docs/content-engine/cadence.md`).

### Why the monthly cron fires every Friday

Vixie cron cannot express "last Friday of the month" (when both day-of-month and
day-of-week are restricted they are **OR**'d, not AND'd). So the monthly job
fires **every** Friday at 09:15 ET and the wrapper self-gates: `--monthly` is a
no-op (exit 0) on any Friday that is not the last of the month. The 09:15 stagger
keeps it from colliding with the 09:00 weekly job. On the last Friday both the
weekly pack and the monthly retro fire — intended.

## Ready-to-register payloads

The full job definitions live as JSON under [`crons/payloads/`](payloads/):

- [`content-engine-weekly.json`](payloads/content-engine-weekly.json)
- [`content-engine-monthly.json`](payloads/content-engine-monthly.json)

Each payload captures the schedule, the `systemEvent` text, and the
failure-alert + sandbox settings below.

## Registration (the verification session runs these)

Claude Code cannot call the OpenClaw `cron` tool, so register with the CLI.
Run from the clawrari repo checkout:

```bash
# Weekly — Friday 09:00 ET
openclaw cron add \
  --name "Clawrari Content Engine — Weekly Pack" \
  --cron "0 9 * * 5" --tz "America/New_York" \
  --session main \
  --description "Weekly build-in-public draft -> AWDS gate -> Slack #prasclaw-content. Draft-only." \
  --system-event "[content-engine] Friday 09:00 ET — from the clawrari repo run \`scripts/content-engine-run.sh --weekly\`. Generates docs/content-engine/drafts/<YYYY-MM-DD>-weekly.md, runs the AWDS v0.1 gate, posts the AWDS-gated preview to Slack #prasclaw-content. Draft-only; do NOT publish to X/LinkedIn/email; Slack #prasclaw-content only; the post is a draft preview + approval request. Idempotent (skips if this week's draft exists). Confirm the AWDS verdict is in the Slack message. If the script exits non-zero, report the failure."

# Monthly — every Friday 09:15 ET, wrapper acts only on the last Friday
openclaw cron add \
  --name "Clawrari Content Engine — Monthly Retro" \
  --cron "15 9 * * 5" --tz "America/New_York" \
  --session main \
  --description "Last-Friday monthly retro draft -> AWDS gate -> Slack #prasclaw-content. Draft-only. Self-gates to last Friday." \
  --system-event "[content-engine] Friday 09:15 ET — from the clawrari repo run \`scripts/content-engine-run.sh --monthly\`. The wrapper only acts on the LAST Friday of the month (no-op otherwise). On the last Friday it generates docs/content-engine/drafts/<YYYY-MM>-monthly.md, runs the AWDS v0.1 gate, posts the AWDS-gated preview to Slack #prasclaw-content. Draft-only; do NOT publish to X/LinkedIn/email; Slack #prasclaw-content only; the post is a draft preview + approval request. Idempotent. Confirm the AWDS verdict is in the Slack message. If the script exits non-zero, report the failure."
```

Verify after registering:

```bash
openclaw cron list                 # both jobs present, next-run times sane
openclaw cron run "<job-id>"       # debug fire; check #prasclaw-content for the preview
openclaw cron runs "<job-id>"      # run history / failures
```

## Failure-alert settings

- **Do NOT pass `--best-effort-deliver`.** The wrapper exits non-zero when the
  AWDS gate cannot run, generation fails, or the Slack post fails. Without
  best-effort, the cron marks the run **failed** so it shows up in
  `openclaw cron runs`.
- A monthly no-op on a non-last Friday exits **0** — that is expected, not a
  failure.
- The Sunday **System Health & Cleanup** cron should surface repeated failures
  (it already reviews AWDS P0-hit metrics; add content-cron run health to it).

## Sandbox boundary

- **Tools:** `exec`, `read`, `write` only.
- **Working dir:** the clawrari repo checkout. Drafts are written only under
  `docs/content-engine/drafts/`.
- **Egress:** exactly one network send per run — `openclaw message send` to
  Slack `#prasclaw-content` (`C0B1BENB3EC`). No X/LinkedIn/email/web publish
  tools in the session.
- The generator (`scripts/content-engine.sh`) is itself network-silent: it only
  reads git history / files and writes markdown.

## AWDS gate

- Detector: `avoid-ai-writing` (`awds-detect.mjs`) in the OpenClaw workspace.
  The wrapper finds it at `$AWDS_DETECT`
  (default `~/.openclaw/workspace/scripts/awds-detect.mjs`); override the env var
  if your checkout differs. **Missing detector → no Slack post (gate is
  mandatory).**
- Per-run output: `<draft>.awds.json` next to the draft (gitignored; regenerated
  each run) with the full verdict + flags.
- The Slack preview always includes the AWDS verdict (`CLEAN`/`PATCH`/`REWRITE`),
  P0/P1 counts, categories touched, and the flagged pattern ids.
- Expect generated drafts to score `PATCH`/`REWRITE`: they are pre-edit review
  artifacts (markdown headings/bold + `<placeholders>`), so v2 markdown-format
  flags fire by design. The signal to fix before publishing is the v1 (lexical)
  and v3 (structural) tells. The human approval gate is where the draft becomes
  ship-ready content.

## After the run

1. A dated draft lands under `docs/content-engine/drafts/`.
2. A draft-preview message (with the AWDS verdict) posts to `#prasclaw-content`.
3. Review through the human approval gate: edit against the template voice
   guardrails (`docs/content-engine/templates/`), then publish manually.
4. Nothing is published automatically.

## Local smoke test

```bash
scripts/content-engine-run.sh --weekly --no-notify   # generate + gate, no Slack
scripts/content-engine-run.sh --weekly               # full run, posts once to Slack
```
