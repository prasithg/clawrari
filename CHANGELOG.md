# Changelog

## v0.3.0 — 2026-03-08

### Added
- **Session Brief** (`memory/session-brief.md`) — Preconscious buffer for fast session startup. A ~50-line "what matters right now" file read before daily logs. Eliminates wading through 7-13KB of logs to find the 5 things that matter. Inspired by Total Recall's preconscious buffer pattern.
- **Sub-Agent Ledger** (`memory/subagent-ledger.md`) — Append-only record of every sub-agent spawned. Surfaces silent failures at the next session start instead of 4 sessions later. Read at session startup; stale rows (>2h, no output) get flagged immediately.
- **Structured Task Queue** (`templates/tasks/queue.md`) — Task format with goal ancestry, explicit acceptance criteria, type tags, and a formal state machine (`pending → claimed → in_progress → done | failed | blocked`). Atomic claiming prevents duplicate sub-agent spawning.
- **Failure Artifacts System** (`systems/failures/`) — Structured failure records when sub-agents fail or tasks go wrong. Surfaces problems rather than hiding them. Every failure is recorded, learnable-from, and retryable.
- **Agent Prompt Template** (`reference/agent-prompt-template.md`) — XML-structured prompt template for spawning sub-agents and coding agents. Includes `<goal>`, `<context>`, `<constraints>`, `<acceptance_criteria>`, `<output>`, `<persistence>`, `<context_gathering>`, and `<self_reflection>` blocks with examples.
- **Prompt Engineering Patterns** (`reference/prompt-engineering-patterns.md`) — Cheat sheet of LLM prompting patterns: XML tag library, conflict-free prompt principles, goal ancestry pattern, lean vs. rich prompt calibration, and reasoning effort guide.
- **Task Management docs** (`docs/components/task-management.md`) — Full documentation for the task management system: queue format, state machine, sub-agent ledger, failure artifacts, and heartbeat integration.
- **Memory type tagging** — Type taxonomy for all memory entries: `[type:fact]`, `[type:pref]`, `[type:rule]`, `[type:goal]`, `[type:event]`, `[type:habit]`, `[type:context]`. Enables selective loading and type-aware decay.

### Changed
- Updated `docs/components/memory.md` with session-brief and sub-agent ledger patterns, plus memory type tagging documentation
- Updated `README.md` with new architecture layout, task management component, and reference directory
- Updated architecture diagram to show new files and directories

### Credits
- HZL (tmchow/hzl) — durable task ledger, session start workflow, handoff protocol, atomic claiming
- Total Recall (gavdalf/total-recall) — preconscious buffer, memory type taxonomy, dream cycle, multi-hook retrieval
- Paperclip (paperclipai/paperclip) — goal ancestry, failure visibility, structured task state, artifact-first output

---

## v0.2.0 — 2026-02-25

### Added
- Meta-learning loop architecture (9 feedback loops for cross-session improvement)
- New memory files: regressions.md, context-holds.md, predictions.md, influences.md
- Full documentation for all 6 components (memory, self-improvement, content-engine, security, proactive, connectors)
- CONTRIBUTING.md and CODE_OF_CONDUCT.md for open-source readiness
- Bootstrap templates for new meta-learning memory files
- Trust-scored memory with three tiers (constitutional, strategic, operational)
- Prediction-outcome calibration system
- Active context holds with automatic expiry
- Recursive self-improvement cycle with explicit stop conditions

### Changed
- Updated architecture docs to reflect meta-learning additions
- Updated README with meta-learning section and current architecture
- Replaced bird CLI reference with x-api in skills docs

### Credits
- @AtlasForgeAI / @jonnym1ller for the meta-learning loop framework
- @johnsonmxe for the vasocomputation concept (active context holds)

---

## v0.1.0 — 2026-02-20

### Added
- Initial repo structure
- Bootstrap script with interactive questionnaire
- Template files for SOUL.md, USER.md, HEARTBEAT.md, AGENTS.md, MEMORY.md, IDENTITY.md
- Landing page (static HTML + Tailwind)
- Architecture and philosophy docs
- Component documentation stubs
- Skills and crons reference directories
