# Documentation Evaluation: Waiting Limits, Search Results, and Draft Retention

## Header

- **Change under test:** [whole-process waiting limits](../../docs/self-improvement.md#50-verify-waiting-limits-across-the-whole-process), [search-result reporting](../../docs/self-improvement.md#51-keep-failed-searches-separate-from-empty-results), and [draft retention](../../skills/avoid-ai-writing/SKILL.md#retain-drafts-that-passed-review).
- **Document type:** workflow documentation and one existing writing skill.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from maintenance and review.
- **Fault side:** a process waiting past its deadline is an execution defect; treating a failed request as empty data is an interpretation defect. Missing passing drafts limits later writing review.
- **Scope:** documentation only. No launcher, connector, detector, storage tool, or installed skill changes.

## Method and Task Set

The author manually applied the proposed instructions to twelve synthetic cases. Baseline coverage was inspected in the previous public documents. These are documentation walkthroughs, not executed runtime tests or independent judgments.

The criteria are a usable action, an observable outcome, preserved uncertainty, and a clear limit on the conclusion. The existing sections on [check coverage](../../docs/self-improvement.md#28-count-completed-checks-separately-from-passing-checks) and [worker evidence](../../docs/self-improvement.md#46-collect-worker-results-before-deleting-the-worker) provide related guidance. The prior public writing skill supplies the editorial baseline for retention.

### Waiting-Limit Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A child-wait helper returns on time, but an output reader remains blocked by a background child. | Completion and worker-evidence guidance does not address the remaining output connection. | Measure the launcher's final return and include output collection in the time budget. | Pass |
| A host stops background work when the agent exits. | Existing result-collection guidance cannot recover a stopped task. | Verify host behavior and keep required measurements in supported tracked execution. | Pass |
| Only tests with redirected child output pass; the agent's original error is lost. | No specific inherited-output comparison or original-result requirement. | Test ordinary and redirected output through each supported mode; retain the original agent result. | Pass |
| A waiting deadline expires before results are complete, or waiting is disabled. | Generic limits do not define this completion boundary. | Report unfinished work, preserve available evidence, respect cancellation authority, and keep real-workload acceptance open. | Pass |

### Search-Result Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A rejected search produces plain text saved under a structured-data filename. | General output verification exists without this request-error distinction. | Preserve the raw text separately and record explicit failure in a parseable summary. | Pass |
| A successful filtered request returns zero records and no further pages. | Empty-result handling exists for other artifacts. | Verify success, scope, and pagination before reporting zero matches. | Pass |
| A request returns records for the wrong owner, or another page remains. | General identifier checks do not establish filtering completeness. | Validate returned identities and states, finish pagination, and state any local selection. | Pass |
| A maintained instruction teaches an unsupported parameter while historical notes quote it. | Instruction maintenance is documented without this query-specific acceptance sequence. | Correct active teaching examples, distinguish history, test both requests, and verify normal scheduled output when required. | Pass |

### Draft-Retention Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A passing piece has no detected problems, but a reader later finds it generic. | The logging step requests original text without explicitly calling out passing pieces. | Preserve the full passing draft so later review can inspect the missed example. | Pass |
| A rejected piece is rewritten with author preferences applied. | Original text, review result, and rewrite are already required. | Preserve those fields and keep applied preferences visible. | Pass |
| A second attempt has the same proposed filename. | Append-only intent exists without a returned-path or byte-comparison instruction. | Save a distinct artifact, return its path, and verify the first artifact is unchanged. | Pass |
| A passing draft contains private material. | Private local retention is already required. | Preserve that boundary and separate writing acceptance from permission to publish. | Pass |

## Metrics

- Manual document cases: **12 reviewed; 12 satisfy the stated criteria**.
- Runtime cases executed for this publication: **0**.
- Independent reader or model evaluations: **0**.
- Mapped artifacts refreshed: **1**, the existing writing skill and its changelog.
- New skill ports: **0**.

## Evaluation-Fault Check

A passing helper test does not establish a whole-process deadline. A successful transport status does not establish a successful query, and a positive record count does not prove correct filtering. A passing writing result does not make a draft public.

The author also judged these examples. The changes make the existing logging requirement explicit; they do not demonstrate a storage repair or improved writing quality. Private incident records, identifiers, input data, and measurements are excluded from this report.

**Expected false-alarm cost:** an incorrect completion rule can interrupt useful work; a mistaken empty-result report can hide work. A retention failure can remove examples needed for review. This change introduces no automated alerts.

## Behavior Not Tested

No launcher, live connector, scheduled report, or storage implementation ran for this publication. Deadline enforcement, long-running measurements, concurrent writes, storage failure recovery, access controls, and detector quality require separate implementation evidence.

## Evaluation Result

**ship** the documentation within its stated scope. This result does not close any unresolved implementation defect.

## Artifact Path

This file contains the complete manual case record: `reports/evals/2026-10-09-waiting-results-and-draft-retention.md`. There is no separate runtime transcript for these walkthroughs.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-09.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-09), self-improvement guide, and writing skill.
