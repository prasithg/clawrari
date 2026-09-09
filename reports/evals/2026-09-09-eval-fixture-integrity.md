# Eval — Controlled Evidence for Golden Fixtures

## Header

- **Change under test:** add a reusable procedure for repairing stale golden-fixture citations and denominators without changing the claim being tested.
- **Surface class:** core workflow documentation.
- **Linked ticket:** N/A. Distilled from a completed evaluator-maintenance run.
- **Fault side:** `grader`. Stale citations and duplicated counts are evaluator defects, not model defects.

## Task Set

1. Repair a golden row whose cited file was deleted when another canonical source still supports the same claim.
2. Handle a golden row whose cited file and underlying fact are both gone.
3. Reconcile a fixture that contains more rows than the runner's hardcoded expected count.

## Baseline vs New

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| Live replacement source exists | Repoint the row based on topic similarity, with no proof that the same fact survived | Change only the citation after confirming the replacement contains the load-bearing fact | Preserves test meaning while restoring provenance |
| Underlying fact is gone | Force the row green by citing a related document | Leave the row unresolved and route retirement or replacement through review | Prevents an evidence repair from silently rewriting the test |
| Fixture count changed | Update a duplicated constant by hand, risking future drift | Parse the denominator from the fixture's single source of truth | Keeps dry runs and policy reports honest automatically |

## Metrics

- Task success: 3/3 procedure cases produce a deterministic decision.
- Evidence preservation: question and expected answer remain unchanged in the citation-only repair case.
- Fault localization: all three cases are classified as evaluator faults; no model prompt or quality threshold changes.
- Qualitative verdict: the new procedure makes a green score depend on live evidence, not semantic luck or synchronized constants.

## Grader / Eval-Fault Check

The observed failures live in the evaluator: two provenance states and one denominator state. The procedure repairs those surfaces directly. It explicitly blocks model tuning and threshold changes until the evaluator is sound.

## Untested Surface

This documentation eval does not exercise concurrent fixture edits, signed datasets, or very large fixture stores. Projects with those risks should add transactional writes and integrity hashes.

## Verdict

**ship**. The three representative cases are covered, preserve the tested claim, and keep unresolved evidence visible.

## Artifact Path

`reports/evals/2026-09-09-eval-fixture-integrity.md`

## Sign-off

- Run by: Claw
- Date: 2026-09-09
- Linked from: `docs/self-improvement.md` §16 and `CHANGELOG.md`
