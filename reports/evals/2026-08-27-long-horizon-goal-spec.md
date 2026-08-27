# Long-Horizon Goal Spec Eval

## Header

- **Change under test:** add a reusable long-horizon goal-spec block to the public agent prompt template.
- **Surface class:** prompt template.
- **Linked ticket:** N/A — scheduled public-sync refresh.
- **Fault side:** `owner` — the public template covered bounded tasks but omitted the resumable execution contract used for longer work.

## Task Set

1. Implement a multi-module feature without changing adjacent public APIs.
2. Run a data migration that requires a dry run, an explicit publish step, and a rollback-safe stopping point.
3. Complete an unattended documentation rebuild that may hit a time limit and resume later.

## Baseline vs New

This is a static contract evaluation. Each representative task was checked against the template before and after the change.

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| Multi-module feature | General constraints and acceptance criteria, but no explicit in-scope/out-of-scope boundary | Requires a scope fence, invariants, and exact verification commands | Adjacent cleanup is separated from required implementation |
| Data migration | External writes and local verification could be mixed together | Required side effects are named and all other external writes are forbidden | Publish authority and completion evidence are explicit |
| Resumable rebuild | Persistence was defined, but time-box recovery was not | Requires a resumable progress record at the time limit and stable sources of truth | A later run can continue without silently restarting |

## Metrics

- Task success: 3/3 representative tasks expose scope, verification, invariants, and terminal conditions at the point of use.
- Completeness: all six goal-spec sections have a stated purpose and a fillable placeholder.
- Privacy review: no organization names, people, private URLs, internal identifiers, credentials, financials, or operator-specific commands appear in the change.
- Portability: the pattern names no model vendor, issue tracker, repository host, or proprietary harness.

## Grader / Eval-Fault Check

No model outputs were graded. This eval tests static contract coverage, so its main limitation is `fault:grader`: it cannot measure whether a particular agent obeys the contract under long context or tool failure.

## Untested Surface

This eval did not run live agents, measure completion rates, compare token use, or test recovery after an actual process interruption. It also does not prove that three retries is the right threshold for every environment.

## Verdict

**ship** — the added block closes a clear long-horizon execution gap without binding users to one model or harness. Run a paired live-agent eval before adding provider-specific syntax or automatic enforcement.

## Artifact Path

This file contains the full static evaluation. The changed surface is `reference/agent-prompt-template.md`.

## Sign-off

- Run by: scheduled public-sync agent.
- Date: 2026-08-27.
- Linked from: `reference/agent-prompt-template.md`.
