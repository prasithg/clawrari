# ExecPlan Template

Use for any work beyond a quick fix. Self-contained, living document. Based on OpenAI's Codex execution plans.

**Trigger policy:** ExecPlan required when work spans >1 session/run, OR needs >2 coordinated agents, OR touches a production system where rollback is nontrivial. Single-session/single-agent: the prompt file with EARS ACs IS the spec.

> **XML sections** (`<context>`, `<constraints>`, `<acceptance_criteria>`) are machine-parsed by coding agents.
> Keep them tight and unambiguous — no prose padding. Markdown sections are for humans.

---

# [Short, action-oriented title]

_This ExecPlan is a living document. Progress, Surprises, Decision Log, and Outcomes must be kept current._

Maintained per: `reference/execplan-template.md`

## Purpose / Big Picture

_What someone gains after this change. How they can see it working. State the user-visible behavior you will enable. 2-4 sentences max._

---

<!-- ═══════════════════════════════════════════════════
     MACHINE-PARSED SECTIONS (used when piping this plan
     to a coding agent). Keep these tight and complete.
     ═══════════════════════════════════════════════════ -->

<context>
Project: [repo name or path]
Key files:
- [full/path/to/file.ts] — [one-line purpose]
- [full/path/to/other.py] — [one-line purpose]

Recent decisions that affect this work:
- [Decision summary + date]

Current state: [What exists today that's relevant. Embed the knowledge — don't reference external docs.]
</context>

<constraints>
- [Hard constraint: what NOT to do or touch]
- [Hard constraint: tech/pattern restrictions]
- [Hard constraint: anything that must stay unchanged]
- Do NOT delete existing content or files unless explicitly listed as a task step.
- Do NOT add new dependencies without documenting the rationale.
</constraints>

<acceptance_criteria>
EARS acceptance-criteria convention (required):
- Write every criterion as a testable EARS requirement: `WHEN <trigger>, the <system or artifact> SHALL <observable result>.`
- Use `WHILE` for a state, `WHERE` for a scoped feature, or `IF` for a condition; every criterion SHALL contain `SHALL` and at least one trigger keyword (`WHEN`, `WHILE`, `WHERE`, or `IF`).
- Give every criterion its own `Verification:` command and expected pass signal. A criterion without a runnable command is incomplete.
- Do not use soft adjectives such as "robust", "clean", "good", or "properly". Replace them with measurable behavior, exact output, an exit status, a threshold, or another observable result.

Worked before/after examples:

1. Before (soft/vague): `The parser handles malformed input robustly.`
   After (EARS): `WHEN the parser receives malformed JSON, it SHALL exit with status 2 and print "invalid JSON" to stderr.`
   Verification: `parse-config fixtures/malformed.json >/tmp/parse.out 2>/tmp/parse.err; test $? -eq 2 && grep -F "invalid JSON" /tmp/parse.err` → exits 0.
2. Before (soft/vague): `The warm cache performs well.`
   After (EARS): `WHILE the cache is warm, the benchmark SHALL report p95 latency of 50 ms or less across 20 requests.`
   Verification: `cache-bench --warm --requests 20 --max-p95-ms 50` → exits 0.
3. Before (soft/vague): `The generated documentation is clean and properly formatted.`
   After (EARS): `WHEN the documentation generator runs, it SHALL create a non-empty build/api.md that passes markdownlint.`
   Verification: `docs-build && test -s build/api.md && markdownlint build/api.md` → exits 0.

This work is complete when every item follows that convention:
- [ ] AC-1: WHEN [trigger], [system or artifact] SHALL [observable result].
      Verification: `[command]` → [expected pass signal].
- [ ] AC-2: IF/WHILE/WHERE [condition, state, or scope], [system or artifact] SHALL [observable result].
      Verification: `[command]` → [expected pass signal].
</acceptance_criteria>

---

## Research / Pitfall Preflight

_Complete before implementation research is considered done and before any build/code agent is spawned._

1. Form a query from the target repository, component, task type, and named failure modes, plus `[type:pitfall] build code`.
2. Run `memory_recall` with that query. If `memory_recall` is unavailable, run `memory_search` with the same query.
3. Record the exact query, top relevant hits, and source paths below. Ignore unrelated hits; record an explicit no-hit result rather than inventing one.
4. Copy every relevant hit into `<context>` under `Prior pitfalls (preflight)` and into the build prompt before acceptance criteria. State both the failure mode and preventive action.

