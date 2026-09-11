# Eval — Model Playbook Refresh to the GPT-6 Astra Two-Primary Doctrine

## Header

- **Change under test:** refresh `reference/model-playbook/` from the GPT-5.6 Sol era to the current two-primary doctrine. GPT-6 Astra replaces Sol as the OpenAI lane and owns coding/review/artifacts/computer use with task-varied effort; Fable 5.1 stays main/general/voice; resilience chains become three deep (other primary, then Grok 4.5 high, then Muse Spark 1.3 high) and stop routing to Kimi K3 or GLM. Changed files: `models.yaml` (v14 → v15), `README.md`, `effort-ladder.md`, `orchestration-strategy.md`, new `models/gpt-6-astra.md`, `models/gemini-3.7-flash.md`, `models/glm-5.3.md`, `models/muse-spark-1.3.md`, `overlays/main-gpt6.md`; targeted edits to `models/fable.md`, `models/grok-4.5.md`, `models/kimi-k3.md`, `models/gpt-5.6.md`, `models/gemini-3.5-flash.md`, `models/glm-5.2.md`, `overlays/main-fable.md`, `overlays/main-gpt54.md`, `overlays/main-opus.md`, `overlays/main-opus5.md`, `fable-operating-pack.md`.
- **Surface class:** orchestration playbook (documentation and machine-readable route contract).
- **Linked ticket:** N/A. Scheduled documentation refresh against the live reference; no tracker issue.
- **Fault side:** `memory`. The public playbook lagged the live routing decisions of 2026-09-09 and 2026-09-10; the defect was stale documentation, not model or harness behavior. The repair is a documentation resync plus validator enforcement, not a prompt-side reminder.

## Premise check

Before rebuilding, the public `effort-ladder.md` was confirmed to route ticket execution to "Fable 5.1 medium → GPT-5.6 Sol max → Kimi K3 high" while the live ladder routes to "Fable 5.1 medium → GPT-6 Astra medium → Grok 4.5 high → Muse Spark 1.3 high". The premise held; the rebuild proceeded.

## Task Set

Each task is a routing question an agent or helper would answer from the playbook. Tasks exercise the changed behavior, not generic happy paths.

1. A routine ticket fails on the primary model; which fallback does the main-session chain select, and what does it select if that fails too?
2. A code review must run cross-family; which model and effort own it, and which model is tried first if it is unavailable?
3. A bounded bulk classification job needs a utility route; which model runs it and what is its recovery path?
4. A retired or comparison-only model (GPT-5.6 Sol, Kimi K3, GLM 5.2) is proposed as a fallback; does the contract accept it?
5. A same-family Anthropic backup (Opus 5) is proposed as a council seat or cross-provider fallback; does the contract accept it?

## Baseline vs New

Baseline is the public tree before this change (models.yaml v14). New is v15. Both columns were read from the fixture files; no live model calls were made.

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| 1 Main-session fallback | Fable 5.1 medium → GPT-5.6 Sol max → Kimi K3 high. Sol is retired live; Kimi is comparison-only live. | Fable 5.1 medium → GPT-6 Astra medium → Grok 4.5 high → Muse Spark 1.3 high. Grok and Muse fire only after both primaries fail. | Retired and comparison models leave the chain; chain is three deep and ends at Muse. |
| 2 Cross-family code review | GPT-5.6 Sol max → Fable 5.1 high → Grok 4.5 high. | GPT-6 Astra high → Fable 5.1 high → Grok 4.5 high → Muse Spark 1.3 high. | Astra replaces Sol; effort is task-varied (high for review) instead of max everywhere. |
| 3 Bulk classification | Gemini 3.5 Flash low → Fable 5.1 medium. | Gemini 3.7 Flash low → GPT-6 Astra low → Fable 5.1 low. Scope narrowed to classification, extraction, OCR. | Flash generation updated; both primaries available at low effort; summaries removed from the Flash scope. |
| 4 Retired model as fallback | Sol and Kimi were `active`, so the validator accepted them in production chains. GLM 5.2 was already `experimental` and the unchanged validator already rejected it in production intents. | Sol, Luna, GLM 5.2, Gemini 3.5 Flash are `retired`; Kimi, Sonnet 5, Fable 5, Grok 4.6 are `comparison-only`; GLM 5.3 is `experimental`. Validator rejects any of them in a production intent. | Retirement is now enforceable rather than prose-only. |
| 5 Opus 5 as seat or fallback | Opus 5 was absent from the roster, so an intent naming it would fail the undeclared-model check. Its intended backup role was unspecified. | Opus 5 is `active` only under the `anthropic_family_backup` intent, documented as never a council seat and never in cross-provider chains. | Same-family backup is explicit and bounded. |

## Metrics

Structural checks were run with a Python script over the parsed `models.yaml` and the changed docs, using the validator's own YAML subset. Results below are from fixture reads, not live model output.

