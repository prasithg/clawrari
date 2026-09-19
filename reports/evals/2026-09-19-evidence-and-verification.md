# Run Evidence and Verification: Documentation Evaluation

## Header

- **Change under test:** [run evidence](../../docs/self-improvement.md#27-preserve-evidence-and-check-the-exact-run), [check coverage](../../docs/self-improvement.md#28-count-completed-checks-separately-from-passing-checks), [measurement failure reporting](../../docs/self-improvement.md#25-recover-the-measurement-without-changing-the-score), and the [ExecPlan template](../../reference/execplan-template.md).
- **Surface class:** workflow documentation and planning template.
- **Linked ticket:** N/A; scheduled distillation and one mapped artifact refresh.
- **Fault side:** artifact overwrites belong to the evidence writer; missing-result handling belongs to the runner and reporter; a plan that promises unsupported automation has a documentation-to-tool contract defect.
- **Method:** manual walkthroughs of synthetic cases against saved baseline text and the edited documents. The results below measure instruction coverage. They are not a live agent A/B or a runtime implementation test.

The source work preserved repeated evaluation outputs, checked their returned paths and freshness, separated incomplete measurements from completed failures, and added explicit verification categories to planning documents. This update publishes the reusable lessons. Private reports, operational identifiers, providers' error transcripts, and company-specific examples are excluded. No source scripts or skills are ported.

## Task Set

1. Preserve repeated-run evidence and select the correct artifact for a downstream decision.
2. Report completed failures and missing measurements without hiding either.
3. Assign each acceptance criterion an executable check, independent review, or human sign-off.
4. Report a failed upstream measurement without inventing downstream defects.

## Baseline vs New

### Evidence Cases

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| E1 | Two runs of one workload select the same artifact name | Append-only records are encouraged, without a file-creation contract | Preserve the first file; allocate a new name through exclusive creation; return the chosen path. An existence check followed by an ordinary write is insufficient. | Pass |
| E2 | An old artifact has the expected identifiers; another current artifact is missing one item | Durable artifacts and valid fixtures are discussed, without a current-run identity rule | Reject both as evidence for the requested output: one is stale, the other incomplete. Use the producer's returned path and check freshness, identifiers, and count. | Pass |
| E3 | A run finds zero eligible items | File-existence guidance can leave a valid empty outcome ambiguous | Write and validate an explicit empty item set and reason. A missing file remains missing evidence. | Pass |
| E4 | The correct current artifact contains a failed quality verdict | Completion evidence is discussed, without this artifact-versus-verdict boundary | Accept the artifact as evidence of the result; retain the failed verdict and withhold publication. | Pass |

### Coverage Cases

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| C1 | Four checks return defined verdicts; one verdict is negative | Valid failure receipts are already distinguished from successful work | Record four completed checks and the named failure. Do not mislabel the negative verdict as an unfinished measurement. | Pass |
| C2 | Three checks pass; the fourth has no usable result | Unavailable measurements cannot establish health, but aggregate coverage is unspecified | Record three of four completed checks, name the unavailable check, and withhold the all-clear. The expected inventory remains independent of returned results. | Pass |
| C3 | Four result rows contain a duplicate identifier and omit a required check | No explicit identity-based coverage rule | The duplicate cannot replace the missing check even when row counts match. Compare identifier sets as well as counts. | Pass |
| C4 | Every required check returns its contract's passing verdict | Existing guidance requires evidence for completion | Record complete coverage and passing verdicts. No failure is inferred merely because a different check contract uses nonzero codes for completed negative results. | Pass |

### Verification Cases

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| V1 | A parser criterion names a trigger, expected error, and runnable check | Already requires observable acceptance and a command per criterion | Retain that evidence as a programmatic criterion. Every plan still needs at least one such criterion. | Pass |
| V2 | A plan contains only a subjective review criterion with no rubric or reviewer | Requires a command even for subjective work; no review category | Reject the incomplete plan. Require named review criteria, a reviewer from a different model family, and at least one programmatic criterion. A passing syntax check does not perform that review. | Pass |
| V3 | A human sign-off is named but has not happened | No explicit human-verification category or agent completion boundary | Keep the criterion incomplete. An agent cannot provide the named person's sign-off. Tags alone do not implement runner behavior. | Pass |

### Measurement Case

| Case | Synthetic input | Baseline coverage | Decision supported by new text | Walkthrough |
| --- | --- | --- | --- | --- |
| M1 | One failed measurement leaves several dependent scores unavailable; a later valid measurement has two genuine failures | Already distinguishes an unavailable measurement from a bad score | Report the first failure once with affected checks. Preserve both genuine failures from the later valid measurement. Grouping missing-score consequences must not suppress measured defects. | Pass |

## Metrics

- **12 of 12 manual scenarios** have explicit decisions in the edited text.
- One mapped artifact is refreshed: the execution-plan template.
- No runtime code, live configuration, thresholds, or skill catalog entries change.
- Latency, cost, and production reliability are not measured by this evaluation.

## Grader / Eval-Fault Check

The baseline already requires observable acceptance, distinguishes failed receipts from success, and treats unavailable measurements as unknown. This evaluation credits those protections. The additions specify artifact identity and preservation, aggregate check coverage, and separate forms of verification.

A syntax checker can accept a document without enforcing its review or sign-off rules. The public template states that limitation explicitly. No existing runner is claimed to implement these categories.

A fresh run of the existing source tests for artifact naming and current-run artifact validation passed 21 tests. Those deterministic fixtures corroborate the source lessons; the source implementation is not included in this publication, and their result does not certify the public instructions as runtime enforcement. The manual cases above are the self-contained public evaluation artifact.

**False-alarm cost:** stale evidence can falsely authorize publication, while treating a completed negative verdict as a crash sends the operator to the wrong repair. Missing-score alerts can multiply one outage into several investigations. Naming both coverage and verdicts preserves the reason to act. No new alert is installed by this change.

## Untested Surface

The walkthroughs are author-reviewed, not an independent model review. No live outage, scheduled delivery, concurrent artifact writer, interrupted write, clock skew, or automated judge or human-sign-off handling was exercised here. The identifier-set coverage recommendation is a documentation safeguard, not a claim about the source runner. No production reliability or automatic enforcement is established.

## Verdict

**Ship** this documentation update. The manual cases cover the new instructions and their limits. A user adopting the patterns still needs to implement and test the corresponding runtime behavior.

## Artifact Path

`reports/evals/2026-09-19-evidence-and-verification.md` contains the synthetic inputs, baseline comparisons, decisions, and manual results. Baseline snapshots and source-test output are retained in the private maintenance run record; they are not public dependencies.

## Sign-off

- Run by: Codex, GPT-6.
- Date: 2026-09-19.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-19), Self-Improvement, and the execution-plan template.
