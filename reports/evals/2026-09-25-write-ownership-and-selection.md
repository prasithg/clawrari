# Documentation Eval: Write Ownership, Quiet Selection, and Delegation

## Header

- **Change under test:** two additions to [Self-Improvement](../../docs/self-improvement.md) and one refresh of the [agent prompt template](../../reference/agent-prompt-template.md).
- **Surface class:** documentation and prompt template.
- **Linked ticket:** N/A; scheduled capture of existing operational work.
- **Fault side:** writer lifetime and selector fallback belong to the harness; missing labels belong to evaluation. Neither is repaired by asking a model to be more careful.
- **Evidence mode:** manual synthetic walkthroughs. No live A/B or runtime benchmark is claimed.

The source work established a writer-settlement boundary and tested a default-off selector. Its runtime observations remain separate from this public documentation evaluation. Private inputs, identities, service details, and incident records are omitted.

## Task Set and Baseline vs New

### Deadline Cases

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| A writer completes normally before the deadline | Existing recovery guidance emphasizes interrupted external actions | Accept its result and preserve the ordinary success path | Consistent; cancellation is conditional on failure |
| A writer returns after the deadline | No explicit ownership requirement through writer settlement | Signal cancellation, stop and join the writer, restore, verify, then expose failure | Consistent; late writes cannot be assumed harmless |
| A partial write rejects without returning a receipt | Recovery handle availability is unspecified | Capture restoration state before mutation and retain it independently of the result | Consistent; partial failure still has a recovery path |
| A writer ignores cancellation or restoration fails | A timeout could be mistaken for completed rollback | Use bounded isolation where available; otherwise preserve unresolved state and block dependent writes | Consistent; failure does not imply restored state |

### Selection Cases

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| The selector is disabled | Fixture and live evidence are distinguished, but suppression is not specified | Perform no selector reads, provider calls, or state writes; continue normally | Consistent; disabled behavior is observable |
| Quiet is selected from an input that changes during evaluation | Confidence alone could appear sufficient | Recheck state and fall back when the input changed | Consistent; confidence cannot repair stale evidence |
| A reader warns, a provider times out, or a receipt cannot be saved | No specific quiet-decision failure contract | Retain the normal workflow for every unavailable or unverifiable decision | Consistent; optimization failure does not hide work |
| An automated grader agrees with a classifier on unlabeled examples | Evidence provenance is named, but suppression accuracy remains unknown | Keep unlabeled cases outside the graded denominator and run shadow comparisons | Consistent; agreement is not independent truth |

### Delegation Cases

This is the only mapped artifact refreshed. The source template's model-specific guidance calls for an autonomy preamble, instruction precedence, and testing calibration. The public copy generalizes those points without importing a model roster or local launcher dependencies. All three persistence examples use the same bounded-authority wording; the coding example retains its scoped schema-inspection guidance.

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| An already-authorized document edit meets stale skill text asking for another confirmation | Persistence is unconditional while instruction conflict handling is implicit | Follow current task authorization within higher-priority rules, complete the edit, and record the conflict | Consistent; no redundant permission request |
| A deployment requires a decision not supplied by the task | Persistence says to avoid confirmation without naming the authority boundary | Finish authorized preparation, present the reviewable result, and name the unresolved decision | Consistent; the prompt does not authorize deployment |
| A narrow edit passes its required checks | The smallest meaningful check is required, but the stopping condition for testing is implicit | Stop expanding checks unless new evidence or risk warrants more verification | Consistent; required checks remain mandatory |
| A behavioral repair reveals a second failure | Narrow verification could be interpreted as a fixed ceiling | Expand verification to cover the new failure and retain successful controls | Consistent; calibration does not weaken acceptance |

## Metrics

- Manual documentation walkthroughs: 12 reviewed; 12 consistent with the stated decisions.
- Implementation tests executed for these patterns: 0.
- Live classifier decisions, write cancellations, or deployments performed for this evaluation: 0.
- Public scope: three edited documents and this evaluation.
- Qualitative result: the guidance makes ownership, fallback, authority, and evidence limits explicit without asserting runtime enforcement.

## Grader / Eval-Fault Check

The tables are reasoning walkthroughs, not measured agent trials. They check whether the prose supports the intended decision. They cannot establish cancellation correctness, classifier accuracy, or agent compliance.

Conservative selection can run extra work when it falls back unnecessarily. The operator pays that execution cost. Incorrect suppression can hide important work; measure that error separately before enabling suppression. No universal confidence threshold or acceptable miss rate is inferred here.

## Publication Checks

Publication checks are recorded in the private run receipt. Required checks cover added-text privacy, relative links and heading targets, consistency of all three persistence examples, and the mandatory pending-diff secret scan before publication.

## Untested Surface

No public runtime implementation changed. Worker termination, lock ownership, restoration under concurrent writers, remote input races, production suppression accuracy, and instruction-following under adversarial input were not exercised. Cancellation of an external effect needs a destination-specific contract. A successful documentation review cannot close those runtime acceptance criteria.

## Verdict

**ship** the documentation and single template refresh, subject to the publication checks. This verdict covers the stated guidance and its scope, not activation or production reliability.

## Artifact Path

The synthetic inputs and expected decisions are the twelve rows in this file: `reports/evals/2026-09-25-write-ownership-and-selection.md`. The [changelog](../../CHANGELOG.md) links this evaluation. Private source records remain outside the public repository.

## Lessons Learned

A caller-visible failure needs evidence about the state left behind. Suppressing work needs stronger evidence than choosing which work to run. Delegation should preserve both existing authorization and the boundaries of what has been verified.

## Sign-off

- Run by: GPT-6 documentation agent.
- Date: 2026-09-25.
- Linked from: changelog, Self-Improvement, and the delegation template.
