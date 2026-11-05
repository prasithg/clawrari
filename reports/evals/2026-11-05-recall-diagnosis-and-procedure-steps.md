# Recall diagnosis and procedure steps: documentation evaluation

Date: 2026-11-05.

## Change under test

The [search guidance](../../docs/self-improvement.md#identify-the-failed-passage-and-the-questions-date) distinguishes passage selection, outdated expectations, missing source labels, and incomplete logs. The [agent prompt template](../../reference/agent-prompt-template.md#write-procedure-steps-with-completion-checks) adds conditions and completion checks to procedure steps.

Changed document types: guidance and an agent prompt template. Tracking: routine public documentation maintenance; no separate issue was created. Exactly one mapped artifact is refreshed: the agent prompt template. Its source instructions specify numbered imperative steps, conditions before actions, one completion check per action, consistent terms, and reader-specific reports. Existing public additions remain unchanged.

Fault location: search selection, source content, test expectations, or the evidence retained by the runner. A missing answer does not identify one common cause. The procedure addition defines instruction quality; it does not implement runtime enforcement.

## Method and task set

These nine cases are synthetic, manual instruction walkthroughs. Baseline observations describe the previous documents' coverage. They are not measurements from before-and-after agent runs. The reviewer compared each case with the added text and recorded the required decision. No live memory query, model comparison, source mutation, or test-data edit was performed.

### Recall cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| The expected file is first, but its answer-bearing passage is outside the measured result limit. | File identity and answer correctness were separate; passage-level positions were not explicit. | Retain the passage miss despite the file match. | Pass |
| A current-status question requires an earlier milestone despite verified newer evidence. | Controlled test edits and stale citations were covered generally. | Propose a dated historical question or an authorized expectation change; preserve the original failure. | Pass |
| The answer ranks first, but the source lacks the required uncertainty label. | Source and retrieval failures were distinguished generally. | Inspect source metadata and label handling before changing ranking. | Pass |
| A case named duplicate crowding records zero duplicates and misses the answer. | General fault diagnosis existed. | Treat the name as a hypothesis; preserve the answer omission and investigate its cause. | Pass |
| The evaluator reads full results, but the saved log contains a shortened first passage, later file paths, and an aggregate match flag. | Evidence limits were covered generally. | Distinguish grading input from saved evidence; leave unsupported passage positions unknown. | Pass |
| Source maintenance is paused while a proposed source repair would satisfy a failing case. | Publication boundaries and controlled edits existed elsewhere. | Keep the proposal pending and the original failure visible. | Pass |

### Procedure cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| A procedure mixes conditional directory creation with an export and has no per-step completion checks. | Outcome-level verification was required; procedure-step form was not explicit. | Separate ordered actions, put the condition first, and name a check for each action. | Pass |
| An export command exits successfully but saves records that violate its selection rule. | General behavioral verification existed. | Inspect the exported records; process success alone does not satisfy the step. | Pass |
| The agent needs exact tool paths, while the operator needs a short outcome summary. | Audience contracts existed without this procedure/report distinction. | Keep exact operational terms in instructions; explain results and uncertainty for the report's reader. | Pass |

## Metrics and verification

Manual documentation cases: 9 of 9 specify the intended decision. This measures instruction coverage only. The update changes no retrieval code, source records, test expectations, scheduler settings, or executable enforcement.

Fourteen file-scope, link, and privacy checks passed, including seven relative links and their section targets. All four writing samples passed with nonempty input verified. One advisory flag on imperative procedure steps was reviewed; the steps contain explicit actions and checks. The required secret-token scan and remote publication verification run separately.

## Evaluation-fault check

A file-level match is insufficient evidence for a passage-level requirement. A stale current-status expectation can misgrade a supported answer. A missing source label warrants inspection of both source and label handling; it does not prove a ranking defect. A truncated log limits reconstruction without proving that the evaluator used truncated input.

Two initial verification attempts were invalid: file reads with an output limit could not establish complete originals, and an incorrect detector input field supplied empty text. The corrected checks use complete contents from the specific prior public commit and assert the detector's input length. Initial outputs remain in the private publication record. These were verification errors, not successful checks.

Expected false-alarm cost: an unsupported diagnosis can send an operator toward the wrong repair or an unnecessary test-data change. Preserve the failure and the uncertainty until evidence supports the repair. No new alert or detector is installed.

## What remains untested

No live retrieval improvement, label propagation, test-data correction, concurrent source change, or automated procedure compliance was measured. The manual examples do not establish agent adherence, export correctness, or performance under adversarial input. A stronger runtime claim requires a separate implementation and evaluation.

## Publication decision

Ship the documentation with these limits. The operational failures used to motivate it are not claimed fixed.

Lesson learned: identify the exact passage and failed requirement before choosing a repair. Procedure steps also need checks of their intended effects.

## Artifact path and sign-off

The synthetic inputs, required decisions, and manual results are the tables in `reports/evals/2026-11-05-recall-diagnosis-and-procedure-steps.md`. Private operational examples are excluded.

Run by: Codex documentation review, 2026-11-05. Linked from the changelog and both changed guidance sections. No independent model review is claimed.
