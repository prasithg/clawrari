# Bounded revision documentation evaluation

## Header

- Change under test: revision guidance in [self-improvement](../../docs/self-improvement.md#bound-revisions-where-repetition-is-controlled) and [evaluation template](../../reference/skill-change-eval-template.md#revision-budget-evidence).
- Surface class: documentation and evaluation template.
- Linked ticket: N/A; scheduled capture of an existing working pattern.
- Fault side: coordination instructions; no model failure asserted.

## Task Set and Baseline vs New

These are manual reasoning cases inspected against the written guidance, not model or runtime tests.

| Case | Previous public guidance | New guidance and observed review result |
| --- | --- | --- |
| Five findings need edits | No shared draft budget in this section | Pass: send only the top three after deduplication; retain the rest. |
| Three rounds used, draft still fails | No explicit exhausted-budget example here | Pass: hold the draft and exclude publication. |
| Switch writer after two rounds | No budget continuity rule here | Pass: preserve the same count; no fresh allowance. |
| Prior counts unavailable | No unknown-history rule here | Pass: require review instead of assuming zero. |
| Static instruction check passes | General evaluation limits only | Pass: template requires separate evidence of live compliance. |
| Earlier stop rule is stricter | No revision-specific precedence rule here | Pass: stop at the earlier limit. |

## Metrics

Six manual cases passed document inspection. No latency, cost, writing-quality, or compliance improvement was measured.

## Grader / Eval-Fault Check

The cases assess the written contract only. They do not treat an instruction reference as executed enforcement. The maintainer bears the review cost if these additional reporting requirements are applied to a workflow with no resubmission behavior.

## Untested Surface

No live writer, exhausted-budget runtime, delivery exclusion, or automated controller was exercised. The source pattern has local instruction-check evidence, but live hold behavior remains unmeasured. This publication adds no executable enforcement.

## Verdict

Ship the documentation only. Live compliance remains unverified.

## Artifact Path

This file contains the complete manual case record: `reports/evals/2026-11-17-bounded-revisions.md`.

## Sign-off

- Run by: Claw, GPT-6.
- Date: 2026-11-17.
- Linked from: changed guidance, evaluation template, and changelog.
- Lesson learned: enforce budgets at the component that actually decides to repeat work; do not confuse static instruction checks with runtime proof.
