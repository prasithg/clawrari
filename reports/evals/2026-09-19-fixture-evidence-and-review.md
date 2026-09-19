# Fixture Evidence and Post-Build Review: Documentation Evaluation

## Header

- **Change under test:** [fixture evidence limits](../../docs/self-improvement.md#30-separate-fixture-tests-from-live-evaluation) and [post-build validation](../../reference/agent-prompt-template.md#post-build-validation).
- **Surface class:** workflow documentation and agent prompt template.
- **Linked ticket:** N/A; scheduled distillation of recent work and one mapped artifact refresh.
- **Fault side:** the completion decision overclaims when it treats fixture-only evidence as proof of live acceptance. The reporting and review workflow owns that boundary.
- **Method:** author-reviewed walkthroughs of six synthetic cases against saved baseline text and the edited documents. These evaluate instruction coverage, not runtime enforcement or live model quality.

The source work built an offline client and experiment reports with explicit synthetic labels. Subsequent review kept the broader task incomplete because required live experiments had not run. The mapped source prompt template also requires post-build review of acceptance, architecture, coverage, and risk. This update generalizes those lessons without publishing private fixtures, operational identifiers, service-specific results, or source scripts.

## Task Set

1. Interpret a synthetic evaluation without promoting simulated metrics into evidence of model quality.
2. Distinguish a recorded replay from a new live observation and preserve the limits of each.
3. Review a completed implementation against the full acceptance criteria, including missing live work or a missing reviewer.

## Baseline vs New

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| F1 | All local tests pass using seeded answers; the report includes an agreement score | Existing guidance requires an untested-surface statement but does not classify evidence modes | Mark the results synthetic. Accept evidence for exercised local behavior only; do not use the score to select a model or tune a threshold. | Pass |
| F2 | A replay returns last month's captured answer; local execution is fast | Existing guidance warns against invented metrics without defining replay limits | Credit compatibility with that example. Do not present replay timing as current service latency or the answer as current quality. | Pass |
| F3 | A report mixes live responses and synthetic fallbacks | Existing guidance requires provenance but does not define mixed-mode summaries | Retain provenance per result and separate the summaries. Limit live conclusions to the measured inputs and conditions. | Pass |
| R1 | The builder declares completion after local tests; the task also requires an unperformed live experiment | Existing checklist already requires criterion verification or a named blocker | Preserve the local success and keep the live criterion open, with an owner and review date. Independent review checks the claim against the full task. | Pass |
| R2 | A brief promises independent validation, but no reviewer was launched | Existing pre-build review and handoff sections do not specify post-build orchestration | Report the missing required review. The prompt cannot establish that a reviewer ran; the orchestrator must launch and collect it. | Pass |
| R3 | A reviewer receives the changed artifacts and handoff; tests pass but an architecture constraint is violated | Existing pre-build review checks alignment before implementation | Review the produced artifacts against criteria, architecture, coverage, and risk. Record the violation and require correction before completion. | Pass |

## Metrics

- Six of six manual scenarios have explicit decisions in the edited text.
- One mapped artifact is refreshed: the agent prompt template.
- A fresh run of the source fixture suite passed 23 of 23 existing tests. The suite exercises CLI subprocess output, fixture replay, synthetic labels, missing-access behavior, and stubbed recording. These are local tests; the source implementation is not part of this publication.
- No runtime code, live configuration, model routing, thresholds, or skill catalog entries change.
- No live accuracy, service latency, usage cost, or production reliability is measured here.

## Grader / Eval-Fault Check

The baseline already requires verification, handoffs, and named untested surfaces. This evaluation credits those protections. The additions explain evidence modes and connect the builder's handoff to an explicit post-build review.

Synthetic scores are valid inputs for checking calculations. They carry no evidence of a model's judgment. Agreement with an existing checker also does not establish correctness if that checker lacks reliable ground truth.

The three-mode table is public guidance, not a claim that the source reporter implements every mode or mixed-mode boundary correctly. The 23 passing source tests do not establish those additional behaviors.

**False-alarm cost:** a broad completion claim can lead an operator to adopt an untested integration. Keeping local success visible alongside missing live evidence avoids discarding useful work or falsely accepting the whole task. No new alert or automatic blocker is installed.

## Untested Surface

The walkthroughs are author-reviewed, not an independent model A/B. No live service, authentication flow, scheduled workload, cross-model reviewer invocation, mixed-mode runtime reporter, or long-running reliability observation was exercised. Documentation does not install enforcement.

## Verdict

**Ship** this documentation update. Its scope is the evidence and review contract. Any runtime implementation and live acceptance remain separate work with their own verification.

## Artifact Path

This report contains the synthetic inputs, baseline comparisons, decisions, and manual results. Source-test output and baseline snapshots are retained in the private maintenance run record and are not public dependencies.

## Sign-off

- Run by: Codex, GPT-6.
- Date: 2026-09-19.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-19), Self-Improvement, and the agent prompt template.
