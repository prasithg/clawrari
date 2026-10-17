# Documentation Evaluation: Changing Inputs and Meaning Checks

## Header

- **Change under test:** [recording search-input changes](../../docs/self-improvement.md#record-changes-to-the-data-being-searched), [enabled integrations](../../docs/self-improvement.md#test-optional-integrations-when-enabled), and [separate writing revisions](../../skills/avoid-ai-writing/SKILL.md#separate-structure-and-voice-revisions).
- **Document type:** evaluation guidance and one existing writing skill.
- **Linked ticket:** N/A. Scheduled publication of lessons from actual maintenance and review.
- **Fault side:** attributing a changed answer to one edit without controlling other input changes is a measurement error. Altering facts during a style rewrite is a writing error.
- **Scope:** documentation only. No retrieval implementation, scoring rule, detector, installed skill, or runtime setting changes.

## Method and Task Set

The author manually applied the instructions to twelve synthetic cases. The comparison below describes coverage in the previous public documents and the action supported by the revised text. These are documentation walkthroughs, not software tests, independent reviews, or measured model comparisons. All numeric examples are synthetic.

Each case requires a usable action, a checkable result, and a conclusion limited to the available evidence.

### Measurement Cases

| Task | Previous coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A source file changes during a run while the published revision label stays fixed. | The guide required verified inputs but did not specify start-and-end recording. | Record both file states and the scope covered. Treat the comparison as unresolved until the changing input is controlled. |
| A file's modification time changes, but its content digest stays identical. | The guide did not explain the limits of metadata-based change detection. | Report the metadata change without claiming the text changed. Prefer content evidence when available. |
| A changed document is absent from a question's returned sources, but ranking shifts. | The guide did not explicitly cover collection-wide effects outside the returned sources. | Do not infer causal independence from absence. Investigate the changed collection on controlled inputs. |
| A stored-fact correction is the intended change, while another writer also updates unrelated notes. | Verified-input guidance could be read as forbidding the intended data change itself. | Identify the deliberate correction separately, control unrelated writes, and keep the questions and scoring rules fixed. |
| A question passes three separate original runs and fails three separate candidate runs. | The guide required instability evidence but did not distinguish repeated measurements from one saved observation. | Retain the repeated decline and investigate its cause. Neither missing source attribution nor an unstable label establishes that the candidate is safe. |
| One unstable question is removed from a ten-question comparison, including a privacy check. | The guide kept individual results visible but did not specify symmetric exclusions and denominators. | Show the original ten-question results and the nine-question adjusted results on both sides. Keep the privacy requirement unresolved until independently satisfied. |

### Integration Cases

| Task | Previous coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| An integration refuses calls by default, and only that refusal is tested. | The guide separated local and live evidence without explicitly requiring both activation states. | Retain the default-restriction result. Require separate evidence that the enabled operation is implemented and handles responses and failures. |
| Explicit opt-in reaches an unimplemented placeholder before any request can be made. | The guide named unavailable services but did not distinguish them from missing implementation. | Keep the enabled-path requirement open as unfinished functionality. Do not claim that credentials are the cause. |
| The enabled operation handles controlled responses, but no live provider call is authorized. | Existing guidance already limited synthetic evidence to local behavior. | Report the local request, response, and failure checks. Leave authentication, availability, and live performance unverified. |

### Writing Cases

| Task | Previous coverage | Revised instruction and walkthrough result |
| --- | --- | --- |
| A public article announces its structure, repeats its opening at the end, and uses repetitive sentence patterns. | The skill scored structural problems but did not describe separate structure and author-style revisions. | Revise the organization first, then the sentence patterns and length. Keep the substantive claim and finish with useful new information. |
| A style rewrite changes a response time from 250 milliseconds in a warm-cache test to 100 milliseconds without qualifications. | The skill said to preserve intent without an explicit fact comparison after rewriting. | Restore the supported 250-millisecond result and warm-cache condition before scoring. A smoother sentence does not pass the meaning check. |
| An operational report needs a short conclusion-first summary, and a reply is only two sentences long. | The skill did not state these limits for article-level revision advice. | Preserve the useful report summary and leave the reply's structure alone. Still check both pieces against their supporting facts. |

## Metrics

- Manual documentation cases reviewed: 12 of 12.
- Cases with usable actions and appropriately limited conclusions: 12 of 12, by author judgment.
- Software tests and live model comparisons executed for this publication: none.
- Retrieval accuracy, writing quality, latency, and cost improvements: not measured by this publication.

## Grader and Evaluation-Fault Check

The review checks instruction coverage and consistency. It cannot prove that an agent follows the instructions or that a detector catches a meaning change. The measurement cases preserve unexpected declines and privacy requirements. They do not equate a file change with causation, or absence from returned sources with causal independence.

The integration cases distinguish a safe default from a working enabled operation. They preserve the boundary between local checks and authorized live tests. The writing cases distinguish useful early conclusions from announcements about an article. They preserve facts and supported author preferences without treating older mistakes as acceptable style.

Private maintenance work motivated the patterns. Its identifiers, source text, and measurements are not reproduced as public evidence.

## What Was Not Tested

This review did not test concurrent source writes, content snapshots, retrieval comparisons, provider integrations, automated meaning checks, or a detector implementation. It did not measure whether the revision sequence improves real drafts. Repeated runs alone do not remove confounding changes or prove causation.

## Result

**ship** the limited documentation refresh. No runtime repair, automated enforcement, or measured quality improvement is claimed.

## Artifact Path

The complete synthetic inputs and author judgments are the tables in this file: `reports/evals/2026-10-17-changing-inputs-and-meaning-checks.md`. There is no separate software-test transcript.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-17.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-17), self-improvement guide, and writing skill.
- False-alarm cost: no detector or alert is installed. Metadata-only recording can cause unnecessary repeat measurements; the documentation makes that limitation explicit.

## Lesson Learned

Changing inputs limit causal claims. Rewriting language requires checking the facts again.
