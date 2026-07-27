# Changelog

## v0.5.0 — 2026-07-27

The proof-and-execution release. The public model playbook is resynced with the live stack (`effort-ladder.md`, per-model prompt guides, updated overlays and orchestration routing, a Fable long-horizon pack), and four production skills ship sanitized for reuse: `cross-review`, `night-work`, `coding-agent`, and `loop-watcher`. The harness set matured — the night-work pipeline now survives a dead orchestrator via an external finalizer, and the regression suite, six-axis eval scorecard, and "no eval = not Done" skill gate are wired in. Adds agent observability (`trace → usage → scorecard → report` with a zero-dependency morning report), memory promotion (the dreaming pass) plus reusable templates, and ~13 distilled field-tested pattern docs landed since v0.4. Dated entries below carry the detail.

## 2026-07-27

### Changed
- **Model Playbook refresh** (`reference/model-playbook/`) — brought the public playbook back in sync with the live stack after ~3 months of drift. Rebuilt the roster around **Opus 4.8 medium** as the default orchestrator with a cross-provider fallback chain (Opus → GPT-5.6 Sol → Kimi K3), **Fable 5** as the hard-autonomous/long-horizon primary, GPT-5.6 Sol as reviewer/coding, Grok 4.5 as specialist escalation, Gemini 3.5 Flash as fast/bulk-only, and GLM 5.2 as experimental-only. New `models.yaml` (v13), `orchestration-strategy.md` routing table + decision tree, and per-model prompt files (`opus`, `fable`, `gpt-5.6`, `grok-4.5`, `kimi-k3`, `gemini-3.5-flash`, `glm-5.2`) plus refreshed `overlays/` (`main-opus`, `main-fable`, `main-gpt54`).

### Added
- **Ported four flagship execution/improvement skills from the live workspace** (`skills/`), sanitized and generalized so another OpenClaw user can install and adapt them:
  - **`cross-review`** — cross-model review handle (opposite family reviews the build), vended in full with its prompt template + per-family nudge blocks. Grades every acceptance criterion with `file:line` evidence and requires an *untested surface* section on every verdict.
  - **`night-work`** — overnight autonomous build loop: bounded task → verify → log → next, with lane-based model routing (strong-autonomous / coding-fallback / fast-bulk-only) and hard stop conditions.
  - **`coding-agent`** — bash-first delegation to Codex/Claude Code (PTY for Codex, `--print` for Claude Code), plus the mechanical *delegate-or-declare* cumulative-edit trigger that stops interactive sessions from drifting into inline editing.
  - **`loop-watcher`** — pattern scaffold for scouting external agent loops: read-only source adapters, a shared content-addressed seen-ledger, a deterministic 5-class rubric, an inventory relevance map, and a draft-only formatter that never auto-files or posts. Harness scripts are operator-specific and intentionally not vended; the skill specifies the five reusable parts instead.
- **`effort-ladder.md`** — single source of truth for effort levels (xhigh/high/medium/low/max) and the default routing chain, with guardrails on which lanes each model may enter.
- **`fable-operating-pack.md`** — a prompt library for long-horizon autonomous work (a pre-discovery prompt + 13 task templates), adapted from Every's public Fable 5 pack to an OpenClaw-style harness.
- **`models/fable.md`** — Fable 5 prompting and long-horizon constraints, including the reasoning-extraction hazard, effort/`max_tokens` pairing, orchestration patterns, and field-tested usage notes.
- **`overlays/main-fable.md`** — main-session behavior when driving Fable: reasoning handling, automatic task-entry compiler, sub-agent fan-out governor, and durable execution/recovery discipline.
- **`goal-loop-vasilescu-second-brain.md`** — an annotated reference exemplar of a well-structured Codex `/goal` spec (orientation-first, hard checkpoints, resumable state, deterministic validation gates).

### Removed
- Retired/superseded per-model files: `models/gpt-5.4.md`, `models/gemini-3.1-pro.md`, `models/glm-5.1.md`, `models/sonnet-4.6.md`, and `models/haiku-4.5.md` — replaced by the current roster above (Sonnet prompting now folds into `models/opus.md`; Haiku and Gemini Pro are retired routes).

## 2026-07-25

