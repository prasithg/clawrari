# Orchestration Strategy

`models.yaml` is authoritative. This file is the compact human routing guide.

## Routing table

| Task | Primary | Fallbacks |
|---|---|---|
| Main / general orchestration | Opus 4.8 medium | Sol medium -> Kimi K3 high |
| Research synthesis | Opus 4.8 medium | Sol medium -> Kimi K3 high |
| Coding build | Sol xhigh | Fable xhigh -> Grok high |
| Code review / eval | Sol high | Fable high -> Grok high |
| Hard autonomous work | Fable xhigh | Sol xhigh -> Grok high |
| Content / voice | Opus 4.8 medium | Sol medium -> Kimi K3 high |
| Fast/bulk extraction | Gemini 3.5 Flash low | Sol medium |
| Specialist escalation | Grok 4.5 high | Sol high -> Fable high |
| Explicit Kimi run / comparison | Kimi K3 high | none |
| Experimental GLM comparison | GLM 5.2 high | none |

## Decision tree

```text
Task arrives
├─ Hard, long-horizon, autonomous? -> Fable xhigh -> Sol xhigh -> Grok high
├─ Coding or independent review? -> Sol high/xhigh -> Fable -> Grok
├─ Explicit specialist escalation? -> Grok high
├─ Bounded high-volume extraction/classification/OCR? -> Flash low
├─ Explicit Kimi run? -> Kimi K3 high
├─ Explicit GLM experiment? -> GLM 5.2 high
└─ Everything else -> Opus medium -> Sol medium -> Kimi K3 high
```

Flash may prepare intermediate evidence for a hard task, but it never owns the hard judgment or final synthesis.

## Prompt styles

| Family | Contract |
|---|---|
| Anthropic Opus | XML or Markdown; explicit scope and observable completion. |
| Anthropic Fable | Outcome contract, large task budget, durable state, no requests for raw chain-of-thought. |
| OpenAI GPT-5.6 | Compact XML control blocks, scope fence, persistence, and verification loop. |
| xAI Grok via OpenRouter | Concise Markdown; disputed question, evidence, decision, flip condition. |
| Kimi K3 via OpenRouter | Compact outcome contract; tools, acceptance checks, and exact output shape. |
| Google Flash | One format only; exact schema; sample/validate bulk results mechanically. |
| GLM 5.2 | Compact OpenAI-compatible contract; exact model/effort captured in the eval. |

## Provider policy

- No same-provider alternate ladder. Opus/Fable are role-specific Anthropic models, not mutual outage fallbacks.
- General fallback chain: Opus -> GPT-5.6 Sol -> Kimi K3 through OpenRouter.
- Perplexity is the configured web-search provider and may feed evidence to any reasoning route.
- OpenRouter supplies Grok 4.5 as a specialist and Kimi K3 as the current third-best general fallback, plus GLM 5.2 for experiments.

## Model Council

Use councils only when disagreement materially improves a high-stakes decision. Prefer three distinct roles over three identical prompts:

1. Opus or Fable for judgment and adversarial synthesis.
2. Sol for implementation realism and verification.
3. Grok for specialist or third-family challenge.

Kimi K3 or GLM 5.2 may join only when the council itself is an explicit comparison. Flash may collect evidence, never vote on the hard conclusion.

Council output: verdict, consensus, disagreements, cruxes, flip conditions, dissent, and action items.

## Enforcement

1. `scripts/spawn-helper.sh` reads `models.yaml` and prints model, effort, and fallbacks.
2. `reference/agent-prompt-template.md` exposes the routing table before prompt scaffolding.
3. Live OpenClaw aliases/allowlist contain only the approved roster.
4. Every routing change needs provider smoke tests and a linked core-workflow eval.

## Changelog

- 2026-07-21: Promoted Kimi K3 to the third general fallback after Opus and GPT-5.6 Sol; Grok remains specialist escalation.
- 2026-07-15: Simplified the OpenAI lane to Sol only: medium for conversational/light fallback, high for review/coding, and xhigh for hard-work backup. Terra retired.
- 2026-07-15: Rebuilt policy around Opus medium, cross-provider fallback, Sol/Fable hard-work roles, Grok specialist escalation, Flash fast/bulk-only, and GLM 5.2 experimental.
