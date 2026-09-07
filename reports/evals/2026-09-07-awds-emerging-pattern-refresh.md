# AWDS Emerging Pattern Refresh — Eval

## Header

- **Change under test:** Three new observation-only candidates in `skills/avoid-ai-writing/patterns/v4-emerging.md`.
- **Surface class:** skill pattern documentation.
- **Linked ticket:** N/A — scheduled public-sync pass.
- **Fault side:** N/A — this is corpus-driven drift capture, not a failure repair.

## Task Set

1. Detect one credential callback reused as evidence for unrelated claims without treating a single biographical mention as a tell.
2. Detect repeated confession-shaped setup-and-reversal framing without penalizing one evidence-led hypothesis correction.
3. Detect repeated first-person receipts that end in generic open questions while preserving questions that select a required next action.

## Baseline vs New

| Task | Baseline | New candidate | Delta |
|---|---|---|---|
| Recycled credential | Existing v4 candidates do not compare repeated credential phrases across bodies. | Normalize the role-and-scale phrase and require recurrence across three distinct bodies with different theses. | Adds a recurrence threshold plus one-off and quotation exclusions. |
| Confession reversal | Existing rules cover contrast templates but not repeated self-correction staging. | Require a setup marker and a reversal about the same incident, repeated across three bodies. | Captures the batch habit without penalizing one honest correction. |
| Receipt then question | Existing rules cover either-or question closers but not receipt-backed generic questions. | Require a first-person receipt, final open question, and a batch threshold; preserve action-selecting questions. | Separates a repeated engagement template from useful clarification. |

## Fixed Examples and Results

The candidate file carries a fixed comparison set for each rule. Applying the written boundaries produced:

| Candidate | Positive examples matched | Boundary examples preserved |
|---|---:|---:|
| `v4.06-recycled-credential-callback` | 3/3 | 2/2 |
| `v4.07-confession-shaped-reversal` | 3/3 | 2/2 |
| `v4.08-receipt-to-open-question-tail` | 3/3 | 3/3 |

- **Task success:** 3/3 candidate families documented with an observable threshold, rewrite, positive examples, and negative boundaries.
- **Regression:** none expected. v4 candidates are observation-only and do not change CLEAN, PATCH, or REWRITE verdict math.
- **Sanitization:** examples are synthetic and contain no private identity, organization, customer, URL, account, or credential data.
- **Artifact check:** PASS — version bump, three complete candidate sections, eval links, and a new-text private-marker scan all passed.

## Gaps + Fixes

- No production detector consumes these three candidates yet. Promotion requires fresh recurrence plus a detector implementation and regression fixtures.
- The fixed examples are intentionally small. Before promotion, test a larger mixed corpus and report precision, recall, and false-alarm cost.
- Semantic normalization for credential reuse needs an implementation design; a broad number-or-role regex would overfire.

## Verdict

**ship** — publish the three candidates as observation-only guidance. Do not promote them into active scoring until fresh-corpus recurrence and detector-level evaluation satisfy the gaps above.

**Untested surface:** This eval did not exercise live social content, production detector behavior, multilingual text, paraphrase embeddings, or week-over-week promotion. It validates the candidate boundaries and safe public shape, not production precision or recall.

## Artifact Path

- This report: `reports/evals/2026-09-07-awds-emerging-pattern-refresh.md`
- Pattern file: `skills/avoid-ai-writing/patterns/v4-emerging.md`

## Sign-off

- Run by: Claw
- Date: 2026-09-07
- Linked from: `CHANGELOG.md` and `skills/avoid-ai-writing/CHANGELOG.md`
