# Eval - PRA-173: Human-facing message standard pattern

**Date:** 2026-06-21
**Ticket:** PRA-173
**Type:** documented pattern / agent operating rule -> eval required ("no eval = not Done")

## Header

- **Change under test:** Added `docs/human-facing-message-standard.md` and linked it from `docs/index.md`.
- **Surface class:** documented pattern / operating rule.
- **Linked ticket:** PRA-173.

## Task Set

1. Explain the rule for chat, Slack, and status messages without relying on private registry labels.
2. Show a before/after example that translates internal machinery into a human action.
3. Describe an enforcement path future agents can reuse during review.

## Baseline vs New

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| 1 | No public Clawrari pattern captured the plain-English-first message rule. | New doc states the rule for all human-facing agent messages. | PASS - reusable public pattern exists. |
| 2 | No local example showed how to rewrite a machinery-first update. | New doc includes bad and better examples with evidence routed to logs. | PASS - concrete example added. |
| 3 | Enforcement lived outside the repo. | New doc gives review checks and a reusable prompt. | PASS - future agents have a documented gate. |

## Metrics

- Task success: PASS on all three tasks.
- Latency / cost: Not material for a documentation-only change.
- Qualitative verdict: The pattern matches the root-level Clawrari docs style: narrative rationale, rule shape, example, enforcement guidance, and see-also links.

## Validation

- Reviewed nearby pattern docs: `docs/observability.md`, `docs/stacking-loops.md`, and `docs/harness/README.md`.
- Placed the pattern in `docs/`, where the existing observability and stacking-loops pattern docs live.
- Linked the doc from `docs/index.md` beside those pattern docs.
- Kept private registry labels and private workspace paths out of the public pattern doc.

## Verdict

**ship** - the change is a concise, reusable documentation artifact and satisfies the pattern-doc requirement.

## Artifact Path

`reports/evals/2026-06-21-pra173-clawrari-cadence.md`

## Sign-off

- Run by: Codex
- Date: 2026-06-21
- Linked from: PRA-173

## Build complete

Codex finalized the PRA-173 cadence recovery packet by keeping the human-facing message standard indexed, pairing it with the stacking-loops pattern, adding GitHub CI and issue templates, adding an OpenClaw cadence recovery note, and recording this eval as the evidence artifact for the recovery commit.
