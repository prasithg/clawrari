# Activation, Branches, and Handoffs: Documentation Evaluation

## Header

- **Change under test:** two patterns in [Self-Improvement](../../docs/self-improvement.md#22-verify-service-activation-before-grading-a-change) and the [session handoff section](../../reference/agent-prompt-template.md#record-what-the-next-session-needs) of the public agent prompt template.
- **Surface class:** workflow documentation and prompt template.
- **Linked ticket:** N/A; scheduled capture of recent maintenance work and one existing-template refresh.
- **Fault side:** ambiguous tool inspection and unverified activation belong to the service-control environment and harness. Shared-checkout branch drift belongs to orchestration. Missing cross-system handoff fields belong to the delegation contract.
- **Method:** manual walkthroughs of synthetic scenarios against the previous and refreshed text. These evaluate instruction coverage through simulated decisions. No service, Git, or agent comparison was executed.

The recent source work repaired restricted-environment service inspection and added shared-checkout branch checks. Standing handoff guidance supplied the template refresh. Private logs, names, service addresses, account details, and internal issue references are excluded. No live control scripts or agent skills are ported.

## Task Set

1. Distinguish missing inspection tools from an absent service, reject an unchanged-process restart as activation proof, and handle a reload-only boundary.
2. Keep a shared checkout on its designated branch, detect conflicting worktree state, and distinguish detection from prevention.
3. Preserve a complete handoff for a cross-system change, a local-only change, and an incomplete task.

## Baseline vs New

### Activation cases

| Synthetic input | Previous documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A detached runner cannot find its inspection utility, then reports no listener | General completion guidance requires evidence but does not distinguish these states | Report inspection failure; do not infer service absence. Validate tool paths under the restricted environment. | Pass |
| A restart returns successfully, the process is unchanged, and health checks pass | General completion guidance lacks an activation prerequisite for grading a candidate | Reject the restart as activation evidence. Retain health output while marking it invalid for the candidate; inspect the control helpers and affected callers. | Pass |
| A service uses hot reload; its process identity stays stable | No restart-versus-reload boundary is stated | Use reload-specific activation evidence. A process-change check does not establish reload success, and a changed process alone does not identify loaded code. | Pass |

### Shared-checkout cases

| Synthetic input | Previous documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| An agent needs a task branch while several writers share the primary checkout | Shared-settings guidance covers concurrent restores, not checkout-wide branch selection | Use a separate worktree or clone and keep the primary checkout on the designated branch. Coordinate write scopes for any remaining shared edits. | Pass |
| The primary checkout is detached, another worktree holds its designated branch, or inspection fails | No explicit shared-checkout invariant or inspection-failure distinction | Report the offending state or inspection failure; preserve other writers' work before reconciliation. | Pass |
| A warning hook fires after a branch switch; unrelated worktrees remain valid | Hook guidance covers tracked enforcement but not this warning-only boundary | State that the hook warns and the scheduled assertion detects later. Keep unrelated worktrees as valid controls; neither check serializes writes. | Pass |

### Handoff cases

| Synthetic input | Previous documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A local schema edit changes a contract consumed by another repository | Handoff requests decisions, surprises, tests, and remaining work, without an explicit cross-system field | Record affected consumers and the changed contract under state changes, plus all files touched. Do not imply the note proves deployment or delivery. | Pass |
| A local-only change has complete tests and an existing handoff note | No explicit no-impact value or complete field set | Write `None` for cross-system effects and put the required fields in the existing durable handoff. No duplicate episode file is required. | Pass |
| Work stops with a known missing verification step | Existing checklist requires test gaps and remaining work; it does not define their actionability | Name the next action and relevant file, component, or acceptance criterion. Record commands actually run and leave the verification gap explicit. | Pass |

## Metrics

- **9 of 9 manual scenarios** have an explicit decision in the refreshed text. This is documentation coverage, not a runtime success rate.
- Exactly one mapped public artifact is refreshed: the agent prompt template.
- Two recent-work patterns are distilled into the existing Self-Improvement document.
- No service restart, branch change, live agent dispatch, or cross-system notification is performed by this evaluation.
- Latency and cost are not grading criteria for this documentation update.

## Grader / Eval-Fault Check

Each walkthrough checks the resulting decision, including failure boundaries. A successful health response cannot establish activation. A warning cannot establish prevention. A completed handoff cannot establish delivery to another agent.

The handoff baseline already required test results and remaining work. The improvement is the explicit field set, complete file inventory, cross-system effects, and actionable continuation; it is not the invention of handoffs.

**False-alarm cost:** no live alert is added. An implementation should distinguish inspection failure from branch drift or service absence. Otherwise the operator pays for needless recovery, and an automatic repair may disrupt other writers.

## Untested Surface

These are manual documentation checks. No live activation identity, revision-reporting mechanism, concurrent Git writer, hook installation, worktree recovery, agent handoff generation, or cross-repository consumer update was exercised. Public instructions do not certify the source implementations.

## Verdict

**Ship** the documentation and bounded template refresh. The text covers the observed failures and names the limits of its evidence without publishing private operational material.

## Artifact Path

`reports/evals/2026-09-15-activation-branches-and-handoffs.md` contains the synthetic inputs, baseline comparisons, decisions, and walkthrough results.

## Sign-off

- Run by: Codex, GPT-6.
- Date: 2026-09-15.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-15), Self-Improvement, and the agent prompt template.
