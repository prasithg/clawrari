# Claude Haiku 4.5 — Prompting

Source: Anthropic prompting best practices (shared family with Opus/Sonnet), anthropic.com/news/claude-haiku-4-5.

Released: October 15, 2025. Active as of April 2026. Model id: `claude-haiku-4-5`.

Use this when: extreme-volume subagent work, latency-critical tool loops, very cheap execution where Sonnet is overkill but you still want Anthropic-family prompting.

---

## Positioning

| | Haiku 4.5 | Sonnet 4.6 | Opus 4.7 |
|---|---|---|---|
| Input / Output $ (per M) | **$1 / $5** | $3 / $15 | $5 / $25 |
| Context | 200K | 1M (or 200K) | 1M |
| Max output | 64K | 128K (or 64K) | 128K |
| Role | Speed + cheap | Reliable workhorse | Frontier reasoning |
| Vision | Yes | Yes | Yes (3× resolution) |

**When Haiku beats the default (GLM 5.1):**
- You need Anthropic ecosystem (Claude Code harness, vision, specific tool calling)
- You need the Anthropic prompt style you've already built
- Vision input (GLM 5.1 is text-only)
- Very high-volume batch work where token price differential matters

**When GLM 5.1 beats Haiku:**
- Long-horizon autonomous work (Haiku's strength is short tasks; GLM's is 8-hour loops)
- SOTA coding benchmarks (GLM 5.1 > Haiku 4.5 on SWE-Bench)
- Pure text with cost as main driver

## Prompt Style

Identical to Sonnet/Opus — Anthropic XML or Markdown, consistent per prompt.

**Key difference from larger Claudes:** Haiku may be more literal and less interpretive. Be explicit about expected output. Don't rely on "figure it out" framings that work on Sonnet/Opus.

## System Prompt Template

Same structure as Sonnet. Extra emphasis on:

```xml
<instructions>
For tool use:
- If a required parameter is missing or ambiguous, ASK. Don't guess.
- After each tool call, state briefly: result + next planned action.
- If a tool fails, try one alternate strategy before reporting failure.

Be specific and literal. Don't infer requests that weren't made.
</instructions>

<output>
[Exact format. Haiku performs better with tight specs than with "use your best judgment."]
</output>
```

## When to Use Haiku 4.5 Over Sonnet 4.6

- Task is well-scoped and doesn't need reasoning depth
- Cost matters at volume (3× cheaper than Sonnet)
- Latency matters
- Tool loops where each turn is bounded

## When to Escalate from Haiku

- Task loops or fails twice → go to Sonnet or GLM 5.1
- Multi-step reasoning across more than ~4 steps
- Voice-critical content
- Anything requiring novel synthesis vs. applying a clear pattern

## Anti-Patterns

- ❌ Using Haiku for personal voice-critical content — too short and compressed to capture tone well
- ❌ Vague task framings — Haiku underperforms on open-ended prompts
- ❌ Expecting Opus-style thoroughness — Haiku is optimized for speed, not depth

## Active in This Workspace

- Not currently in `openclaw.json` model list
- Candidate for: high-volume batch work, latency-sensitive tool loops
- Would fit the `cheap_tool_driving` intent alongside GLM 5.1 if added
