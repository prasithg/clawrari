# Orchestration Strategy

`effort-ladder.md` owns model doctrine; `models.yaml` implements the runtime intent defaults. This file is the compact human routing guide. Choose task effort (`low`, `medium`, `high`, `xhigh`) on the two primaries before reaching for another model. The roster is an example stack; substitute your approved models while keeping the shape.

## Routing table

| Task | Primary | Recovery |
|---|---|---|
| Main/default, crons, routine delegation, research synthesis, voice | Fable 5.1 medium | Astra medium, then Grok 4.7 high → Muse Spark 1.3 high only after both fail |
| Hard autonomous work | Fable 5.1 xhigh | Astra xhigh, then Grok 4.7 high → Muse Spark 1.3 high only after both fail |
| Coding/Codex/SWE, long-horizon autonomous coding | GPT-6 Astra xhigh | Fable 5.1 xhigh, then Grok 4.7 high → Muse Spark 1.3 high only after both fail |
| Code review, evals, specialist escalation | GPT-6 Astra high | Fable 5.1 high, then Grok 4.7 high → Muse Spark 1.3 high only after both fail |
| Artifact and computer-use subagents | GPT-6 Astra medium (vary by task) | Fable 5.1 medium, then Grok 4.7 high → Muse Spark 1.3 high only after both fail |
| Bounded bulk classification, extraction, OCR | Gemini 3.7 Flash low | Astra low, then Fable 5.1 low |
| Search evidence | Search provider (Perplexity here) | Fable or Astra owns final synthesis |
| Fable-specific outage, provider still up | Opus 5 high | Cross-provider chain if the provider is also down |
| Explicit comparison run | Kimi K3 high, Sonnet 5, Fable 5, Grok 4.5, or Grok 4.6 | none |
| Experimental utility candidate | GLM 5.3 high | none |

Light work uses low effort, routine work medium, difficult work high, and hard autonomous work xhigh. Substantial Codex builds default to xhigh; task-specific overrides are encouraged. Fable remains main/default even when Astra subagents do much of the work.

## Decision tree

```text
Task arrives
├─ Hard, long-horizon, autonomous orchestration? -> Fable 5.1 xhigh -> Astra xhigh -> (Grok 4.7 -> Muse, resilience only)
├─ Coding, review, eval, artifact, or computer use? -> Astra at task effort -> Fable 5.1 -> (Grok 4.7 -> Muse, resilience only)
├─ Bounded high-volume classification/extraction/OCR? -> Flash low -> Astra low -> Fable 5.1 low
├─ Explicit comparison (Kimi / Sonnet / Fable 5 / Grok 4.5 / Grok 4.6)? -> that model, recorded as a comparison
├─ Explicit GLM utility experiment? -> GLM 5.3 high, recorded as an experiment
└─ Everything else -> Fable 5.1 medium -> Astra medium -> (Grok 4.7 -> Muse, resilience only)
```

Flash may prepare intermediate evidence for a hard task, but it never owns the hard judgment or final synthesis. Grok 4.7 and Muse are never a chosen lane; a job that prefers them is a routing bug.

## Prompt styles

| Lane | Contract |
|---|---|
| Fable 5.1 | Outcome, scope, observable completion, durable checkpoints; no raw chain-of-thought requests. `models/fable.md`. |
| GPT-6 Astra | Outcome, autonomy preamble, instruction precedence, scope, calibrated verification, done-when. `models/gpt-6-astra.md`. |
| Opus 5 (same-family backup) | Claude XML or Markdown; concision, scope, and delegation limits from `overlays/main-opus5.md`. |
| Grok 4.7 via OpenRouter | Concise Markdown; disputed question, evidence, decision, flip condition. |
| Muse Spark 1.3 via OpenRouter | Bounded evidence packet, observed/inferred/speculative labels, committed verdict, flip condition. |
| Google Flash | One format only; exact schema; sample/validate bulk results mechanically. |
| Comparison and experimental models | Read the matching guide; record exact model, effort, and comparison context. |
| Retired GPT-5.6 and Opus 4.8 | Historical prompting reference only; never an active route. |

## Provider policy

- Keep the operational core small: Fable 5.1 primary for main/general/voice, GPT-6 Astra for coding/review/artifacts/computer use. Other models have bounded roles.
- Resilience chain: the other primary first, then Grok 4.7 high, then Muse Spark 1.3 high. Three deep, no self-fallbacks, and the degraded route is recorded.
- Kimi K3 and Sonnet 5 are comparison-only. GLM 5.3 is an experimental utility candidate. None of them enters a live chain.
- Opus 5 is a same-family backup for a Fable-specific outage, not an independent seat or a cross-provider fallback.
- Retiring a model means removing every active intent reference, not merely changing the prose default.
- The search provider feeds evidence to any reasoning route; it is not a reasoning-model route.

## Model Council

Use councils only when disagreement materially improves a high-stakes decision. Prefer three distinct roles over three identical prompts:

1. Fable 5.1 for judgment and adversarial synthesis.
2. GPT-6 Astra for implementation realism and verification.
3. Grok 4.7 high as the standing third-family seat (since 2026-09-23; Grok 4.5 comparison-only).

Optional fourth lane: Muse Spark 1.3 high for strategy/positioning provocation, or GLM 5.3 high for product/integration. A seated model must not be the sole synthesizer: use a non-seated synthesizer, or dual Fable xhigh + Astra xhigh grading, and report the grader gap. Flash may collect evidence, never vote on the hard conclusion. Resilience position does not confer a council seat; Opus 5 is same-family and never seated.

Council output: verdict, consensus, disagreements, cruxes, flip conditions, dissent, and action items.

## Enforcement

1. `models.yaml` is the machine-readable route contract; optional workspace helpers should consume it rather than duplicate the roster.
2. `reference/agent-prompt-template.md` points prompt authors back to this playbook.
3. Runtime aliases and allowlists contain only the approved active roster.
4. Every routing change needs provider smoke tests and a linked core-workflow eval.
5. `node scripts/validate-model-playbook.mjs` rejects missing model references, retired models in active intents, and stale primary-route prose.

## Changelog

- 2026-09-11: Public refresh to the GPT-6 Astra two-primary doctrine. Astra owns coding/review/artifacts/computer use with task-varied effort; Fable 5.1 stays main/general/voice. Grok 4.5 high is fallback #2 and the standing third seat; Muse Spark 1.3 high is fallback #3 and the optional fourth lane. Kimi K3 and Sonnet 5 are comparison-only; Opus 5 is the same-family backup; Gemini 3.7 Flash replaces 3.5; GLM 5.3 is an experimental utility candidate; Sol, Luna, Gemini 3.5 Flash, and GLM 5.2 are retired. Eval: `reports/evals/2026-09-11-model-playbook-refresh.md`.
- 2026-09-03: Promoted Fable 5.1 to the primary route, moved Sol to max for backup/review/coding, retired Opus 4.8, and added a consistency validator.
- 2026-07-21 (historical): Promoted Kimi K3 to the third general fallback after Opus and GPT-5.6 Sol; Grok remains specialist escalation.
- 2026-07-15: Simplified the OpenAI lane to Sol only: medium for conversational/light fallback, high for review/coding, and xhigh for hard-work backup. Terra retired.
- 2026-07-15 (historical): Rebuilt policy around Opus medium, cross-provider fallback, Sol/Fable hard-work roles, Grok specialist escalation, Flash fast/bulk-only, and GLM 5.2 experimental.
