# Agent Prompt Template

Use this template when spawning coding agents or sub-agents for complex tasks.
XML blocks are machine-parsed; Markdown sections are for human readability.

> **Why XML?** LLMs parse XML-delimited instructions reliably and unambiguously.
> Structured XML reduces contradictions, makes stop criteria explicit, and prevents
> the "vague prompt → vague output" failure mode. Contradictory instructions waste
> reasoning tokens — the model searches for reconciliation instead of acting.

---

## Compile the Request Before Delegating

People should not have to speak in templates. Convert a casual request into a complete
task contract before you route it to an agent. Compile these fields silently when the
request already provides enough evidence:

- **Outcome:** the concrete artifact or state that must exist at the end.
- **Sources:** the files, systems, and decisions that define truth for the task.
- **Scope:** what may change, what must not change, and where adjacent work stops.
- **Done:** observable acceptance criteria and the commands that verify them.
- **Authority:** allowed internal changes, required external side effects, and actions
  that still require a human decision.
- **Effort:** expected depth, time limit, and whether the task warrants parallel work.
- **Execution:** direct work, delegated work, review, or a long-horizon supervised run.
- **Recovery:** the durable plan, state record, or handoff needed to resume without
  silently starting over.

Expose the compiled contract only when the request is materially underspecified, two
constraints conflict, or a consequential choice belongs to the human. Otherwise, use
it to author the prompt and start work. This preserves conversational input without
passing ambiguity downstream.

For long independent runs, record the prompt digest, parent and child identities,
heartbeats, and exactly one terminal outcome. Recovery reads that record and resumes
the existing run; it does not launch an untracked duplicate.

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

<audience_contract>
- Primary audience: [who will use the result]
- Use context: [decision memo | implementation | research brief | public draft]
- This is NOT: [adjacent artifact to avoid]
- Reader knows: [relevant domain knowledge]
- Reader does not need: [background, jargon, or implementation detail to omit]
</audience_contract>

<constraints>
- Do NOT delete or overwrite existing files unless explicitly listed as a task step.
- Do NOT add new dependencies without documenting rationale in the handoff note.
- Do NOT change [specific system/file/API] — it is out of scope.
- [Any other hard limits]
</constraints>

<code_change_discipline>
- Think first: state the smallest plan and the checks that prove it worked.
- Prefer the smallest boring solution. Do not add speculative abstractions.
- Make surgical changes only. Avoid drive-by refactors and dependency churn.
- Trace every changed line to the task, an acceptance criterion, or a named bug.
- Run the narrowest meaningful test, lint, or build command before handoff.
</code_change_discipline>

<negative_constraints>
- Do NOT produce [the adjacent but wrong artifact class].
- Do NOT drift into [internal language, customer language, hype, or vague summary].
- Do NOT omit [the critical comparison, recommendation, citation behavior, or rollout caveat].
- Do NOT overstate certainty beyond the available evidence.
</negative_constraints>

<failure_modes_to_avoid>
- Common failure: [writing the wrong layer of document for the named audience].
- Common failure: [optimizing for completeness instead of decision usefulness].
- Common failure: [creating a file that exists but does not fit its purpose].
</failure_modes_to_avoid>

<acceptance_criteria>
Write each criterion as an observable requirement with its own verification:
- [ ] AC-1: WHEN [trigger], [system or artifact] SHALL [observable result].
      Verification: `[command]` → [expected pass signal].
- [ ] AC-2: IF/WHILE/WHERE [condition, state, or scope], [system or artifact] SHALL [observable result].
      Verification: `[command]` → [expected pass signal].
</acceptance_criteria>

<pre_completion_checklist>
- [ ] Expected output files exist and are non-empty.
- [ ] Every acceptance criterion has been verified, or its exact blocker is named.
- [ ] Tests, lint, and build checks relevant to the changed surface pass.
- [ ] Untested surface is stated in one line; a green check is not proof beyond its scope.
- [ ] Handoff records decisions, surprises, test results, and remaining work.
</pre_completion_checklist>

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

## Long-Horizon Goal Spec

Use this stricter block when work may span multiple agent turns and has a verifiable end state. Keep it to one objective. If you cannot fill every section, tighten the plan or use the base template instead.

