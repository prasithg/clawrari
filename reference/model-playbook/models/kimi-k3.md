# Kimi K3

**Runtime id:** `openrouter/moonshotai/kimi-k3` · **alias:** `kimi`

## Routing

Kimi K3 is an **explicit user-selected and comparison route** through OpenRouter. Invoke it with `/model kimi` when you want Kimi specifically or when an eval benefits from another model family. It must not enter the default, reviewer, coding, autonomous, or outage fallback chains without a separate promotion eval.

## Runtime facts

- Pinned OpenRouter model: `moonshotai/kimi-k3`.
- Verified native context window: 1,048,576 tokens.
- Inputs: text and image; output: text.
- OpenRouter list price at verification: $3 per 1M input tokens, $15 per 1M output tokens, and $0.30 per 1M cached-input tokens.
- OpenRouter advertised tools, structured outputs, and reasoning-effort support on 2026-07-21.

## Prompt shape

Use a compact outcome contract: name the deliverable, relevant source material, permitted tools, acceptance checks, and exact output format. Keep constraints concrete. For long agentic work, require durable progress checkpoints and an explicit verification loop.

## Verification

Record the exact provider/model identity, effort, latency, and whether fallback occurred. A picker/config change is not complete until a real Kimi inference succeeds and the authenticated Control UI renders `Kimi K3` under OpenRouter.
