> RETIRED MODEL GUIDE (2026-09-09): historical version; current candidate guide: `glm-5.3.md`.

# GLM 5.2

**Runtime id:** `openrouter/z-ai/glm-5.2` · **alias:** `glm`

## Routing

GLM 5.2 is **retired**; it was experimental only while active. Invoke it, if at all, only for a deliberate historical comparison. It must not appear in the main, autonomous, reviewer, or production fallback chains; GLM 5.3 is the current candidate.

## Prompt shape

Use a compact OpenAI-compatible instruction contract: outcome, scope, required tools, acceptance checks, and output format. OpenClaw exposes GLM 5.2 reasoning controls through the provider profile; use high for normal experiments and max only when the eval explicitly tests maximum reasoning.

## Verification

Record the exact model id, provider, effort, latency, and task result. Compare against the current production lane on the same fixture before recommending any promotion.

