# Bounded Exceptions: Documentation Evaluation

## Header

- **Change under test:** [known-defect exceptions](../../docs/self-improvement.md#29-keep-known-defect-exceptions-separate-from-acceptance) and [model-update acknowledgements](../../reference/model-playbook/effort-ladder.md#weekly-model-freshness-check).
- **Surface class:** workflow documentation and one mapped model-playbook refresh.
- **Linked ticket:** N/A; scheduled capture of existing operational work.
- **Fault side:** documentation-to-tool mismatch and completion grading; exception scope belongs to the check and reporter.
- **Method:** author-reviewed walkthroughs of synthetic cases against saved baseline text and the edited documents. These measure instruction coverage, not live adoption or runtime enforcement.

The source work added a regression check for a documented CLI output that never appeared. Its temporary exception required the exact defect to remain openly rejected in the owning task. Separately, the source model-freshness checker verifies exact version-pair acknowledgements and retains incomplete catalog coverage. This update publishes those boundaries without copying private tasks, reports, configuration, or source implementations.

## Task Set

1. Keep an acknowledged defect visible without accepting the unfinished task.
2. Reject an exception when its defect, task state, or supporting evidence changes.
3. Preserve later upgrade findings after a specific version has been declined.
4. Distinguish an acknowledged upgrade from a missing measurement.

## Baseline vs New

### Known-Defect Cases

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| D1 | The tool passes validation but never prints the summary promised by its guide; the exact defect remains queued with a failed review | Completion claims require evidence; failed work remains failed | Compare the output with the promise. Label any temporary acknowledgement separately; the task still fails acceptance. | Pass |
| D2 | The same defect remains, but a newer record claims completion or the task enters acceptance | General completion verification, without conditions for an existing exception | Withhold the exception. An older failed review cannot authorize the newer completion claim. | Pass |
| D3 | The promise changes, a second defect appears, or the owning task cannot be verified | General narrow-scope and evidence guidance | Withhold the exception for changed, additional, or unverifiable work. | Pass |
| D4 | The promised output now exists, or the guide removes the unsupported promise | Repair the documented contract and verify completion | Use the ordinary check result and retire the exception. This closes the specific mismatch, not unrelated acceptance criteria. | Pass |

### Version Acknowledgement Cases

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| V1 | Version 1.1 was declined while 1.0 is installed; both are present in the catalog | Record a decision and reason to stop repeat alerts | Record the exact 1.0/1.1 pair and date; retain its acknowledged status in the report. | Pass |
| V2 | Version 1.2 later appears | No explicit scope for the old acknowledgement | Report 1.2 as a new finding. The 1.0/1.1 decision cannot hide it or exempt the family. | Pass |
| V3 | A required catalog is unavailable, or one acknowledged version cannot be verified; another upgrade is confirmed | General catalog comparison, without incomplete-coverage rules | Report incomplete coverage, retain confirmed findings, and do not silently treat the unverified pair as acknowledged. | Pass |

## Metrics

- **7 of 7 manual scenarios** have explicit decisions in the edited text.
- The existing source contract check passed **9 executable cases** in this run, including premature acceptance, changed promises, and missing task evidence.
- The existing public model-playbook validator passed: **16 model entries and 19 intents** remain aligned.
- One mapped pair is refreshed: the model-playbook directory, through its effort-ladder document. No model route, runtime configuration, or skill catalog entry changes.
- Latency, cost, live alert precision, and production reliability are not measured.

## Grader / Eval-Fault Check

The baseline already requires evidence for completion and records declined model upgrades. Those protections receive credit. The additions define exception boundaries and distinguish acknowledged debt from accepted work.

The source check's successful self-test verifies its case logic; it does not prove the underlying documentation defect was repaired. The public routing validator checks consistency; it does not query providers or implement acknowledgement behavior.

**False-alarm cost:** unverifiable supporting records can require operator investigation. Silently accepting an exception could instead hide unfinished work or a later release. Keep the reason visible so the operator can distinguish an existing acknowledged defect from a new failure. This publication installs no alert.

## Untested Surface

No independent reviewer, live issue-tracker state transition, provider outage, scheduled alert delivery, or live model comparison was exercised. Version cases are manual walkthroughs supported by source inspection, not a new execution of the freshness checker. Adopting these instructions requires implementing and testing the corresponding local checks.

## Verdict

**Ship** this documentation update. Its scope and evidence support the published instructions; it does not certify runtime enforcement or close the source task.

## Artifact Path

This document contains the synthetic inputs, baseline comparisons, decisions, and manual results. Baseline snapshots and executable-check output are retained in the private maintenance record and are not public dependencies.

## Sign-off

- Run by: Codex, GPT-6.
- Date: 2026-09-19.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-19), Self-Improvement, and the model effort ladder.
