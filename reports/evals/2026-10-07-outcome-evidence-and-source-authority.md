# Documentation Evaluation: Outcome Evidence and Source Authority

## Header

- **Change under test:** [final-outcome measurement](../../docs/self-improvement.md#48-measure-the-final-outcome-of-a-multi-step-process), [source ordering](../../docs/self-improvement.md#49-keep-generated-summaries-below-their-supporting-sources), and [evidence requirements](../../reference/agent-prompt-template.md#declare-the-evidence-behind-factual-claims).
- **Document type:** workflow documentation and one prompt template.
- **Linked ticket:** N/A. Scheduled publication of reusable lessons from recent maintenance and research.
- **Fault side:** incomplete outcome measures belong to evaluation design; summary priority belongs to retrieval ordering; unspecified sources belong to the task instructions.
- **Scope:** documentation only. No detector, retrieval service, model routing, installed skill, or runtime policy changes.

## Method and Task Set

The author manually applied the proposed instructions to the ten synthetic cases below. Baseline coverage was inspected in the previous public documents. These are document walkthroughs, not executed runtime tests or independent judgments.

The review criteria are an actionable instruction, an observable result, preservation of uncertainty, and a stated boundary on the conclusion. Existing sections on [source measurement](../../docs/self-improvement.md#42-measure-retrieved-sources-separately-from-matching-answers) and [synthetic versus live evidence](../../docs/self-improvement.md#30-separate-fixture-tests-from-live-evaluation) provide editorial reference points.

### Outcome Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| Every object is detected, but the applied regions miss part of each object. | General verification rules do not distinguish detection from final coverage. | Report both measurements and keep the uncovered output visible. | Pass |
| Extracted text loses spaces that a downstream rule requires. | Fault classification exists without stage-by-stage evidence guidance. | Preserve intermediate text and assign the first miss to the affected interface. | Pass |
| One output region covers two expected regions, while unrelated inputs are also modified. | No specific treatment of merged outputs or over-processing. | Preserve matching and coverage scores; report negative examples separately. | Pass |
| A method performs well on synthetic examples tuned by its author. | Untested behavior must be stated, without these specific limits. | Declare tuning overlap and absent input variation; make no deployment or privacy guarantee. | Pass |

### Source-Ordering Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A summary has a higher combined score than its supporting record. | Required-source measurement exists without this ranking failure. | Check source validity and apply the declared authority rule; preserve the higher-score condition in the test. | Pass |
| A historical question has no generated summary among its candidates. | General source checks do not establish ordering controls. | Preserve the requested time scope and ordinary candidate ordering. | Pass |
| A local fix restores first place for the source but leaves duplicate score contributions. | Local versus live evidence is discussed separately. | Keep duplicate scoring open and require running-service evidence for a live claim. | Pass |

### Evidence-Contract Cases

| Case | Baseline coverage | New guidance applied | Result |
| --- | --- | --- | --- |
| A research assignment requires external evidence as well as supplied notes. | Audience and acceptance requirements exist without a dedicated source contract. | Select mixed evidence, name sources, and require supporting citations. | Pass |
| A required source cannot be read, or does not support the proposed claim. | General certainty limits exist without an explicit unresolved-claim marker. | Mark the claim unverified and name the missing evidence. | Pass |
| A complete, cited report omits the requested recommendation. | Artifact fitness is mentioned without linking it to the evidence contract. | Check decision usefulness as well as source support; request the missing recommendation and its conditions. | Pass |

## Metrics

- Manual document cases: **10 reviewed; 10 satisfy the stated documentation criteria**.
- Executed runtime cases: **0**.
- Independent reader or judge evaluations: **0**.
- Mapped artifacts refreshed: **1**, the agent prompt template.
- New skill ports: **0**.

## Evaluation-Fault Check

Detection, final coverage, and resistance to recovering hidden information are different claims. A passing ordering example does not establish live service behavior or fix duplicate scoring. A citation can be relevant without supporting the claim. The review keeps these boundaries explicit.

The author also judged these cases. All examples are generic; no private incident text, internal identifiers, source records, or research measurements are published. This report does not claim improved reader comprehension or improved runtime performance.

**Expected false-alarm cost:** a poor metric can reject useful outputs or approve incomplete ones; an overbroad authority rule can hide relevant historical evidence. Preserve separate measurements, time scope, and unaffected-result controls. This documentation change introduces no automated alerts.

## Behavior Not Tested

No image-processing, retrieval, or delegation runtime was executed for this publication. The document review does not establish performance on new input populations, changes taking effect in the running service, independent source verification by future agents, or behavior under concurrent updates.

## Evaluation Result

**ship** the documentation within the stated scope. Runtime improvements and privacy guarantees remain unproven by this evaluation.

## Artifact Path

The manual case record is this file: `reports/evals/2026-10-07-outcome-evidence-and-source-authority.md`. No separate runtime transcript exists for these walkthroughs.

## Sign-off

- Run by: publishing assistant, GPT-6.
- Date: 2026-10-07.
- Linked from: [changelog](../../CHANGELOG.md#2026-10-07), self-improvement guide, and agent prompt template.
