# GLM 5.1 — Prompting

Source: docs.z.ai/guides/llm/glm-5.1, docs.z.ai/guides/overview/migrate-to-glm-new, z.ai/blog/glm-5.1.

Released late 2026 as z.ai's flagship. This replaces GLM-4.6 as our primary z.ai model. Model id: `glm-5.1`.

Use this when: long-horizon autonomous coding, engineering optimization loops, real-world development workflows, agent harness execution (Claude Code / Cline / Roo / OpenClaw-native coding agents), research synthesis with tool use. Not just "cheap tool-driving" — **this is a frontier-competitive model.**

---

## ⚠️ Calibration — revise the mental model

My earlier draft called this the "cheap tool-driving subagent." That undersold it. Actual positioning from z.ai + third-party benchmarks:

- **SWE-Bench Pro: 58.4** — outperforms GPT-5.4, Claude Opus 4.6, Gemini 3.1 Pro (state-of-the-art on that benchmark)
- **Overall capability aligned with Claude Opus 4.6** per z.ai's own framing (take with salt, but directional)
- **8-hour sustained autonomous execution** — built for long-horizon work, not short tool loops
- **Explicitly optimized for OpenClaw** (called out by name in z.ai docs)
- 655-iteration optimization loops, autonomous benchmark-driven performance tuning
- Built a complete Linux desktop from scratch in 8 hours in demo

It's still cheaper than Opus/GPT, so cost still favors it for subagent work. But **treat it as a peer of Opus 4.6 / GPT-5.4 on many tasks**, not a downgrade.

What it ISN'T:
- **Text-only** (no vision) — send to Gemini / Opus for vision
- **Not the best for personal voice-critical content** — Anthropic models still win there
- **Not frontier-frontier** — Opus 4.7 still ahead on hardest knowledge work

## Strengths

- Long-horizon autonomous tasks (up to 8 hours single-task continuous execution)
- Agentic coding at SOTA on SWE-Bench Pro
- Iterative optimization loops ("experiment → analyze → optimize")
- Function calling + streaming tool calls + MCP tool integration
- Thinking mode with multiple modes (see capabilities doc)
- Structured output (JSON-mode equivalent)
- 200K context, 128K max output
- Context caching for long conversations
- Office productivity (PPT, Word, Excel, long-form reports)
- Front-end / artifacts — less templated than prior GLMs

## Hard Rules

