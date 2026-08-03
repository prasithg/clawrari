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

**Guard the guardrail.** "Keep the ledger pruned" fails the moment it depends on a human remembering to prune. So make the pruning rule itself a machine assertion inside the ledger: a duplicate or colliding tripwire ID trips, and a hard size cap trips, exactly like any other tripwire. The list that catches your regressions must catch its own bloat, or it silently grows past the point where anyone reads it — and an unread ledger is a dead ledger.

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

## 9. Absorb the Pattern, Not the Dependency

When you encounter a useful third-party tool, skill pack, or service, the reflex is to install it and wire it into the loop. Resist that as the default. Most external tools bundle a genuinely good *idea* with a delivery mechanism you don't need — a hosted service, an account, a plugin runtime, a heavy dependency tree, a data-sharing boundary. Installing the whole thing to get the idea imports all of that surface area, and now your system depends on someone else's uptime, pricing, and API stability for a capability you could own outright.

The better move is often **reimplement the pattern locally against your existing primitives**:

1. **Separate the idea from the packaging.** Ask what the tool actually *does* for you, described as a transformation ("turns a diff into a scannable review artifact," "classifies items against a baseline"). That transformation is the value. The hosted app, the MDX renderer, the SaaS — that's packaging.
2. **Check what you already have.** If the transformation can be expressed in your standard stack (a stdlib script, an existing model call, a plain file), you don't need the dependency. A single portable script with zero external services beats a plugin that phones home.
3. **Reimplement small and self-contained.** Rebuild just the pattern, tuned to your own conventions and file layout. You get to keep the output portable, inspectable, and free of a data-sharing boundary — and you can extend it in directions the original never intended.
4. **Credit the source and record the choice.** Note where the idea came from and why you took the pattern rather than the pack. That keeps the decision reviewable and stops a future session from "just installing it" and re-importing the dependency.

This is not never-use-anything-external dogma. Some tools are deep enough, or maintained well enough, that reimplementing is wasted effort — use those. The discipline is to make it a *choice* rather than a reflex: default to absorbing the pattern, and only take the dependency when the packaging itself is the hard part. The payoff compounds — every capability you own as a small local script is one fewer external failure mode, one fewer bill, and one more thing you can improve on your own schedule.

## 10. Make "Done" Falsifiable

The most expensive failure in an autonomous system is not a crash — it's a confident "done" on work that is actually broken. An agent writes a file with a literal `\n` instead of a newline, or claims it produced a report that doesn't exist, then prints "Done — tested, everything works" and exits 0. Every downstream consumer trusts that exit code. The lie propagates.

A voice gate or a human reviewer catches *some* of this, but neither scales and neither is deterministic. The durable fix is to make the success claim **machine-checkable**, and to make the check *block* the claim:

1. **Turn "done" into assertions, not prose.** A run that claims completion should emit a small manifest of falsifiable claims — file X exists, file X parses, file X is at least N bytes, command Y exits 0. "I tested it and it works" is not a claim; `python3 -c "import ast; ast.parse(open('X').read())"` returning 0 is.
2. **Gate at every surface that says "done."** The claim is made in more than one place — coding-agent wrappers, background/night crons, the main chat loop. Each surface runs the same verifier before it is allowed to report success.
3. **A red gate overrides a green agent.** This is the load-bearing rule. If the agent exited 0 but the gate failed, the run is NOT done — the wrapper returns a distinct failure exit code, the cron posts `failed-qa` instead of ✅, and the FAIL lines are pasted as evidence. The agent's self-report never wins over the mechanical check.
4. **Syntax-parse everything the run changed.** A cheap universal check — parse every file the run touched with the right tool for its type (`ast.parse`, `node --check`, `bash -n`, `JSON.parse`). This alone kills the entire class of "emitted a literal `\n` / truncated file" bugs that read fine in a diff and explode at import time.
5. **Log every catch to a scorecard.** Each blocked claim appends a line to an append-only log. That log is the system-vs-human catch-rate metric — proof the gate is earning its keep, and a dataset for tuning it. (See the "a metric you cannot read is null" rule in `docs/observability.md`.)

The test that proves the gate works is deliberately adversarial: feed it a run that writes a syntax-broken file and claims success, and confirm the wrapper *blocks* it (non-zero exit) rather than passing the agent's 0 through. A gate you have not watched reject a real fake-success is not a gate — it's a hope.

This is the executable end of the Toil/Anomaly graduation (§2): "agents claim done when it isn't" is a mechanical failure, so the remedy is a verifier that runs and refuses — not another line of prose asking agents to be careful.

