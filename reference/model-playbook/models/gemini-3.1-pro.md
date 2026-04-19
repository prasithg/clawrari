# Gemini 3.1 Pro — Prompting

Sources: docs.cloud.google.com/vertex-ai/generative-ai/docs/start/gemini-3-prompting-guide, philschmid.de/gemini-3-prompt-practices, Google Gen AI SDK notebook (intro_gemini_3_1_pro.ipynb).

Use this when: deep research, websearch, YouTube/video, multimodal, anything needing >200k context, anything where grounding matters.

---

## Strengths

- 1M-token context window
- Native video, audio, image (multimodal as equal-class inputs)
- Improved factuality and reduced repetition vs. 2.5 Pro
- Strong agentic + coding capabilities (improved)
- Three thinking levels with explicit token budgets

## Hard Rules (these aren't suggestions)

1. **Temperature MUST be 1.0.** Lower values cause looping or degraded performance, especially on complex math/reasoning. This is the OpenAI/Anthropic default-low-temp habit fighting Gemini's training.
2. **Pick ONE format: XML or Markdown. Don't mix in the same prompt.** Mixing causes Gemini to drop instructions.
3. **Place core request + negative constraints LAST.** Gemini drops constraints that appear too early in long prompts.
4. **For grounding-critical work, explicitly say "use only the provided context."** Otherwise model may revert to training data.

## Thinking Levels

```python
thinking_config=types.ThinkingConfig(
    thinking_level=types.ThinkingLevel.HIGH  # or MEDIUM, LOW
)
```

| Level | Token Budget | When |
|---|---|---|
| `LOW` | 1 - 1,000 | Simple instruction following, chat, lookups |
| `MEDIUM` | 1,001 - 16,384 | Balanced — good default for moderate reasoning |
| `HIGH` (default) | 16,384 - 32,768 | Complex reasoning, hardest tasks. Slow first token but thorough. |

**Notes:**
- Cannot turn off thinking entirely (errors at budget=0)
- For lower latency: set `LOW` + add system instruction "think silently"
- OpenAI's `reasoning_effort: medium` ≈ Gemini's `thinking_level: high`

## Prompt Order (CRITICAL — different from other models)

```
1. Role / persona definition (top — anchors reasoning)
2. Instructions / methodology
3. Constraints (general)
4. Context / data / sources
5. ⚠️ Specific request + negative constraints + format requirements (BOTTOM)
```

**Why:** Gemini drops late-prompt constraints if they appear early. Inverted from GPT-5.4's "context at end" pattern.

For long context (books, codebases, long videos): always end with **"Based on the entire document above, [specific question]"** to anchor synthesis.

## System Prompt Template (XML version — pick this OR Markdown, not both)

```xml
<role>
You are Gemini 3.1 Pro, a [domain] specialist. You are precise, analytical, and persistent.
</role>

<instructions>
1. Plan: Parse the goal into distinct sub-tasks.
2. Execute: Carry out the plan. If using tools, reflect before each call. Track progress as TODO list ([ ] pending, [x] complete).
3. Validate: Review output against the user's task.
4. Format: Present in the requested structure.
</instructions>

<constraints>
- Verbosity: [Low | Medium | High]
- Tone: [Formal | Casual | Technical]
- Handling Ambiguity: Ask clarifying questions ONLY if critical info is missing; otherwise make reasonable assumptions and state them.
</constraints>

<grounding_rules>
You are strictly grounded to the information in <context>.
- Rely ONLY on facts directly mentioned in <context>.
- Do NOT use your own knowledge or common sense.
- Do NOT assume or infer beyond what's stated.
- If the answer is not explicitly in <context>, state "the information is not available."
</grounding_rules>

<output_format>
1. Executive Summary: [2-sentence overview]
2. Detailed Response: [main content]
3. [Other required sections]
</output_format>

<context>
[Source data, documents, search results, etc.]
</context>

<task>
Based on the entire <context> above, [specific question or instruction].

Constraints for this answer:
- [Negative constraint, e.g., "do not speculate beyond the data"]
- [Format constraint, e.g., "output as a markdown table"]
- [Length constraint, e.g., "max 500 words"]
</task>
```

## Tool Use / Function Calling

- **Pre-call reflection** — explicitly prompt: "Before calling any tool, state: (1) why you're calling it, (2) what data you expect, (3) how it helps."
- **Persistence** — for autonomous tool loops:

```text
You are an autonomous agent.
- Continue working until the user's query is COMPLETELY resolved.
- If a tool fails, analyze the error and try a different approach.
- Do NOT yield control back until you have verified the solution.
```

- **Thought signatures** — Gemini 3 introduces encrypted reasoning state preserved across tool calls. Pass them through your function-calling loop or you lose multi-turn reasoning continuity.

## Research / Synthesis Pattern

Gemini's killer use case in this workspace. Pattern:

1. **Decompose** the topic into 3-5 specific research questions
2. **Search** each independently (parallel where possible)
3. **Synthesize** with the framing: "Based on the entire document above, synthesize all relevant information from the text that pertains to [question]"
4. **Cite** every claim — "Every claim must be immediately followed by [Source ID]; if no source, say 'general estimate'"

## Multimodal

Treat text/image/audio/video as equal-class. **Reference modalities explicitly** in instructions:

> "Synthesize across the video timestamps and the document text below..."

For long video, use `media_resolution: low` to fit context. For OCR/fine detail, use `MEDIA_RESOLUTION_HIGH` per part.

## Split-Step Verification (for obscure topics or capability checks)

```text
Verify with high confidence if you have access to [resource/topic].
If you cannot verify, state 'No Info' and STOP.
If verified, proceed to generate a response.

Query: [actual question]
```

Prevents hallucinated plausible-but-false content.

## Anti-Patterns

- ❌ Mixing XML and Markdown in same prompt → constraints dropped
- ❌ Lowering temperature below 1.0 → looping, degraded reasoning
- ❌ Putting negative constraints at the top of a long prompt → ignored
- ❌ Open-ended "do not infer" / "do not guess" → over-indexes, fails basic logic
- ❌ Vague "research this topic" without grounding rules → model uses training data
- ❌ Long context without "Based on the entire document above" anchor → partial processing
- ❌ Persona that conflicts with task ("be brief" + "explain in detail") → persona wins, task drops
- ❌ Using web/youtube tools without asking for citations → unsupported claims

## Active in This Workspace

- Deep research subagent (planned): Gemini 3.1 Pro
- Multimodal / video / YouTube subagent (planned): Gemini 3.1 Pro
- Default model alias: `gemini` → `google/gemini-3.1-pro-preview`
- Note: workspace `agents_list` currently restricts subagent spawning. To use Gemini for research, route via Codex CLI tool calls or main-session web fetches with Gemini-style prompts.