- **Query:** [exact memory_recall/memory_search query]
- **Relevant hits:** [pitfall + preventive action + source, or `no relevant hits`]
- **Prompt injection point:** [prompt path + section]

---

## Risks & Assumptions

_Required for any ExecPlan born from a PRD/FRD. Populate by running a premortem (structured red-team) on the plan before implementation starts. Paste the premortem's ExecPlan-Ready Insert here._

**Top 3 failure modes we are betting against:**
1. [Failure 1] — mitigation: [how we prevent / detect it]
2. [Failure 2] — mitigation: [how we prevent / detect it]
3. [Failure 3] — mitigation: [how we prevent / detect it]

**Hidden assumption to validate before build starts:**
- [The assumption the premortem surfaced]
- Validation: [specific, concrete test]

**Pre-build checklist** (blocks the move from `review` → `in-progress`):
- [ ] [Item 1]
- [ ] [Item 2]
- [ ] [Item 3]

**Premortem transcript:** `reports/premortem/[slug]-YYYY-MM-DD.md`

---

## Progress

_Granular checklist. Update at every stopping point. Split partially-completed tasks into done/remaining._

- [x] (YYYY-MM-DD HH:MMZ) Example completed step
- [ ] Example incomplete step
- [ ] Example partial step (completed: X; remaining: Y)

## Context and Orientation

_Current state relevant to this task, as if the reader knows nothing. Name key files by full path. Define any non-obvious terms. Do NOT reference external docs — embed the knowledge here._

_(This section is the human-readable expansion of the `<context>` block above. Keep both in sync.)_

## Plan of Work

**Stable unit IDs:** Label plan units `U1`..`Un` in execution order (for example, `### U1 — [Name]`). Once assigned, do not renumber or reuse an ID; append new units with the next unused ID so reviews and follow-ups can cite them unambiguously.

_Prose description of the sequence of edits and additions. For each edit:_
- _Name files with full repo-relative paths_
- _Name functions and modules precisely_
- _Show exact commands with working directory_
- _State expected outputs_

### U1 — [Name]

**Scope:** _What will exist after this milestone that didn't before._

**Steps:** _Narrative of what to do._

**Verification:** _Commands to run, expected output. Behavior a human can verify — not just "struct exists."_

### U2 — [Name]

_Same structure..._

## Surprises & Discoveries

_Unexpected behaviors, bugs, optimizations, or insights. Include evidence._

- Observation: ...
  Evidence: ...

## Decision Log

_Every design decision made during implementation._

- Decision: ...
  Rationale: ...
  Date/Author: ...

## Outcomes & Retrospective

_At completion: what was achieved, what remains, lessons learned. Compare result against original purpose._

---

## Rules (Non-Negotiable)

1. **Self-contained.** A novice can implement end-to-end from ONLY this document.
2. **Living.** Update as progress is made and discoveries occur. Every revision stays self-contained.
3. **Observable outcomes.** Define acceptance as behavior, not code changes.
4. **Idempotent and safe.** Steps can be run multiple times. Include fallbacks for destructive operations.
5. **Validation is not optional.** Include test commands, expected outputs, and proof of success.
6. **No external references.** If knowledge is required, embed it. Don't point to blogs or docs.
7. **XML sections are agent interfaces.** `<context>`, `<constraints>`, `<acceptance_criteria>` must be kept complete and contradiction-free. Agents parse these directly — ambiguity wastes reasoning tokens.

---

## Optional Enhancement: Self-Reflection (Zero-to-One Builds)

For greenfield builds where quality matters more than speed, prepend this block to the coding agent prompt:

```xml
<self_reflection>
- Before beginning, create a quality rubric with 5-7 categories specific to this task.
- Think deeply about what "world-class" looks like for this work.
- Do not show the rubric — it is for internal iteration only.
- Iterate internally until hitting top marks across all rubric categories.
- Only present the final best version.
</self_reflection>
```

_See `reference/prompt-engineering-patterns.md` for the full XML block library._