## 11. The Generator Is Not the Grader (Subjective Quality)

§10 makes a *mechanical* claim falsifiable — does the file parse, does the command exit 0. But the most common self-improvement loop is about *subjective* quality: voice, taste, tone, whether a draft actually sounds like the person it's written for. There is no `ast.parse` for "is this in my voice." The failure mode is subtler and more corrosive than a crash: the agent that *wrote* the draft also *certifies* it — "this is voice-clean," "quality wasn't the gap," "cleared the bar" — and marks the loop closed. The generator grading its own output always passes itself. The correction never lands, and the next cycle inherits the same blind spot dressed up as a fresh diagnosis.

The rule: **an agent may not be the final judge of its own subjective quality.** Where no mechanical assertion exists, the verdict comes from an *independent* signal — the human reviewer, or a separate grader that never saw the drafting step — never from the producer self-scoring.

Concretely:

1. **The verdict is an input, not an output.** Quality/voice sign-off comes from an external source (the human's actual reply, a shipped-vs-rejected outcome, a separate evaluator). The producing agent records that verdict; it does not manufacture one.
2. **Read the real feedback and the real output before diagnosing.** Before writing any quality assessment, load what the human actually said *and* what the pipeline actually produced. A review written blind to the corrections — or blind to what shipped — will invent a plausible theory that dodges the real gap.
3. **Persist corrections where the producer reads them next cycle.** A one-off correction in a chat thread decays. Append it to a durable feedback ledger that the drafting step reads on every run and appends to — so the loop is closed in the operating system, not just this conversation (see §1).
4. **Ban the self-certifying headline.** "The quality was fine, the problem was elsewhere" from the very component under review is the tell. If the human said the output was off and it isn't *demonstrably* fixed, the diagnosis is "still off per their feedback" (quoted) — not a new externalizing theory.
5. **Cross-reference sibling loops.** When several automated jobs touch the same output, a self-grading check run in isolation can bless work that a sibling job already flagged. The grader has to see the other loops' signals, not operate as if it were the only one.

This generalizes §10 into the domain where the check can't be a script: keep the *judge* separate from the *maker*. A green self-review is worth exactly as much as a green self-report — nothing, until an independent signal confirms it.

## 12. Tier Your Alerts by Blast Radius (Kill the Noise, Keep the Signal)

Any long-lived system accumulates monitors: dependency drift, config skew, expiring credentials, disk usage, broken links. The naive version dumps everything it finds — "here are the 13 things that are out of date" — and a human learns within a week to ignore it. A monitor that fires on every trivial change is worse than no monitor: it trains you to skim past the one alert that mattered. The goal of a self-monitoring loop is not *coverage*, it's *the right thing surfaced at the right severity*.

The fix is to make the monitor carry the policy, not just the observation. Three moves turn a flat dump into a signal:

1. **Tier by blast radius, not by recency.** Split the things you watch into *auto-safe* (a headless agent may act, smoke-test, and move on — routine app/CLI updates, backward-compatible bumps) and *decision-only* (never touched autonomously — the runtime, the package manager, anything whose change forces a supervised restart or a breaking migration). The tier is a property of the *thing*, not of how big this particular change looks. A decision-only item surfaces as a decision *with a reason-to-upgrade attached* ("security advisory," "required by a tool we auto-update," "a bug we're hitting") and is never actioned on its own.
2. **Gate on a threshold so trivial churn stays silent.** Not every delta deserves a ping. Define what "trivial" means (a patch bump below N releases behind, with no advisory) and make the monitor go *genuinely quiet* — exit clean, send nothing — when everything is trivial. Silence is a valid, informative output: it means "checked, nothing worth your attention." Reserve the alert for real drift (a minor/major change, enough accumulated patches to matter, or an override condition).
3. **Let a real signal punch through the gate.** A severity override — a live security advisory, a hard dependency — should force even a "trivial" item to flag. The quiet default is for noise; it must never swallow the one urgent thing. Keep the override window narrow and time-bounded so it doesn't quietly become the new default.

Two supporting disciplines keep the monitor honest over time:

- **Surface the untracked separately, don't silently ignore it.** Anything you watch has an explicit policy list, and lists rot — new things appear that aren't classified yet. Bucket those into a visible "untracked" section rather than dropping them. That visible bucket is what makes someone maintain the policy file instead of letting it silently outgrow reality.
- **Ship an actionable payload, not just a verdict.** Each flagged item carries the exact next step — the precise upgrade command, or the reason-to-decide for a decision-only item. An alert that says "X is out of date" makes the human go look up how to fix it; an alert that says "X is behind — run `<exact command>`" gets acted on. And make the whole thing deterministic and self-testable: a fixture-driven `--selftest` proving the tiering, the quiet-on-trivial gate, and the override all behave means you can trust the monitor without watching it run.

The underlying principle is the same honesty rule from `docs/observability.md`: a monitor's job is to earn attention, and it earns it by being *quiet when it should be*. A system that cries wolf on every patch bump is not more vigilant — it's just teaching its operator not to listen.

## 13. Treat an Agent's "Blocked" Claim as a Checkable Fact

When you delegate work to a subagent or coding agent, the most expensive lie is not a crash — it's a *plausible excuse*. An agent reports "credentials unavailable, so I skipped live verification," or "the config file wasn't there, so I ran in mock mode," and marks the task done at reduced scope. The report reads reasonable, so the orchestrator accepts it. The verification that mattered never ran, and nobody notices until a human points out the credentials existed the whole time.

The root cause is usually environmental, not dishonest: the agent ran in a fresh worktree, container, or sandbox that never inherited the gitignored runtime config — the `.env`, the credential file, the token — that the canonical clone has. From inside that stripped environment, "unavailable" is a true observation and a false conclusion.

The rule: **an agent's claim that something is missing or blocked is a hypothesis to check, not a fact to accept.** Two moves close the gap:

1. **Provision the environment before you blame it.** When you spin up a worktree, clone, or sandbox for an agent, copy the runtime config it will need from the canonical location (credential files at mode `600`, `.env`, service tokens) as part of provisioning — not after the agent complains. An isolated environment that silently lacks the inputs the task requires will always produce a confident reduced-scope result.
2. **Verify the blocker before accepting reduced scope.** "I couldn't find X so I skipped Y" is a checkable statement. Go look: does X actually exist in the canonical clone? Can the command the agent claims failed be run directly? A blocker that dissolves the moment you check it was never a blocker — it was an un-provisioned environment plus an accepted excuse. Only accept a scope reduction after you've confirmed the input genuinely isn't obtainable.

This is the delegation-layer version of "make done falsifiable" (§10): there, the agent's *success* claim gets a mechanical gate; here, the agent's *failure* claim gets one too. Both directions of an agent's self-report are suspect until an independent check confirms them. The cheapest guardrail is a provisioning step that copies known-required config into every fresh environment, so "unavailable" stops being the default state an agent reasons from.

## 14. A Run's Status Is Separate From the Work It Did

A scheduled, tool-heavy agent run can flip to `error` while every deliverable it was supposed to produce already landed. The tell is a status like "agent couldn't generate a response" on a run whose commits, messages, and state edits all went through. This is not a crash and it is not the work failing — it is the *run wrapper* reporting failure because the agent's final turn ended on a tool call or a thinking block with no closing plain-text message, so the harness had nothing to return and marked the turn empty.

The failure has a fingerprint worth learning, because the obvious explanations are all wrong:

- **It does not correlate with token volume.** The largest, slowest run can succeed while a small, fast one fails. If you go hunting for context overflow you will find nothing, because overflow was never the cause.
- **It is not a timeout.** Runs finish well under their cap.
- **The model did produce output** — you can see non-zero output tokens on the failing run. It was generating right up to the end; it just never emitted a terminal text turn.
- **Model fallbacks do not save you.** An empty-terminal-content condition is not a provider error, so failover to a backup model never triggers. Adding more fallbacks is wasted effort here.

The cause is structural: heavy tool-driven work plus extended thinking makes it *nondeterministic* whether the model closes with plain text after its last tool call. Sometimes it does, sometimes the thinking or the tool call consumes the terminal turn. That is why the failures alternate for no visible reason.

Two levers, cheapest first:

1. **Require a terminal plain-text line on every path.** Make the closing summary a hard instruction in the run's prompt — "a terminal plain-text line is REQUIRED on every path, after all tool calls." This removes the exact condition the wrapper errors on and is purely additive: it cannot regress the work the run already does. Bounding tool output in the same prompt reduces the chance that thinking and context starve the final turn.
2. **Reduce terminal-turn pressure.** If it still recurs, lower the reasoning/thinking effort on that job (less thinking-token pressure on the last turn) or add a runtime-level "require final text" retry that re-prompts once for a closing message instead of failing.

The general lesson generalizes §10 from the other direction: there, a green self-report was untrustworthy because the work might not have happened. Here, a red run status is untrustworthy because the work *did* happen — the status is measuring "did the model say something last," not "did the job succeed." Before you debug the work, confirm which one your status signal is actually reporting. A run's exit state and its side effects are separate facts, and a tool-heavy agent is exactly where they diverge.

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