### Added
- **Where a guardrail's enforcement lives** (`docs/harness/regression-suite.md`) — an executable check only holds where you wire it, and the obvious spot is a trap. A pre-commit script dropped in `.git/hooks/` is untracked per-clone git metadata: it vanishes on a fresh clone, never reaches CI, and silently does nothing for every contributor who skipped your setup step — you get a green board and zero enforcement, which is worse than no hook because now you trust one. Four rules turn a check into one that actually holds: (1) **commit the hook into the tree** (`.githooks/pre-commit` + an idempotent installer that points `core.hooksPath` at it) so it ships with the repo instead of living in private metadata; (2) **back it with a CI gate** running the same check module on push — the local hook is fast feedback, CI is the gate that holds because it runs whether or not anyone installed the hook, and when they disagree CI wins; (3) **fail closed** — when the check can't run (unreadable blob, missing tool, incomplete parse) it must block, never wave through, because a guard that fails open silently converts "I couldn't check" into "looks fine"; (4) **check the staged index, not the working tree**, so you gate exactly the bytes that will land rather than a cleaner version sitting on disk. Companion discipline — **detect, don't silently repair**: a guard that auto-rewrites source turns a loud reviewable failure into a silent mutation the author never sees, and corrupts the thing it protects when its fix is wrong; report the offense, exit non-zero, let a human edit, and reserve auto-repair for outputs you fully own. Generalizes: enforcement is a property of *where the check is wired*, not whether the check exists — two points (tracked local hook + CI) sharing one module, tracked one authoritative, is the shape that can't be skipped by forgetting to install it.

## 2026-07-23

### Added
- **Don't ship a skill without an eval** (`docs/harness/skill-evals.md`, wired as the 5th harness pattern) — the executable end of a "no-eval = not Done" gate, aimed one level up from the regression suite: instead of turning prose guardrails into assertions, it turns "this skill triggers correctly and says the right thing" into a check that runs *before* the skill ships. Load-bearing insight: a skill's trigger point is a boundary that drifts silently — a clarifying description edit drops the word that made it fire, an overlapping new skill steals a prompt — and the regression only shows up as the agent quietly failing to load (or wrongly loading) it, found weeks later from a bad answer. The eval locks two distinct things: the **trigger boundary** (fires on prompts it owns, stays silent on adjacent prompts it doesn't — over-triggering is as much a bug as under-triggering, and most people only write the happy cases) and the **content guarantee** (when it does fire, the response contains the right SDK/pattern and avoids the deprecated one, via cheap `present`/`absent` regex asserts). Four trust rules: (1) load the skill in **isolation** — never let the runner see prior eval outputs or run logs, or the agent "passes" by pattern-matching its own history; (2) **derive trigger signals from the live skill file** at run time, not hardcoded, so a dropped trigger term turns the eval red automatically and the eval guards the exact text that ships; (3) **score outcomes not paths** — 3-6 trials per case, majority vote, never assert "loaded on turn 1" (rigid path asserts flake and train people to ignore the suite); (4) keep the **LLM judge optional and lazy** so the deterministic base run needs no live model call and gates CI free and fast. Non-zero exit on failure is the whole point — it lets the eval gate a pre-commit hook or completion sweep, turning "I updated the skill" from a claim you take on faith into a three-step contract (write happy+negative cases, run green, link the artifact). Generalizes: the eval doesn't prove a skill is good, it proves the skill still fires where it should, stays quiet where it shouldn't, and says the non-negotiable things when it speaks — that's the floor, and shipping without it is shipping blind.

## 2026-07-21

### Added
- **Tier your alerts by blast radius** (`docs/self-improvement.md` §12) — how a self-monitoring loop (dependency drift, config skew, expiring creds, disk) earns attention instead of training its operator to ignore it. A monitor that fires on every trivial change is worse than none: it teaches you to skim past the one alert that mattered. Three moves turn a flat "here's everything out of date" dump into signal — (1) **tier by blast radius**: split what you watch into *auto-safe* (a headless agent may act, smoke-test, move on) vs *decision-only* (never autonomous — the runtime/package-manager/anything forcing a supervised restart), where the tier is a property of the *thing* not this change, and decision-only items surface with a reason-to-upgrade attached; (2) **gate on a threshold so trivial churn stays silent** — define "trivial" and make the monitor genuinely quiet (exit clean, send nothing) when everything is, because silence is a valid, informative output; (3) **let a real signal punch through** — a live security advisory or hard dependency forces even a trivial item to flag, on a narrow time-bounded window. Plus two honesty disciplines: surface untracked items in a visible bucket (so the policy list gets maintained, not silently outgrown) and ship an actionable payload (exact upgrade command / reason-to-decide) behind a fixture-driven `--selftest`. Generalizes the observability honesty rule: a monitor earns attention by being quiet when it should be — crying wolf on every patch bump isn't vigilance, it's teaching the operator not to listen.

## 2026-07-19

### Added
- **The generator is not the grader** (`docs/self-improvement.md` §11) — the companion to §10's mechanical done-gate, for the subjective case (voice, taste, tone) where no `ast.parse` exists. Load-bearing rule: **an agent may not be the final judge of its own subjective quality** — where no mechanical assertion is possible, the verdict comes from an independent signal (the human's actual reply, a shipped-vs-rejected outcome, a separate evaluator that never saw the drafting step), never from the producer self-scoring. The tell is the self-certifying headline ("quality wasn't the gap") emitted by the very component under review, which lets a correction go uncaptured while the next cycle invents a fresh externalizing theory. Practices: treat the verdict as an input not an output, read the real feedback and the real output before diagnosing, persist corrections to a durable ledger the producer reads every run, and cross-reference sibling loops instead of grading in isolation. Generalizes: a green self-review is worth as much as a green self-report — nothing, until an independent signal confirms it.

