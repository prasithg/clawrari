# Agent Prompt Template

Use this template when spawning coding agents or sub-agents for complex tasks.
XML blocks are machine-parsed; Markdown sections are for human readability.

> **Why XML?** LLMs parse XML-delimited instructions reliably and unambiguously.
> Structured XML reduces contradictions, makes stop criteria explicit, and prevents
> the "vague prompt → vague output" failure mode. Contradictory instructions waste
> reasoning tokens — the model searches for reconciliation instead of acting.

---

## Base Template

```
[One-liner: what this agent is doing and why it matters]

<goal>
[What you need accomplished. Be specific — not "improve X" but "add Y to file Z so that W works."]

Ancestry (why this matters):
- [Parent goal / project context]
- [How this fits the broader system]
</goal>

<context>
Key files:
- [full/path/to/file] — [one-line purpose]
- [full/path/to/other] — [one-line purpose]

Recent decisions relevant to this task:
- [Decision + date]

Current state:
[What exists today. Embed the knowledge — no "see the docs" references.]
</context>

<constraints>
- Do NOT delete or overwrite existing files unless explicitly listed as a task step.
- Do NOT add new dependencies without documenting rationale in the handoff note.
- Do NOT change [specific system/file/API] — it is out of scope.
- [Any other hard limits]
</constraints>

<acceptance_criteria>
This work is complete when:
- [ ] [Observable behavior — testable by a human or command]
- [ ] [Verification: `<command>` → Expected output: `<exact or described output>`]
- [ ] No regressions in [related areas]
- [ ] Handoff note written to notes/<task-name>-handoff.md
</acceptance_criteria>

<output>
Primary deliverable: [file path or description of what gets created/changed]
Handoff note: notes/<task-name>-handoff.md (required — document decisions, surprises, test results)
</output>

<persistence>
- Keep going until all acceptance_criteria are checked off.
- Only terminate when you are sure the problem is solved.
- Never hand back on uncertainty — research and continue.
- Do not ask for confirmation — decide, proceed, document assumptions in the handoff note.
</persistence>
```

---

## XML Block Reference

### `<persistence>` — Full Autonomy Mode
Use when you want the agent to run to completion without checking in:
```xml
<persistence>
- Keep going until the task is completely resolved.
- Only terminate when you are sure the problem is solved.
- Never hand back on uncertainty — research or deduce the most reasonable approach and continue.
- Do not ask for confirmation — decide, proceed, document assumptions afterward.
</persistence>
```

### `<context_gathering>` — Efficient Exploration Mode
Use to prevent over-exploration and reduce latency in agentic tasks:
```xml
<context_gathering>
Goal: Get enough context fast. Stop as soon as you can act.
- Start broad, then fan out to focused subqueries.
- Parallelize discovery; deduplicate paths; don't repeat queries.
- Trace only symbols you'll modify; avoid transitive expansion.
Early stop: Once you can name the exact content to change, start acting.
</context_gathering>
```

### `<self_reflection>` — High-Quality Generation
Use for zero-to-one builds or any output where quality matters more than speed:
```xml
<self_reflection>
- Before beginning, create a quality rubric with 5-7 categories.
- Think deeply about what "excellent" looks like for this specific task.
- Internally iterate until hitting top marks across all rubric categories.
- Only present the final best version. Do not show the rubric.
</self_reflection>
```

### `<code_editing_rules>` — Codebase-Aware Coding
Use when giving coding agents rules for an existing codebase:
```xml
<code_editing_rules>
<guiding_principles>
- Clarity and Reuse: Every component should be modular and reusable. Avoid duplication.
- Consistency: Adhere to the existing conventions — naming, structure, formatting.
- Simplicity: Favor small, focused components. Avoid unnecessary complexity.
</guiding_principles>
<style_rules>
- Use explicit, searchable naming (no clever abbreviations)
- File size: prefer fewer than 300 lines per file
- One concept per file where practical
</style_rules>
</code_editing_rules>
```

