# Documentation Evaluation: Delivery States and Review Findings

## Header

- **Change under test:** [distinct delivery states](../../docs/self-improvement.md#distinguish-unsent-uncertain-and-confirmed-delivery) and [review findings](../../reference/agent-prompt-template.md#report-findings-with-impact-and-confidence).
- **Document type:** recovery guidance and one existing agent prompt template.
- **Linked ticket:** N/A. Scheduled publication of lessons from maintenance and review.
- **Fault side:** an ambiguous delivery record can cause repeated sends. A review request restricted to severe defects can omit supported findings the owner still needs.
- **Scope:** documentation only. No sender, record writer, runtime setting, or installed skill changes.

## Method and Task Set

The author manually applied the revised instructions to nine synthetic cases. The comparison describes previous public coverage and the action supported by the new text. These are documentation walkthroughs, not software tests, independent reviews, or measured model comparisons.

Each case requires a usable action and a conclusion limited to the available evidence.

### Delivery Cases

| Task | Previous coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| Publication is verified, but the confirmation argument for a summary is omitted. | The guide separated publication and messaging without specifying optional-argument semantics. | Retain publication-only state and reuse the existing result. Do not claim the summary was sent. |
| A sender confirms success without returning a message identifier. | Missing identifiers appeared in the test list, but the resulting state was unspecified. | Record explicit completion and skip another send. An identifier is optional only after success is confirmed. |
| The process stops after sending and before recording the response. | The guide required intent and destination verification in general. | Persist sending state before the request. On retry, check the destination and save a matching summary's existing identifier. |
| A successful history read returns no match but covers only the newest messages. | The guide preserved ambiguous evidence without defining the required history coverage. | Keep delivery unresolved. An empty partial result does not authorize another send. |
| A retry starts after midnight, or the existing record is malformed. | The guide used a stable operation key and rejected malformed evidence without naming the date boundary. | Keep the original scheduled date and time zone. Preserve a malformed record and withhold publication and sending. |
| A repeated publication-only update replies with completion although a fresh read still says publication-only. | The guide already required matching update and read results. | Retain that requirement. Reject the contradictory result and do not infer completed delivery. |

### Review Cases

| Task | Previous coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A review finds a supported minor defect and a supported severe defect. | The template required review but did not request findings across severity levels. | Report both with locations, evidence, and consequences. Put the severe defect first; apply the task's acceptance criteria to the completion decision. |
| A potentially severe concern lacks enough evidence to confirm a defect. | The template requested remaining risks without separating severity from confidence. | State the possible consequence and missing evidence. Keep the concern uncertain rather than upgrading it to a confirmed finding. |
| A scoped review finds no supported defects but did not exercise live behavior. | Existing guidance required missing review evidence to remain visible. | Return no findings, identify the reviewed scope, and retain the live-testing limitation. Do not invent a defect to fill the report. |

## Metrics

- Manual documentation cases reviewed: 9 of 9.
- Cases with usable actions and appropriately limited conclusions: 9 of 9, by author judgment.
- Software tests, live interruption experiments, and model comparisons executed for this publication: none.
- Duplicate-send prevention and review-quality improvements: not measured by this publication.

## Grader and Evaluation-Fault Check

The review checks instruction coverage and consistency. The delivery cases preserve the distinction between no confirmation, uncertain delivery, and confirmed success without an identifier. They do not treat a successful history request as proof that its results are complete.

The review cases separate impact from evidential support. They require supported lower-severity findings without asking the reviewer to manufacture defects. The original acceptance criteria still determine whether work can finish.

Private maintenance evidence motivated the delivery guidance. Its identifiers, source text, and measurements are excluded from this public report. The template refresh is a generalized instruction, with no claim of measured model behavior.

## What Was Not Tested

This review did not exercise destination consistency, pagination, concurrent workers, crashes, storage failures, or a sender implementation. It did not measure an agent's compliance, reviewer accuracy, or calibration of confidence. A local record cannot guarantee that an external action occurs exactly once.

## Result

**ship** the limited documentation refresh. No runtime repair, automatic enforcement, or measured quality improvement is claimed.

## Artifact Path

The complete synthetic inputs and author judgments are the tables in this file: `reports/evals/2026-10-19-delivery-states-and-review-findings.md`. There is no separate software-test transcript.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-19.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-19), self-improvement guide, and agent prompt template.
- False-alarm cost: incomplete history can delay a summary until an operator resolves its delivery state. The documentation names that delay rather than authorizing a duplicate.

## Lesson Learned

An absent message identifier can mean several different outcomes. Record the outcome explicitly. In review, report the consequence of a possible defect separately from the evidence that it exists.
