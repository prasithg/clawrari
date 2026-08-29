# Memory Integrity and Prompt Constraints — Eval

## Header

- **Change under test:** add journaled canonical-write recovery, expiring handoff aliases, and explicit negative/failure-mode blocks to the public reference docs.
- **Surface class:** core workflow + prompt template.
- **Linked ticket:** N/A — scheduled public distillation from live operating work.
- **Fault side:** memory—index · fault:harness for unjournaled trusted writes; prompt—artifact · fault:harness for underspecified output boundaries.

## Task Set

1. A canonical memory file changes outside the normal writer while the retrieval index trusts a hash manifest.
2. A new session receives a short handoff phrase whose full context was captured previously.
3. An agent is asked for a decision memo but is likely to return an adjacent implementation plan or generic summary.

## Baseline vs New

| Task | Baseline | New | Observable delta |
| --- | --- | --- | --- |
| Canonical edit bypass | The docs state that Markdown is truth and the index is derived, but do not define how a trusted direct edit reaches publication or recovers from fail-closed detection. | The write path validates authority, journals before/after hashes, applies atomically, rebuilds, verifies, and includes a bounded no-op adoption route. | Six explicit integrity and recovery requirements are documented. |
| Session handoff | Temporary context holds have expiry, but exact session-resume aliases have no canonical registration or consume-on-use contract. | The alias contract names phrase, resolved context, registration, expiry, lookup-before-guessing, consume-on-use, and scheduled cleanup. | Seven lifecycle requirements are documented. |
| Artifact-fit prompt | The template names audience and constraints, but likely adjacent outputs and known failure shapes remain implicit. | Separate `negative_constraints` and `failure_modes_to_avoid` blocks make both boundaries explicit. | Two machine-readable prompt blocks and seven reusable prompts are added. |

## Metrics

- Task success: 3/3 scenarios now have an explicit reusable operating contract.
- Correctness: 20/20 enumerated requirements above are present in the changed docs.
- Safety: public-text review found no private organizations, people, internal identifiers, URLs, credentials, or financial details.
- Regression risk: additive documentation only; no scripts, schemas, APIs, or dependencies changed.

## Gaps + Fixes

- Gap: this run does not ship a generic journal/adoption implementation or expiry-sweep script.
- Fix: keep this change as the public operating contract; port executable scaffolds only after they can be generalized and evaluated independently.

## Untested Surface

No live retrieval index was fault-injected, and no model trial measured whether the new prompt blocks improve artifact fit. This eval proves completeness and public safety of the documented contracts, not runtime effectiveness.

## Verdict

**ship** — the additions are additive, falsifiable, sanitized, and close three concrete documentation gaps without claiming executable coverage.

## Artifact Path

`reports/evals/2026-08-29-memory-integrity-and-prompt-constraints.md`

## Sign-off

- Run by: Claw
- Date: 2026-08-29
- Linked from: `CHANGELOG.md`