| Check | Result |
| --- | --- |
| `node scripts/validate-model-playbook.mjs` | PASS, exit 0: 16 models, 19 intents, routing docs aligned |
| `node scripts/validate-model-playbook.mjs --selftest` | PASS, exit 0: 4 fixtures |
| C1 main_session primary and chain | PASS |
| C2 coding_review primary Astra high; Fable tried before Grok/Muse | PASS |
| C3 hard_autonomous_work Fable xhigh → Astra xhigh → Grok → Muse | PASS |
| C4 fast_bulk Flash 3.7 low → Astra low → Fable low | PASS |
| C5 no retired or comparison model in any intent chain | PASS |
| C6 Grok/Muse never first fallback; primary only in council intents | PASS |
| C7 all 13 three-deep chains end at Muse Spark 1.3 | PASS |
| C8 GLM 5.3 only in the experimental intent; Opus 5 only in the family-backup intent | PASS |
| C9 statuses match the intended roster | PASS |
| C10 no current-doc arrow chain routes to Kimi, GLM, or Sol | PASS after grader fix (see below) |
| Relative link check across the playbook tree | 4 unresolved, all pre-existing pointers to workspace-local wrappers (`scripts/run-codex.sh`, `scripts/run-claude-code.sh`) or to this eval file before it was written |
| Private-string scan on the playbook tree | No hits introduced by this change; remaining names are public authors cited from a published prompt library and a pre-existing regression tag |

Procedure coverage: 5/5 manual routing cases have an explicit outcome in the new tree. The baseline comparison identifies stale routes or missing roles; it is not a model-performance score. The validator enforces status and reference checks, but it does not enforce every provider-family or council-role restriction stated in prose. Cost: zero paid model calls. Qualitative verdict: the public playbook now states one consistent doctrine that the validator can enforce, and the retained historical guides are labeled as such.

## Grader / Eval-Fault Check

Two check results were reviewed before the verdict. Ambiguous historical prose received explicit retirement markers; a faulty experiment-matching expression was corrected. The public validator and its acceptance rules were unchanged.

- **Validator first pass (4 failures).** The validator flagged four lines that mention a retired model next to the word "fallback" without a retired marker. Three were historical changelog and decision-history lines; one was the GLM 5.2 guide body. These were `fault:grader` in the narrow sense that the prose was already historical, but the validator's rule is deliberate (no ambiguous retired-route prose), so the lines were reworded with explicit historical or retired markers rather than loosening the validator. The validator was not edited.
- **C10 first pass (1 failure).** The structural check's regex matched the decision-tree branch "Explicit GLM utility experiment? -> GLM 5.3 high, recorded as an experiment". That branch is a labeled experiment, not a fallback chain, so the check was wrong. Fixed by excluding lines that label themselves as experiment or comparison. The document was not changed for this failure.

Green is not correctness: the checks prove internal consistency of the public tree, not that the routes perform well.

## Untested Surface

- **No live provider calls.** GPT-6 Astra, Grok 4.5, Muse Spark 1.3, Gemini 3.7 Flash, GLM 5.3, and Opus 5 were not invoked. Effort semantics, fallback triggering, latency, and cost are documented from the live reference and vendor pages, not measured here.
- **Astra behavior claims** (asks more, follows skills harder, over-tests small changes) are carried from OpenAI's published guide and the live workspace's evaluation; they were not reproduced in this run.
- **Muse Spark 1.3 tool-enabled work** is unverified in the source evaluation and remains unverified here.
- **Runtime enforcement** (allowlists, cron overrides, picker aliases) is outside the public repo and was not checked.
- **Inbound pointers outside the playbook tree** were not part of this collection refresh. Older consumers may still point to retained historical guides. The parent review confirmed that the current changelog entry describes the new roster; prior dated entries remain historical.

## Verdict

**ship**. The public tree is internally consistent, passes the validator and selftest, resolves the stale Sol and Kimi/GLM tails, labels the roster as an example rather than a universal claim, and keeps retired guides clearly marked. Follow-ups are listed under Untested Surface and belong to the parent task or a later live smoke, not to this documentation change.

## Artifact Path

`reports/evals/2026-09-11-model-playbook-refresh.md` (this file). Fixture under test: `reference/model-playbook/models.yaml` v15 and the changed docs listed in the header. Validator: `scripts/validate-model-playbook.mjs` (unchanged). Structural checks C1–C10 were run inline from a Python script whose assertions are reproduced in the Metrics table.

## Sign-off

- Run by: Claude Code (Claude Fable 5.1), scheduled documentation refresh
- Date: 2026-09-11
- Linked from: `reference/model-playbook/models.yaml` changelog v15 and `reference/model-playbook/orchestration-strategy.md` changelog


## Final publication review

The parent maintainer reviewed the prepared collection against the published baseline on 2026-09-11. The catalog validator accepted 16 models and 19 intents, and its four unchanged test cases passed. The existing local shared-settings helper also passed all six tests for the companion [identity and shared-state lesson](2026-09-11-identity-and-shared-state.md).

The proposed additions were reviewed for private identities, internal identifiers, account-specific paths, internal links, and email addresses. None were found. This refresh changes one mapped collection, `reference/model-playbook/`; no additional skill port or mapped collection is included. No live routing configuration or provider account was changed.

Review by: GPT-6 Astra, 2026-09-11. This review narrows the baseline and enforcement claims above to what the inspected catalog and existing validator actually establish.
