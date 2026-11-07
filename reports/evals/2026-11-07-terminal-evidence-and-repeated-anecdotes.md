# Completion evidence and repeated anecdotes: documentation evaluation

Date: 2026-11-07.

## Change under test

The [verification guidance](../../docs/self-improvement.md#read-the-agents-final-record-before-launcher-messages) locates the agent's final record before documented trailing launcher messages. The [historical-failure guidance](../../docs/self-improvement.md#bind-historical-failure-acknowledgements-to-exact-evidence) requires exact evidence for an acknowledgement. The [writing candidate](../../skills/avoid-ai-writing/patterns/v4-emerging.md#v458-recycled-setup-anecdote-one-personal-setup-reused-across-unrelated-replies) reviews repeated setup anecdotes across unrelated replies.

Changed document types: verification guidance and writing-skill reference data. Tracking: routine public documentation maintenance; no separate issue was created. Exactly one mapped artifact is refreshed: the writing-skill directory. Its maintained source supplies the repeated-setup candidate. The public version uses synthetic examples and includes no author-specific exceptions.

Fault location: a completion parser can misread launcher output as agent output. A broad historical exception can hide a different failure. The writing candidate describes a possible editorial problem; it does not establish automated authorship or detector accuracy.

## Method and task set

These twelve cases are synthetic, manual instruction walkthroughs. The reviewer compared each input with the previous documents and the additions below. The results measure documentation coverage, not before-and-after agent behavior. No historical record was altered or reclassified during this evaluation.

### Completion-record cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| A valid final agent record is followed by forty routine launcher lines with documented tags. | Valid status vocabulary was covered; trailing-message selection was not explicit. | Locate the final agent record after the contiguous documented trailing block; inspect termination evidence separately. | Pass |
| A prompt quotes a valid record, but the agent never emits one. | Missing records were invalid; echoed examples were not explicit. | Reject the quoted example as completion evidence. | Pass |
| The agent emits a valid record and then continues with another output line. | Final-position requirements were not explicit. | Reject the earlier record as the final record. | Pass |
| A signal line or an unrecognized warning follows an apparent success claim. | Valid reporting and successful work were distinguished. | Keep the line visible and completion unverified until its effect is resolved. | Pass |

### Historical-failure cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| An old failed record matches the acknowledged name, content hash, failure type, and cutoff. | Task-bound exceptions existed; byte-bound historical records were not explicit. | Report it as an acknowledged failure, separate from passing work. | Pass |
| A record with the same name has changed bytes or a different failure type. | Changed promises invalidated task exceptions. | Withhold the historical acknowledgement and require a fresh decision. | Pass |
| Another run repeats the symptom after the historical cutoff. | New defects were outside existing task exceptions. | Keep the new failure visible; do not extend the old acknowledgement. | Pass |
| The acknowledgement input contains duplicate names, missing evidence, or a directory-wide exemption. | Exact defect scope was required generally. | Reject invalid or overbroad acknowledgement data. | Pass |

### Writing cases

| Task | Previous coverage | Required decision after the change | Manual result |
| --- | --- | --- | --- |
| Three unrelated replies within seven days reuse one personal setup as support. | Repeated credentials were covered; repeated equipment/setup anecdotes were not explicit. | Review the recurring anecdote and retain only its relevant contribution. | Pass |
| Three saved variants belong to one reply to one source post. | Distinct bodies were required for credential repetition. | Count one case, below this candidate's threshold. | Pass |
| A source post asks how the author hosts and accesses an assistant. | Direct-answer setup cases were not explicit. | Preserve the setup detail when it answers the question. | Pass |
| Several replies describe different concrete incidents on the same equipment, or only one mentions the setup. | Incident boundaries existed for credential repetition. | Keep incidents distinct and avoid treating one mention as a recurring pattern. | Pass |

## Metrics and verification

Manual documentation cases: 12 of 12 specify the intended decision. The writing candidate remains observation-only. No detector score, runtime reliability, or improvement in generated writing was measured.

Twenty-five file-scope, preservation, privacy, whitespace, and link checks passed across six changed files. The checks used exact saved originals from the published version. The required secret-token scan and remote publication verification run separately.

The first writing check misapplied Slack formatting rules to Markdown headings and links. Prose review therefore uses a rendered-text projection that preserves the words while removing Markdown markup. Links and section targets are checked separately. A short reference-link label also triggered the rhythm heuristic; its replacement describes the linked evidence more fully. The initial results remain in the private publication record.

## Evaluation-fault check

Recognizing a valid final record does not mean its reported task succeeded. Acknowledging a killed run does not create a successful result. A reduced alert count after acknowledgement must not be reported as a repair count.

Repeated vocabulary alone cannot establish an editorial problem. The writing cases preserve direct answers and distinct incidents. These manual decisions cannot establish the precision of an unimplemented detector.

Expected false-alarm cost: a parser mistake wastes the operator's review time; an overbroad exception hides fresh failures. An overbroad writing rule removes relevant experience. No automated check or exemption is installed by this update.

## What remains untested

No public parser implementation, live launcher format, historical acknowledgement loader, scheduled-job result, or detector for the new writing candidate was exercised. Concurrent log writes, adversarial tags, model adherence, and writing-quality gains remain untested. The private operational records that motivated the documentation are excluded.

## Publication decision

Ship the documentation with these limits. Existing operational failures are not claimed fixed by this publication.

Lesson learned: bind a completion claim to its final output and an exception to its exact evidence. For writing review, count distinct uses and preserve context that answers the question.

## Artifact path and sign-off

The synthetic inputs, expected decisions, and manual results are the tables in `reports/evals/2026-11-07-terminal-evidence-and-repeated-anecdotes.md`.

Run by: Codex documentation review, 2026-11-07. Linked from the changelog and changed guidance. No independent model review is claimed.
