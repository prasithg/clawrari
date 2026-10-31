# Model Playbook

Single source of truth for which model to use, at what effort, and how to prompt it.

Maintenance guidance updated: 2026-10-31. The model roster remains an example snapshot.

The roster here is an example of one working stack. It does not assume every user has access to every provider or model named; keep the shape (two primaries with task-varied effort, one bounded utility lane, resilience-only tails) and substitute your approved models.

## Files

| File | Purpose |
|---|---|
| `models.yaml` | Canonical roster, statuses, aliases, intent routes, efforts, and fallbacks. |
| `effort-ladder.md` | Routing doctrine: two primaries, effort table, runtime routes, resilience, council, retired list. |
| `orchestration-strategy.md` | Human-readable routing table, decision tree, prompt styles, council, enforcement. |
| `models/fable.md` | Fable 5.1 prompting, migration notes, and long-horizon constraints. |
| `models/gpt-6-astra.md` | GPT-6 Astra (OpenAI lane since 2026-09-09): effort tiers, behavior deltas, verbatim autonomy/precedence/testing snippets. |
| `models/grok-4.7.md` | Grok 4.7: standing council third seat and resilience fallback #2 (since 2026-09-23). |
| `models/grok-4.5.md` | Grok 4.5: comparison-only; superseded by 4.7. |
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
- Default fallback: GPT-6 Astra medium, then Grok 4.7 high → Muse Spark 1.3 high only after both primaries fail.
- Reviewer/coding/Codex/SWE/artifact/computer-use: GPT-6 Astra; vary low/medium/high/xhigh by task. Fable 5.1 is the alternate.
- Hard autonomous: Fable 5.1 xhigh, then GPT-6 Astra xhigh, then Grok 4.7 high → Muse Spark 1.3 high only after both primaries fail.
- Fast/bulk only: Gemini 3.7 Flash low (classification, extraction, OCR), then Astra low, then Fable 5.1 low.
- Council: Fable 5.1, GPT-6 Astra, Grok 4.7 high; optional fourth lane Muse Spark 1.3 (strategy) or GLM 5.3 (product/integration).
- Same-family backup: Opus 5 high for Fable-specific outages; never a council seat.
- Comparison-only: Kimi K3, Sonnet 5, Fable 5, Grok 4.5 (`grok45`), Grok 4.6. Experimental utility candidate: GLM 5.3.
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

## Maintain Model Routes as One Change

A model replacement can leave scheduled jobs, tool defaults, or plugin settings on the old model after the main setting changes. Maintain a registry that maps each task role to its approved model and records retired identifiers. Keep provider discovery separate from activation: finding a candidate is a reason to evaluate it, not permission to switch.

Before changing a route:

1. Inventory every consumer: runtime allowlists, fallback chains, scheduled-job settings and prompts, command-line tools, plugin settings, and maintained instructions.
2. Preview the proposed changes without writing. Preserve aliases and required parameters, and remove any fallback that becomes identical to the primary model.
3. Back up affected configuration and apply the approved change through each system's supported writer. Preserve unrelated jobs and settings.
4. Check active consumers for retired identifiers. Treat an unreadable consumer as incomplete coverage. Keep historical examples outside active-route checks, with narrow, explained exceptions.
5. Determine whether activation requires a restart. After activation, check service health and run the intended operation through the selected runtime. A provider response alone does not prove the runtime uses the replacement.
6. Save the evaluation and report unfinished consumers. Keep discovery, configuration validation, activation, and operation results separate.

When implementing this workflow, test a no-write preview, a replacement across multiple consumers, and rejection of unknown or unchanged models. Check that unrelated jobs remain unchanged. Use disposable configuration and a fake command runner before any live write.

This section refreshes the maintenance process from operational work. The model list above remains an example snapshot; this update does not replace its model identifiers. The public repository's existing validator checks the bundled playbook. The wider discovery, switching, and consumer-scanning tools described here are design requirements and are not shipped by this update.

Read the [documentation evaluation](../../reports/evals/2026-10-31-test-isolation-and-model-maintenance.md#model-maintenance-cases) for reviewed cases and untested behavior.
