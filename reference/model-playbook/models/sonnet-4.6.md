# Claude Sonnet 4.6 — Prompting

Source: Anthropic prompting best practices (shared family with Opus), tool-use overview.

Released: February 17, 2026. Context window: 1M tokens. Max output: 128K. Pricing: $3 input / $15 output per M tokens.

Use this when: content drafting in the operator's voice, tasks where Anthropic ecosystem matters, fallback when GLM 5.1 doesn't fit (vision needed, Anthropic-specific tool calling), multi-step tool loops where Sonnet's reliability matters.

---

## Strengths

- Reliable multi-step execution and agentic workflows
- Strong tool use (decision-making + execution)
- Good context handling across long sequences
- Cheaper than Opus, faster than Opus
- Pairs well with Opus orchestrator (Opus plans, Sonnet executes)

## Where Sonnet Differs from Opus

- **May guess at missing tool params** (Opus asks). Mitigate by prompting explicitly.
- Less tone control than Opus 4.7 — be more explicit about voice if it matters
- Slightly more interpretive / less literal than Opus 4.7

## Prompt Style

Same Anthropic XML/Markdown — pick one per prompt. Same prompt order:

1. Identity / role
2. Instructions  
3. Examples (3-5 if format matters)
4. Context
5. Task

## Effort Levels

Sonnet 4.6 supports the same effort range as Opus 4.7. Defaults:
- `high` for most subagent execution
- `xhigh` for coding work
- `medium` for routine extraction / format conversion

## System Prompt Template

```xml
<role>
You are [role]. [One sentence.]
</role>

<instructions>
1. [Step]
2. [Step]
3. [Step]

For tool use:
- If a required parameter is missing or ambiguous, ASK before calling the tool. Do not guess values.
- After each tool call, briefly state the result and your next planned action.
- If a tool fails or returns empty, try one alternate strategy before reporting failure.
</instructions>

<constraints>
- [Hard limits]
- [What not to touch]
- [Output format]
</constraints>

<context>
[Files, state, decisions]
</context>

<task>
[Specific, testable ask]

Done criteria:
- [Checklist item 1]
- [Checklist item 2]
- [Checklist item N]
</task>
```

## Tool Use Specifics

Critical: include this in the prompt for any tool-use sub-agent task:

```text
If a required parameter for a tool call is missing, ambiguous, or uncertain, 
ASK a clarifying question instead of guessing. Tool calls with wrong values 
are worse than no tool call.
```

This single line prevents the most common Sonnet failure mode (silently inferring tool params).

## When Sonnet Beats Opus

- Default subagent — cost matters at fan-out scale
- Tool execution where reasoning is bounded
- Long sequential workflows (Sonnet holds context well)
- Any case where Opus would overthink a clear task

## When to Escalate to Opus

- Sonnet failed twice on the same task with corrections
- Task requires evaluating 4+ tradeoffs simultaneously
- Voice/tone fidelity is critical
- Code review for non-obvious bugs (Opus 4.7 +11pp recall)

## Anti-Patterns

- ❌ No "ask before guessing" for tool params → silent wrong values
- ❌ Vague done criteria → Sonnet may declare done early
- ❌ Mixing XML and Markdown chaotically → less of a problem than Gemini but still hurts
- ❌ Using Sonnet for highly voice-critical content → use Opus

## Active in This Workspace

- **Default subagent is GLM 5.1**, not Sonnet, per `openclaw.json`. Sonnet is the fallback and the pick for:
  - Content drafts (personal voice is usually better on Anthropic models)
  - Tasks where Anthropic ecosystem integration matters
  - Any case where GLM 5.1 needs backup
- Coding-agent fallback (after Codex/Claude Code): Sonnet via API