---

## Quick Reference: When to Use Each Block

| Block | When to Use |
|---|---|
| `<goal>` | Always — unambiguous statement of what needs to be done and why |
| `<context>` | Always — files, state, recent decisions |
| `<constraints>` | Always — hard limits, what NOT to touch |
| `<acceptance_criteria>` | Always — explicit, testable done conditions |
| `<output>` | Always — where results go, what gets created |
| `<persistence>` | Long autonomous tasks; anything going to full-auto mode |
| `<context_gathering>` | Large codebases where over-exploration is a risk |
| `<self_reflection>` | Zero-to-one builds, content, any output where quality > speed |
| `<code_editing_rules>` | Coding tasks in established codebases with existing conventions |

---

## Example: Research Task

```
Research the top 3 vector database options for a production RAG pipeline and recommend one.

<goal>
Evaluate three leading vector database options for use in a semantic search pipeline.
Produce a concise recommendation with rationale.

Ancestry:
- The system needs semantic search over millions of documents.
- A vector DB decision is needed before the next sprint.
- The decision-maker will review the recommendation — keep it decision-ready, not academic.
</goal>

<context>
Stack: Node.js/TypeScript backend, PostgreSQL for relational data.
Scale: ~2M vectors at launch, growing to 50M over 12 months.
Budget: prefer managed services, cost cap ~$500/mo at launch scale.
Key constraint: must support metadata filtering.
</context>

<constraints>
- Do NOT recommend self-hosted-only solutions.
- Do NOT recommend anything that requires more than 2 weeks to integrate.
- Keep the final recommendation to 1 page max.
</constraints>

<acceptance_criteria>
This work is complete when:
- [ ] Report covers at least 3 options with latency, cost, and metadata filtering details
- [ ] Clear recommendation with 2-3 sentence rationale
- [ ] Risks/tradeoffs for the recommended option are noted
- [ ] Written to reports/vector-db-recommendation-YYYY-MM-DD.md
</acceptance_criteria>

<output>
Primary: reports/vector-db-recommendation-YYYY-MM-DD.md
</output>
```

---

## Example: Coding Task

```
Build a CLI script that exports all active users to a CSV file.

<goal>
Create scripts/export-active-users.ts that queries the database and
writes a CSV with: user_id, email, created_at, last_active_at, plan_tier.

Ancestry:
- Finance needs a monthly user export for billing reconciliation.
- This runs ad-hoc — triggered manually.
</goal>

<context>
Key files:
- src/lib/db.ts — database client singleton (use this, don't create a new one)
- src/types/user.ts — User type definition
- .env.example — shows required env vars

Current state:
- No export tooling exists yet.
- Active users: where last_active_at > now() - 30 days AND deleted_at IS NULL.
</context>

<constraints>
- Do NOT add new npm dependencies — use built-in Node.js fs or already-installed libs.
- Do NOT modify src/types/user.ts or src/lib/db.ts.
- Output file should go to tmp/exports/ (gitignored).
</constraints>

<acceptance_criteria>
This work is complete when:
- [ ] Script runs without error
- [ ] Produces tmp/exports/users-YYYY-MM-DD.csv with correct headers
- [ ] Handles empty result gracefully (writes headers, zero data rows)
- [ ] Error message if DB connection env vars are not set
</acceptance_criteria>

<output>
Primary: scripts/export-active-users.ts
Handoff: notes/export-active-users-handoff.md
</output>

<persistence>
- Keep going until all acceptance_criteria pass.
- If you hit a schema uncertainty, inspect the table and adapt.
- Document any schema surprises in the handoff note.
</persistence>

<context_gathering>
- Read src/lib/db.ts and src/types/user.ts first.
- Check package.json for existing CSV/utility libs before adding any.
- Do NOT explore the full codebase — scope is limited to the above files.
Early stop: Once you know the DB client API and User type shape, start coding.
</context_gathering>
```
