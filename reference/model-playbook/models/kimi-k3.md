# Kimi K3

**Runtime id:** `openrouter/moonshotai/kimi-k3` · **alias:** `kimi`

## Routing

Kimi K3 is **comparison-only**. Invoke it with `/model kimi` for an explicit user-selected run or when an eval benefits from another model family. It was removed from every fallback chain on 2026-09-09; resilience is Grok 4.7 high → Muse Spark 1.3 high after both primaries fail (Grok 4.7 replaced 4.5 on 2026-09-23), and Muse also took over the optional fourth council lane. Never include Kimi in a fallback list without a separate promotion eval.

## Runtime facts

- Pinned OpenRouter model: `moonshotai/kimi-k3`.
- Verified native context window: 1,048,576 tokens.
- Inputs: text and image; output: text.
- OpenRouter list price at verification: $3 per 1M input tokens, $15 per 1M output tokens, and $0.30 per 1M cached-input tokens.
- OpenRouter advertised tools, structured outputs, and reasoning-effort support on 2026-07-21.

## Prompt shape

Use a compact outcome contract: name the deliverable, relevant source material, permitted tools, acceptance checks, and exact output format. Keep constraints concrete. For long agentic work, require durable progress checkpoints and an explicit verification loop.

## Verification

For an explicit comparison run, record the exact provider/model identity, effort, and latency. A routing change that only removes Kimi from chains does not require a Kimi execution; adding it back anywhere does.
