# Check Contracts and Completion Evidence: Documentation Evaluation

## Header

- **Change under test:** [Self-Improvement §24](../../docs/self-improvement.md#24-repair-regression-checks-against-the-current-contract) and a bounded refresh of the [agent workflow](../../reference/sop-agent-task-workflow.md#3-complete).
- **Surface class:** workflow documentation.
- **Linked ticket:** N/A; scheduled capture of recent maintenance work and one existing public-artifact refresh.
- **Fault side:** obsolete inspection assumptions belong to the grader or tool integration. An authentic failed task remains a task failure even when its receipt is valid.
- **Method:** manual walkthroughs of synthetic scenarios against the previous and refreshed text. These are simulated decisions about instruction coverage, not executed runtime tests or agent-performance measurements.

Recent maintenance repaired checks that depended on old storage fields, executable layouts, and receipt vocabulary. The public lesson captures the diagnostic distinctions. The workflow refresh comes from existing completion and deferred-evaluation requirements. Private logs, host paths, people, accounts, and issue references are excluded. No runtime scripts or skills are ported.

## Task Set

1. Repair a check after a storage or installation layout change while preserving the tested property.
2. Validate completion receipts without converting a reported failure into successful work.
3. Close a workflow change with evidence, or retain a clearly owned and dated verification gap.

## Baseline vs New

### Check-contract cases

| Synthetic input | Previous documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A field moves into a nested record; the alert destination is unchanged | Existing guidance says to fix the source and retain thresholds; it does not address a stale inspection adapter | Update the read path, retain the destination predicate, and exercise a wrong-destination control. Report ambiguous inspection as unknown. | Pass |
| An executable becomes a launcher and a bundle filename changes | General completion and activation guidance does not cover installed-code discovery | Resolve the installed implementation, prefer supported interfaces, and state version limits for private-layout inspection. A discovery failure cannot establish health. | Pass |
| The producer documents a terminal failed status, but the receipt validator accepts only successful or incomplete statuses | General guidance separates run status from side effects, without defining the receipt-validity boundary | Accept the documented failure as a valid receipt while keeping the work unsuccessful. Missing, malformed, and unknown statuses remain invalid; exercise an unknown-status control. | Pass |

### Workflow refresh cases

| Synthetic input | Previous documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A reviewed workflow change has a linked evaluation | The separate evaluation section already requires the link; the completion checklist omits it | The checklist now repeats the existing completion prerequisite. This improves visibility; it introduces no new enforcement. | Pass |
| A workflow change has no evaluation link | The existing rule already blocks review and completion | It remains incomplete. The refreshed checklist does not relax the separate rule or treat code existence as sufficient. | Pass |
| A real evaluation cannot run because an external dependency is unavailable | The provisional path requires a dated TODO and owner, but no due date | Keep the change provisional and link a TODO with both owner and due date. Creating the TODO does not prove the deferred behavior works. | Pass |

## Metrics

- **6 of 6 manual scenarios** have a stated decision in the refreshed text. This is documentation coverage, not runtime reliability.
- Exactly one mapped public artifact is refreshed: the agent workflow.
- One recent-work pattern is added to the existing Self-Improvement document.
- No live runtime, alert configuration, assertion inventory, task state, or model route changes.
- Latency and cost are not grading criteria for this documentation change.

## Grader / Eval-Fault Check

The baseline already required evaluation evidence and distinguished broken graders from agent defects. The additions are specific repair boundaries, receipt validity versus outcome, completion-checklist visibility, and a due date for deferred work.

A simulated decision is insufficient evidence that an implementation handles a changed schema or rejects an invalid receipt. Negative controls are instructions for an eventual implementation; none were executed here.

**False-alarm cost:** no alert is added. A validator that rejects a documented failed receipt can create a false missing-output alert. A validator that accepts that receipt as task success hides the actual failure. The operator pays for both errors.

## Untested Surface

No runtime storage migration, launcher resolution, private-bundle discovery, receipt parser, scheduler, concurrent worker, issue-tracker transition, or live agent behavior was exercised. The documentation does not certify the private source implementations. Actual false-alarm rates and adoption of the refreshed checklist remain unmeasured.

## Verdict

**Ship** the bounded documentation change. The manual cases support publishing; they do not establish live system health.

A separate Claude Code review passed with no material findings. It checked source fidelity, the before/after comparisons, privacy of added content, local links and headings, and the distinction between receipt validity and task success. Its requested verdict finalization and optional changelog spacing cleanup were applied. This review assessed documentation only.

## Artifact Path

`reports/evals/2026-09-15-check-contracts-and-workflow.md` contains the synthetic inputs, baseline comparisons, decisions, and walkthrough results.

## Sign-off

- Run by: Codex, GPT-6.
- Independent reviewer: Claude Code.
- Date: 2026-09-15.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-15), Self-Improvement, and the agent workflow.
