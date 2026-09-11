# Model Playbook

Single source of truth for which model to use, at what effort, and how to prompt it.

Last updated: 2026-09-11.

The roster here is an example of one working stack. It does not assume every user has access to every provider or model named; keep the shape (two primaries with task-varied effort, one bounded utility lane, resilience-only tails) and substitute your approved models.

## Files

| File | Purpose |
|---|---|
| `models.yaml` | Canonical roster, statuses, aliases, intent routes, efforts, and fallbacks. |
| `effort-ladder.md` | Routing doctrine: two primaries, effort table, runtime routes, resilience, council, retired list. |
| `orchestration-strategy.md` | Human-readable routing table, decision tree, prompt styles, council, enforcement. |
| `models/fable.md` | Fable 5.1 prompting, migration notes, and long-horizon constraints. |
| `models/gpt-6-astra.md` | GPT-6 Astra (OpenAI lane since 2026-09-09): effort tiers, behavior deltas, verbatim autonomy/precedence/testing snippets. |
| `models/grok-4.5.md` | Grok 4.5: standing council third seat and resilience fallback #2. |
| `models/muse-spark-1.3.md` | Muse Spark 1.3: resilience fallback #3 and optional fourth council lane. |
| `models/gemini-3.7-flash.md` | Flash-only fast/bulk lane (classification, extraction, OCR). |
| `models/glm-5.3.md` | GLM 5.3: experimental utility candidate, never a live route. |
| `models/kimi-k3.md` | Kimi K3: comparison-only. |
| `models/gpt-5.6.md` | GPT-5.6 Sol: retired 2026-09-09; historical prompting reference. |
| `models/gemini-3.5-flash.md` | Gemini 3.5 Flash: retired; superseded by 3.7. |
| `models/glm-5.2.md` | GLM 5.2: retired; superseded by 5.3. |
| `models/opus.md` | Opus 4.8: retired prompting reference. |
| `overlays/main-fable.md` | Main-session behavior when running Fable 5.1. |
| `overlays/main-gpt6.md` | Main-session behavior when running GPT-6 Astra. |
| `overlays/main-opus5.md` | Main-session behavior when the same-family backup Opus 5 is active. |
| `overlays/main-gpt54.md` | Retired GPT-5.6 main-session overlay; historical reference only. |
| `overlays/main-opus.md` | Retired Opus 4.8 main-session overlay; historical reference only. |
| `fable-operating-pack.md` | Prompt library for long-horizon Fable work. |

## Active roster

- Default main/crons/delegation/voice: Fable 5.1; task effort low/medium/high/xhigh.
- Default fallback: GPT-6 Astra medium, then Grok 4.5 high → Muse Spark 1.3 high only after both primaries fail.
- Reviewer/coding/Codex/SWE/artifact/computer-use: GPT-6 Astra; vary low/medium/high/xhigh by task. Fable 5.1 is the alternate.
- Hard autonomous: Fable 5.1 xhigh, then GPT-6 Astra xhigh, then Grok 4.5 high → Muse Spark 1.3 high only after both primaries fail.
- Fast/bulk only: Gemini 3.7 Flash low (classification, extraction, OCR), then Astra low, then Fable 5.1 low.
- Council: Fable 5.1, GPT-6 Astra, Grok 4.5 high; optional fourth lane Muse Spark 1.3 (strategy) or GLM 5.3 (product/integration).
- Same-family backup: Opus 5 high for Fable-specific outages; never a council seat.
- Comparison-only: Kimi K3, Sonnet 5, Fable 5, Grok 4.6. Experimental utility candidate: GLM 5.3.
- Retired: Opus 4.8, GPT-5.6 Sol, GPT-5.6 Luna, Gemini 3.5 Flash, GLM 5.2.

A search provider remains a search provider, not a reasoning-model route.

## Use

Treat `models.yaml` as authoritative, then read the selected model file before non-trivial delegation. `effort-ladder.md` owns doctrine; `models.yaml` implements the intent defaults and must agree. A workspace may add its own routing helper, but the public playbook does not assume one exists. Run `node scripts/validate-model-playbook.mjs` after any roster or route change.

When adding or retiring a model:

1. Update the live runtime allowlist and fallback chain.
2. Update `models.yaml` and bump its version.
3. Align the human-readable routing docs and per-model guides.
4. Run live model smokes and the core-workflow eval.
5. Run `node scripts/validate-model-playbook.mjs`; retirement is incomplete while an active intent still references the old route.
