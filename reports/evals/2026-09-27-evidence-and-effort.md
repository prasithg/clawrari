# Documentation Eval: Evidence, Shared Work, and Effort

## Header

- **Change under test:** two additions and one clarification in [Self-Improvement](../../docs/self-improvement.md), plus a targeted refresh of the [model effort ladder](../../reference/model-playbook/effort-ladder.md).
- **Surface class:** documentation and orchestration playbook.
- **Linked ticket:** N/A; scheduled capture of existing operational improvements.
- **Fault side:** shell redirection and writer-completion checks belong to the harness; taking other writers' work belongs to execution discipline. Effort selection cannot repair an incorrect specification.
- **Evidence mode:** manual synthetic walkthroughs. No live agent comparison or runtime benchmark is claimed.

The source work repaired a dry-run capture path, connected a size audit to its writer, and revised effort guidance after a shared-workspace incident. This public evaluation reviews the generalized documentation. Private records, inputs, identities, and service details remain outside the repository.

## Task Set and Baseline vs New

### Dry-Run Cases

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| A wrapper skips its collector, but the caller redirects output | Fixture and live evidence are distinguished; shell-created captures are not explicit | Branch before opening the result destination; print only the plan | Consistent; skipped work has no measurement |
| A dry run points at an existing capture | No explicit preservation check for the skipped capture path | Verify the existing bytes remain unchanged and the collector is never called | Consistent; absence of execution cannot authorize truncation |
| A real capture finds no items | An empty artifact could be confused with a skipped measurement | Accept a valid empty result only from an executed capture under its format contract | Consistent; no fabricated success object |

### Shared-Workspace Cases

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| A baseline test needs a clean checkout while other agents are writing | The branch guidance warns that automatic stashes can damage other work | Use an isolated worktree or temporary copy; leave the shared changes present | Consistent; temporary removal is still interference |
| Isolation is unavailable | The baseline procedure is unspecified | Report the baseline as unrun instead of stashing the shared tree | Consistent; incomplete evidence stays explicit |

### Size-Limit Cases

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| A small file change pushes combined startup input over its limit | Periodic self-audit exists; responsibility at write completion is implicit | Measure the full configured input set and fail workflow completion with total, limit, and contributors | Consistent; a small changed file can exceed a shared budget |
| The post-write audit detects an oversized result | A failed check could be mistaken for a prevented write | Report detection after mutation; do not claim prevention or automatic rollback | Consistent; persisted state and workflow verdict are separate |
| The audit cannot obtain a measurement | No explicit unavailable-measurement outcome | Report unverified; retain periodic auditing and investigate the unavailable check | Consistent; unknown does not mean within budget |

### Effort Cases

This is the only mapped artifact refreshed. Only the effort ladder within the model-playbook directory changes. Model rosters, provider defaults, and unrelated differences are left alone.

| Task | Baseline guidance | Updated decision | Review result |
| --- | --- | --- | --- |
| A parser repair has many edge cases | The effort table names complex work without a failure-mode question | Use higher effort with explicit boundary and failure cases | Consistent; effort is connected to a verification need |
| A feature is built against an uncertain requirement | Increasing effort could appear to resolve uncertainty | Improve the specification or obtain independent review first | Consistent; more computation does not prove the premise |
| An operator can steer a bounded, well-specified feature | Substantial coding has one undifferentiated default | Use medium for implementation and a separately specified stronger verification pass | Consistent; required checks and consequential decisions remain |
| A substantial task runs unattended | A phase split could be mistaken for a universal downgrade | Retain the stronger default, authority boundaries, and acceptance evidence | Consistent; higher effort is not permission or proof |

## Metrics

- Manual documentation walkthroughs: 12 reviewed; 12 consistent with the stated decisions.
- Implementation tests executed for these patterns during this evaluation: 0.
- Live agent comparisons, production writes, or collector trials for this evaluation: 0.
- Public scope: three edited documents and this evaluation.
- Qualitative result: the guidance distinguishes planned work from measurements, write detection from prevention, and effort policy from measured performance.

## Grader / Eval-Fault Check

These walkthroughs inspect the decisions supported by the prose. They cannot establish runtime enforcement or agent compliance. No passing source test is reclassified as proof of the public implementation, and no historical failed run is rewritten.

For size checks, a bad measurement can block a valid writer; the maintainer pays the investigation cost. Distinguish an unavailable audit from an actual overage, and use the same defined input set and counting method at the writer and periodic audit. No new alert or runtime check is installed by this publication.

## Publication Checks

The private publishing receipt records added-text privacy review, relative-link and heading-target checks, pending-file ownership, and the mandatory secret scan. The publishing guard must verify that the remote branch contains the committed revision before publication is reported complete.

## Untested Surface

No public runtime implementation changed. Shell behavior under the documented repair, concurrent writers, atomic size enforcement, and compliance by delegated agents were not exercised here. The effort split has no new measured quality, latency, or cost comparison. Other model-playbook differences remain on the publishing backlog.

## Verdict

**ship** the documentation and targeted effort-ladder refresh, subject to the publication checks. This verdict covers the written guidance; runtime acceptance and comparative performance remain separate.

## Artifact Path

The synthetic inputs and expected decisions are the twelve rows in this file: `reports/evals/2026-09-27-evidence-and-effort.md`. The [changelog](../../CHANGELOG.md) links this evaluation. Private source records remain outside the public repository.

## Lessons Learned

An output file is evidence only when its producing operation ran. A post-write failure does not erase the write. Isolate comparisons before disturbing shared state, and use extra effort to investigate a named failure mode.

## Sign-off

- Run by: GPT-6 documentation agent.
- Date: 2026-09-27.
- Linked from: changelog, Self-Improvement, and the effort ladder.
