# Scheduler Results, Known Defects, and Prompt Procedures

The documentation explains how a completed review can be recorded as a failed job and how to track a known defect without reporting it as fixed. One existing prompt guide also gains condition-first procedures with completion checks.

## Change Under Review

- **Change type:** public workflow documentation and one existing prompt template.
- **Files:** [scheduler guidance](../../docs/self-improvement.md#verify-the-stored-scheduler-result), [diagnostic guidance](../../docs/self-improvement.md#track-a-known-defect-without-calling-it-fixed), and [prompt procedures](../../reference/agent-prompt-template.md#write-procedures-with-conditions-and-completion-checks).
- **Issue:** none. This scheduled documentation update captures work already performed.
- **Failure location:** the boundary between a review reply and the scheduler's stored status, plus the reporting boundary between an operating threshold and a stricter diagnostic result.

Only the agent prompt template is selected from the mapped synchronization backlog. Other differences remain for later review. No installed skill, scheduler, detector, or retrieval service changes in this public commit.

## Method

This is a manual documentation evaluation of twelve hypothetical cases. The tables compare the saved pre-edit documents with the revised instructions. These cases use reasoning only. No scheduler, parser, or model execution was performed.

The earlier guide separates completed checks from passing checks and known-defect exceptions from acceptance. It does not explain status-marker removal in stored scheduler errors or the evidence limits of a separately owned diagnostic check. The earlier prompt template has acceptance criteria but no general condition-action-check procedure format.

## Scheduler Cases

| Case | Representative task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| S1 | Complete a review that finds defective work. | Completion and result are separate. | Keep the negative review finding; derive the run status from the review job's deliverable. |
| S2 | Complete a repair job without fixing the requested defect. | General completion criteria apply. | Keep the missing repair visible; review-job success rules cannot certify this deliverable. |
| S3 | Inspect a stored error after the scheduler removes its control marker. | Stored-message transformation is unspecified. | Inspect the original reply and transformation; absence of the marker alone proves nothing. |
| S4 | Classify a long genuine failure and a short false failure. | No report-shape classifier limit is stated. | Treat report shape as a heuristic, test both boundaries, and retain ambiguous cases. |

## Diagnostic Cases

| Case | Representative task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| D1 | Read a score that meets the operating minimum but misses a stricter diagnostic target. | Known defects do not satisfy acceptance. | Report both conditions; the stricter check stays failed with an owner and clearing condition. |
| D2 | Read a missing, malformed, or stale saved report. | Unavailable measurements cannot establish success. | Apply the declared evidence contract and distinguish unavailable evidence from a measured defect. |
| D3 | Read a score with no failing case identifiers after a later report overwrites an earlier failure. | General provenance rules apply. | Preserve timestamped results and report absent identifiers without inferring them. |
| D4 | Pass parser tests while the saved system score still fails. | Local checks cannot prove live behavior. | Keep parser correctness, system repair, the running service version, and later scheduled observation separate. |

## Procedure Cases

| Case | Representative task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| P1 | Author a settings update with several actions in one vague instruction. | Final acceptance criteria are required. | Split the procedure into numbered condition-action-check steps. |
| P2 | Verify a write that reports success but reads back a different value. | Verification is required but the step sequence is unspecified. | Read back the value and unrelated settings; record the mismatch without claiming verification. |
| P3 | Follow a procedure whose write is outside the task's authority. | Authorized scope is required. | Keep the write blocked; a completion check supplies no additional permission. |
| P4 | Explain the result to a human after one dependent step lacks evidence. | Human-facing output must fit its reader. | State the missing evidence plainly, keep names consistent, and continue independent authorized work. |

## Metrics and Evaluation Check

All twelve manual cases have an explicit, appropriate outcome under the revised text. Four concern scheduler status, four concern diagnostic evidence, and four concern prompt procedures. No measured reliability, model-quality, latency, or cost improvement is claimed.

The review checks the job's actual deliverable before assigning success. It also checks that a stricter diagnostic result does not replace an operating threshold or relax a release requirement. A false scheduler classification belongs to the status interpretation boundary; rewriting unrelated agent behavior would not repair it.

An alert based on report shape can cost an operator an unnecessary investigation or miss a genuine failure. A stale diagnostic report can also consume the repair owner's time. Record those limits before automating either rule. No new alert is installed here.

## Untested Behavior

No runtime implementation is executed by this evaluation. It does not prove classifier precision, report freshness enforcement, live service repair, scheduler compliance, or improved model execution. A trial or local check remains separate from the next normal scheduled run. The documentation does not close any unresolved repair in the source work.

## Verdict (Result)

**Ship the documentation.** Runtime changes require their own executed tests and any required later observations.

## Artifact and Sign-Off

The complete case records are the S1–S4, D1–D4, and P1–P4 tables in this file: `reports/evals/2026-10-23-scheduler-results-and-owned-defects.md`. The [changelog](../../CHANGELOG.md#2026-10-23) links this evaluation.

Reviewed by: Claw, GPT-6 Astra. Date: 2026-10-23.

Lesson: a useful report can coexist with a failed status or an unresolved defect. Verify each claimed outcome against the evidence that actually supports it.
