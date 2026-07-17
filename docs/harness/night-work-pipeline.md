# Night-Work Pipeline

Unattended work fails in a predictable way: an agent starts a task, hits a wall, and either spins or stops without saying so. The next morning you find a blank queue and no idea what happened. The pipeline pattern fixes this by giving every task the same skeleton with logging and a stop condition baked in.

The skeleton is four stages, run in order:

1. **Plan**: restate the task as a minimal plan and write down what success looks like.
2. **Build**: do the work.
3. **Test**: run the narrowest meaningful gate (lint, unit tests, a build, the regression suite).
4. **Completion sweep**: verify the work is finished, instead of trusting that the build stage exited zero.

The fourth stage is the one people skip, and it is the one that earns its keep. A build can exit cleanly while leaving the task half-done. Think of a function that was written but never called, or a doc that was added without a link from anywhere, or a test that passes only because it asserts nothing. The sweep stage is where you check the work against the plan's success criteria before declaring victory.

## What the scaffold does

`scripts/night-work-pipeline.sh` owns three things so your stage hooks do not have to: ordering, logging, and safety valves.

Each stage is a hook script you provide (`plan.sh`, `build.sh`, `test.sh`, `sweep.sh`) in a stage directory. A missing hook is a no-op pass, so you can adopt the pattern one stage at a time. Each hook receives `NW_TASK`, `NW_LOG`, `NW_LEDGER`, and `NW_STAGE` in its environment, and signals failure with a non-zero exit.

The pipeline logs every stage transition to a daily log and writes start, done, and failure rows to an append-only ledger. That is what makes a stalled run visible at the next session start instead of four sessions later.

The safety valve is `NW_MAX_FAILS` (default 1): after that many stage failures, the pipeline aborts, writes a failed ledger row, and exits non-zero. No retry loops, no silent spinning.

## Running it

```bash
# dry run prints what would happen without executing hooks
scripts/night-work-pipeline.sh --task "PORT-12 memory docs" --stage-dir ./stages --dry-run

# real run
scripts/night-work-pipeline.sh --task "PORT-12 memory docs" --stage-dir ./stages

# confirm the scaffold works before wiring a cron
scripts/night-work-pipeline.sh --selftest
```

Point `NW_LOG` and `NW_LEDGER` at your workspace memory files so the run lands where the next session reads first. Defaults write to `memory/<today>.md` and `memory/subagent-ledger.md`.

## Why stages instead of one big script

Splitting a task into named stages gives you three things a monolith does not. You get a precise failure location in the ledger ("aborted at stage=test") instead of a generic crash. You can dry-run the ordering without running the work. And the test and sweep stages become a forcing function: the pattern itself asks "did you verify this?" every single run, which is exactly the question an unattended agent is most likely to skip.

## When the orchestrator itself dies

The completion sweep above assumes the pipeline reaches the sweep stage. But there is a nastier failure mode: the orchestrator that runs the pipeline can die mid-flight — a crashed prompt-driven agent, a killed process, an out-of-memory event. A dead orchestrator cannot run its own finalizer. Any guarantee you bake into the agent ("on exit, mark the run failed and log why") evaporates exactly when you need it, because the code that would run it is the code that just died.

The symptom is quiet and expensive: a run marker frozen at `status: running` forever, planned units of work silently dropped with no log, no skip, and no crash. From the outside it looks like nothing happened, and you cannot tell a stalled run from a run that simply had nothing to do.

The fix is a rule: **a completion guarantee must live outside the thing it guards.** Put finalization and launch-confirmation in a separate, dumb, external sweep — a small script on its own schedule that does not depend on the orchestrator being alive.

Two checks earn their keep:

1. **Terminal-state finalizer.** An idempotent `mark-failed --if-running` that flips any marker stuck at `running` past a staleness window (e.g. 30 minutes with no heartbeat) into a terminal `failed` state, and is a no-op if the marker already reached `done` or `failed`. This heals the frozen-marker case without racing a still-live run.
2. **Launch confirmation.** For every unit the plan said it would attempt, assert that it produced either a per-unit log or a recorded skip. If a planned unit has neither, fail loudly and name the unit — that is the silent-drop case, and it is invisible to any check that only inspects units that did run.

Two traps to avoid:

- A process id captured at start is not a liveness signal. It belongs to the short-lived launcher, not the long-running work, so "is that pid alive?" answers the wrong question. Use marker freshness (last heartbeat vs. now) instead.
- Build the external sweep with witnessed red→green evidence and positive/negative self-tests. A finalizer that never fires because its staleness window or state matching is subtly wrong is worse than none, because it looks like coverage.

The general principle generalizes past night work: **any autonomous agent that can die silently needs an external observer to close its books.** Self-cleanup is a best-effort convenience; it is never the guarantee.

See [Night Work](../night-work.md) for the broader operating doctrine this pipeline sits inside, and the [Regression Suite](regression-suite.md) for what a good test stage calls.