## 2026-07-17

### Added
- **When the orchestrator itself dies** (`docs/harness/night-work-pipeline.md`) — extends the night-work pipeline past its "agent reaches the completion sweep" assumption to the nastier case where the orchestrator crashes mid-flight and cannot run its own finalizer. Load-bearing rule: **a completion guarantee must live outside the thing it guards.** Ship two external, orchestrator-independent checks on their own schedule: an idempotent `mark-failed --if-running` finalizer that heals markers stuck at `running` past a staleness window (no-op once terminal), and a launch-confirmation sweep that fails loudly and names any planned unit that produced neither a log nor a recorded skip (the silent-drop case invisible to checks that only inspect units that ran). Traps: a start-time process id is the launcher, not the work, so use marker freshness for liveness; and build the sweep with witnessed red→green evidence plus pos/neg self-tests, or a finalizer that never fires just looks like coverage. Generalizes: any autonomous agent that can die silently needs an external observer to close its books.

## 2026-07-15

### Added
- **The dispatch contract** (`docs/night-work.md`) — hardens unattended background-job handoff so a run can never report green while doing nothing. Six rules: write a liveness receipt before any external side effect (so QA can tell never-started from started-and-failed), forbid detached `nohup`/`&` launches in favor of supervised exec with recoverable process ids, pass agent prompts via files not shell quoting, make cross-model fallback part of the dispatch path rather than a manual retry, require a written build→next-stage handoff receipt, and alert on the first failed run instead of waiting for two. Encode it as a mechanical regression check so a skipped receipt or forbidden launch fails loudly.

## 2026-07-09

### Added
- **Make "done" falsifiable** (`docs/self-improvement.md` §10) — documents the discipline of turning a completion claim into machine-checkable assertions (file exists / parses / min-bytes / command exits 0) and gating every surface that reports "done" (agent wrappers, background crons, the chat loop) with the same verifier. The load-bearing rule: a red gate overrides a green agent — if the agent exited 0 but the check failed, the run is NOT done and the wrapper returns a distinct failure code. A cheap universal syntax-parse of every changed file kills the whole "literal `\n` / truncated file" class that reads clean in a diff and explodes at import. Every blocked claim logs to an append-only scorecard (system-vs-human catch rate). The proof it works is adversarial: watch it reject a deliberate fake-success. This is the executable end of the Toil/Anomaly graduation (§2).

## 2026-07-07

### Added
- **Absorb the pattern, not the dependency** (`docs/self-improvement.md` §9) — documents the discipline of reimplementing a useful third-party tool's *pattern* against your own primitives instead of installing the whole pack. Separate the idea (the transformation it performs) from the packaging (hosted service, plugin runtime, dependency tree, data-sharing boundary); if your standard stack can express the transformation, own it as a small portable script rather than importing an external failure mode. Not anti-external dogma — the point is to make it a choice, defaulting to absorption and only taking the dependency when the packaging itself is the hard part. Credit the source and record the choice so a future session doesn't re-import the dependency.

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
