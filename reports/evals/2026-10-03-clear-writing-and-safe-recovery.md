# Documentation Evaluation: Clear Writing and Safe Recovery

## Header

- **Change under test:** [fact-preserving writing](../../docs/self-improvement.md#43-make-clearer-writing-preserve-the-facts), [test isolation](../../docs/self-improvement.md#44-isolate-tests-before-loading-side-effecting-code), [independent continuation checks](../../docs/self-improvement.md#45-check-unattended-work-without-relying-on-completion-messages), and [audience-aware delegation](../../reference/agent-prompt-template.md#match-instructions-and-results-to-their-readers).
- **Document type:** workflow documentation and prompt template.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from recent maintenance.
- **Fault side:** factual changes during rewriting belong to the writer; unsafe tests belong to the test setup; lost continuation belongs to scheduling and task coordination.
- **Scope:** documentation only. No installed skills, tests, schedulers, or runtime settings are changed.

## Method and Task Set

The author manually applied the proposed guidance to twelve synthetic cases below. Baseline coverage was inspected in the previous public documents. The review covers document walkthroughs only. Runtime execution, reader comprehension, and independent judgments remain untested.

The fixed criteria are an actionable instruction, an observable result, preservation of source meaning, and an explicit limit on what the evidence proves. Existing sections on [fixture (synthetic test data) evidence](../../docs/self-improvement.md#30-separate-fixture-tests-from-live-evaluation) and [interrupted work](../../docs/self-improvement.md#31-recover-interrupted-jobs-from-verified-effects) serve as editorial examples, not reader-approved writing exemplars. No improvement in reader comprehension is claimed.

### Writing Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A source says "daily at 09:00 UTC"; its rewrite says "every weekday at 09:00 UTC". | The audience contract does not explicitly require a meaning check after rewriting. | Reject the changed frequency despite preserved numbers; retain "daily at 09:00 UTC". | Pass |
| A progress message consists of an unexplained internal name and a link. | The template identifies the audience but does not specify the first-use treatment of names. | State the practical outcome, give the name a supported plain label, and retain the link. | Pass |
| Every listed template contains the writing rule and a word checker reports no findings. | Generic verification guidance exists without distinguishing instruction coverage from writing quality. | Report coverage and checker results only; readability and factual accuracy still need review. | Pass |

### Isolation Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| The older cleanup implementation ignores a fake-client argument and calls a system command. | Disposable examples are recommended, but the pre-import command boundary is unspecified. | Install a blocking boundary before import; require the old implementation's attempted call to fail without reaching real state. | Pass |
| A module captures a command function during import, before a test replaces it. | General isolation advice does not specify when captured references become unsafe. | Move isolation setup before module loading and exercise the blocked boundary directly. | Pass |
| An offline test unexpectedly changes real state, then its assertions pass. | Synthetic and live evidence are separated, but an accidental side effect is not explicitly classified. | Stop the responsible test, preserve evidence, and record a safety failure; do not count the action as live verification. | Pass |

### Continuation Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A worker finishes but the parent never receives its completion message. | Stable worker identities and saved output exist; an independent schedule is unspecified. | The scheduled check inspects the saved output and required destination artifacts, then continues missing work. | Pass |
| A check is registered successfully but targets the wrong session or has no usable notification destination. | The public retry guidance focuses on external actions, not scheduling admission. | Keep registration, correct targeting, successful execution, and notification delivery as separate evidence. | Pass |
| A worker stops after publication, before recording success; its required review is still missing. | Checking destination evidence is already required for interrupted publication. | Verify whether publication already happened before replacement, resume the missing review, and remove schedules only after final verification and reporting. | Pass |

### Template Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| An agent needs an exact tool name while a human only needs the outcome and next action. | One audience block exists without an explicit split between execution instructions and result wording. | Keep exact execution references in the procedure; explain the human-facing result independently. | Pass |
| A report preserves a time and count but drops the condition that limits the result. | General accuracy instructions do not explicitly cover simplification. | Compare the result with the source and restore the condition before completion. | Pass |
| The writer cannot explain an unfamiliar identifier from the available evidence. | The audience is named but missing explanatory context is not addressed. | State the missing context rather than inventing an expansion or unsupported meaning. | Pass |

## Metrics

- Manual document cases: **12 reviewed; 12 satisfy the stated documentation criteria**.
- Executed runtime cases: **0**.
- Independent reader or judge evaluations: **0**.
- Mapped artifacts refreshed: **1**, the agent prompt template.
- Skills ported: **0**.
- File, link, privacy, and writing checks are recorded with the publication evidence. They do not add runtime cases to this evaluation.

## Publication Checks

The writing checker initially treated Markdown headings and link destinations as chat-format errors. A separate prose-only run retained visible words but removed Markdown syntax, link targets, and section numbering. All four document additions and the status-message draft passed that review with no high-severity findings. The original source-format result remains recorded as rejected; document formatting and links were checked separately.

The publication review also checked added text for private names, contact details, internal references, and operational identifiers. It confirmed one mapped template refresh and no skill ports. These checks support this documentation release, not claims about the runtime behavior described above.

## Grader and Evaluation-Fault Check

A passing assertion cannot excuse a test that reached real state. A successful schedule registration cannot establish that recovery works. A preferred rewrite can still contain a factual error. The review keeps these distinctions explicit instead of treating a single success signal as proof of the whole task.

The author also reviewed these examples; this is not independent evidence. All examples use generic roles and invented inputs. Private incident text, operational identifiers, and internal measurement results are excluded.

**Expected false-alarm cost:** a broad vocabulary check can flag appropriate technical language and waste editorial time. A command block can reject an intentional integration test, which needs separate authorization and isolation. An imprecise scheduled check can restart completed work. Each requires a scoped check and an observable negative case.

## Untested Behavior

No model rewriting, subprocess isolation, worker recovery, scheduler delivery, concurrent retries, or external publication failure paths were executed for this evaluation. The examples establish document clarity and coverage only. Live reliability, reader comprehension, and compliance with the revised prompt remain unmeasured.

## Result

**ship** as documentation. The additions make the verification requirements explicit without claiming that the runtime behavior is implemented or proven.

## Artifact Path and Sign-off

- Artifact: this report; the synthetic cases and judgments are embedded above.
- Run by: Codex, author review.
- Date: 2026-10-03.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-03), the three lessons, and the refreshed template.
- Lesson: clearer wording, safer tests, and reliable continuation each require evidence specific to that claim.
