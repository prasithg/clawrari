# Content-Engine Cron — Change Eval (2026-06-10)

Eval artifact for landing the Clawrari content-engine generator + AWDS-gated cron
wrapper on `main`. Follows `reference/skill-change-eval-template.md`. No artifact of
this shape → the change is not Done.

## Header

- **Change under test:** Merge the content-engine draft generator
  (`scripts/content-engine.sh`), the AWDS-gated Slack-only cron wrapper
  (`scripts/content-engine-run.sh`), the cron spec + payloads
  (`crons/content-engine.md`, `crons/payloads/*.json`), example config, and the
  PRA-99 template/cadence/case-study base onto `main`.
  Commits: `080e609` (PRA-99 template base), `71d97b6` (PRA-122 generator + cron).
- **Surface class:** core workflow + cron policy + prompt templates.
- **Linked ticket:** PRA-122 (primary), PRA-99 (template dependency), PRA-129
  (cadence recovery — cleared by `080e609` landing on `main`).

## Task Set

Tasks exercise the *changed behavior* (generation + mandatory gate + draft-only
notify), not generic happy paths.

1. Generate a weekly content draft end-to-end through the cron wrapper and confirm
   it writes to the canonical path and runs the AWDS gate before any notify step.
2. Generate a monthly content draft through the cron wrapper, bypassing the
   last-Friday guard (`--force`), and confirm the same gate-then-notify chain.
3. Confirm the AWDS v0.1 verdict surfaces in the Slack notification *payload*, and
   that `--no-notify` runs the full generate + gate chain while sending nothing.

## Baseline vs New

Baseline = pre-merge state: generator, wrapper, and templates were stranded on
un-merged branches (`claw/pra-99-…`, `claw/pra-122-…`). On `main`, the cron spec
and `docs/content-engine.md` referenced templates (`docs/content-engine/templates/*`)
that did not exist there, so the generator's template references could not resolve
and no cadence work had landed since `548b212` (PRA-129 cadence breach).

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| 1 Weekly | Generator/templates not on `main`; template refs dangling; no draft producible from `main` | `bash scripts/content-engine-run.sh --weekly --as-of 2026-06-10 --no-notify` wrote `docs/content-engine/drafts/2026-06-10-weekly.md` from real templates, then ran AWDS gate → verdict `REWRITE` (P0:3 P1:4, categories v1,v2,v3) | Pipeline runs from `main`; template refs resolve; gate runs before notify |
| 2 Monthly | Same — nothing on `main`; monthly path untested | `--monthly --as-of 2026-06-10 --no-notify --force` wrote `docs/content-engine/drafts/2026-06-monthly.md`; AWDS verdict `REWRITE` (P0:3 P1:3, categories v1,v2,v3). `--force` correctly bypassed the last-Friday guard (2026-06-10 is a Wednesday) | Monthly path verified incl. last-Friday self-gate semantics |
| 3 Gate/notify | No gate, no notify path on `main` | Both runs: AWDS verdict + flagged rule IDs + the "markdown review draft → v2 noise" explanatory note rendered into the Slack payload; `--no-notify` printed the would-post preview and sent nothing | Gate verdict is surfaced, not swallowed; notify is draft-only and was suppressed |

## Metrics

- **Task success:** PASS (3/3). Both drafts generated to the canonical
  `docs/content-engine/drafts/` paths; gate ran on both; nothing was sent.
- **AWDS verdict (weekly):** `REWRITE` — P0:3 (`v1.01-em-dash`,
  `v2.40-md-headings-in-slack`, `v2.41-double-asterisk-bold`), P1:4
  (`v2.04-no-space-after-punct`, `v2.21-all-caps-emphasis`, `v3.02-uniform-rhythm`,
  `v3.10-bare-np-bullets`), P2:1 (`v3.20-round-number-specificity`). char_count 2894.
- **AWDS verdict (monthly):** `REWRITE` — P0:3, P1:3, same category mix (v1,v2,v3).
- **Latency:** sub-second per run (local git read + markdown render + node gate).
- **Cost:** none — generator is git/file read only; gate is a local node script; no
  network calls, no model tokens.
- **Qualitative:** The `REWRITE` verdict is expected and correct here, not a
  failure. Per the verified AWDS gotcha, feeding a *full markdown review draft*
  through the detector always returns `REWRITE` because v2 rules flag markdown
  itself (`#` headings, `**bold**`) plus the `[epistemic]`/`<placeholder>` scaffolding.
  For a pre-edit review artifact that is the correct "not ship-ready" signal. The
  actionable tells for the eventual *post* are the v1 (lexical, e.g. em-dash) and v3
  (structural) flags; the wrapper renders a note in the payload saying exactly this.
  The gate is fail-closed: if the detector is missing or errors, the wrapper dies
  before notifying (verified by reading the wrapper; detector present at
  `~/.openclaw/workspace/scripts/awds-detect.mjs`).

## Verdict

**ship** — the pipeline lands and runs correctly from `main`, the mandatory gate
runs before any notify, and the notify path is draft-only. Follow-ups below are
non-blocking.

## Gaps + Fixes (non-blocking follow-ups)

1. **Register the cron (manual, intentional one-liner).** Per the night-work safety
   rule, the cron SPEC lands in-repo but the actual `cron add` was NOT registered
   and NO Slack post was made. Registering remains a documented manual step in
   `crons/content-engine.md`.
2. **Stale top-level `drafts/` samples.** `drafts/weekly/weekly-content-2026-06-06.md`
   and `drafts/monthly/monthly-content-2026-06-06.md` arrived from the PRA-122 branch
   (commit `548cdcd`) and predate the settled canonical path
   `docs/content-engine/drafts/`. Left in place (faithful to the merged branch); a
   future cleanup can remove them to avoid confusion with the canonical location.
3. **Per-post clean verdict.** To get a meaningful AWDS verdict on the eventual
   shippable post (vs. the review draft), feed only the stripped prose
   (no headings/bold/fences/placeholders) through the detector.

## Artifact Path

- Generated drafts: `docs/content-engine/drafts/2026-06-10-weekly.md`,
  `docs/content-engine/drafts/2026-06-monthly.md`.
- Raw gate JSON (gitignored, regenerated per run):
  `docs/content-engine/drafts/2026-06-10-weekly.awds.json`,
  `docs/content-engine/drafts/2026-06-monthly.awds.json`.
- Scripts under test: `scripts/content-engine.sh`, `scripts/content-engine-run.sh`.

## Sign-off

- Run by: Claude Code autonomous night-work (Opus 4.7).
- Date: 2026-06-10
- Linked from: PRA-122, PRA-129; commits `080e609`, `71d97b6`.
