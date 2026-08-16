# Opus 5 Overlay Port Eval — 2026-08-16

## Header

- **Change under test:** add a public, generalized Opus 5 main-session overlay.
- **Surface class:** model playbook / prompt guidance.
- **Linked ticket:** N/A — recurring public-sync run.
- **Fault side:** N/A — capability port, not an incident repair.

## Task Set

1. **Small tool task:** guidance should discourage unnecessary delegation and repeated self-checks.
2. **Bounded implementation task:** guidance should preserve end-to-end completion while preventing silent scope expansion.
3. **Consequential artifact:** guidance should retain independent tests, evals, and reviewer controls while removing same-model recheck boilerplate.
4. **Public sanitization:** the overlay must contain no private company, person, channel, ticket, URL, credential, or financial detail.

## Baseline vs New

| Task | Baseline: Opus 4.8 overlay | New: Opus 5 overlay | Result |
|---|---|---|---|
| Small tool task | encourages delegation for meaty work and extra tool use | explicitly reserves delegation for sizeable independent tracks | pass |
| Bounded implementation | warns mainly about under-scoping | adds a completion-without-expansion instruction | pass |
| Consequential artifact | relies on explicit verification nudges | removes redundant self-checks but retains independent evidence | pass |
| Public sanitization | contains older workspace-specific examples | new overlay uses operator-neutral examples only | pass |

## Metrics

- Task success: 4/4 checks passed.
- Structural coverage: all three documented behavior inversions are represented.
- Privacy scan: zero matches for the private-name, internal-ticket, channel-id, URL, credential, and financial patterns used by the public commit guard preflight.
- Formatting: `git diff --check` passed.

## Verdict

**ship** — the overlay captures the reusable Opus 5 behavior changes, stays concise, and removes workspace-specific examples.

**Untested surface:** This was a documentation-port eval. It did not run live model A/B trials, measure token savings, or test behavior across every effort level and provider. Those claims remain guidance derived from observed behavior and the vendor migration guidance, not a benchmark.

## Artifact Path

- Overlay: `reference/model-playbook/overlays/main-opus5.md`
- Eval: `reports/evals/opus5-overlay-port-2026-08-16.md`

## Sign-off

- Run by: Clawrari Pulse automation
- Date: 2026-08-16
