# Model Overlay Writing-Baseline Eval

## Header

- **Change under test:** add one durable-writing baseline to each main-model overlay and generalize product-specific design examples.
- **Surface class:** model playbook / orchestration guidance.
- **Linked ticket:** N/A — scheduled public-repo drift refresh.
- **Fault side:** `model—reader · fault:harness`; model-specific overlays lacked a shared minimum standard for durable text.

## Task Set

1. Write a change note from a model overlay that previously had no durable-writing rule.
2. Write a conditional operational instruction whose order could confuse the reader.
3. Describe a technical product's visual direction without relying on a private product example.

## Baseline vs New

| Task | Baseline | New | Result |
|---|---|---|---|
| Change note | Model-specific style guidance only; the minimum editorial standard was implicit. | The overlay requires the point first, active voice, present tense, stable terminology, and no unexplained shorthand. | Pass |
| Conditional instruction | No shared rule required the condition to precede the action. | Every overlay explicitly places the condition before the instruction. | Pass |
| Visual direction | Two overlays and one model guide used a product-specific example. | The same guidance now uses a generic technical and enterprise context. | Pass |

## Metrics

- Overlay coverage: 4 of 4 main-model overlays contain the baseline.
- Required baseline clauses present: 5 of 5.
- Private product references in the model playbook: 0 after the refresh.
- Surface precedence preserved: 4 of 4 overlays state that the surface-specific voice guide wins.

## Golden Exemplars

These fixed examples define the minimum bar for future checks:

- **Change note:** “The deploy now rejects unsigned artifacts. This prevents an unverified package from reaching production.”
- **Conditional instruction:** “If the verification command fails, stop the release and report the failing check.”
- **Visual direction:** “For a technical enterprise interface, specify the palette, typography, density, and component structure; blues, greens, and whites are a reliable starting point.”

The changed guidance should produce text at least this direct. It should not add a windup, hide the condition after the command, switch terms for the same concept, or require private context.

## Gaps and Fixes

- This is a documentation-level control. It does not mechanically lint prose produced by every supported model.
- A future eval can sample live outputs across model families if the baseline grows beyond these deterministic clauses.

## Untested Surface

This eval did not run live generations or measure reader comprehension. It checks coverage, wording, and sanitization in the published playbook, not downstream model compliance.

## Verdict

**ship** — the baseline is consistent, reusable, and sanitized across all main-model overlays.

## Artifact Path

`reports/evals/2026-08-25-model-overlay-writing-baseline.md`

## Sign-off

- Run by: Clawrari Pulse automation.
- Date: 2026-08-25.
- Linked from: `CHANGELOG.md` and `reference/model-playbook/overlays/`.
