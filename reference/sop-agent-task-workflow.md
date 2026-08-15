# SOP: Agent Task Workflow

Structured workflow for agent-executed tasks in this workspace. This adapts the Veritas-style Kanban pattern into a simple operating rule: claim the task, do the work, close it with review and learning captured.

## Why This Exists

Without explicit workflow state, agent tasks rot in chat, review gets skipped, and the same mistakes repeat. The board is the contract.

## Lifecycle

### 1. Claim

Before work starts, the task must have:

- `claimedBy` set to the owner driving the task
- `executorModel` set to the model doing the implementation
- acceptance criteria or a scoped description

Claim means "someone owns the outcome," not just "someone looked at it."

**Premortem gate (high-stakes plans only):** before a task backed by a PRD/FRD or other high-stakes plan moves into implementation, run a premortem (structured red-team: "it's six months later and this failed — why?") on the plan and keep the transcript as an artifact. Copy the resulting risks and assumptions into the plan's Risks section. No premortem, no build. This applies wherever the cost of being wrong is high: feature launches, pricing changes, architecture pivots, hires, partnerships. Bug fixes, maintenance, and quick turnarounds are exempt.

### 2. Work

During execution:

- keep status in `in-progress`
- append progress notes or comments on meaningful changes
- attach artifacts when they exist: commits, files, reports, screenshots
- for schema / migration / identity-normalization diffs, attach a visual diff recap by default — a rendered summary of the diff makes it reviewable at a glance and surfaces invariant/blast-radius risk. On-demand only for logic-only or small diffs.
- if the executor is an agent, keep the human or reviewer visible in the task metadata

The executor model writes. The board records the evidence.

### 3. Complete

A task is not complete when code exists. It is complete when:

- a reviewer has checked it
- review status is approved
- lessons learned are captured
- the task is moved to `done`

If review finds issues, move it back to `in-progress` or keep it in `review` with `changes-requested`.

### Skill / Core-Workflow Eval Gate (mandatory)

Any change to a `skills/*/SKILL.md`, a workflow reference doc, an orchestration playbook, a prompt template, a cron policy, or another core operating rule is **not Done** until an eval artifact exists (see `reference/skill-change-eval-template.md`) and is linked from the change note. The artifact must include: change under test, a ≥3-task task set, baseline vs new behavior, metrics, a verdict (ship / iterate / rollback), the artifact path, and sign-off.

No eval artifact linked → the task cannot move to `review` or `done`. Ship-without-eval on these surfaces is a regression — log it. If a real run is impossible right now (quota, time, external dependency), mark the change `[provisional]`, file a dated eval TODO with an owner, and link it from the change note — never silently treat docs-updated as done.

Applies to agent-driven and human-driven changes alike.

## Cross-Model Review

Default pattern:

- one model writes
- a different model reviews

Recommended pairings:

- Claude writes, Codex reviews
- Codex writes, Claude reviews
- Human writes, agent reviews
- Agent writes, human reviews for high-risk changes

The reviewer should challenge correctness, regressions, tests, and scope creep. "Looks fine" is not review.

## Goal-Mode Auto-Routing (Long Coding Runs)

When a coding-agent task is expected to run long (>2h wall-clock) OR has a linked spec with explicit scope, acceptance criteria, and invariants, default the executor to a **goal/constraint workflow** (e.g. Codex `/goal`, or a wrapper that prepends a canonical constraint preamble to `codex exec`) rather than a plain prompt. The goal spec carries: scope = files in play, gating tests = the verification commands, invariants = what must not break. The constraint preamble keeps scope and gating tests honored across turns.

Skip goal mode and use a plain prompt when: expected runtime <30 min, no verifiable gating test exists, scope spans multiple repos, or the task is drafting/brainstorming rather than a code change.

Autonomous promotion flow: when an unattended scheduler moves a ticket to in-progress, if the ticket references a spec or plan artifact, generate the goal-spec file from it and launch in goal mode; otherwise fall back to the standard prompt flow.

Hard rule: do not mix goal mode with plan mode in the same Codex session (known upstream stall, issue #20656).

## Validation Gate (Post-Build, Pre-Present)

After any coding agent completes, Claw runs a **validation agent** before presenting results to the operator. This is the mechanical enforcement of cross-model review.

**Flow:** Build agent completes → Claw spawns validation agent (opposite model) → structured JSON verdict → Claw acts on verdict.

**When to run:** All night work tasks, all coding agent spawns during sessions. Skip for research/content subagents and trivial single-file edits.

**Verdicts:**
- `PASS` (completeness ≥85, no P0) → present to the operator with ✅ badge
- `PASS_WITH_ISSUES` (completeness ≥70, no P0) → present with issues callout
- `FAIL` (completeness <70 or any P0) → auto-retry once (night work) or escalate (session work)

**Full spec:** `reference/validation-agent-spec.md` — includes prompt template, output schema, model routing, and escalation protocol.

**Ledger tracking:** Every coding task row in `memory/subagent-ledger.md` should include a Validation column: `✅ PASS` / `⚠️ PASS_WITH_ISSUES` / `❌ FAIL` / `⏭️ skipped`.

## Required Metadata

Every board task should carry these fields once it is active:

- `claimedBy`
- `executorModel`
- `reviewerModel`
- `reviewStatus`
- `lessonsLearned`

Recommended values:

- `claimedBy`: operator, claw, or named owner
- `executorModel`: `codex`, `claude`, `claw`, `human`
- `reviewerModel`: different from executor when possible
- `reviewStatus`: `not-started`, `pending`, `approved`, `changes-requested`

## Enforcement Gates

### Move to `in-progress`

Required:

- claimed owner
- executor model

### Move to `review`

Required:

- claimed owner
- executor model
- reviewer model
- at least one piece of evidence in the task: link, artifact, or progress comment

### Move to `done`

Required:

- review approved
- lessons learned captured

## Lessons Learned Rule

Every completed task must leave a learning trail.

Minimum:

- one short `lessonsLearned` note on the task

If the lesson is reusable beyond the task:

- also log it via your learning-capture path if you keep one

That is the difference between finishing work and improving the system.

## Review Checklist

The reviewer checks:

- does the change satisfy the task description
- are tests or validation steps present
- are risks and regressions called out
- are artifacts linked
- is the lesson worth promoting to a reusable rule or memory file

## Anti-Patterns

- starting work from `inbox` with no claim
- same model writes and rubber-stamps its own output
- moving to `done` with no review metadata
- closing tasks without lessons learned
- leaving important progress only in chat instead of the task card
