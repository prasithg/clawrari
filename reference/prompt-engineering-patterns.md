# Prompt Engineering Patterns

A practical reference for writing effective prompts for LLM agents.
Use when: building new skills, writing task prompts for coding agents, or debugging underperforming prompts.

---

## 1. Canonical Prompt Structure

For any system message, use this order:

```
# Identity
[Who the assistant is, communication style, high-level goal]

# Instructions
[Rules, what to do, what never to do — subsections as needed]

# Examples
[Few-shot input/output pairs — use XML tagging]

# Context
[Additional data, session-specific info — variable per request]
```

**Why order matters:** Stable content at the top maximizes prompt caching. Variable context at the end. Examples reinforce instruction format before context varies.

---

## 2. XML Tag Patterns

XML tags delineate sections. Models respond better to structured XML over prose blocks — it reduces ambiguity and prevents contradictory instructions.

### 2.1 Persistence (Full Autonomy Mode)
```xml
<persistence>
- Keep going until the task is completely resolved.
- Only terminate when you are sure the problem is solved.
- Never hand back on uncertainty — research or deduce the most reasonable approach and continue.
- Do not ask the human to confirm assumptions — decide, proceed, document them afterward.
</persistence>
```

### 2.2 Context Gathering (Efficient Exploration Mode)
```xml
<context_gathering>
Goal: Get enough context fast. Stop as soon as you can act.
Method:
- Start broad, then fan out to focused subqueries.
- Parallelize discovery; deduplicate paths; don't repeat queries.
- Trace only symbols you'll modify; avoid transitive expansion.
Early stop criteria:
- You can name exact content to change.
- Top hits converge (~70%) on one area/path.
Loop:
- Batch search → minimal plan → complete task.
- Search again only if validation fails or new unknowns appear.
- Prefer acting over more searching.
</context_gathering>
```

**Lean version (for simple tasks):**
```xml
<context_gathering>
- Maximum of 2 tool calls for context gathering.
- Bias strongly towards providing a correct answer as quickly as possible.
- You may proceed under uncertainty — document your assumptions and adjust if wrong.
</context_gathering>
```

### 2.3 Self-Reflection Rubric (High-Quality Generation)
```xml
<self_reflection>
- Before beginning, create a quality rubric with 5-7 categories.
- Think deeply about what "excellent" looks like for this specific task.
- Do not show the rubric to the user — it is for your internal iteration only.
- Internally iterate until hitting top marks across all rubric categories.
- Only present the final best version.
</self_reflection>
```

### 2.4 Tool Preambles (Transparent Agentic Work)
```xml
<tool_preambles>
- Always begin by rephrasing the user's goal clearly before calling any tools.
- Outline a structured plan detailing each logical step.
- As you execute, narrate each step succinctly.
- Finish by summarizing completed work.
</tool_preambles>
```

### 2.5 Code Editing Rules (Codebase-Aware Coding)
```xml
<code_editing_rules>
<guiding_principles>
- Clarity and Reuse: Every component should be modular and reusable. Avoid duplication.
- Consistency: Adhere to the existing design system — color tokens, typography, spacing.
- Simplicity: Favor small, focused components. Avoid unnecessary complexity.
</guiding_principles>
<stack_defaults>
- [List your stack here, e.g. Next.js, TailwindCSS, shadcn/ui]
</stack_defaults>
<style_rules>
- Use explicit, searchable naming (no clever abbreviations)
- File size: prefer fewer than 300 lines per file
- One concept per file where practical
</style_rules>
</code_editing_rules>
```

---

## 3. Few-Shot Examples Pattern

Use XML IDs to tag examples clearly:
```xml
<example id="1">
<input>How do I reverse a list in Python?</input>
<output>Use slicing: `my_list[::-1]` or `my_list.reverse()` for in-place.</output>
</example>
```

---

## 4. Conflict-Free Prompt Principle

Contradictory instructions waste reasoning tokens — the model searches for reconciliation instead of acting.

**Audit checklist before deploying any prompt:**
- [ ] Is there a general rule + a conditional exception that contradicts it?
- [ ] Does an "always do X" conflict with any "never do Y"?
- [ ] Are priority/ordering rules clear when instructions compete?

**Fix pattern:**
- "Exception: Do not do [X] in [specific case] — instead, do [Y]."
- "Priority: If [condition], [instruction A] takes precedence over [instruction B]."

---

## 5. Reasoning Effort Guide

| Task Type | Recommended Level | Notes |
|---|---|---|
| Latency-sensitive, well-defined | minimal | Add explicit planning prompts |
| Standard agentic tasks | medium (default) | Good balance for most tasks |
| Complex multi-step, ambiguous | high | Worth the extra cost |
| Research, architecture decisions | high | Most autonomous; less instruction needed |
| Content generation, formatting | medium | High reasoning won't help much here |

For **minimal reasoning**, always add:
```
Decompose the query into all required sub-requests and confirm each is completed.
Do not stop after completing only part of the request.
Plan extensively before each tool call. Reflect on outcomes after each call.
```

---

## 6. Prompt Caching Optimization

1. Put **stable content** first: identity, rules, examples
2. Put **variable content** last: user data, RAG results, session context
3. Keep stable sections **exactly the same** across calls to maximize cache hits

---

## 7. Metaprompting Template

When a skill/prompt isn't working, use an LLM to diagnose it:

```
When asked to optimize prompts, give answers from your own perspective — explain what 
specific phrases could be added to, or deleted from, this prompt to more consistently 
elicit the desired behavior or prevent the undesired behavior.

Here's a prompt:
[PASTE PROMPT]

The desired behavior is for the agent to [DO DESIRED BEHAVIOR], but instead it 
[DOES UNDESIRED BEHAVIOR].

While keeping as much of the existing prompt intact as possible, what are some minimal 
edits/additions you would make to address these shortcomings?
```

---

## 8. Goal Ancestry Pattern

Always inject the "why" into agent prompts. Agents that know the goal hierarchy make better decisions:

```
Goal ancestry:
- Top-level objective: [what you're ultimately trying to achieve]
- This task contributes to: [mid-level goal]
- Specific task: [immediate thing to do]
```

Without ancestry: agents optimize locally. With ancestry: agents understand tradeoffs.

---

## 9. Lean vs. Rich Prompt Calibration

| Task Type | Prompt Style | What to Include |
|---|---|---|
| Simple, well-defined | Lean | Task + acceptance criteria only |
| Complex, multi-context | Rich | Task + goal ancestry + relevant files + constraints |
| Stateless/repeatable | Lean | Standardize on a template |
| First run / novel | Rich | Over-specify; trim after first success |

Deliberately calibrate — don't use the same prompt format for every task.

---

## 10. Sub-Task Decomposition Before Spawning

For complex tasks, decompose before spawning agents:

1. Write out the sub-tasks explicitly
2. Spawn separate focused agents per sub-task (or pass as structured list)
3. Synthesize results after

**Why:** A focused agent with one clear task outperforms a single agent with a compound prompt.

Apply selectively — parallel agents have coordination overhead. Use for tasks that are clearly parallelizable.
