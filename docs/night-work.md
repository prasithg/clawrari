# Night Work

Night work is where Clawrari shifts from reactive assistant to background operator.

The purpose is simple: wake up to finished work, not to a blank queue.

## What Night Work Is For

- queued coding tasks
- research batches
- memory maintenance
- failure review
- config drift repair
- missing test coverage
- content preparation for the next day

## What Night Work Is Not For

- sending people messages without approval
- noisy alerts for non-urgent problems
- endless retry loops
- hiding failures

## The Operating Pattern

1. Read `tasks/queue.md` or equivalent queue source.
2. Pick the highest-priority executable item.
3. Decide whether it is a coding job, a research job, or a maintenance job.
4. Spawn the right worker.
5. Log status into the daily file and the subagent ledger.
6. Continue until the queue is exhausted or a safety valve trips.

## Recommended Worker Split

Coding jobs:

- primary: Claude Code or Codex via wrapper scripts
- fallback: the other coding agent if the first path fails quickly

Research and synthesis jobs:

- isolated sessions or sub-agents with explicit output paths

Maintenance jobs:

- main runtime or lightweight sub-agent, depending on scope

## Safety Valves

Night work should be productive, not runaway.

Recommended limits:

- max continuous work block per session
- max consecutive failures before pausing
- timeout for any single task with no progress
- explicit logging before every stop

## High-Value Recurring Night Work

- audit active projects for missing tests
- reindex local memory if stale
- process idea inboxes into research or tasks
- clean stale background-agent entries
- run weekly model freshness and tool version checks
- prep tomorrow's briefing inputs

## Logging Rules

Every meaningful overnight action should leave:

- what ran
- where output landed
- whether it completed, blocked, or failed
- what the next session should do

At minimum, log to:

- `memory/YYYY-MM-DD.md`
- `memory/subagent-ledger.md`

## Model Playbook Link

Night work is also where model routing discipline matters most.

Use the model playbook to decide:

- which model is worth paying for
- which model is fast enough for background execution
- when to switch from one family to another

That keeps the overnight loop efficient instead of expensive guesswork.
