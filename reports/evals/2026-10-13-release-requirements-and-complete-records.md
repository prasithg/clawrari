# Documentation Evaluation: Release Requirements and Complete Records

## Header

- **Change under test:** [release requirements](../../docs/self-improvement.md#keep-release-requirements-separate-from-comparison-baselines), [complete-entry review](../../docs/self-improvement.md#54-review-the-full-entry-before-adding-a-lesson), and [supervised implementation](../../reference/model-playbook/models/gpt-6-astra.md#separate-supervised-implementation-from-verification).
- **Document type:** workflow documentation and one existing model guide.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from actual maintenance and review.
- **Fault side:** changing a stated minimum after measuring a candidate is an evaluation-decision error. Treating a queue preview as the full record is an evidence-selection error.
- **Scope:** documentation only. No installed skills, model routing, launchers, scheduled jobs, or production checks change.

## Method and Task Set

The author manually applied the revised instructions to nine synthetic cases. Baseline coverage was inspected in the previous public documents. These are documentation walkthroughs, not executed software tests, independent judgments, or measurements of model behavior. The example scores below are synthetic.

Each case requires an action, an observable completion condition, and a conclusion limited to the available evidence.

### Release Requirement Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| The candidate and unchanged system both score 7/10 against a required 8/10. | The guide rejected lowering thresholds, without separating causal comparison from release eligibility explicitly. | Retain both measurements. State that the defect predates the candidate and that the release requirement still fails. |
| A check cannot read the candidate's build identity. | Generic evidence-preservation guidance did not cover this rejected-build check. | Report that identity could not be verified. Do not treat the missing evidence as a passing result. |
| The restored version passes a check for absence of one rejected build. | The guide separated run status from work outcomes. | Claim only that the rejected build is absent. Keep the underlying quality problem and future-build acceptance unresolved. |

### Complete Record Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A short preview omits a dated clause that already covers the proposed lesson. | Existing curation guidance compared candidates with a baseline but did not require the complete entry at this decision point. | Read the dated clause and record a skip. Leave the entry unchanged. |
| The entry covers the procedure but lacks one specific detail. | Existing guidance described refinements in general terms. | Add only the missing detail within authorized scope; verify the decision, the entry, and resolved state. Preserve unrelated history. |
| The item is absent before the next scheduled run, which has not completed. | Existing guidance required exact-run evidence in other workflows. | Leave recurrence prevention unverified until a successful scheduled run completes and a fresh check confirms absence. Do not claim recurring automation was installed. |

### Supervision Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A limited feature has a clear specification and review between passes. | The central effort guide described phase-specific effort; the model-specific coding default was ambiguous about supervision. | Start implementation at medium and request separate high or xhigh verification. The instructions agree with the central guide. |
| Supervised work changes a parser or credential boundary. | The central guide treated edge cases as a reason for higher effort. | Keep implementation at high or above when warranted. Supervision does not remove the risk exception. |
| A substantial coding job runs unattended. | The model guide already used xhigh for substantial coding. | Preserve xhigh for unattended work. Do not apply the supervised-work default or claim a launcher was updated. |

## Metrics

- Manual documentation cases reviewed: 9 of 9.
- Cases with a usable action and appropriately limited conclusion: 9 of 9, by author judgment.
- Runtime tests and live model comparisons executed for this publication: none.
- Latency, token use, and cost improvements: not measured.

## Grader / Eval-Fault Check

The rubric checks instruction coverage and consistency, not whether prose enforces behavior. A same-run baseline can help diagnose causality without replacing an explicit requirement. If a requirement itself is wrong, obtain an authorized revision and preserve the prior result rather than substituting a lower minimum without approval.

The queue cases do not assume a production defect merely because a new test was added. The supervision cases check agreement between documents, not which effort setting performs best.

## What Was Not Tested

This evaluation did not execute a rejected-build detector, protected-record writer, scheduled consumer, launcher, or model comparison. It did not test adversarial inputs, concurrent decisions, or recurrence after a real scheduled run. Those claims need separate runtime evidence.

## Result

**ship** the limited documentation update. No production repair, quality-score improvement, recurring automation, or provider-performance gain is claimed.

## Artifact Path

The complete manual case inputs and author judgments are the tables in this file: `reports/evals/2026-10-13-release-requirements-and-complete-records.md`. There is no separate runtime test transcript.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-13.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-13), self-improvement guide, and model guide.
- False-alarm cost: no detector or alert is installed by this change.

## Lesson Learned

Preserve distinct conclusions when they answer different questions: causality and release eligibility; an empty queue and a verified write; one successful decision and a working recurring process.
