# GLM 5.3

**Runtime id:** `openrouter/z-ai/glm-5.3` · **alias:** `glm`

## Routing

GLM 5.3 is a **comparison and utility candidate**, never a live default or fallback. Invoke it for an explicitly requested comparison, a harness test, or a bounded utility evaluation (classification and extraction). Flash remains the utility default until GLM 5.3 passes its own utility eval. It must not appear in the main, autonomous, reviewer, or production fallback chains; the live chains stay three deep and end at Muse Spark 1.3.

The optional product/integration council lane may seat GLM 5.3 when a council is an explicit comparison. Route through OpenRouter unless a native provider key is configured and smoke-tested.

## Prompt shape

Use a compact OpenAI-compatible instruction contract: outcome, scope, required tools, acceptance checks, and output format. Reasoning controls are exposed through the provider profile; use high for normal experiments and max only when the eval explicitly tests maximum reasoning.

## Verification

Record the exact model id, provider, effort, latency, and task result. Compare against the current production lane on the same fixture before recommending any promotion.
