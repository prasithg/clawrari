# Approval and change-history documentation evaluation

- Change: add two lessons to self-improvement guidance and refresh the evaluation template's risk-specific checks.
- Surface: documentation and evaluation template.
- Linked issue: none; captured from operational repairs.
- Fault location: planning authority and writer history handling. Repair belongs at those boundaries, not only in reminder text.

## Tasks and baseline comparison

These are documentation walkthroughs, not executed software tests. The baseline is the public documentation before this update.

| Case | Baseline | Updated guidance | Result |
| --- | --- | --- | --- |
| Inspection request becomes a restore plan | No specific inspection-versus-restore distinction in these additions | Requires explicit operation-scoped authorization and unchanged-data controls | Pass in walkthrough |
| Another caller bypasses the planner | Generic verification advice | Requires the writer to check authorization | Pass in walkthrough |
| Approved manual edit reaches a no-content-change write | No explicit adoption-record retention requirement | Retains structured history despite unchanged bytes | Pass in walkthrough |
| Adoption record has mismatched content identities | Generic provenance requirement | Leaves the transition unresolved | Pass in walkthrough |

## Metrics and grader check

Four of four documentation cases have an explicit decision rule. These counts measure coverage of the written guidance, not runtime correctness. The cases include denied operations and incomplete evidence so permissive advice cannot pass merely by describing success.

## Untested surface

No public implementation is introduced or executed. Concurrent writers, production journal reconciliation, real approval services, and index publication are untested. Operational source repairs informed the lessons; their private logs and identifying details are not published.

## Verdict

Ship the documentation. It specifies acceptance checks; it does not certify a reader's implementation.

## Evidence and sign-off

The table above is the retained walkthrough output. Changed artifacts: `docs/self-improvement.md` sections 71–72 and `reference/skill-change-eval-template.md`, risk-specific additions. Reviewed by the publishing agent on 2026-11-13.

Lesson learned: approval and historical continuity must survive every path to the writer, including writes that change no content.
