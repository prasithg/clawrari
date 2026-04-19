# ARCHITECTURE.md Template

Use this template for any project we build or contribute to. Keep it short, stable, and searchable.

---

# Architecture

## Bird's Eye Overview

_2-3 sentences: what problem does this solve, for whom, and how._

## Codemap

_Describe coarse-grained modules and how they relate. Answer: "where's the thing that does X?" and "what does this thing do?"_

_Name important files, modules, and types. Do NOT link them directly (links rot). Encourage search by name._

### `/src/domain/`
- `module-name` — what it does, key types: `TypeA`, `TypeB`

### `/src/infra/`
- `module-name` — what it does

### `/src/api/`
- `module-name` — what it does

## Layer Boundaries & Dependency Rules

_Which layers exist? What are the allowed dependency directions?_

Example:
```
Types → Config → Repository → Service → Runtime → UI
```

_Cross-cutting concerns (auth, logging, telemetry) enter through a single explicit interface._

## Architectural Invariants

_Things that are true and must stay true. Often expressed as the ABSENCE of something._

- [ ] No UI layer depends on database internals directly
- [ ] All external data is validated/parsed at the boundary (parse, don't validate)
- [ ] Structured logging only — no `console.log` / `print` in production paths
- [ ] _Add project-specific invariants here_

## Cross-Cutting Concerns

- **Auth:** _how it works, where it lives_
- **Error handling:** _pattern used_
- **Logging/Observability:** _structured logging, where traces go_
- **Testing:** _strategy, where tests live, how to run_
- **Configuration:** _how config is loaded, env vars vs files_

## Key Design Decisions

_Brief log of "why" for non-obvious choices. Keep it to decisions that would confuse a newcomer._

| Decision | Rationale | Date |
|----------|-----------|------|
| _example_ | _example_ | _date_ |

---

_Keep this file under 200 lines. Revisit 2-3x per year or after major structural changes. Don't try to keep it synchronized with every commit._
