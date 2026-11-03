# Recovery and report attribution: documentation evaluation

Date: 2026-11-03.

## Change under test

The [recovery guidance](../../docs/self-improvement.md#65-recover-missing-records-without-inventing-history) describes evidence-based reconstruction. The [storage guidance](../../docs/self-improvement.md#66-protect-scheduled-data-from-repository-operations) describes protection for actively written data. The [prompt addition](../../reference/agent-prompt-template.md#identify-automated-completion-reports) identifies automated reports.

Changed document types: guidance and an agent prompt template. Tracking: routine public documentation maintenance; no separate issue was created. Exactly one mapped artifact is refreshed: the agent prompt template. The source instruction requires a maintained posting helper because unmarked automated comments can be mistaken for human comments. Related operational evidence supports the distinction; no private reports or examples are copied here.

Fault location: the execution environment can replace uncommitted runtime data, while a receiving service can misclassify report authorship. The documentation assigns those protections to storage and service behavior. It does not claim that a prompt alone enforces them.

## Method and task set

The following twelve cases are synthetic, manual instruction walkthroughs. Baseline observations describe the previous documents' coverage, not a measured agent run. The reviewer compared each case with the added text and recorded the required decision below. No production recovery, service call, or model comparison was performed for these cases.

### Recovery cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| A historical report counts ten outcomes, but only six have retained source records. | Source preservation was covered; reconstruction rules were absent. | Recover the six supported outcomes and retain four as gaps. | Pass |
| An event's text is known, but only its publication time survives. | Historical source gaps were covered generally. | Label the substituted timestamp and unknown metadata. | Pass |
| Rebuilt totals match, but one underlying record differs. | Individual comparisons existed elsewhere, without recovery-specific application. | Keep recovery unverified until the record-level difference is resolved. | Pass |
| An application accepts added recovery fields while the declared format rejects them. | General evaluation-fault guidance existed. | Report both results and preserve the unresolved contract; do not claim full compliance. | Pass |

### Storage cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| A scheduled writer has added data since the last commit when branch integration starts. | Write ownership was covered generally. | Isolate branch integration and preserve unrelated live bytes. | Pass |
| A runtime file leaves Git tracking without an ignore rule. | No specific runtime-data storage procedure. | Preserve the file and add precise ignores for it and its copies. | Pass |
| An append succeeds but publishing its recovery copy fails. | Interrupted side effects were covered generally. | Report the saved append separately; do not blindly retry it. | Pass |
| A file has equal row counts but changed content, or only an early daily copy survives. | No specific row-count or daily-copy limit. | State the detection gap; do not claim complete recovery or off-machine backup. | Pass |

### Attribution cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| An authorized automated status report uses a person's service account. | Output notifications were described without this attribution rule. | Use the maintained helper and identify the automated producer and task. | Pass |
| A genuine human follow-up arrives after an automated report. | No paired author-classification check. | Keep the human follow-up eligible for handling. | Pass |
| A report lacks an automation marker or has contradictory author evidence. | No explicit unresolved-attribution case. | Preserve uncertainty; do not infer human authority from the display name. | Pass |
| Automated review feedback carries a readable marker. | Generic review guidance existed. | Keep expected review feedback available; a marker cannot authenticate it or grant authority. | Pass |

## Metrics and verification

Manual documentation cases: 12 of 12 specify the intended decision. These results measure instruction coverage only. Ten relative links and their section targets passed inspection. A scan of the additions found no private organization names, personal identifiers, internal service links, or local home paths. Token scanning and publication verification run separately before release.

## Evaluation-fault check

A total-count match is an incomplete recovery criterion. Missing evidence is not permission to invent an event. Likewise, a shared account name or a text marker alone is insufficient author verification. These are limits of the criterion or available evidence, not proof of a model defect.

The social-text writing detector also treated Markdown headings and link syntax as invalid message formatting. The writing review therefore used reader-visible text with those syntax markers removed; link destinations were checked separately. The original finding remains in the private publication record. No detector rule was changed or disabled.

Expected false-alarm cost: a suspected count reduction or unresolved author requires an operator's review. Ordinary data growth and marked status reports must not become automatic incident claims. No new detector is installed in this update.

## What remains untested

No merge abort, concurrent live append, power failure, disk restore, retention job, or service author-classification implementation was exercised. The source recovery remains partial. This documentation evaluation does not establish that its missing history or data-format conflict is resolved. The manual examples do not measure agent adherence or performance under adversarial input.

## Publication decision

Ship the documentation with those limits. Runtime recovery and service behavior require their own implementation and verification.

Lesson learned: evidence-supported recovery, repeatable measurements, and complete history are separate claims. Automated reports also need explicit authorship before a responder can interpret them.

## Artifact path and sign-off

The synthetic task inputs, decisions, and observed manual results are the tables in `reports/evals/2026-11-03-recovery-and-report-attribution.md`. Private operational inputs are intentionally excluded.

Run by: Codex documentation review, 2026-11-03. Linked from the changelog and each changed guidance section. No independent model review is claimed.
