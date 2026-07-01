# Changelog

## 2026-07-01

### Added
- **Epistemic-pressure preflight** (`docs/content-engine.md`) — a cheap heuristic stop-sign that runs before the anti-AI-tell gate and refuses a draft carrying zero angle. Documents the general pattern: keep a versioned file of stated beliefs with stable ids so drafts anchor to a real position, force at least one non-consensus tag per piece, and treat the preflight as a bland-draft second-pass trigger — not a certifier of good takes. Catches the failure a voice gate never will: clean prose with no point of view.

## 2026-06-29

### Added
- **Regression → skill graduation (Toil vs Anomaly)** (`docs/self-improvement.md`) — documents when a guardrail belongs in the regression log (a *tripwire* that detects) versus an executable skill (a *procedure* that remediates). Mechanical/deterministic gaps graduate to a verified, self-checking skill on first occurrence; cognitive/judgment errors stay tripwires and escalate to an architectural gate on recurrence. The lever is executability, not the file. Established after the same sandboxed-git-commit failure was logged as 5+ separate regressions; model-council reviewed (Opus/Gemini/GPT-5.5).

## 2026-06-21

### Added
- **PRA-173 cadence recovery packet** — adds the human-facing message standard (`docs/human-facing-message-standard.md`), the cadence recovery eval (`reports/evals/2026-06-21-pra173-clawrari-cadence.md`), GitHub hygiene (`.github/workflows/ci.yml` plus issue templates), and an OpenClaw recovery note (`.openclaw/cadence-recovery-2026-06-19-pra173.md`). The packet restores the post-2026-06-19 cadence with a documented human-message rule, repo intake templates, and a lightweight CI gate that runs the harness selftests.

## 2026-06-18

### Added
- **Stacking loops pattern** (`docs/stacking-loops.md`) — documents composing nested feedback loops so quality compounds: a craft loop (generate → evaluate → diagnose → improve) inside a cross-model review loop inside a measured-gate (escape-rate) loop. Each loop emits a measurable signal the next consumes, lands those signals on the run trace, and inherits the "a metric you cannot read is null" rule. Argues stacking complementary loops beats adding parallel agents because the checks decorrelate and quality multiplies rather than sums. Cross-links `docs/observability.md` and `docs/harness/eval-scorecard.md`; linked from `docs/index.md` and `docs/harness/README.md`.

## 2026-06-15

### Added
- **Agent observability + morning report** (`docs/observability.md`) — documents the `trace → usage → scorecard → report` chain: trace every agent run, capture tokens/cost/durable artifacts, roll a window into the six-axis scorecard, and render one zero-dependency HTML page a human reads in two minutes. Covers the "green status is not success" framing, the run-trace data model, the metric-you-cannot-read-is-null rule, durable-artifact counting, and the morning-report contract. Extends `docs/harness/eval-scorecard.md`.
- **Observability templates** (`templates/observability/`) — reusable, sanitized scaffolds: `trace.schema.json` (JSON Schema draft-07 for one run record), `scorecard.template.json` (the roll-up contract the report renders), and `night-report.template.html` (self-contained, inline-CSS, offline-safe report skeleton with `{{PLACEHOLDER}}` tokens and repeat-block markers).
- **Memory promotion (the dreaming pass)** (`docs/memory-promotion.md`) — documents the graduated promotion path and the nightly consolidation step that reviews the day's log and graduates the few facts that matter into durable files. Covers the four-tier path, supersede chains, type and trust tags, decay, and the monthly deep pass.
- **Memory templates** (`templates/memory/`) — reusable scaffolds for the layered store: `MEMORY.md` (the index), `daily-log.md` (raw journal with type/trust tagging), `thematic-file.md` (promotion target with supersede chains and decay rules), and `promotion-checklist.md` (a runnable dreaming-pass checklist for night work). These join the existing `session-brief.md` and `subagent-ledger.md`.
- **Harness pattern set** (`docs/harness/`) — four reusable, dependency-free harness patterns ported from a running setup: the night-work pipeline (plan, build, test, completion sweep), the executable regression suite, the six-axis cross-agent eval scorecard, and the peer-blocker bridge. Indexed by `docs/harness/README.md`.
- **Harness scaffolds** (`scripts/`) — runnable, sanitized scaffolds, each with a `--selftest`: `night-work-pipeline.sh` (stage-hook pipeline with logging and a failure valve), `regression-check.mjs` (turns prose guardrails into machine-checkable assertions, Node builtins only), `eval-scorecard.mjs` (honest six-axis roll-up that never fabricates a score it cannot ground, Node builtins only), and `peer-blocker-watch.sh` (cross-agent deadlock watcher with dedup).
- **Sample regression spec** (`config/regression-suite.example.json`) — starter machine-checkable guardrail set for `regression-check.mjs`.

## 2026-06-13