1. **Temperature = 1.0** (z.ai's published default). `top_p = 0.95`. Don't tune both.
2. **Enable thinking for reasoning + coding + agent loops.** `thinking: { type: "enabled" }`. Disable only for pure mechanical transformation.
3. **OpenAI-compatible API** — use OpenAI Python SDK pointed at `https://api.z.ai/api/paas/v4/` OR z.ai's native `zai-sdk`.
4. **Coding agent routing:** use base URL `https://api.z.ai/api/coding/paas/v4` when wiring into Cline / Claude Code / agentic IDEs, not the regular paas/v4 endpoint.

## Prompt Style

OpenAI-compatible message structure. Markdown headers work best; XML works too. The model leans toward markdown in its own outputs. Default to markdown unless the consumer is parsing XML.

**Critical parameters:**

```python
thinking={"type": "enabled"}   # default for anything beyond formatting
temperature=1.0
top_p=0.95
```

| Thinking mode | When |
|---|---|
| `enabled` (default) | **Reasoning, coding, agent loops, tool selection, long-horizon work** — your default |
| `disabled` | Trivial: format conversion, fact lookup, translation, mechanical text manipulation |

## System Prompt Template

```text
# Role
You are [role]. Your job is [single sentence].

# Operating principles
- Long-horizon discipline: you work in full experiment → analyze → optimize loops.
  Don't declare done after one pass; iterate until acceptance criteria are met.
- Tool use: reflect before each tool call — state why, what you expect, how it helps.
- When iterating on engineering tasks, run benchmarks / tests, identify bottlenecks,
  adjust strategy, continue.

# Task
[The specific ask. Describe inputs, outputs, and the success metric.]

# Constraints
- [Output format]
- [Hard limits]
- [What not to touch]

# Available tools
[List tools with 1-line descriptions of when to use each]
- For each tool call, briefly state: why + expected result.
- If a tool fails or returns empty, try one alternate strategy before giving up.

# Done criteria
- [Specific, testable conditions]
- [Handoff note requirements]
- [How to confirm the work is complete]
```

For long-horizon / 8-hour-style work, add a persistence block:

```text
# Persistence
- Continue working until all Done criteria pass.
- If you hit a wall, analyze the specific error, propose 2-3 alternate strategies, pick the most promising, continue.
- Do NOT yield control back until the task is verified complete or you have exhausted viable strategies.
- Track your progress: what's done, what's remaining, what's blocked.
```

## Tool Use Pattern (streaming)

For agent loops, use streaming + tool_stream so you can react to thinking deltas:

```python
response = client.chat.completions.create(
    model="glm-5.1",
    messages=[...],
    tools=[...],
    stream=True,
    tool_stream=True,
    thinking={"type": "enabled"},
    temperature=1.0,
    top_p=0.95,
)

for chunk in response:
    delta = chunk.choices[0].delta
    if delta.reasoning_content:   # 🧠 thinking — capture for debugging long-horizon work
        ...
    if delta.content:              # 💬 answer
        ...
    if delta.tool_calls:           # 🔧 tool call (stream-concat arguments across chunks)
        ...
```

`reasoning_content` is especially valuable for long-horizon work — save it to disk for post-hoc debugging when an 8-hour run goes sideways.

## Agent Harness Integration

When using GLM 5.1 inside Claude Code / Cline / Roo / Kilo / similar:

```jsonc
{
  "baseUrl": "https://api.z.ai/api/coding/paas/v4",
  "model": "glm-5.1",
  "contextWindow": 200000,
  "temperature": 1.0,
  "topP": 0.95
}
```

Note the `/api/coding/paas/v4` base URL (different from regular API). z.ai routes coding traffic differently for optimizations.

## When to Use GLM 5.1 Instead of Opus / Sonnet / GPT

| Task | Pick | Why |
|---|---|---|
| Long-horizon autonomous coding (hours, not minutes) | **GLM 5.1** | Built for it; SOTA on SWE-Bench Pro |
| Iterative performance optimization (benchmark → tune → benchmark loop) | **GLM 5.1** | Autonomous experiment loops |
| Subagent for most execution work | GLM 5.1 or Sonnet 4.6 | Cost/quality trade — GLM 5.1 cheaper, Sonnet's ecosystem support is deeper |
| Vision / image / video | Gemini 3.1 Pro or Opus | GLM is text-only |
| Personal voice content | Opus 4.7 | GLM doesn't nail voice |
| Frontier reasoning / hardest decisions | Opus 4.7 / GPT-5.4 | Still slightly ahead |
| Code review / bug hunt | Opus 4.7 | +11pp recall on bug-finding |
| Parallel tool calling with evidence synthesis | GPT-5.4 | Trained control-block library |
| Deep research with websearch | Gemini 3.1 Pro | Native grounding + 1M ctx |
| Writing code that runs for 8 hours unsupervised | **GLM 5.1** | This is its core pitch |

## Anti-Patterns

- ❌ Disabling thinking on a reasoning/coding task → wrong answer, quickly
- ❌ Asking for vision / image analysis → not supported
- ❌ Lowering temperature below 1.0 → degrades like Gemini
- ❌ Skipping tool_stream for agent loops → can't debug when thinking goes off-track
- ❌ Treating it as "just a cheap Sonnet" → undersells capability; you'll under-task it
- ❌ Using regular paas/v4 base URL for coding harnesses → use `/api/coding/paas/v4` instead
- ❌ Giving it short-horizon prompts when you need long-horizon work → it thrives on big problems, starves on tiny ones

## Active in This Workspace

- OpenRouter / z-ai alias: `glm` → `z-ai/glm-5.1` (also at `openrouter/z-ai/glm-5.1`)
- Default subagent (per openclaw.json): GLM 5.1
- Coding agent alternate: GLM 5.1 via coding endpoint — consider adding a local GLM wrapper if you start using it as a primary coding driver
- Cost tier: **medium-low** — real value for real capability
- Configured in: `~/.openclaw/openclaw.json` (model id `glm-5.1`, alias `glm`)

## Migration Note

If any workspace file still references GLM 4.6 / GLM 4.5 positioning (e.g., "cheap tool-driving subagent" framing), update it. GLM 5.1 is a different class of model and deserves to be positioned accordingly. The old framing likely came from GLM 4.6 public docs, which predate GLM 5.1's release.
