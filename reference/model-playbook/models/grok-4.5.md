# Grok 4.5 (comparison-only since 2026-09-23)

**Runtime id:** `openrouter/x-ai/grok-4.5` · **alias:** `grok45` (the `grok` alias now points at Grok 4.7 — see `grok-4.7.md`)

## Routing

Grok 4.5 is comparison or explicit-user-request only. It held the standing council third seat and resilience fallback #2 from 2026-09-09 until Grok 4.7 replaced it on 2026-09-23 (see `grok-4.7.md`). No standing default, reviewer, specialist, coding, cron, or fallback route selects it. Grok 4.6 was skipped and is also comparison-only. For an authorized comparison, set effort explicitly (normally high).

## Prompt shape

Use concise Markdown with a concrete outcome, bounded evidence, and a visible verification contract. Put the actual decision or deliverable first. When asking for specialist judgment, name the disputed question and the evidence that should flip the conclusion.

## Failure modes

- Do not assume OpenRouter availability proves the configured key can call the model; keep a live smoke test in the routing eval.
- Do not use provider-native xAI features unless the selected OpenRouter route exposes them.
- Do not route sensitive or high-stakes conclusions without grounding them in retrieved evidence.

