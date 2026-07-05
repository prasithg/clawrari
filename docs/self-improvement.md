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

### Graduation: tripwire vs executable procedure (Toil vs Anomaly)

Not every guardrail belongs in the regression log. A regression is a *tripwire* — it detects. A skill is an *executable procedure* — it remediates. The lever that matters is **executability, not which file it lives in**: a fix written as prose to be re-read by a busy agent is a reminder, and reminders decay.

Classify a failure at the first postmortem:

- **Toil / mechanical** — a missing deterministic step (a tool call, a commit+push, an env/auth setup, a path assertion). Promote it to an **executable skill immediately, on the first occurrence**. The skill runs the step and *verifies the outcome*; it never just reminds someone to do it.
- **Anomaly / cognitive** — a reasoning, judgment, or hallucination error. Log it as a regression tripwire. On recurrence, force an **architectural gate** (a test, validator, or pre-flight assertion), not another reminder.

Keep the regression log small and high-signal (prune, compile to lints, or collapse a recurring family into a single tripwire). A tripped tripwire should emit the exact command to run its remedial skill. **The same mechanical failure reappearing as new regressions is the signal that the system failed to graduate it to a skill.**

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

## 7. Periodic Workspace Self-Audit

Self-improvement loops fix things as they break. But a long-running workspace also accumulates *debris* that no single failure ever trips: bloated ledgers, references to retired models stated as if live, a duplicated or stale index, a skills catalog diluted by thin wrappers, config drift, and root-directory clutter. None of it throws an error — it just quietly degrades every session's boot context and recall.

Run a structured audit on a cadence (monthly is a reasonable default) across a fixed set of dimensions, for example:

- **Context / boot** — is startup context lean and true, or is it pointing sessions at stale or non-injected files?
- **Skills** — is the catalog high-signal, or diluted by near-duplicate wrappers and name collisions?
- **Memory** — are logs rotating, or growing unbounded? Is there a single canonical index, or has it forked?
- **Regression ledger** — still a tight, high-signal tripwire set, or bloated past the point of usefulness?
- **Sandbox / env** — do the runtime flags match the documented config, or has a deprecated flag silently overridden it?
- **Root hygiene** — how many loose files accumulated? Archive, don't delete.

### The load-bearing insight

The first time you run this seriously, the finding is usually counterintuitive: **the system is structurally sound. The doctrine and guardrails already exist. The debts are accumulated debris and execution cadence, not missing rules.**

That reframes the fix. The temptation on finding a problem is to write another rule. But if the rule already exists and the failure still happened, the gap is *enforcement or cleanup*, not *authorship*. Prefer: prune the ledger, archive the clutter, script the rotation, delete the stale reference, add a mechanical assertion — over writing a new paragraph nobody will re-read.

Every fix in an audit should be reversible (archive, don't delete), evidenced (cite the file/command that proves it landed), and where possible converted into a standing check so the debris can't silently re-accumulate.

## 8. Refreshing a Curated Artifact Without Overwriting It

Some artifacts are living distillations — a personal opinions/positions file, a voice guide, a set of operating principles. They should evolve as the system accumulates new activity, but they are also load-bearing and easy to corrupt with a bad automated rewrite. The failure mode is a well-meaning refresh job that silently overwrites a hand-curated file with lower-quality regenerated content.

The safer pattern is **draft-only extraction with drift classification against a versioned baseline**:

1. **Extract repeatably from local sources.** Read recent, already-captured local material (date-named notes, cached samples) rather than hitting live APIs. Repeatability and zero external cost matter more than freshness here — you want the same command to produce the same review artifact.
2. **Classify each candidate against the current baseline**, not in a vacuum. Label every extracted item as `REFINEMENT` (sharpens an existing entry), `NEW` (a genuinely new position), or `REVERSAL` (contradicts a prior stance). The reversal label is the most valuable — it surfaces where your own thinking has actually changed.
3. **Flag factual / time-sensitive risk.** Any candidate whose truth depends on a moment in time gets a risk flag so a reviewer knows not to enshrine a soon-stale claim.
4. **Emit a `v(n+1)-candidate` artifact, never a live overwrite.** Preserve the existing schema and headings, and mark which entries are carried over versus newly proposed. The current live file is untouched until a human promotes the candidate.

This keeps a self-refreshing artifact aligned with the governance rules below: the change stays reviewable, provenance is explicit (which run proposed what), and rollback is trivial because the live file never moved. Automate the *extraction and triage*; keep the *promotion* a human step.

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
