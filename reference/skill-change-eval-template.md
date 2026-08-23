Skill, workflow, and orchestration changes that ship without verification leave regressions invisible until they fire in production. This template is the eval artifact that closes that gap: a minimum-shape report you produce alongside any change to a skill, core workflow, prompt template, or cron policy that future agents will rely on as infrastructure. It pairs directly with the repo's PR template — which asks contributors to confirm an eval artifact link exists for skill or core-workflow changes — by giving you the artifact to link. The rule is short: no document of this shape → the change is not Done. Style matches the rest of `reference/`: direct, practical, no marketing.

# Skill / Core-Workflow Change Eval Template

Minimum eval shape for any change to a skill, core workflow, orchestration playbook, prompt template, cron policy, or other operating rule that future agents will rely on as infrastructure. No artifact following this shape → the change is not Done. See SOUL.md, AGENTS.md, and `reference/sop-agent-task-workflow.md` for the rule. Source regressions: REG-032, REG-034.

A heavier complement to `reference/eval-artifact-template.md` — use this one for skill/core-workflow surfaces specifically.

## Header

- **Change under test:** one-line description + links to changed files / commits / PRs / ticket.
- **Surface class:** skill | core workflow | orchestration playbook | prompt template | cron policy | other.
- **Linked ticket:** <TICKET-ID> (or N/A + reason). Example shown below uses a Linear-style ID for clarity; substitute your issue tracker's format.
- **Fault side (if this change fixes a failure):** which component was actually at fault — `model` | `harness` | `memory` | `tool` | `grader` | `owner` | `environment`. State the interaction edge + fault side, e.g. `tool—model · fault:harness`. Route the repair to that component; do NOT patch a harness/tool/grader fault with a model-side prose reminder (that class of fix cannot work). Source: Raj et al., "Model or Harness?" (arXiv:2607.28802). See your regression log's fault-localization convention.

## Task Set

At least 3 representative tasks the skill / workflow should handle. Pick tasks that exercise the *changed behavior*, not generic happy paths. State each task in one sentence.

1. …
2. …
3. …

## Baseline vs New

For each task, record what the *old* version did and what the *new* version does. If a real A/B isn't possible (cost, quota, time), simulate the reasoning and say so explicitly — never silently substitute a thought experiment for a run.

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| 1 | … | … | … |
| 2 | … | … | … |
| 3 | … | … | … |

## Metrics

Pick what fits the surface. Don't over-instrument:

- Task success (pass / partial / fail per task)
- Latency (wall-clock per task; per-lane if a council)
- Cost (tokens / $ if material)
- Qualitative verdict (1–2 sentence judgement on whether the new behavior is actually better)

## Grader / Eval-Fault Check (MANDATORY before verdict)

Before blaming the agent for any failed task, ask: **is the eval itself wrong?** Tag each failure fault-side. If `fault:grader` (broken success criterion, spec-gaming the check, flaky/wrong fixture, `fault:environment`) the repair is to **fix the eval, not the agent** — record that and do not tune the agent to a broken grader. Green ≠ correct; a passing broken grader is still a grader fault. Only failures with `fault:model` / `fault:harness` / `fault:memory` / `fault:tool` justify an agent-side change.

## Verdict

One of: **ship** | **iterate** | **rollback**.
- ship — keep the change as-is.
- iterate — keep but with named follow-up fixes (list them in Gaps + Fixes).
- rollback — revert the change; the new version is worse than the baseline on the task set.

**Untested surface (MANDATORY):** before the verdict, state in one or two lines what this eval did NOT exercise — scenarios not run, assumptions simulated rather than tested, behavior under load/edge/adversarial input left unchecked. A change that goes "green" on a thin task set is satisfying the verifier, not proven correct (green ≠ correct). Naming the blind spot is required for ship/iterate verdicts.

## Artifact Path

Where the raw eval run output lives — fixtures, transcripts, JSON snapshots, model outputs. Inline the path even if the evidence is also embedded above; future agents grep by path.

## Sign-off

- Run by: human / agent name + model
- Date: YYYY-MM-DD
- Linked from: change PR / ticket / regression entry

## Risk-Specific Additions

Add these checks when the changed surface carries the matching risk:

- **Validators, scanners, and alerts:** state the expected false-alarm cost and who pays it. A noisy guardrail trains people to ignore the real signal, so precision is part of the specification.
- **Human-facing writing:** grade against fixed golden exemplars and a stable rubric. A paired rewrite comparison alone can show that one draft is better than another without proving either draft meets the real quality bar.

---

## Example (filled-out, retroactive)

This section shows the template applied to a model-council orchestration upgrade. Full doc would live under `reports/evals/<your-run>.md`.

### Header
- **Change under test:** Quick Council vs Canvas Council modes added to model orchestration; new dedicated `skills/model-council/SKILL.md`. See the linked upgrade report.
- **Surface class:** skill + orchestration playbook.
- **Linked ticket:** <TICKET-ID> (gate codification); originating change tracked under REG-032.

### Task Set
1. Pick the next autonomous night-work target from the active project queue (your issue tracker).
2. (Optional follow-ups for future runs: pick an architecture-review target; pick a content angle for a technical post.)

### Baseline vs New
| Task | Baseline ("ask 3 models the same prompt") | New (Quick / Canvas + adversary) | Delta |
| --- | --- | --- | --- |
| Pick night-work target | Three polished summaries that average toward a safe pick; no visible disagreement | Role-specific briefs surface a real objective-function fork (compounding leverage vs shippability vs safety); adversary picks a target with named cruxes and a flip condition to a second target | Disagreement preserved + decision committed instead of averaged |

### Metrics
- Task success: PARTIAL PASS — adversary produced a committed verdict; 2 of 7 lanes timed out.
- Latency: Canvas ~30–60 min target met for completed lanes; one role and one Quick lane exceeded budget.
- Qualitative: New pattern exposes the real fork; baseline would have produced "all three are reasonable, pick one."

### Verdict
**iterate** — ship the pattern, but add per-lane timeout budgets and fallback rules in `skills/model-council/SKILL.md` before treating the upgrade as closed.

### Artifact Path
`reports/evals/model-council-quick-vs-canvas-<date>.md` (raw run) and `reports/evals/model-council-upgrade-<date>.md` (this template applied retroactively). Fixture: `reports/evals/model-council-active-snapshot-<date>.json`.

### Sign-off
- Run by: agent name + model (e.g., Opus 4.7 main session, retroactive)
- Date: YYYY-MM-DD
- Linked from: <TICKET-ID>, REG-034, change-upgrade report.
