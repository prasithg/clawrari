# Documentation Evaluation: Report Scope and Executable Examples

## Header

- **Change under test:** [full-report preservation](../../docs/self-improvement.md#52-keep-small-test-runs-from-replacing-full-reports), [executable setup examples](../../docs/self-improvement.md#53-execute-published-setup-examples-from-a-fresh-folder), and [coding completion blocks](../../reference/agent-prompt-template.md#coding-completion-blocks).
- **Document type:** workflow documentation and one existing agent prompt template.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from maintenance and review.
- **Fault side:** partial runs replacing full reports are a reporting defect. Missing setup prerequisites and incorrect exit-status descriptions are documentation defects.
- **Scope:** documentation only. No test runner, launcher, model configuration, installed skill, or scheduled job changes.

## Method and Task Set

The author manually applied the proposed instructions to twelve synthetic cases. Baseline coverage was inspected in the previous public documents. These are documentation walkthroughs, not executed runtime tests or independent judgments.

Each case requires a usable action, an observable result, and a conclusion limited to the evidence. Existing guidance on [check coverage](../../docs/self-improvement.md#28-count-completed-checks-separately-from-passing-checks), [fresh-checkout dependencies](../../docs/self-improvement.md#20-track-the-files-a-fresh-checkout-needs), and [post-build validation](../../reference/agent-prompt-template.md#post-build-validation) remains in force.

### Report-Scope Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| One failing diagnostic check runs after a full suite. | Coverage counting exists without an explicit report destination rule. | Save the diagnostic separately; compare both full reports before and after. | Pass |
| One diagnostic check passes before any full report exists. | No rule forbids creating a full-report placeholder from partial results. | Save only the partial result and leave full reports absent. | Pass |
| Shared history contains full and selected-check runs. | Completed and passing counts are distinct, but run scope is not specified here. | Record scope and selection; require consumers to filter partial coverage. | Pass |
| A repaired check exposes an unresolved system defect. | Check-repair guidance already preserves genuine failures. | Retain the failure result and do not let the smaller report replace full coverage. | Pass |

### Setup-Example Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| Output redirection names a folder missing from a new checkout. | Tracked-dependency guidance does not require executing the displayed setup sequence. | Start from stated prerequisites, create the folder, and confirm the program is invoked. | Pass |
| An outer timeout command returns a different status from its child. | Whole-process deadline guidance exists without this exit-status distinction. | Exercise the exact timeout invocation and record the outer and child results separately. | Pass |
| A harmless stand-in saves output, but live authentication is untested. | General synthetic-versus-live limits exist. | Verify saved output while keeping authentication and provider behavior explicitly unverified. | Pass |
| The maintained guide is corrected but a shared copy is stale. | Generic output checks do not compare guide copies. | Compare the final copies after correction; only the tested version is ready for readers. | Pass |

### Coding-Completion Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| The implementation is written but never executed. | General completion checks exist; the coding example lacks separate completion blocks. | Record implementation evidence while leaving runtime validation incomplete. | Pass |
| A program exits successfully but its empty output violates the required format. | Acceptance criteria can catch this if the author remembers the edge case. | Explicitly check location, format, and empty-result behavior before completion. | Pass |
| A safe local substitute works while the required live service is unavailable. | Post-build guidance already distinguishes simulated and live evidence. | Record the validation path and exact blocker; keep the live criterion incomplete. | Pass |
| All output checks pass, but an unrelated file was modified. | Change scope is stated elsewhere in the template. | Include an explicit scope inspection in the final verification sequence. | Pass |

## Metrics

- Manual document cases: **12 reviewed; 12 satisfy the stated criteria**.
- Runtime cases executed for this publication: **0**.
- Independent reader or model evaluations: **0**.
- Mapped artifacts refreshed: **1**, the existing agent prompt template.
- New skill ports: **0**.

## Grader / Evaluation-Fault Check

The author also judged these cases. They establish that the instructions specify actions for the modeled failures, not that an implementation enforces them. General completion and evidence rules already existed; the template change supplies explicit coding blocks without claiming a measured improvement in agent performance.

A passing small test run cannot establish full-suite health. A corrected check does not prove that the system it checks is repaired. A stand-in does not verify live authentication. A prompt does not create automatic review.

**Expected false-alarm cost:** mislabeling partial coverage can hide a failure or generate a misleading alert. Incorrect timeout classification can trigger unnecessary recovery. This documentation adds no automated alerts.

Private incident identifiers, customer details, source data, and internal measurements are excluded.

## Behavior Not Tested

No reporting implementation, shell example, live provider, scheduler, or delegated coding task ran for this publication. Concurrent report writes, status-page filtering, platform-specific command behavior, and agent compliance require separate execution evidence.

## Evaluation Result

**ship** the documentation within its stated scope. This result does not close any unresolved implementation defect.

## Lessons Learned

Preserve the scope of the evidence at each boundary: a selected check, a stand-in program, and a completed code edit each prove less than the complete workflow.

## Artifact Path

This file contains the complete manual case record: `reports/evals/2026-10-11-report-scope-and-executable-examples.md`. There is no separate runtime transcript for these walkthroughs.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-11.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-11), self-improvement guide, and agent prompt template.
