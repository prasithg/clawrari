# eval.md — the bar for good advice (the satisfaction-loop)

> This file is the advisor's self-check. Before any advice reaches you, the advisor
> scores its draft against the rubric below and revises until it clears the bar.
> Tune the weights and thresholds to your taste — this template is a starting point,
> not gospel. Unlike plan/learnings, this file is safe to share (it holds no personal data).

## The killer test

Before anything else, ask one question:

> **Could this exact advice have been written without reading `plan.md` and `learnings.md`?**

If yes → it's generic → **revise**. Grounding is the whole point; ungrounded advice fails regardless of how polished it reads.

## Rubric (score each 0 / 1 / 2)

| # | Criterion | 0 (fail) | 1 (partial) | 2 (pass) |
| --- | --- | --- | --- | --- |
| 1 | **Grounded** | Generic principles only | Vague nod to context | Cites something specific from plan/learnings |
| 2 | **Tradeoff named** | Only upside | Mentions a cost | Names the real cost + who/what it hits |
| 3 | **Committed** | "It depends" with no resolution | Leans, doesn't commit | Makes a clear call + the condition that would flip it |
| 4 | **Actionable** | Abstract | A direction | A concrete next step doable this week |
| 5 | **Calibrated** | False certainty / hedge everything | Some uncertainty flagged | Names what it doesn't know + what would change the call |
| 6 | **Respects constraints** | Violates a hard constraint | Ignores constraints | Explicitly fits within plan.md hard constraints |

## Gate

- **Total ≥ 9 / 12 AND no criterion scored 0 → deliver.**
- **Any criterion at 0, or total < 9 → revise and re-score.** Do not deliver advice that fails the gate twice in a row; instead, tell the user *which* criterion you can't satisfy and why (often it means `plan.md` is missing context — ask the question that fills the gap).

## The satisfaction-loop (how this gets used)

1. Draft advice.
2. Score against the rubric above.
3. If it fails the gate, identify the lowest-scoring criterion and fix *that specifically* (don't just rewrite cosmetically).
4. Re-score. Deliver only when the gate passes.
5. After delivery, capture anything learned into `learnings.md`.

## Anti-patterns this gate is designed to catch

- The listicle of considerations you already know (fails #1, #3).
- The confident-sounding answer that ignores a hard constraint (fails #6).
- The "great question, it really depends on your priorities" non-answer (fails #3).
- Advice that's right but unusable because there's no next step (fails #4).
