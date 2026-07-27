# GLM 5.2

**Runtime id:** `openrouter/z-ai/glm-5.2` · **alias:** `glm`

## Routing

GLM 5.2 is **experimental only**. Invoke it explicitly for model comparisons, harness tests, or bounded evaluations. It must not appear in the main, autonomous, reviewer, or production fallback chains until a dedicated eval promotes it.

## Prompt shape

Use a compact OpenAI-compatible instruction contract: outcome, scope, required tools, acceptance checks, and output format. OpenClaw exposes GLM 5.2 reasoning controls through the provider profile; use high for normal experiments and max only when the eval explicitly tests maximum reasoning.

## Verification

Record the exact model id, provider, effort, latency, and task result. Compare against the current production lane on the same fixture before recommending any promotion.

