# Self-Improvement

Clawrari is built around the idea that an assistant should improve through use, not just through re-prompting.

This happens through a few connected loops.

## 1. RLHF Channel Pattern

The simplest useful feedback loop is a dedicated review channel.

Pattern:

1. The assistant posts summaries, drafts, alerts, or findings to a review channel.
2. The human replies with corrections, approval, or sharper instructions.
3. The assistant acknowledges the message, applies the correction, and records the durable lesson.

What gets promoted:

- style corrections into `SOUL.md` or `USER.md`
- workflow corrections into `AGENTS.md` or `HEARTBEAT.md`
- repeated mistakes into `memory/regressions.md`
- project facts into the appropriate memory file

The key is that feedback changes the operating system, not just the current output.

## 2. Failure-to-Guardrail Pipeline

A failure should either be fixed or turned into a named safeguard.

Recommended flow:

1. Failure gets logged.
2. Root cause is described in plain language.
3. If the pattern is reusable, promote it into a regression or rule.
4. Future sessions load that guardrail automatically.

This is how the system gets harder to break over time.

## 3. Semi-Automatic Learning Capture

Clawrari prefers semi-automatic promotion over blind self-editing.

Good capture candidates:

- user corrections
- stale or broken connector behavior
- recurring shell or tool mistakes
- formatting failures
- routing mistakes between models

Good promotion targets:

- `SOUL.md` for behavior
- `AGENTS.md` for workflow
- `TOOLS.md` for operational gotchas
- `memory/regressions.md` for failure patterns

## 4. Weekly Model Freshness Checks

Model routing goes stale faster than most people think.

Run a weekly review that checks:

- new model releases
- deprecations
- context window changes
- prompt-style quirks
- cost/performance tradeoffs

Clawrari uses a model playbook so switching models means changing a routing file and an overlay, not rewriting the whole workspace.

## 5. Auto-Optimize, but with Review

Clawrari supports benchmarking prompt or workflow improvements before adopting them.

The principle is:

- capture candidate improvement
- test it on representative tasks
- compare it to the current baseline
- promote only if the gain is real

This avoids the common trap where an assistant "self-improves" by thrashing its own instructions.

## 6. Night Work as Improvement Time

Night-time automation is not only for queued feature work.

It is also the best time to:

- reindex memory
- audit config drift
- review failures
- add missing tests
- clean stale docs
- process ideas and notes into durable artifacts

Night work should leave a trail in the daily log so the next main session can pick up cleanly.

## Governance Rules

- Not every signal deserves promotion.
- External behavior changes should remain reviewable.
- Durable changes need provenance.
- Rollback should be easy.
- The system should prefer better defaults, not more complexity.

## Minimal Review Checklist

Before promoting a learning, ask:

1. Was this a one-off or a pattern?
2. Does it belong in memory, behavior, or tooling?
3. Will this still help in two weeks?
4. Is the change safe to apply automatically?
5. Can a human inspect and undo it easily?

That discipline is what keeps self-improvement useful instead of chaotic.
