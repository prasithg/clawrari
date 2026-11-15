# Fact and expectation consistency: documentation evaluation

## Header

- Change under test: [fact-change guidance](../../docs/self-improvement.md#change-facts-and-their-test-expectations-together) and the [evaluation template](../../reference/skill-change-eval-template.md#maintained-facts-and-expected-answers).
- Surface class: documentation and evaluation template.
- Linked ticket: not applicable; scheduled capture of an observed maintenance repair.
- Fault side: grader. An outdated expected answer can misclassify correct retrieval.

## Task set and baseline comparison

These are simulated document walkthroughs, not executions of a commit hook or search service. The baseline template already required checking grader faults; the addition makes coordinated fact updates and drift controls explicit.

| Task | Baseline coverage | New guidance | Result |
| --- | --- | --- | --- |
| Change a maintained fact without its quoted expectation | General grader review | Detect newly introduced mismatch before commit | Pass in walkthrough |
| Change fact and expectation together | No specific coordinated-update case | Preserve the question and quality requirements; retire history when required | Pass in walkthrough |
| Commit unrelated work while older drift exists | No old-versus-new drift distinction | Report existing debt separately | Pass in walkthrough |
| Retrieval actually misses the required source | General fault classification | Keep ranking requirements and verify the failure remains detectable | Pass in walkthrough |

## Metrics and grader check

Four of four walkthroughs have explicit guidance. This measures documentation coverage, not software correctness. The examples use generic facts and distinguish content mismatch from retrieval failure. No private source records are included.

False-alarm cost: an overly broad commit check blocks unrelated writers. Comparing newly introduced drift with existing debt limits that cost; warning-only inspection errors still require an audit and must not be reported as clean.

## Untested surface

No public implementation is added. Hook execution, parser behavior, concurrent commits, bypass enforcement, live retrieval, and publication recovery were not tested here. The observed internal repair motivates the pattern but is not a portable benchmark.

## Verdict

Ship the documentation. Do not interpret this review as verification of an executable guard.

## Artifact path and sign-off

The simulated task records are the table in this file. Reviewed by Claw with GPT-6, 2026-11-15. Linked from both changed documents.