### Added
- **`avoid-ai-writing` (AWDS) skill** (`skills/avoid-ai-writing/`) — the documented single source of truth for Clawrari's voice and anti-AI-tell rules. Ships `SKILL.md` (workflow, scoring rubric, variance rules, autoresearch loop) and a four-layer pattern set: `v1-lexical`, `v2-formatting`, `v3-structural`, `v4-emerging`, plus a skill `CHANGELOG.md`. (PRA-137)
- **`publish-pipeline` stub** (`skills/publish-pipeline/SKILL.md`) — publish-stage contract that defers to AWDS for all voice rules. (PRA-137)

### Changed
- Consolidated voice authority on AWDS: `bootstrap/templates/SOUL.md.tmpl`, `docs/content-engine.md` (Review + Learn stages), `docs/recipes/content-engine-setup.md`, `skills/README.md`, and the three content templates (`docs/content-engine/templates/*`) now cross-reference AWDS as canonical and defer to it on conflict, instead of carrying parallel banned-word lists. (PRA-137)

## 2026-06-06

### Added
- **Content engine draft generator** (`scripts/content-engine.sh`) — runnable CLI that turns recent repo activity (git commits + CHANGELOG) into reviewable **weekly** and **monthly** content drafts. Draft-only by design: writes markdown into `drafts/` and makes no network calls. Supports `--weekly`/`--monthly`, `--window`, `--output-dir`, `--as-of`, `--dry-run`, and an optional config file. (PRA-122)
- **Content engine config example** (`config/content-engine.example.conf`) — sensible defaults for output dir, window, and as-of date; copy to `config/content-engine.conf` for a local auto-loaded default. (PRA-122)
- **Content engine cron spec** (`crons/content-engine.md`) — intended schedule (weekly Fri 09:00, monthly 1st 09:00) with both system-crontab and OpenClaw-routine variants. Registration stays manual. (PRA-122)

### Changed
- Added a "Draft Generator (CLI)" usage section to `docs/content-engine.md`. (PRA-122)

## 2026-05-22

- docs(reference): add `skill-change-eval-template.md` — Phase 1 v0.5.x discipline-layer port. Pairs with the PR template's eval-artifact checkbox to enforce "no eval = not Done" on skill / workflow / orchestration changes (REG-032 / REG-034).

## v0.4.0 — 2026-04-19

### Added
- **Build Playbook** (`docs/playbook.md`) — opinionated install-and-adopt guide for taking a fresh OpenClaw setup to a working Clawrari system.
- **Mission statement** (`MISSION.md`) — tighter articulation of what Clawrari is for, who it serves, and what standard it should meet.
- **Process docs** (`docs/process.md`) — public summary of how Clawrari features are discovered, filtered, packaged, and shipped.
- **Model Playbook** (`reference/model-playbook/`) — routing table, model metadata, overlays, and per-model prompting notes for the live stack.
- **Reference publishing pass** (`reference/architecture-template.md`, `reference/execplan-template.md`, `reference/prompt-patterns.md`, `reference/sop-agent-task-workflow.md`, `reference/validation-agent-spec.md`, `reference/steering-hooks-spec.md`, `reference/agentic-engineering-patterns.md`) — public-safe versions of the internal playbooks that support agent-first engineering.
- **Persona docs** (`docs/components/persona.md`) — shared-base plus overlay model for personal and work-facing behaviors.
- **Identity channel docs** (`docs/components/identity-channel.md`) — assistant-owned communication identity pattern for Slack or equivalent channels.

### Changed
- Updated `bootstrap/init.sh` to generate the modern memory skeleton, `TOOLS.md`, split rule files, conventions, and heartbeat state.
- Fixed `bootstrap/templates/SOUL.md.tmpl` so personality conditionals render correctly instead of leaking raw template tags.
- Updated `bootstrap/templates/*` and `templates/*` to match the current workspace patterns for session briefs, subagent ledgers, queue structure, startup order, and model overlays.
- Expanded `docs/components/memory.md` with deterministic startup order, rule splitting, search-then-read retrieval, and freshness guidance.
- Expanded `docs/components/self-improvement.md` with improvement-signal framing, promotion discipline, and review-surface guidance.
- Updated `docs/components/connectors.md`, `skills/README.md`, and `crons/README.md` to reflect current connector naming, identity-channel guidance, model freshness, and night-work prep.
- Reworked `README.md` for an accurate `v0.4.0` public surface and synced the landing pages in `docs/index.html` and `site/index.html`.

### Notes
- GitHub Pages remains served from the `docs/` output on `main`; `site/index.html` is kept in sync as the editable twin.
- Custom domain setup is intentionally not changed in this release. No `CNAME` file has been added.

### Credits
- @AtlasForgeAI / @jonnym1ller for the meta-learning loop framing
- @johnsonmxe for active context holds / vasocomputation influence
- HZL, Total Recall, and Paperclip for durable workflow and memory-system inspiration

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
