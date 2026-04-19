# GPT-5.4 — Prompting

Source: developers.openai.com/api/docs/guides/prompt-guidance (GPT-5.4 prompt guidance), GPT-5 cookbook patterns.

Use this when: alternate main session, Codex CLI heavy coding, parallel tool-use research, evidence-rich synthesis, anything needing strict completion contracts.

---

## Strengths

- Strong personality and tone adherence over long answers
- Agentic workflow robustness — sticks with multi-step work, retries, completes loops
- Evidence-rich synthesis in long-context or multi-tool workflows
- Instruction adherence in **modular, block-structured prompts when the contract is explicit**
- Long-context analysis across messy, multi-document inputs
- Batched / parallel tool calling with high accuracy
- Spreadsheet, finance, Excel workflows

## Where Explicit Prompting Still Matters

- Low-context tool routing **early in a session** (before tools have been used)
- Dependency-aware workflows (prerequisite + downstream-step checks)
- Reasoning effort selection (higher isn't always better)
- Research tasks needing disciplined source collection + consistent citations
- Irreversible / high-impact actions (verify before execute)

## Prompt Style — XML Blocks Are First-Class

**GPT-5.4 was trained on a specific set of XML control blocks.** Use them by name. They reduce ambiguity and dramatically improve completion behavior.

### Canonical block library

```xml
<output_contract>
- Return exactly the sections requested, in the requested order.
- If a format is required (JSON, Markdown, SQL, XML), output only that format.
- Apply length limits only to the section they target.
</output_contract>

<verbosity_controls>
- Prefer concise, information-dense writing.
- Avoid repeating the user's request.
- Keep progress updates brief.
- Do not shorten so aggressively that required evidence/reasoning is omitted.
</verbosity_controls>

<default_follow_through_policy>
- If the user's intent is clear and the next step is reversible and low-risk, proceed without asking.
- Ask permission only if the next step is:
  (a) irreversible,
  (b) has external side effects (sending, purchasing, deleting, writing to production), or
  (c) requires missing sensitive information or a choice that materially changes the outcome.
- If proceeding, briefly state what you did and what remains optional.
</default_follow_through_policy>

<instruction_priority>
- User instructions override default style, tone, formatting, and initiative preferences.
- Safety, honesty, privacy, and permission constraints do not yield.
- If a newer user instruction conflicts with an earlier one, follow the newer one.
- Preserve earlier instructions that do not conflict.
</instruction_priority>

<tool_persistence_rules>
- Use tools whenever they materially improve correctness, completeness, or grounding.
- Do not stop early when another tool call is likely to improve correctness.
- Keep calling tools until: (1) the task is complete, AND (2) verification passes.
- If a tool returns empty/partial results, retry with a different strategy.
</tool_persistence_rules>

<dependency_checks>
- Before taking an action, check whether prerequisite discovery, lookup, or memory retrieval steps are required.
- Do not skip prerequisite steps just because the intended final action seems obvious.
- If the task depends on the output of a prior step, resolve that dependency first.
</dependency_checks>

<parallel_tool_calling>
- When multiple retrieval/lookup steps are independent, prefer parallel tool calls.
- Do not parallelize steps with prerequisite dependencies.
- After parallel retrieval, pause to synthesize before making more calls.
- Prefer selective parallelism: parallelize independent evidence gathering, not speculative or redundant tool use.
</parallel_tool_calling>

<completeness_contract>
- Treat the task as incomplete until all requested items are covered or explicitly marked [blocked].
- Keep an internal checklist of required deliverables.
- For lists/batches/paginated results: determine expected scope, track processed items, confirm coverage before finalizing.
- If any item is blocked by missing data, mark it [blocked] and state exactly what is missing.
</completeness_contract>

<empty_result_recovery>
If a lookup returns empty, partial, or suspiciously narrow results:
- Do not immediately conclude no results exist.
- Try at least 1-2 fallback strategies (alternate wording, broader filters, prerequisite lookup, alternate source).
- Only then report no results found, along with what you tried.
</empty_result_recovery>

<verification_loop>
Before finalizing:
- Correctness: does the output satisfy every requirement?
- Grounding: are factual claims backed by provided context or tool outputs?
- Formatting: does the output match the requested schema/style?
- Safety/irreversibility: if next step has external side effects, ask permission.
</verification_loop>

<missing_context_gating>
- If required context is missing, do NOT guess.
- Prefer the appropriate lookup tool when context is retrievable; ask a minimal clarifying question only when not.
- If you must proceed, label assumptions explicitly and choose a reversible action.
</missing_context_gating>

<action_safety>
- Pre-flight: summarize the intended action and parameters in 1-2 lines.
- Execute via tool.
- Post-flight: confirm the outcome and any validation performed.
</action_safety>

<citation_rules>
- Only cite sources retrieved in the current workflow.
- Never fabricate citations, URLs, IDs, or quote spans.
- Use exactly the citation format required by the host application.
- Attach citations to the specific claims they support, not only at the end.
</citation_rules>

<task_update>
[Use this for mid-conversation instruction updates.]
For the next response only:
- [What changes]
All earlier instructions still apply unless they conflict with this update.
</task_update>
```

### How to assemble

You don't need every block. Pick the ones that match the failure mode you want to prevent. **Minimum viable for most agentic tasks:**

1. `<output_contract>` — what to return
2. `<tool_persistence_rules>` + `<completeness_contract>` — finish the work
3. `<verification_loop>` — check before commit
4. Plus the `<context>` and `<task>` blocks (not GPT-specific)

## Reasoning Effort

GPT-5.4 takes a `reasoning_effort` parameter. Pick by task shape, not intuition:

| Effort | When |
|---|---|
| `high` | Multi-step coding, complex synthesis, agent loops, evidence-heavy work |
| `medium` | Most knowledge work, format conversion, single-pass synthesis |
| `low` | Short lookups, simple format work, latency-sensitive |

Match in API: OpenAI Chat Completions `reasoning_effort: medium` corresponds roughly to Gemini's `thinking_level: high`.

## Image / Vision

Set `image_detail` explicitly when precision matters:
- `original` — large, dense, spatially-sensitive (computer use, OCR, click accuracy)
- `high` — standard high-fidelity image understanding
- `low` — speed/cost matters more than detail

Don't rely on `auto` for vision-critical work.

## System Prompt Template

```xml
<role>
You are [role]. [One sentence on identity and goal.]
</role>

<output_contract>
[from library above]
</output_contract>

<tool_persistence_rules>
[from library above]
</tool_persistence_rules>

<completeness_contract>
[from library above]
</completeness_contract>

<verification_loop>
[from library above]
</verification_loop>

<context>
[Files, state, recent decisions. Stable above, variable below.]
</context>

<task>
[The specific ask. Define what "done" looks like with measurable criteria.]
</task>
```

## Anti-Patterns

- ❌ Vague output ask ("write a report") without `<output_contract>` — model will pad
- ❌ Implicit completion ("when you're done") — use `<completeness_contract>` with a checklist
- ❌ Skipping `<dependency_checks>` on multi-step tool work — model may skip prerequisites
- ❌ Using "be conservative" instead of explicit confidence + severity instructions
- ❌ Loading tools without naming when to use them — early-session tool routing is weak
- ❌ Mid-conversation pivot without `<task_update>` block — model may merge old + new
- ❌ Using `reasoning_effort: high` for trivial tasks — wastes tokens and adds latency

## Variants

GPT-5.4 ships as a family of variants (as of March 2026). Default is `gpt-5.4`. Others:

| Variant | $ Input / Output (per M) | When |
|---|---|---|
| **`gpt-5.4`** (standard) | $2.50 / $15 | Default. Professional work, coding, agentic. |
| **`gpt-5.4-pro`** | $30 / $180 | Premium. Multi-turn interactions, deepest reasoning, enterprise-heavy. Takes minutes for complex requests. |
| **`gpt-5.4` with `/fast`** | same as std | 50% faster tokens; use when latency matters and reasoning is bounded |
| **`gpt-5.4-mini`** | ~$0.40 / $1.60 | Budget prototyping. Not in workspace config currently. |
| **`gpt-5.4-nano`** | lowest | Edge/embedded. Not in workspace config. |

**Pro variant decision:** Reserve for tasks where normal GPT-5.4 fails twice *and* the task genuinely needs extra compute (novel architectural decisions, multi-hour reasoning). 12× cost differential — don't default here.

## Active in This Workspace

- Main session model (alternate): GPT-5.4 (standard)
- Codex CLI default (set in `~/.codex/config.toml`): GPT-5.4
- Cross-model review when main = Opus: GPT-5.4
- Coding agent wrapper: your preferred Codex CLI wrapper
- Pro variant: not currently configured; add to `openclaw.json` if we hit a hard reasoning task
