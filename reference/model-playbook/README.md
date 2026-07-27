# Model Playbook

Single source of truth for which model to use, at what effort, and how to prompt it.

Last updated: 2026-07-21.

## Files

| File | Purpose |
|---|---|
| `models.yaml` | Canonical active roster, aliases, intent routes, efforts, and fallbacks. |
| `orchestration-strategy.md` | Human-readable routing policy and decision tree. |
| `effort-ladder.md` | Workspace effort convention. |
| `models/opus.md` | Opus 4.8 prompting. |
| `models/fable.md` | Fable 5 prompting and long-horizon constraints. |
| `models/gpt-5.6.md` | GPT-5.6 Sol effort tiers and prompting. |
| `models/grok-4.5.md` | Grok 4.5 specialist route. |
| `models/kimi-k3.md` | Explicit Kimi K3 route through OpenRouter. |
| `models/gemini-3.5-flash.md` | Flash-only fast/bulk lane. |
| `models/glm-5.2.md` | Experimental GLM route. |
| `overlays/main-opus.md` | Main-session behavior when running Opus. |
| `overlays/main-fable.md` | Main-session behavior when running Fable. |
| `overlays/main-gpt54.md` | GPT-family main-session behavior; filename retained for compatibility. |

## Active roster

- Default: Opus 4.8 medium.
- Default fallback: GPT-5.6 Sol medium, then Kimi K3 high.
- Reviewer/coding: GPT-5.6 Sol high; Fable 5 as the alternate reviewer.
- Hard autonomous: Fable 5 xhigh, then GPT-5.6 Sol xhigh, then Grok 4.5 high.
- Fast/bulk only: Gemini 3.5 Flash low.
- Specialist escalation: Grok 4.5 high.
- Third-best general fallback: Kimi K3 high. Grok 4.5 remains specialist escalation; GLM 5.2 remains experimental.

Perplexity remains a search provider, not a reasoning-model route.

## Use

Run `./scripts/spawn-helper.sh <intent>` before non-trivial delegation, then read the returned model file. `models.yaml` is authoritative if prose drifts.

When adding or retiring a model:

1. Update the live OpenClaw allowlist and fallback chain.
2. Update `models.yaml` and bump its version.
3. Align the prompt template and boot-context summaries.
4. Run live model smokes and the core-workflow eval.
