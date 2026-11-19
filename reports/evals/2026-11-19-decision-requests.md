# Decision requests and reminder evidence

## Header

Change under test: decision-request guidance in [self-improvement](../../docs/self-improvement.md#require-complete-decision-requests-and-confirmed-reminders) and one mapped [evaluation template](../../reference/skill-change-eval-template.md#decision-request-and-reminder-evidence).
Surface class: documentation and evaluation instructions. Linked ticket: N/A, public distillation of operating lessons. Fault side: delivery tool and request preparation; repair belongs at the request and delivery boundaries.

## Task Set and Baseline vs New

These are manual instruction walkthroughs, not executed delivery tests. The baseline is the prior public documentation; private implementation results are not public-runtime evidence.

| Task | Baseline | New guidance | Result |
| --- | --- | --- | --- |
| Approval impact absent, but choice label present | No dedicated completeness rule | Hold for explicit impact | Pass |
| Silence impact absent, but planned default present | No dedicated distinction | Hold; do not borrow the plan | Pass |
| Personal authority absent | No dedicated requirement | Return to owner for repair | Pass |
| Mixed due, deferred, and held requests | No dedicated reminder selection rule | Stamp only included requests after success | Pass |
| Delivery fails or remains uncertain | No dedicated reminder boundary | Do not assert delivery; verify before resend | Pass |
| Default date passes without execution evidence | General completion evidence only | Keep open until request-specific completion is verified | Pass |
| Every request held | No dedicated owner-report rule | Keep maintenance visible without an outbound card | Pass |
| Tracking issue closes with human action remaining | General completion evidence only | Retain the action until its completion condition is met | Pass |

## Metrics

Eight of eight manual cases have an explicit instruction supporting the expected outcome. This measures documentation coverage, not software correctness or human comprehension.

## Grader / Eval-Fault Check

The author performed these walkthroughs. They can miss ambiguity. Check that source statements describe meaningful consequences; text presence alone is not a quality measure. Do not change valid expected outcomes merely to match an implementation.

False-alarm cost: a useful but incomplete request may be held until its owner supplies explicit statements. That owner pays the repair cost.

## Untested Surface and Verdict

No live scheduler, delivery service, reminder writer, concurrency, or human review was exercised. Closing before successful delivery remains an implementation ordering risk to test, not a behavior this documentation proves repaired.

Verdict: ship the documentation. Live behavior remains unverified by this evaluation.

## Artifact Path

Manual inputs, expected outcomes, and results are embedded in this file: `reports/evals/2026-11-19-decision-requests.md`.

## Sign-off

Run by: Codex. Date: 2026-11-19. Linked from the changelog, guidance, and evaluation template.

Lesson learned: request completeness and delivery confirmation need separate evidence.
