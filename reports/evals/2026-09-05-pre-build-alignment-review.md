# Pre-Build Alignment Review Eval

## Header

- **Change under test:** Add a read-only alignment review to `reference/agent-prompt-template.md`.
- **Surface class:** prompt template and core workflow.
- **Linked ticket:** N/A. This refresh comes from the public synchronization backlog.
- **Fault side:** `brief to builder, fault:harness`. The workflow lacked a check between writing the brief and starting implementation.

## Method

This is a deterministic instruction-coverage eval. No model was called. The baseline
is the prior public template, which moved directly from authoring to execution. The new
version applies the five review checks to the cases below. Each case includes its
expected result, so the comparison is explicit and reproducible.

## Task Set

1. Review a brief whose final acceptance criterion has no matching source requirement.
2. Review a brief that names a missing existing path and conflicts with an architecture rule.
3. Review a single-module change whose requirements, paths, scope, and checks all agree.

## Baseline vs New

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| Missing requirement trace | The template provides no required review before build work starts. | FAIL, citing the unmatched criterion and asking for a source requirement or its removal. | The mismatch becomes visible before implementation. |
| Bad path and rule conflict | The builder must discover both problems while changing code. | FAIL, citing the missing path and the conflicting architecture rule with the smallest corrections. | Path and constraint failures move ahead of the build. |
| Aligned single-module change | The brief can proceed, but no intermediate check records why. | PASS because all five checks hold. | The workflow adds a bounded review without expanding the task. |

## Metrics

- Task success: 3 of 3 cases produce the expected review result.
- Static validation: PASS. The public section contains all five checks, both result states, and the read-only boundary; the eval shape and sanitization checks also passed.
- Latency: no live model run was measured; the review is one bounded pass over three named inputs.
- Cost: no model or external service cost was incurred.
- Qualitative verdict: the new section covers the common ways a complete-looking brief can disagree with its source before a builder sees it.
- False-alarm cost: a mistaken FAIL costs one review cycle for the author. Requiring a section citation and a minimum correction keeps that cost bounded.

## Grader / Eval-Fault Check

The three expected results follow directly from the five published checks. This eval
tests instruction coverage, not model compliance. No case failed, and no grader or
environment fault was observed.

## Untested Surface

This eval does not measure how consistently different models follow the review prompt.
It also does not exercise very large briefs, conflicting source documents, or
multi-repository plans.

## Verdict

**ship**. Add the review as a default pre-build check. Measure live model compliance in
a later execution eval before claiming cross-model reliability.

## Artifact Path

The three fixtures and expected results are embedded in this file:
`reports/evals/2026-09-05-pre-build-alignment-review.md`.

## Sign-off

- Run by: Claw using Codex.
- Date: 2026-09-05.
- Linked from: `CHANGELOG.md` and `reference/agent-prompt-template.md`.
