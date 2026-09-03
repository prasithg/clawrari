# Fable 5.1 Routing Refresh Eval

## Header

- **Change under test:** promote Fable 5.1 to the main and routine-agent route, retire Opus 4.8 from active intents, and add a fail-closed model-playbook validator.
- **Surface class:** model-routing playbook + orchestration guardrail.
- **Linked ticket:** N/A — scheduled public-repo drift refresh.
- **Fault side:** `routing docs—runtime · fault:harness`; a route could previously change in one file while stale guidance continued to name the old default.

## Task Set

The model migration used three identical-prompt comparisons between Fable 5 and Fable 5.1 at their routine effort setting:

1. Write a short public draft under a fixed voice and lexical gate.
2. Produce a source-grounded meeting recap under a strict length limit.
3. Audit a workspace and return exact counts, file names, and repository state while batching independent reads.

The guardrail used four deterministic fixtures:

1. Accept a valid active route.
2. Reject an active intent that references a retired model.
3. Reject a model whose prompt guide is missing.
4. Reject an alias assigned to two models.

## Baseline vs New

| Task | Fable 5 baseline | Fable 5.1 | Result |
|---|---|---|---|
| Voice-constrained draft | Passed the lexical gate and produced a safe draft. | Produced stronger structure and specificity but missed one banned word; the independent gate caught it. | Baseline edge on first-pass gate compliance; the existing external gate contains the miss. |
| Source-grounded recap | Complete, faithful, and free of invented facts. | Equally faithful, with two useful source details the baseline omitted. | Tie on correctness; 5.1 edge on detail. |
| Workspace audit | Returned the requested counts and batched its reads. | Returned the same correct answer, surfaced an ambiguous counting rule, and explained its resolution. | 5.1 edge on precision under ambiguity. |
| Routing consistency | Prose review only; stale defaults could survive a roster edit. | Executable checks cover references, statuses, prompt files, aliases, efforts, fallback maps, and the documented main route. | New guardrail rejects the tested drift classes. |

## Metrics

- Correct task outcomes: 3 of 3 on both model generations.
- Fable 5.1 tie-or-better outcomes: 2 of 3; the remaining miss was caught by an existing independent publication gate.
- Provider and routed tool-use smokes: 2 of 2 passed before the alias moved.
- Validator self-test: 4 of 4 fixtures passed.
- Live playbook validation: 10 models and 14 intents passed with routing docs aligned.
- Retired models referenced by active intents: 0.

## Risks and Fixes

- **Conversation-bound thinking blocks:** keep long transcripts append-only; do not edit or reorder earlier turns before replay.
- **Reduced implicit tool batching:** tell long-loop agents to request independent inputs together.
- **Less retrieval at low effort:** raise effort or explicitly require search for evidence-dependent work.
- **Silent documentation drift:** `node scripts/validate-model-playbook.mjs` now fails when routes reference missing or retired models, prompt guides disappear, aliases collide, effort maps drift, or the public docs omit the active main route.

## Untested Surface

This eval did not measure repeated-run variance, very long transcript replay, live provider failover, rate limits, image tasks, or cost under sustained autonomous use. The validator checks the supported YAML shape and named documentation invariants; it does not prove runtime credentials or provider availability.

## Verdict

**ship** — Fable 5.1 matched or improved correctness on the representative tasks, improved ambiguity handling, and retains an independent content gate for the one first-pass lexical miss. The new validator makes retirement and route consistency mechanically enforceable.

## Artifact Path

`reports/evals/2026-09-03-fable51-routing-refresh.md`

## Sign-off

- Run by: Clawrari Pulse automation.
- Date: 2026-09-03.
- Linked from: `CHANGELOG.md` and `reference/model-playbook/`.
