# Documentation Evaluation: Worker Evidence and Repeated Failures

## Header

- **Change under test:** [worker result collection](../../docs/self-improvement.md#46-collect-worker-results-before-deleting-the-worker), [repeated-failure detection](../../docs/self-improvement.md#47-detect-repeated-failures-separately-from-overdue-work), and [historical-writing limits](../../skills/avoid-ai-writing/SKILL.md#treat-past-writing-as-reference-material).
- **Document type:** workflow documentation and one existing writing skill.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from recent maintenance.
- **Fault side:** premature collection belongs to task coordination; incomplete failure counts belong to monitoring; unsupported writing exemptions belong to the review policy.
- **Scope:** documentation only. No runtime tools, installed skills, alerts, or detector rules change.

## Method and Task Set

The author manually applied the proposed instructions to the twelve synthetic cases below. Baseline coverage was inspected in the previous public documents. These are document walkthroughs, not executed runtime tests or independent judgments.

The fixed criteria are an actionable instruction, an observable result, preservation of uncertainty, and an explicit limit on what the evidence proves. Existing documentation on [fixture (synthetic test data) and live evidence](../../docs/self-improvement.md#30-separate-fixture-tests-from-live-evaluation) and [fact-preserving writing](../../docs/self-improvement.md#43-make-clearer-writing-preserve-the-facts) provides editorial reference points. No reader-comprehension improvement is claimed.

### Worker Lifecycle Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A running worker asks for a host record saved only after completion. | Completion and destination checks exist, without this persistence-order distinction. | Move collection to the parent after completion; the running state must not provide the record in the fake host. | Pass |
| A worker finishes, but the host record is delayed or missing. | A saved result is required, without a specific collection deadline. | Retry within a bound, then report missing evidence; do not turn finished status into proof. | Pass |
| A worker is deleted before the parent reads its records. | Independent continuation is required, without retention ordering. | Retain the worker until evidence is collected and saved outside its temporary state. | Pass |
| A failed attempt shares a host with unrelated workers. | Ownership is discussed elsewhere, without this collection sequence. | Preserve diagnostics, then delete only resources owned by this check. | Pass |

### Repeated-Failure Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| Several scheduled runs fail while the last success remains recent. | Alert severity and outcome reporting exist, without a consecutive-run count. | Count eligible failed runs independently of result age. | Pass |
| A diagnostic attempt fails between scheduled runs; a later recovery succeeds. | Run classification and reset semantics are unspecified. | Exclude the diagnostic failure and apply the explicitly defined successful-recovery reset. | Pass |
| History is missing or malformed; the last-run record contains one error. | No specific limit on inferred failure counts is documented. | Establish at most one failure from the available record; do not infer continuity or double-count a duplicate. | Pass |
| History writing fails and an error message contains private input. | General privacy and outcome separation exist without this monitoring boundary. | Preserve the actual job result, report only approved diagnostic fields, and keep automatic pauses under a separate policy. | Pass |

### Historical-Writing Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| An author frequently uses a spacing preference assigned an advisory severity. | Generic research guidance exists, without a bounded personalization policy. | Consider only a cosmetic exemption supported by samples for that author and format; do not enable it automatically. | Pass |
| Frequent old posts contain a substantive high-severity writing problem. | The research loop does not explicitly limit learned exceptions. | Keep the problem subject to review regardless of frequency. | Pass |
| Old posts repeatedly use unexplained internal vocabulary. | No explicit exclusion from cosmetic preferences exists. | Replace or explain the vocabulary; recurrence and low severity cannot make it eligible. | Pass |
| Preference data is malformed, or belongs to another author or format. | No explicit data-quality or applicability boundary exists. | Apply the existing rules without the unsupported exemption. | Pass |

## Metrics

- Manual document cases: **12 reviewed; 12 satisfy the stated documentation criteria**.
- Executed runtime cases: **0**.
- Independent reader or judge evaluations: **0**.
- Mapped artifacts refreshed: **1**, the existing writing skill.
- New skill ports: **0**.
- Pattern severities and scoring changes: **0**.

## Publication Checks

Added text was reviewed for private details and working document links. The vocabulary checker reported no unexplained internal terms. The prose review treated heading dates, Markdown syntax, and table layout separately from paragraph text; those presentation features can produce irrelevant writing warnings. Headings and link targets were checked independently. These checks cover publication quality, not runtime correctness.

## Evaluation-Fault Check

A fake host that returns records too early can approve an impossible lifecycle. A missing history file cannot prove several consecutive failures. A frequent writing habit cannot prove that readers understand or benefit from it. The review keeps those limits separate from a passing document example.

The author also judged these cases, so they do not provide independent evidence. All inputs are generic examples. Private incident text, operational identifiers, writing samples, and internal test measurements are excluded.

**Expected false-alarm cost:** incorrect failure counts can waste operator attention or interrupt healthy work. Overbroad writing rules can erase legitimate style. Retain run classification, explicit reset rules, and narrowly supported cosmetic preferences; test both valid and invalid examples.

## Untested Behavior

No host persistence timing, worker retention, deletion, alert delivery, history durability, concurrent writes, preference mining, or detector behavior was executed for this evaluation. The upstream implementation reports are not proof of this public documentation's runtime behavior. Live reliability and reader comprehension remain unmeasured.

## Result

**ship** as documentation. The instructions define collection order, evidence limits, and personalization boundaries without claiming installed enforcement.

## Artifact Path and Sign-off

- Artifact: this report; the synthetic cases and judgments are embedded above.
- Run by: Codex, author review.
- Date: 2026-10-05.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-05), both lessons, and the refreshed writing skill.
- Lesson: completion state, recorded outcomes, and historical frequency each prove less than a complete quality judgment.