```text
Complete <ONE-LINE OBJECTIVE> without stopping until <VERIFIABLE END STATE>.

Scope fence:
- In scope:
  - <path-or-component> — <allowed change>
- Out of scope:
  - <path-or-component> — <what must not change>
- If a useful adjacent fix falls outside this fence, record it as follow-up work and do not implement it.

Required side effects:
- Tool or service: <none | name>
  Purpose: <why this write is part of completion>

Verification:
- `<exact command>` → <expected pass signal>
- `<exact command>` → <expected pass signal>

Invariants:
- <public API, data, compatibility, dependency, or safety rule that must remain true>
- No external writes except the required side effects listed above.

Stop and continue rules:
- Continue while work remains inside the scope fence and no stop condition has fired.
- Finish only when every verification passes, every invariant holds, and required side effects are complete.
- Stop for a revised spec if the objective requires an out-of-scope change.
- Stop and report a blocker after the same failure repeats three times, or when a required fixture, environment, service, or tool remains unavailable after one retry.
- At the time limit, write a resumable progress record and stop without publishing partial work.

Sources of truth:
- Requirements: <path-or-link>
- Execution plan: <path-or-link>
- Work item: <path-or-link>
```

Why each field exists:

- **Scope fence** prevents a long-running agent from turning nearby cleanup into hidden scope.
- **Required side effects** separates necessary external writes from accidental ones.
- **Verification** makes the finish state observable instead of confidence-based.
- **Invariants** name what a green test suite might still miss.
- **Stop and continue rules** make persistence bounded and recovery explicit.
- **Sources of truth** give a resumed run stable orientation after context loss.

---

## Pre-Build Alignment Review

Run this read-only review after the implementation brief is written and before build
work starts. Use it inline for a small change or give it to a short-lived reviewer for
larger work.

The review checks five failure points:

- Trace every acceptance criterion to a source requirement.
- Confirm that referenced existing paths exist and mark planned paths as new.
- Find conflicts between the brief, its source requirements, and architecture rules.
- Confirm that the scope fits the assigned run; split work that does not.
- Match every acceptance criterion to a runnable check and expected result.

Use this prompt:

```text
Review this implementation brief against its source requirements before work starts.

Inputs:
- Implementation brief: <path-or-link>
- Source requirements: <path-or-link>
- Architecture rules: <path-or-link-or-none>

Check:
1. Every acceptance criterion traces to a source requirement.
2. Every referenced existing path exists; planned paths are marked as new.
3. The brief does not conflict with its sources or architecture rules.
4. The scope fits one assigned run, or the brief names a safe split.
5. Every acceptance criterion has a runnable check and expected result.

Return one result:
- PASS: all five checks hold.
- FAIL: cite each mismatch by section and give the smallest correction.

Keep the review read-only. Do not implement the work or rewrite the brief.
```

A failed review blocks implementation until the cited mismatch is corrected. This
keeps the build agent focused on execution instead of discovering an unusable brief
after code changes have started.

---

## XML Block Reference

### `<audience_contract>` — Artifact-Fit Guard
Use when the result has a reader or decision-maker. Name who the result is for, how they will use it, what they already know, and the adjacent artifact the agent must not accidentally produce. This prevents technically complete work that is wrong for its audience.

### `<code_change_discipline>` — Surgical Implementation
Use for code changes. Require a minimal plan, a small solution, traceability from edits to requirements, and a narrow verification command. This limits speculative abstractions and unrelated cleanup.

### `<pre_completion_checklist>` — Completion Proof
Use when a task can look finished before it has been verified. Require output existence, per-criterion checks, relevant gates, a named untested surface, and a concise handoff.

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
| `<audience_contract>` | Any result with a reader, user, or decision-maker |
| `<constraints>` | Always — hard limits, what NOT to touch |
| `<code_change_discipline>` | Code changes — small scope, traceable edits, concrete verification |
| `<acceptance_criteria>` | Always — explicit, testable done conditions |
| `<pre_completion_checklist>` | Tasks where file creation can be mistaken for completion |
| `<output>` | Always — where results go, what gets created |
| `<persistence>` | Long autonomous tasks; anything going to full-auto mode |
| `<context_gathering>` | Large codebases where over-exploration is a risk |
| `<self_reflection>` | Zero-to-one builds, content, any output where quality > speed |
| `<code_editing_rules>` | Coding tasks in established codebases with existing conventions |

For multi-turn work with a machine-checkable end state, use the **Long-Horizon Goal Spec** in addition to the relevant XML blocks.

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
