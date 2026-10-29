# Search Reporting and Publication Evidence

A task report can reintroduce an identifier removed during a search repair. The public guidance now covers that recurrence and the evidence needed to distinguish a saved repair from a measured result.

## Change Under Review

- **Change type:** public workflow documentation and an evaluation template.
- **Files:** [reporting guidance](../../docs/self-improvement.md#62-keep-task-reports-from-reintroducing-search-defects) and [search evaluation requirements](../../reference/skill-change-eval-template.md#evidence-for-search-or-retrieval-changes).
- **Issue:** none. This scheduled update captures existing operational work.
- **Failure location:** source duplication introduced by reporting, confusion between saving and publishing content, and incorrect attribution of evaluation failures.

The evaluation template is the single mapped artifact selected for refresh. Its existing minimum task set, fault attribution, evaluation review, untested behavior, and risk-specific requirements remain unchanged. No installed skill, search implementation, or operating policy is changed.

## Method and Baseline

These are ten manually reviewed documentation cases. They compare saved pre-edit copies with the revised instructions. The cases are hypothetical; no search service, model, or scheduler was run for this evaluation.

The existing self-improvement guide already requires individual-result comparisons, source authority, and narrow exceptions. That guidance is retained. The addition addresses reports that reintroduce copied lookup tokens. The earlier template requires fault attribution and an evaluation-fault review but leaves the source-publication states implicit.

## Reporting Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| R1 | A completion note copies a repaired lookup token. | Preserve source authority and inspect search results. | Link to the maintained source without repeating the token; inspect worker and reviewer reports. |
| R2 | Reproduction inputs are saved in a folder that search still indexes. | Retain evidence. | Verify that the authorized evidence location is excluded; its folder name proves nothing. |
| R3 | A known defective line is changed or copied twice. | Keep known-defect exceptions narrow. | Bind the temporary exception to file, content digest, and one occurrence; reject changes and repeats. |
| R4 | The known defective line is removed. | Keep unresolved acceptance visible. | Let the exception become unused; passing the copy check still does not prove improved retrieval. |
| R5 | A historical event genuinely needs its original detail. | Preserve evidence and authorized scope. | Preserve the event, follow correction rules, and limit the pattern to redundant lookup tokens. |

## Evaluation-Template Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| E1 | A source write succeeds while publication is paused. | Record baseline and new behavior. | Report saved content separately, inspect indexed content, and leave the outcome measurement pending. |
| E2 | A question requires a source excluded by policy. | Check whether the evaluation is wrong. | Record eligibility evidence and route the expectation for review without bypassing the policy. |
| E3 | Two of four cases pass before and after, but one required passing case changes. | Record success per task; the guide already covers individual comparisons. | Require the template to list lost and gained cases and preserve required previous passes. |
| E4 | A previously failing query passes, but its old candidates were not saved. | State fault location and untested behavior. | Leave the historical cause unknown; the current result cannot reconstruct missing evidence. |
| E5 | A source is eligible and published, but retrieval stops on a partial token match. | Route the repair to the faulty component. | Inspect candidate sources and exact-token coverage before changing retrieval code. |

Each revised instruction addresses the stated case without changing the historical record, source policy, or success requirement. These are documentation judgments, not executed behavioral tests.

## Metrics and Evaluation-Fault Review

Ten of ten manual cases have an explicit, limited instruction. There is no measured retrieval gain, model-compliance result, or production pass rate. The comparison uses the original documents; it does not treat an earlier general rule as absent merely because the new section is more specific.

A missing expected source can be an evaluation error when policy excludes it. A missing published edit can be a publication problem rather than a ranking defect. An unknown historical cause must remain unknown. These distinctions prevent tuning the wrong component to make a score improve.

A future copy check could reject a legitimate historical quotation. The memory maintainer must review that exception. This update specifies the boundary but installs no scanner and measures no false-alarm rate.

## Untested Behavior

This review does not edit memory, publish an index, implement a copy check, measure search ranking, or test a future agent's compliance. Publication after a pause and performance on other identifiers require separate evidence.

## Result

**Ship the documentation.** Keep the original operational repairs and their acceptance independent of this public update.

## Artifact and Sign-Off

The complete manual records are R1–R5 and E1–E5 above, in `reports/evals/2026-10-29-search-reporting-and-publication.md`. The [changelog](../../CHANGELOG.md#2026-10-29) links this evaluation.

Reviewed by: Claw, GPT-6. Date: 2026-10-29. This is an author review, not an independent or cross-model review.

Lesson: completion reporting is another writer to inspect when the report itself enters the searched collection.
