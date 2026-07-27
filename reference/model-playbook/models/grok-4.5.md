# Grok 4.5

**Runtime id:** `openrouter/x-ai/grok-4.5` · **alias:** `grok`

## Routing

Use Grok 4.5 at **high** effort for:

- Explicit specialist escalation.
- A third-family judgment after Anthropic and OpenAI.
- Terminal provider fallback when both the default Anthropic and OpenAI routes are unavailable.

Do not use it as the routine default, reviewer, or cheap/bulk lane.

## Prompt shape

Use concise Markdown with a concrete outcome, bounded evidence, and a visible verification contract. Put the actual decision or deliverable first. When asking for specialist judgment, name the disputed question and the evidence that should flip the conclusion.

## Failure modes

- Do not assume OpenRouter availability proves the configured key can call the model; keep a live smoke test in the routing eval.
- Do not use provider-native xAI features unless the selected OpenRouter route exposes them.
- Do not route sensitive or high-stakes conclusions without grounding them in retrieved evidence.

