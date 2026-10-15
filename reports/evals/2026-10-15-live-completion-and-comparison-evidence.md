# Documentation Evaluation: Live Completion and Comparison Evidence

## Header

- **Change under test:** [implementation completion](../../docs/self-improvement.md#separate-implementation-completion-from-live-deployment), [verified comparison inputs](../../docs/self-improvement.md#55-compare-individual-results-on-verified-inputs), [repeated search labels](../../docs/self-improvement.md#56-keep-repeated-search-labels-from-multiplying-evidence), and [constructive delegation](../../reference/agent-prompt-template.md#give-positive-instructions-and-invite-supported-disagreement).
- **Document type:** workflow documentation and one existing prompt template.
- **Linked ticket:** N/A. Scheduled publication of lessons from actual maintenance and review.
- **Fault side:** treating tested files as a live fix is a completion-decision error. Incomplete input identity is an evaluation error. Excess alias weighting is a retrieval-tool error.
- **Scope:** documentation only. No runtime, installed skill, test runner, scheduler, or model-routing change is included.

## Method and Task Set

The author manually applied the revised instructions to twelve synthetic cases. Baseline coverage was inspected in the previous public documents. These are documentation walkthroughs, not executed software tests, independent judgments, or measurements of model behavior. The numeric examples below are synthetic.

Each case requires a usable action, an observable completion condition, and a conclusion limited to the available evidence.

### Completion Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A worker passes local tests but is forbidden to activate the service; the parent task requires a live fix. | The guide required deployment evidence but did not explicitly require a separately closeable implementation task. | Keep the service-level task open. Define and verify an implementation task with its own criteria. Local success does not satisfy the parent. |
| A limited implementation task has complete tests and files, while authorized deployment will happen later. | The distinction between deployment evidence and implementation completion was implicit. | Preserve the tested candidate and report the finished implementation separately from pending deployment. Do not reject correct code merely because deployment is deferred. |
| The authorized task includes deployment and a live behavior check. | Existing guidance already required loaded-version evidence. | Complete the parent only after the live check identifies the intended version and proves the required behavior. Preserve the existing distinction between process identity and version identity. |

### Comparison Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| Before and after each pass 8 of 10 cases, but one formerly passing case is lost. | The guide separated release minimums from causal comparisons without requiring this case-level comparison. | Report the lost and gained cases. Apply the declared acceptance rule; equal totals do not establish unchanged behavior. |
| A file changes between runs while the recorded revision label stays unchanged. | Existing controlled-evidence guidance did not explicitly cover an incomplete input identity. | Treat the label as insufficient. Preserve or verify the actual inputs before attributing the difference to the patch. |
| A case alternates between passing and failing on the unchanged implementation. | Existing guidance required evaluation-fault diagnosis but did not specify pre-change characterization here. | Record the unstable case and relevant inputs before evaluating the candidate. Keep its outcome visible and exclude it from unsupported improvement claims. |

### Retrieval Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| Several aliases repeat one query word and outrank the entry that answers the question. | Existing source-authority guidance left duplicate score contributions as a separate problem. | Inspect field contributions and limit repeated normalized tokens within the alias field when they cause the error. Verify the intended answer. |
| Another entry matches more distinct query terms, while repeated body text has separate scoring semantics. | The public guide had no field-specific alias repair procedure. | Preserve credit for distinct alias terms and leave body-text frequency unchanged. Check both behaviors instead of removing repetition globally. |
| Local comparisons improve, but the running service still uses the old implementation. | Existing deployment guidance already rejected unsupported live claims. | Report the local result only. Verify broader individual results and privacy checks, then require deployment evidence for a live claim. |

### Prompt Cases

| Task | Baseline coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| The task instructions begin with a long list of mistakes from earlier attempts. | The public template supplied scope and completion blocks without this explicit framing guidance. | Start with the desired task and observable result. Convert ordinary criticism into actionable requirements. |
| A negative instruction protects data from deletion. | The public template already retained hard boundaries. | Keep the prohibition. Positive wording does not remove a necessary restriction. |
| The requested approach conflicts with the cited requirements. | Existing review instructions checked conflicts, but did not explicitly invite supported disagreement in the task instructions. | Identify the conflict and recommend a correction. Continue authorized independent work; do not expand scope without authorization. |

## Metrics

- Manual documentation cases reviewed: 12 of 12.
- Cases with usable actions and appropriately limited conclusions: 12 of 12, by author judgment.
- Runtime tests and live model comparisons executed for this publication: none.
- Retrieval accuracy, latency, cost, and model-compliance improvements: not measured by this publication.

## Grader / Eval-Fault Check

The rubric checks instruction coverage and consistency. It does not prove that prose enforces behavior. The completion cases preserve the original live requirement. The comparison cases retain explicit release minimums and do not turn privacy failures into acceptable noise. The retrieval cases limit the repair to a demonstrated alias-field fault. The prompt cases preserve authorization and hard restrictions.

The source maintenance work motivates these patterns; its private examples and results are not reproduced as public test evidence. The synthetic cases cannot establish a universal ranking improvement or a provider-specific prompting effect.

## What Was Not Tested

This evaluation did not activate a service, run a retrieval implementation, verify an immutable input capture system, or compare model responses. It did not exercise concurrent input writers, adversarial alias lists, or applications that intentionally weight repeated aliases. Those claims need separate runtime evidence.

## Result

**ship** the limited documentation update. No live repair, measured retrieval improvement, automated enforcement, or model-performance gain is claimed.

## Artifact Path

The complete manual case inputs and author judgments are the tables in this file: `reports/evals/2026-10-15-live-completion-and-comparison-evidence.md`. There is no separate runtime test transcript.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-15.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-15), self-improvement guide, and agent prompt template.
- False-alarm cost: no detector or alert is installed by this change.

## Lesson Learned

Match the claim to the evidence: tested files establish implementation progress, individual comparisons reveal behavior changes, and verified live results establish service completion.
