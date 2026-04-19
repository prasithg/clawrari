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

### 2. Work

During execution:

- keep status in `in-progress`
- append progress notes or comments on meaningful changes
- attach artifacts when they exist: commits, files, reports, screenshots
- if the executor is an agent, keep the human or reviewer visible in the task metadata

The executor model writes. The board records the evidence.

### 3. Complete

A task is not complete when code exists. It is complete when:

- a reviewer has checked it
- review status is approved
- lessons learned are captured
- the task is moved to `done`

If review finds issues, move it back to `in-progress` or keep it in `review` with `changes-requested`.

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
