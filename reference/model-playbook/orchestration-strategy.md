# Orchestration Strategy

`models.yaml` is authoritative. This file is the compact human routing guide.

## Routing table

| Task | Primary | Fallbacks |
|---|---|---|
| Main / general orchestration | Fable 5.1 medium | Sol max -> Kimi K3 high |
| Research synthesis | Fable 5.1 medium | Sol max -> Kimi K3 high |
| Coding build | Sol max | Fable 5.1 xhigh -> Grok high |
| Code review / eval | Sol max | Fable 5.1 high -> Grok high |
| Hard autonomous work | Fable 5.1 xhigh | Sol max -> Grok high |
| Content / voice | Fable 5.1 medium | Sol max -> Kimi K3 high |
| Fast/bulk extraction | Gemini 3.5 Flash low | Fable 5.1 medium |
| Specialist escalation | Grok 4.5 high | Sol max -> Fable 5.1 high |
| Explicit Kimi run / comparison | Kimi K3 high | none |
| Experimental GLM comparison | GLM 5.2 high | none |

## Decision tree

```text
Task arrives
├─ Hard, long-horizon, autonomous? -> Fable 5.1 xhigh -> Sol max -> Grok high
├─ Coding or independent review? -> Sol max -> Fable 5.1 -> Grok
├─ Explicit specialist escalation? -> Grok high
├─ Bounded high-volume extraction/classification/OCR? -> Flash low
├─ Explicit Kimi run? -> Kimi K3 high
├─ Explicit GLM experiment? -> GLM 5.2 high
└─ Everything else -> Fable 5.1 medium -> Sol max -> Kimi K3 high
```

Flash may prepare intermediate evidence for a hard task, but it never owns the hard judgment or final synthesis.

## Prompt styles

| Family | Contract |
|---|---|
| Anthropic Fable 5.1 | Outcome contract, large task budget, durable state, no requests for raw chain-of-thought. |
| Retired Anthropic Opus | Historical prompting reference only; never an active route. |
| OpenAI GPT-5.6 | Compact XML control blocks, scope fence, persistence, and verification loop. |
| xAI Grok via OpenRouter | Concise Markdown; disputed question, evidence, decision, flip condition. |
| Kimi K3 via OpenRouter | Compact outcome contract; tools, acceptance checks, and exact output shape. |
| Google Flash | One format only; exact schema; sample/validate bulk results mechanically. |
| GLM 5.2 | Compact OpenAI-compatible contract; exact model/effort captured in the eval. |

## Provider policy

- Keep the operational core small: Fable 5.1 primary, GPT-5.6 Sol cross-provider backup/reviewer/coder. Other models have bounded roles.
- General fallback chain: Fable 5.1 -> GPT-5.6 Sol -> Kimi K3 through OpenRouter.
- Retiring a model means removing every active intent reference, not merely changing the prose default.
- Perplexity is the configured web-search provider and may feed evidence to any reasoning route.
- OpenRouter supplies Grok 4.5 as a specialist and Kimi K3 as the current third-best general fallback, plus GLM 5.2 for experiments.

## Model Council

Use councils only when disagreement materially improves a high-stakes decision. Prefer three distinct roles over three identical prompts:

1. Fable 5.1 for judgment and adversarial synthesis.
2. Sol for implementation realism and verification.
3. Grok for specialist or third-family challenge.

Kimi K3 or GLM 5.2 may join only when the council itself is an explicit comparison. Flash may collect evidence, never vote on the hard conclusion.

Council output: verdict, consensus, disagreements, cruxes, flip conditions, dissent, and action items.

## Enforcement

1. `models.yaml` is the machine-readable route contract; optional workspace helpers should consume it rather than duplicate the roster.
2. `reference/agent-prompt-template.md` points prompt authors back to this playbook.
3. Runtime aliases and allowlists contain only the approved active roster.
4. Every routing change needs provider smoke tests and a linked core-workflow eval.
5. `node scripts/validate-model-playbook.mjs` rejects missing model references, retired models in active intents, and stale primary-route prose.

## Changelog

- 2026-09-03: Promoted Fable 5.1 to the primary route, moved Sol to max for backup/review/coding, retired Opus 4.8, and added a consistency validator.
- 2026-07-21: Promoted Kimi K3 to the third general fallback after Opus and GPT-5.6 Sol; Grok remains specialist escalation.
- 2026-07-15: Simplified the OpenAI lane to Sol only: medium for conversational/light fallback, high for review/coding, and xhigh for hard-work backup. Terra retired.
- 2026-07-15: Rebuilt policy around Opus medium, cross-provider fallback, Sol/Fable hard-work roles, Grok specialist escalation, Flash fast/bulk-only, and GLM 5.2 experimental.
