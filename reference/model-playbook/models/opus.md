# Claude Opus (4.6 + 4.7) — Prompting

Source: Anthropic prompting best practices (claude-prompting-best-practices), tool-use overview. Covers both Opus 4.6 and 4.7, with a deltas section for 4.7.

Use this when: spawning Opus subagents (rare — usually save Opus for main), main-session prompts, code review, voice-critical content.

---

## Strengths

- Long-horizon agentic work
- Knowledge work, vision, memory tasks
- Code review (Opus 4.7: +11pp recall on bug-finding evals vs. 4.6)
- Tone control + literal instruction following (4.7)
- Strong tool decision-making

## Prompt Style

**Format:** XML tags or Markdown — both work. Pick one and be consistent within a prompt. Anthropic's own examples mix freely; the important thing is hierarchy and unambiguous boundaries.

**Best XML tags to use:**

```xml
<instructions>...</instructions>
<context>...</context>
<example>...</example>  (or <examples> wrapping multiple)
<input>...</input>
<thinking>...</thinking>  (when extended thinking is on)
```

**Prompt order:**

1. Identity / role
2. Instructions (rules, what to do, what NOT to do)
3. Examples (3-5, diverse, structured)
4. Context (data, RAG, session-specific — varies per request)
5. The actual task / question

Keep stable content at the top (instructions, identity) for prompt caching savings. Variable context goes at the end.

## Effort Levels (4.7 — strict)

| Effort | When |
|---|---|
| `max` | Hardest tasks; risk of overthinking. Test before defaulting here. |
| `xhigh` | **Default for coding and agentic use cases.** |
| `high` | **Default for intelligence-sensitive non-coding work.** |
| `medium` | Cost-sensitive; risks under-thinking on complex tasks |
| `low` | Short scoped tasks, latency-sensitive only |

**Critical:** Opus 4.7 respects effort strictly. If you need deeper thinking at low/medium, raise effort, don't prompt around it.

**Max output tokens:** Start at **64k** for xhigh/max effort tasks. The model needs room to think across subagents and tool calls.

## System Prompt Template

```xml
<role>
You are [role]. [One-sentence description of what you do and how.]
</role>

<instructions>
1. [Step or rule]
2. [Step or rule]
3. [...]

When you finish:
- [What "done" looks like — checklist]
- [How to hand back / where to write output]
</instructions>

<constraints>
- Apply [pattern] to every [scope item], not just the first one.
- Do not [thing].
- If [condition], stop and ask.
</constraints>

<context>
[Files, decisions, current state. Stable content above this line, variable content here.]
</context>

<task>
[The actual ask. Specific. Testable.]
</task>
```

## Tool-Use Patterns

- Opus 4.7 **uses tools less by default** than 4.6. If you want more tool use, either raise effort to `xhigh` OR explicitly say which tools and when.
- Opus models ask clarifying questions when required tool params are missing — Sonnet may guess. This is good for Opus.
- For long agentic traces, Opus 4.7 self-paces user-facing updates well — don't add scaffolding like "summarize every 3 tool calls" unless you've measured a problem.

## Code Review Specifics (Opus 4.7)

If your prompt says "be conservative" or "only high-severity," 4.7 will follow literally and report less. **Use this framing instead:**

```text
Report every issue you find, including ones you are uncertain about or consider low-severity.
Do not filter for importance or confidence at this stage — a separate verification step will do that.
For each finding, include your confidence level (low/medium/high) and severity (low/medium/high)
so a downstream filter can rank them.
```

## Subagent Spawning (when Opus is the orchestrator)

Opus 4.7 spawns fewer subagents by default than 4.6. To steer:

```text
Spawn multiple subagents in the same turn when fanning out across items or reading multiple files.
Do not spawn a subagent for work you can complete directly in a single response.
```

## Design / Frontend Defaults (4.7)

**Hardcoded house style:** cream/off-white (#F4F1EA), serif (Georgia/Fraunces/Playfair), italic accents, terracotta/amber accent. Persistent across attempts.

**To override:** specify a concrete alternative palette + typeface explicitly. Generic instructions ("don't use cream") tend to swap to a different fixed palette, not produce variety.

For dashboards/dev tools/fintech/healthcare: always state the palette + typography explicitly.

## Anti-Patterns (don't do this with Opus)

- ❌ Using "be conservative" / "don't nitpick" in code review (4.7 follows it)
- ❌ Assuming an instruction will generalize (4.7 is literal — say "every section" not "this section")
- ❌ Forcing interim status updates ("after 3 tool calls, summarize") — 4.7 self-paces
- ❌ Setting low effort for a complex task and then prompting harder — raise effort instead
- ❌ Vague design briefs (4.7 falls back to cream/serif/terracotta)
- ❌ Long warm intros / preamble — 4.7 is more direct, will mirror that

## 4.6 vs 4.7 Quick Deltas

| Aspect | 4.6 | 4.7 |
|---|---|---|
| Instruction interpretation | Interpretive, generalizes | **Literal** — state scope |
| Subagent spawning | Spawns readily | Reduced — must ask |
| Tool use frequency | Higher | Lower — raise effort or ask |
| Verbosity | Warmer, more validation-forward | Direct, opinionated, fewer emoji |
| Effort levels | Loose | Strict — `low` really means low |
| Cost | Lower | **~3x higher per token** — be deliberate |

## Active in This Workspace

- Main session model (default): Opus 4.7
- Main session fallback: Opus 4.6
- Code review: Opus 4.7 with the "report every finding" framing
- Claude Code coding agent: Opus 4.6 (set in `~/.claude/settings.json`)
- Subagent spawn: Opus is **rare** — prefer Sonnet 4.6 to control cost
