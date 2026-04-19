# ExecPlan Template

Use for any work beyond a quick fix. Self-contained, living document. Based on OpenAI's Codex execution plans.

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
This work is complete when:
- [ ] [Observable behavior 1 — testable by a human or command]
- [ ] [Observable behavior 2]
- [ ] [Command: `<verification command>` → Expected output: `<exact or described output>`]
- [ ] No regressions in [related areas]
</acceptance_criteria>

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

_Prose description of the sequence of edits and additions. For each edit:_
- _Name files with full repo-relative paths_
- _Name functions and modules precisely_
- _Show exact commands with working directory_
- _State expected outputs_

### Milestone 1: [Name]

**Scope:** _What will exist after this milestone that didn't before._

**Steps:** _Narrative of what to do._

**Verification:** _Commands to run, expected output. Behavior a human can verify — not just "struct exists."_

### Milestone 2: [Name]

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
