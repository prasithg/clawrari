# Risk-Specific Eval Requirements

## Header

- **Change under test:** add risk-specific requirements to the skill and core-workflow eval template.
- **Surface class:** core workflow template.
- **Linked ticket:** N/A — public documentation sync.
- **Fault side:** `grader—owner · fault:grader`. A generic eval template can miss the failure mode that matters most for noisy guardrails and subjective writing.

## Task Set

1. Evaluate a dependency alert that sometimes fires on harmless version changes.
2. Evaluate a secret scanner that blocks a release when it cannot classify a token.
3. Evaluate a rewrite intended to improve a founder's public voice.

## Baseline vs New

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| Dependency alert | Records pass/fail and task success, but can omit the cost of false alarms | Requires the evaluator to name the false-alarm cost and who absorbs it | Makes alert fatigue an explicit quality criterion |
| Secret scanner | Can report blocking behavior without documenting the operational cost of a wrong block | Requires the expected false-alarm cost alongside correctness evidence | Forces precision and safety to be reviewed together |
| Voice rewrite | Can compare the new draft only with the old draft | Requires fixed golden exemplars and a stable rubric | Prevents a merely less-bad draft from passing as good |

## Metrics

- Task success: 3/3 scenarios now name the missing risk-specific evidence.
- Coverage: both newly documented risk classes are exercised.
- Qualitative verdict: the additions are short, portable, and close two common grader blind spots without changing the base template for unrelated work.

## Grader / Eval-Fault Check

The checks target evidence omitted by the evaluator, not model output quality. The fault belongs to the grader contract. No agent-side prompt tuning is proposed.

## Untested Surface

This eval does not measure long-term alert acknowledgement rates or run a live human voice panel. It checks whether the template requires the evidence, not whether every future evaluator will collect it well.

## Verdict

**ship** — the template now asks for the cost signal needed to judge guardrails and the external reference needed to judge subjective writing.

## Artifact Path

`reports/evals/2026-08-23-risk-specific-eval-requirements.md`

## Sign-off

- Run by: Clawrari Pulse automation
- Date: 2026-08-23
- Linked from: `reference/skill-change-eval-template.md` and `CHANGELOG.md`
