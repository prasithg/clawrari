# Source Evidence and Test Traceability

Writing checks need the original source to assess support for a claim. Evaluation checks need to distinguish allowed input from hidden answers. Reviewers need to know which test supports each acceptance criterion.

## Change Under Review

- **Change type:** public workflow documentation and one prompt-template refresh.
- **Files:** [source retention](../../docs/self-improvement.md#63-retain-original-sources-before-measuring-draft-accuracy), [answer boundaries](../../docs/self-improvement.md#64-check-answer-leakage-against-permitted-inputs), and [test traceability](../../reference/agent-prompt-template.md#connect-behavior-tests-to-acceptance-criteria).
- **Issue:** none. This scheduled update captures lessons from existing work.
- **Failure location:** missing source capture in the recording tool; an evaluation that mistakes shared input for leaked answers; incomplete evidence mapping in a task prompt.

The agent prompt template is the single mapped artifact selected for refresh. The update generalizes the source template's instruction to include acceptance identifiers in test names. It preserves review-based verification for documentation and makes no change to installed skills or running workflows.

## Method and Baseline

These are ten manually reviewed documentation cases using saved pre-edit copies and the revised text. The scenarios below are hypothetical. They are not live experiments, model comparisons, or executable behavior tests.

The earlier self-improvement guide already separates source authority, tests with controlled examples, and live outcomes. It does not describe the specific limits of using an accepted revision as source evidence or a shared input passage as proof of answer leakage. The earlier prompt template requires measurable criteria and relevant tests, but does not explicitly map changed tests to criterion identifiers.

## Source Evidence Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| S1 | Assess a draft when only its accepted revision survives. | Preserve evidence and verify sources. | Report the missing original source; use the revision only for the declared edit comparison. |
| S2 | A revision omits a numerical claim found in the draft. | Check factual support and uncertainty. | Keep unsupported and false distinct; omission alone cannot establish falsehood. |
| S3 | Unit tests pass, but the historical comparison shows no useful relationship. | Separate narrow tests from live outcomes. | Retain the inconclusive result and keep the check report-only. Distinguish input errors from no findings. |

All three cases have a stated decision and a limit. Public examples remain synthetic or sanitized; evidence retention does not authorize disclosure.

## Answer Boundary Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| A1 | A hidden answer begins with an unchanged passage from the permitted input. | Check whether a failed evaluation is itself wrong. | Inspect the passage's origin and prompt construction; retain the failed check without calling the match proof of leakage. |
| A2 | Answer-only text appears in a saved prompt. | Preserve inputs and investigate failures. | Treat the text as evidence requiring an input-boundary investigation; do not rewrite the saved prompt after scoring. |
| A3 | The prompt contains an answer field but no matching answer prefix. | Keep evaluation evidence trustworthy. | Inspect selected fields and construction, since a prefix scan alone misses the defect. |
| A4 | A model reply cannot be parsed. | Preserve failed and passing cases separately. | Keep the missing prediction in the declared denominator and avoid overstating retrospective results as performance on unseen cases. |

The distinction between permitted input and hidden answers does not waive an existing acceptance requirement. An unresolved requirement remains unresolved until its owner reviews it.

## Test Traceability Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| T1 | Add a behavior test for a named acceptance criterion. | Run relevant tests and verify each criterion. | Put the criterion identifier in the test name or an explicit mapping; inspect the assertion and retain the intended failing and passing results. |
| T2 | An existing test already covers the changed requirement. | Keep changes proportional. | Reuse the test and record its mapping; avoid unrelated renaming or duplicate assertions. |
| T3 | Review a documentation-only requirement. | Permit review evidence for criteria that need judgment. | Use the declared rubric and preserve the evidence gap if review is missing; do not invent a behavior test for prose. |

## Metrics and Evaluation-Fault Review

Ten of ten manual cases have an explicit instruction and a stated limit. This count measures documentation coverage judged by the author. It does not measure compliance, factual accuracy, leakage detection, or reviewer efficiency.

The review credits existing principles instead of treating every detail as previously absent. A clean program exit is insufficient when the returned report contains an input error. A test name is insufficient when its assertion does not cover the requirement. A common input passage is insufficient evidence of hidden-answer access.

False alarms require a reviewer to inspect the prompt and permitted sources. No false-alarm rate was measured here, and this update introduces no automated blocking check.

## Untested Behavior

No private draft collection, original source collection, model endpoint, scheduler, or test runner was exercised by these manual cases. The review does not establish that a model follows the revised prompt, that a checker catches all leakage paths, or that a retrospective pattern predicts future edits. Operational use needs separate implementation and evaluation evidence.

## Result

**Ship the documentation.** Keep implementation acceptance, unresolved evaluation requirements, and adoption of writing checks separate from this public update.

## Artifact and Sign-Off

The complete manual records are S1–S3, A1–A4, and T1–T3 above, in `reports/evals/2026-11-01-source-evidence-and-test-traceability.md`. The [changelog](../../CHANGELOG.md#2026-11-01) links this evaluation.

Reviewed by: repository maintainer using GPT-6. Date: 2026-11-01. This is an author review, not an independent or cross-model review.

Lesson: retain the evidence a claim needs before measuring it, and keep a check's result separate from what that result can establish.
