# Grok 4.7

**Runtime id:** `openrouter/x-ai/grok-4.7` · **alias:** `grok` · **context:** 500k (OpenRouter)

## Routing

Grok 4.7 high is the standing council third seat and resilience fallback #2 after **both** Fable 5.1 and GPT-6 Astra fail (`../effort-ladder.md#council-third-seat`, `#resilience-fallback`). Adopted 2026-09-23 on operator direction, replacing Grok 4.5; Grok 4.6 was skipped. Status is `[provisional]`: gateway-smoked and sanity-compared against 4.5, but the n>=3 third-seat re-test with the model-council dual-grader method is still owed (see the 2026-09-23 changelog entry). Set effort explicitly (normally high).

**What changed vs 4.5:** untested here as of 2026-09-23 beyond the smoke + one code-review sanity prompt. OpenRouter list price is lower ($1.6/$4.8 per M vs $2/$6). Treat prompting guidance below as inherited from 4.5 until the re-test says otherwise.

## Prompt shape

Use concise Markdown with a concrete outcome, bounded evidence, and a visible verification contract. Put the actual decision or deliverable first. When asking for specialist judgment, name the disputed question and the evidence that should flip the conclusion.

## Failure modes

- Do not assume OpenRouter availability proves the configured key can call the model; keep a live smoke test in the routing eval.
- Do not use provider-native xAI features unless the selected OpenRouter route exposes them.
- Do not route sensitive or high-stakes conclusions without grounding them in retrieved evidence.
