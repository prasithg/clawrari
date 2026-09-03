# Model Playbook

Single source of truth for which model to use, at what effort, and how to prompt it.

Last updated: 2026-09-03.

## Files

| File | Purpose |
|---|---|
| `models.yaml` | Canonical active roster, aliases, intent routes, efforts, and fallbacks. |
| `orchestration-strategy.md` | Human-readable routing policy and decision tree. |
| `effort-ladder.md` | Workspace effort convention. |
| `models/opus.md` | Retired Opus 4.8 prompting reference. |
| `models/fable.md` | Fable 5.1 prompting, migration notes, and long-horizon constraints. |
| `models/gpt-5.6.md` | GPT-5.6 Sol effort tiers and prompting. |
| `models/grok-4.5.md` | Grok 4.5 specialist route. |
| `models/kimi-k3.md` | Explicit Kimi K3 route through OpenRouter. |
| `models/gemini-3.5-flash.md` | Flash-only fast/bulk lane. |
| `models/glm-5.2.md` | Experimental GLM route. |
| `overlays/main-opus.md` | Retired Opus main-session reference. |
| `overlays/main-fable.md` | Main-session behavior when running Fable. |
| `overlays/main-gpt54.md` | GPT-family main-session behavior; filename retained for compatibility. |

## Active roster

- Default: Fable 5.1 medium for interactive, ticket, and agent work.
- Default fallback: GPT-5.6 Sol max, then Kimi K3 high. Use Sol xhigh when the runtime does not expose max.
- Reviewer/coding: GPT-5.6 Sol max; Fable 5.1 high as the alternate reviewer.
- Hard autonomous: Fable 5.1 xhigh, then GPT-5.6 Sol max, then Grok 4.5 high.
- Fast/bulk only: Gemini 3.5 Flash low.
- Specialist escalation: Grok 4.5 high.
- Third-place emergency fallback: Kimi K3 high. Opus 4.8 is retired; GLM 5.2 remains experimental.

Perplexity remains a search provider, not a reasoning-model route.

## Use

Treat `models.yaml` as authoritative, then read the selected model file before non-trivial delegation. A workspace may add its own routing helper, but the public playbook does not assume one exists. Run `node scripts/validate-model-playbook.mjs` after any roster or route change.

When adding or retiring a model:

1. Update the live runtime allowlist and fallback chain.
2. Update `models.yaml` and bump its version.
3. Align the human-readable routing docs and per-model guides.
4. Run live model smokes and the core-workflow eval.
5. Run `node scripts/validate-model-playbook.mjs`; retirement is incomplete while an active intent still references the old route.
