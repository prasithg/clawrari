# Documentation Evaluation: Write Ownership, Sources, and Review

## Header

- **Change under test:** [worker-owned validation](../../docs/self-improvement.md#41-attribute-validation-to-the-worker-that-made-the-change), [retrieved-source measurement](../../docs/self-improvement.md#42-measure-retrieved-sources-separately-from-matching-answers), and [architecture and regression review](../../reference/agent-prompt-template.md#check-architecture-and-known-regressions).
- **Surface class:** workflow documentation and prompt template.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from recent maintenance.
- **Fault side:** worker-to-validator attribution is a harness concern; source-credit errors are a grader concern. A missing targeted review is a task-contract concern.
- **Scope:** documentation only. No validator, retriever, launcher, or installed skill changes.

## Method and Task Set

The author manually walked through eleven synthetic cases against the previous public guidance and the proposed additions. The baseline column describes document coverage, not a replay of an older runtime. These are reasoning checks, not executed worker or retrieval tests.

Existing sections on [completed checks](../../docs/self-improvement.md#28-count-completed-checks-separately-from-passing-checks) and [retrieval feasibility](../../docs/self-improvement.md#39-check-data-coverage-before-building-a-retrieval-fix) serve as editorial examples. The fixed review criteria are: an actionable condition, an observable result, explicit limitations, and no unsupported runtime claim.

### Ownership Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A worker owns one valid file while a sibling's file is incomplete. | Shared-workspace safety exists; validation attribution is unspecified. | Use the complete owned-file record, preserving separately required checks. | Pass |
| An owned file is malformed but its name resembles a sibling task. | No ownership-versus-name precedence is specified. | Explicit ownership requires validation; the name cannot exclude the file. | Pass |
| The declared list is unreadable, or an empty list was created without recording writes. | Handoffs list touched files without establishing the scope collector's reliability. | Unreadable scope is unavailable evidence; an empty list needs a complete producer record. | Pass |
| A worker deletes a file and has a required claims manifest outside its write list. | Generic completion checks do not resolve this boundary. | Check deletion effects and retain the explicit manifest obligation. | Pass |

### Source Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| Expected words occur in a result from an unrelated, similarly named file. | Fixture provenance is discussed; per-result source credit is unspecified. | Score the answer separately and reject a partial-path source match. | Pass |
| The correct answer and the declared source appear within the agreed result limit. | Retrieval feasibility considers ranking and authority. | Record both answer correctness and source retrieval. | Pass |
| Two negative controls require abstention. | General denominator integrity exists. | Score abstention separately; source retrieval is not applicable. | Pass |
| Five source-bearing positives include four source hits and one authorized exception. | General exception policy preserves unresolved defects. | Report source coverage as 4/5 even if the exception permits overall acceptance. Keep its reason, date, and scope. | Pass |

### Template Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A code change crosses a maintained module boundary. | The checklist asks for relevant tests without explicitly naming architecture review. | Consult the architecture guide and attach boundary-check evidence. | Pass |
| A change touches a known failure area whose required check cannot run. | Generic untested-surface reporting exists. | Identify the regression and report the missing targeted check; no completed verification claim. | Pass |
| A documentation-only repository has no architecture guide or regression record. | Verification budgeting exists but the new review obligation could be read too broadly. | State that the references are absent and use proportionate document checks. | Pass |

## Metrics

- Manual procedure cases: **11 reviewed; 11 satisfy the stated documentation criteria**.
- Executed runtime cases: **0**.
- Mapped artifacts refreshed: **1**, the agent prompt template.
- Skills ported: **0**.
- Structural, link, privacy, and writing checks are recorded in the publication receipt. They do not add runtime cases to this evaluation.

## Grader / Eval-Fault Check

A sibling's incomplete file does not establish a failure in the finishing worker. A matching answer does not establish that its supporting source was retrieved. Both cases require fixing attribution or scoring rather than coaching the model to satisfy a misleading result.

The examples use invented file roles and counts. No private source text, operational identifiers, or internal test results are reproduced. The author also performed this review, so it provides no independent-judge evidence.

**Expected false-alarm cost:** a misattributed validation failure blocks a worker's completion and creates maintainer triage. Overly broad source normalization can instead hide a retrieval miss. The guidance preserves negative controls for both risks.

## Untested Surface

No concurrent workers, file-list collectors, retrieval services, model prompts, or release systems were executed. List completeness, races, live source ranking, and whether agents follow the revised checklist remain unverified. No performance or reliability improvement is claimed.

## Verdict

**ship** as documentation. The additions make previously implicit distinctions reviewable while preserving their implementation limits.

## Artifact Path and Sign-off

- Artifact: this report; the synthetic cases and judgments are embedded above.
- Run by: Codex, author review.
- Date: 2026-10-01.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-01), both new lessons, and the refreshed template.
- Lesson: ownership evidence, source evidence, and review evidence each need an explicit contract; one passing summary cannot substitute for all three.
