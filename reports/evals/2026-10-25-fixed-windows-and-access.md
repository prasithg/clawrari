# Fixed Time Windows, Operation Access, and Recommendation Horizons

The documentation preserves a failing historical case when the ordinary review window moves. It also separates denied reads from empty results and makes the intended lifetime of a recommendation explicit.

## Change Under Review

- **Change type:** public workflow documentation and one prompt template.
- **Files:** [time-window guidance](../../docs/self-improvement.md#58-preserve-the-time-window-that-reproduces-a-failure), [access guidance](../../docs/self-improvement.md#59-verify-access-to-the-requested-operation), and [audience contract](../../reference/agent-prompt-template.md#state-the-recommendations-time-horizon).
- **Issue:** none. This scheduled update captures existing operational work.
- **Failure location:** selection of evaluation inputs, operation-specific authorization, and the evidence requirements of a recommendation.

Only the agent prompt template is selected from the mapped synchronization backlog. The public copy retains its prior generalizations. No service, installed skill, authentication setting, or scheduled job changes in this commit.

## Method and Baseline

This is a manual documentation evaluation of ten hypothetical cases. The reviewer compared saved pre-edit copies with the revised instructions. No model experiment, historical audit, or external-operation test was executed for this evaluation.

The earlier guide requires complete check coverage and narrow generated-file exceptions. It does not explicitly preserve a failing interval after a rolling window expires. Its integration guidance distinguishes mocked and live evidence, but does not spell out operation-specific permission failures and the different meanings of retrieval and event times. The earlier audience contract names the reader and use, but omits the source template's decision horizon.

## Window Cases

| Case | Task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| W1 | A failing edit ages out of a two-day audit. | Empty windows require separate testing. | Preserve the original interval; a zero-record pass is not repair evidence. |
| W2 | A missing evidence record is supplied for an older edit. | Instruction files need evidence. | Repeat the fixed historical case and retain a missing-record negative control. |
| W3 | The current window passes before the next automated write. | Later observations remain distinct. | Report record count and keep the future-writer acceptance criterion open. |
| W4 | Historical source records have expired. | Missing evidence must remain visible. | Use an authorized retained snapshot or report that reproduction is unavailable. |

## Access Cases

| Case | Task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| A1 | Account lookup succeeds but the required read is denied. | Live integration checks are required. | Verify the exact read and authentication mode; account lookup is insufficient. |
| A2 | A denied read leaves an old output file on disk. | Evidence must be attributable. | Stop dependent processing; preserve the old file without treating it as fresh or empty success. |
| A3 | Historical records omit action time. | Recorded data has limited live relevance. | Separate creation, event, and retrieval times; leave the missing event time unknown. |

## Template Cases

| Case | Task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| T1 | Recommend an immediate action using older evidence. | Name the audience and intended decision. | Declare the immediate horizon and assess whether the evidence is recent enough. |
| T2 | Write a plan that depends on a changeable assumption. | State scope and acceptance criteria. | Name the planning period and assumptions needing recheck; no automatic review is implied. |
| T3 | Publish a procedure intended to remain useful. | Fit the artifact to its reader. | Separate the reusable procedure from dated examples; do not imply indefinite source validity. |

## Metrics and Evaluation Check

All ten manual cases have an explicit outcome in the revised text: four window cases, three access cases, and three template cases. These counts measure reviewed documentation cases, not executed software tests or reliability improvement.

A successful empty read remains valid evidence of zero returned records. A denied read does not. A fixed historical case and a later scheduled observation answer different questions. The review preserves these distinctions without changing a scoring threshold or claiming a source repair is complete.

False alarms cost the audit owner investigation time. Fixing an expired-window comparison must not hide a missing-record failure. No alert or validator is installed here.

## Untested Behavior

This review does not exercise an audit runner, credential scopes, concurrent writers, saved-output handling, live source freshness, or a later scheduled execution. It does not measure whether models follow the changed prompt field. Runtime adoption needs its own executed checks.

## Verdict (Result)

**Ship the documentation.** Runtime changes and any required later observations remain separate work.

## Artifact and Sign-Off

The complete case records are W1–W4, A1–A3, and T1–T3 above. The [changelog](../../CHANGELOG.md#2026-10-25) links this artifact: `reports/evals/2026-10-25-fixed-windows-and-access.md`.

Reviewed by: Claw, GPT-6 Astra. Date: 2026-10-25.

Lesson: keep the original evidence selection and its limits visible. Passing a different question cannot prove the intended result.
