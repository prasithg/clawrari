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

## 15. Don't Weaken the Gate to Turn a Test Green

When an eval or regression suite that was passing suddenly goes red, the fastest way to "fix" it is to lower the threshold until the number clears. Resist that reflex. A gate that just went red is usually reporting a *real* downstream effect of an upstream problem — not evidence that the gate was set too high.

The pattern shows up cleanly during any state-management incident. A pipeline that publishes on a "last healthy" snapshot can quietly freeze on stale state after a few upstream write violations. Once it does, everything *downstream* of publication starts failing at once: retrieval quality slides, ranking gates drop below their floor, a named regression reappears. Every one of those looks like an independent quality regression you could paper over by relaxing a threshold. All of them were the same root cause — stale published state — and all of them recovered the moment the source was fixed, with **no gate touched**.

That gives a concrete diagnostic order:

1. **Cluster the failures before you act on any single one.** If multiple independent gates went red in the same window, suspect one shared upstream cause, not N separate quality drops. Independent regressions rarely arrive together.
2. **Find the earliest thing in the chain that changed.** Fix that. Then re-run the whole suite before deciding anything about the gates.
3. **Only after the source is repaired** do you ask whether a still-red gate is genuinely mis-calibrated. Usually it isn't.

Why the discipline matters: a gate's entire value is that a red result means something. Lower it once to escape an incident and you have permanently traded away the signal to save an afternoon — the next real regression now slips under the new, looser bar silently. Recovering the metric by fixing the cause keeps the gate trustworthy; lowering the bar to match a broken reality destroys it.

A companion habit keeps you honest: when a fixture or denominator legitimately changes (a reviewed source move, a renamed item), *keep it in the denominator and document why* rather than quietly dropping it to smooth the number. "We recovered 27/27 without editing a single threshold" is a stronger claim than "we're green again," precisely because it proves you fixed the system instead of the scoreboard.

## 16. Treat Eval Fixtures as Controlled Evidence

An evaluation can stay green while its evidence quietly rots. A golden row may still match by semantic luck after its cited source was deleted. A runner may report the wrong denominator because the expected fixture count is hardcoded in two places. Fixing either problem casually is dangerous: changing a question, expected answer, and source together can turn a repair into an unreviewed rewrite of the test.

Treat golden fixtures like controlled evidence:

1. **Keep the tested claim separate from its citation.** A source-path repair may change only the citation when a new canonical file still supports the same claim. If the fact itself disappeared, stop. Retire or replace the row through the normal review path instead of pointing it at a vaguely related document.
2. **Make golden edits explicit exceptions.** Keep the fixture read-only to ordinary build lanes. Require a named, narrow approval for any edit, record the exact rows in scope, and preserve the question and expected answer unless the approval explicitly covers changing the test.
3. **Derive counts from the fixture.** The runner and policy report should parse the current fixture count from one source of truth. A hardcoded denominator can make a dry run look healthy while the policy and dataset disagree.
4. **Audit provenance, not only scores.** Check that every cited source exists and still contains the load-bearing fact. A passing retrieval score does not prove the row is grounded in the file it claims to test.
5. **Classify the fault before tuning the system.** A dead citation or stale denominator is a grader fault. Repair the evaluator and rerun the unchanged quality thresholds. Do not train the agent around broken evidence.

The finish state is stronger than “all rows pass”: the fixture count is derived, every citation is live, each repaired row still tests the same claim, and unresolved facts remain visibly unresolved rather than being forced green.

## 17. Verify the Identity Returned by a Lookup

A successful lookup can return the wrong record. Human-readable identifiers often combine a namespace with a local number, while a resolver may search only the number. One request can then return records from several teams. A plausible title or the first result is insufficient evidence of identity.

Before reading details or using a returned ID in a write:

1. Keep the full requested identifier, including its namespace.
2. Select a result whose returned identifier exactly matches the request. Check the tenant or project too when the identifier is unique only within that scope.
3. Require exactly one match. Treat zero matches or multiple exact matches as unresolved; do not choose an arbitrary record.
4. Use only that verified record's stable ID downstream. Check the identity again when fetching its details.

For a synthetic request for `OPS-42`, a response containing `WEB-42` and `OPS-42` yields only the second record. A response containing only `WEB-42` must stop the lookup. The same rule applies to repositories, documents, accounts, and inventory items with locally unique names.

A later correct response does not prove an intermittent resolver fault is fixed. Keep the check at the response boundary. A written instruction asks an agent to perform it; a wrapper that rejects mismatches enforces it. Report which protection you actually have.

## 18. Check for Another Writer Before Restoring Shared Settings

Two agents can edit the same scheduled job seconds apart. Each sees a before/after difference and assumes its own command caused every changed field. A restore from either agent's old snapshot can then undo the other's valid work.

A settings snapshot records what existed. It does not establish who caused a later change. Use this procedure for shared configuration:

1. Capture the target's version or revision with the fields you plan to change. Treat a missing revision as insufficient evidence to overwrite shared state.
2. Immediately before applying the change, read the revision again. If it moved, stop and reconcile with the new state.
3. Change only the intended fields. After the write, read them back and record the resulting revision for the next operation.
4. If an unrelated field changed, investigate other writers before restoring it or blaming the tool. Reproduce the command on an isolated, disposable target when attribution is uncertain.
5. Restore only when you can establish that the current version is still the one you own. Otherwise reconcile instead of replaying the old snapshot.

A client-side read followed by a write still has a race window. It detects changes that happened before the check; it cannot prevent a competing write immediately afterward. Use an atomic conditional update when the service supports it, or serialize writers through a shared owner or lock. A version timestamp alone also cannot reconstruct every intermediate write.

The useful finish state is an intended change with verified fields and an owned version, plus an explicit conflict when ownership is uncertain.

## 19. Command Help Must Have No Side Effects

A maintenance runner treated `--help` as an unknown argument, ignored it, and ran its full checks and alert path. A request for usage information sent notifications. Fix this at the command boundary:

1. Parse arguments before starting checks, loading services, or writing reports. Both `--help` and `-h` print usage and exit successfully.
2. Reject unknown, missing, duplicate, and invalid selection arguments before doing work. An invalid selection must not broaden into a full run or produce a zero-check success.
3. Keep focused diagnostic runs local by default. A failing selected check still returns failure, but does not send an alert. Preserve the scheduled full-run notification behavior separately.
4. Verify observable effects in an isolated fixture: exit status, report writes, and sender calls. Include a failing scheduled-run control that reaches a fake sender, so an inert test double cannot make every case look safe.

When the old implementation is available, run the same controls against it and confirm they detect the original failure. Checking a help string alone does not establish that asking for help is harmless.

## 20. Track the Files a Fresh Checkout Needs

A working installation can depend on files that were never committed. Local success hides the omission until another machine or a clean checkout needs those files.

Inventory untracked code against the entrypoints and maintained instructions that use it. Prefer path-qualified references when ranking candidates; common basenames such as `run.js` can create misleading matches. Treat an absent text reference as a review signal, since dynamic imports and configuration can still make a file necessary.

Classify each candidate as track, defer with a reason, or exclude. Review code, tests, configuration, prompts, and evidence individually for credentials and publication scope. Keep sensitive journals in a private store; their durability is not permission to publish them.

Ignore known disposable locations, such as caches and scratch output. Blanket rules for `*.json`, `data/`, or `reports/` can hide required fixtures and evidence. Test proposed ignore rules against both disposable and durable examples in a temporary repository. Existing tracked files remain tracked when an ignore rule is added; changing their retention requires a separate decision.

Keep deferred inventories and evidence needed to justify completion in a durable location. A report that points only into an ignored, pruned log directory loses its proof.

## 21. Validate Attachment Downloads Before Saving Them

An authenticated download can return a login page with a successful HTTP status. A saved filename and a successful request do not establish that the attachment was retrieved.

For an optional attachment-fetch feature:

- Define allowed file types and a byte limit. Refuse unsupported or oversized metadata before fetching.
- Check the response status and content type. Reject login HTML, including when the status indicates success.
- Check the received length against the expected size and the configured limit before writing a file.
- Build filenames from a sanitized basename and a stable file identifier. Restrict the local directory and files to the account running the job.
- Report saved files only after validation succeeds. Distinguish a policy skip from a failed fetch, and determine run success from the caller's required output.
- Keep the existing text and structured output unchanged when the option is off. Add saved-file metadata only when it is requested.

Use synthetic downloads to exercise forbidden types, oversize metadata, authentication failures, successful-status HTML, length mismatches, and a valid file. Compare old and new output with the option off. If the service changes incidental fields between requests, use a same-code repeated-request control before attributing that difference to the implementation.

These checks establish the download contract. They do not establish that file contents are safe to execute or that response headers authenticate the file format.

[Evaluation of these three patterns](../reports/evals/2026-09-13-tool-contracts-and-child-steering.md).

### Keep Optional Attachment Failures Local

When attachments supplement a message read, one inaccessible file should leave the completed message read usable. Validate each file independently, retain good downloads, and report each skip or failure with a safe identifier and reason. Summarize downloaded, skipped, and failed counts separately. Failure to retrieve the message page still fails the read. If the caller requires every attachment, a missing file still makes that task incomplete.

Before sending credentials, check the file's hosting classification and the destination allowed for those credentials. A file object can represent a link to another provider. Skip that external file, or use a separately authorized adapter for its provider; visibility in the message service does not grant download access elsewhere. Apply the credential boundary to redirected requests too.

Exercise a mixed batch with one failed file, a failed message-page request, and an external link that receives no credentialed request. A deliberate skip list needs a recorded reason and durable storage. It must not conceal an attachment the caller requires.

[Documentation evaluation and limits](../reports/evals/2026-09-17-failure-boundaries-and-run-records.md#attachment-cases).

## 22. Verify Service Activation Before Grading a Change

A detached maintenance run can have a smaller command-search path than an interactive shell. In one repair, a missing inspection utility was interpreted as an absent service. The restart did nothing, and later health checks measured the process that was already running.

Before attributing a health result to a deployed change:

1. Resolve required inspection and service-control tools through trusted paths. Check that each tool is executable. Report a missing tool as an inspection failure; it does not establish that the service is absent.
2. Record the running process identity before activation. If the procedure requires a restart, require evidence that the process changed before running the acceptance checks. Keep process identity separate from evidence of the loaded revision: a different process alone does not prove it loaded the intended code.
3. Record activation and health results separately. When activation is unverified, retain the health output but mark it invalid as evidence for the candidate change.
4. Exercise the control path under the scheduler's restricted environment. Include a missing-tool case and a restart that leaves the process unchanged, so a successful health response cannot hide a skipped activation.
5. Correct the shared control helpers and their callers. Clearly label earlier results that measured the wrong process so later reviews cannot reuse them as release evidence.

A reload-only service needs its own observable activation evidence. A process-change assertion applies to a restart; it cannot establish that a hot reload succeeded.

## 23. Keep Branch Changes Out of the Shared Workspace

Git branch selection belongs to a checkout. If several agents write into one checkout, one agent's branch switch changes the context for all of them. Subsequent commits can accumulate on an unexpected branch even while every individual command succeeds.

Keep the primary shared checkout on its designated branch. Give work that needs a different branch a separate worktree or clone, and name that boundary in the agent's write scope.

Make the invariant observable:

- Check the primary checkout's branch and whether another worktree holds the designated branch. Report the offending branch and worktree when either condition is wrong.
- Treat a detached checkout or an unreadable repository as a condition to investigate. An inspection failure cannot establish that the branch is correct.
- Put any checkout warning hook under version control with an installer. Describe a warning-only hook as a warning: it does not block a branch switch. A scheduled assertion detects drift after it happens.
- Exercise the check in disposable repositories: the expected branch, a wrong branch, a detached checkout, another worktree holding the designated branch, and unrelated worktrees that should remain valid.

A branch check does not serialize edits or isolate files. Agents sharing a checkout still need coordinated write scopes. When drift appears, inspect the other writers and preserve their work before reconciling branches; an automatic reset or stash can damage work the checking agent does not own.

[Documentation evaluation and limits](../reports/evals/2026-09-15-activation-branches-and-handoffs.md).

## 24. Repair Regression Checks Against the Current Contract

After a runtime upgrade, several checks can fail because their assumptions are stale. A storage field moved, the executable became a launcher, or a producer gained a documented terminal status. Those failures need repair, but a higher pass count alone cannot show whether the system improved.

Triage each failure against current evidence:

1. **Classify the failure before changing the check.** Separate a real behavior defect, a superseded requirement, and a broken inspection method. Cite the installed contract or the decision that changed the requirement. An inspection error leaves the result unknown; it does not establish healthy behavior.
2. **Preserve the property being checked.** If data moved into a different structure, update how the check reads it while keeping the same predicate. If a launcher hides the installation, resolve the installed implementation before inspecting it. Prefer supported interfaces; checks that inspect private bundle layouts need explicit version limits and a clear failure when discovery is ambiguous.
3. **Keep receipt validity separate from task success.** A producer may legitimately report `done`, `partial`, `blocked`, or `failed`. Validate the producer's documented vocabulary, then grade the outcome separately. A valid failure receipt proves the worker reported its outcome; it still reports unsuccessful work. Missing, malformed, and unknown-status receipts remain invalid.
4. **Prove the repair still detects failure.** Pair a valid case with a relevant negative control, such as an unknown receipt status or a violated predicate in the new data layout. An assertion that only recognizes the new happy path can silently stop detecting the original defect.
5. **Report remaining failures explicitly.** Keep the assertion inventory and quality thresholds stable during the repair. Show before/after results, identify any assertion whose meaning changed, and record unresolved defects with their evidence and next action. A documented remaining failure is still a failure.

When an expected answer conflicts with its cited source, apply the [fixture-evidence rules](#16-treat-eval-fixtures-as-controlled-evidence). Keep implementation repairs and expectation changes separately reviewable. A check repair can be correct while the broader system remains unhealthy.

[Documentation evaluation and limits](../reports/evals/2026-09-15-check-contracts-and-workflow.md).

## 25. Recover the Measurement Without Changing the Score

A health probe can fail before it measures the system. Retrying that failed measurement may help; retrying an unfavorable score until it passes invalidates the evaluation.

1. Capture the command's exit or signal and its structured error, including errors returned on standard output. Keep raw prompts, credentials, and sensitive payloads out of diagnostics.
2. Retry only recognized transient failures in a read-only probe, within a fixed attempt budget. Use a fresh isolated session when the previous session may be damaged. Authentication, invalid arguments, and missing executables need repair, not repeated attempts. Unknown failures remain unresolved.
3. Clean up probe-owned sessions after failed attempts and terminal failure as well as success. Keep other workers' sessions untouched, and preserve the attempt evidence outside the disposable session.
4. If retries are exhausted, report the measurement as unavailable. Dependent checks have no valid measurement; they have neither passed nor established a behavioral defect. Keep any protective action conservative without changing the scoring threshold. Report one measurement failure with its affected checks, instead of emitting a separate defect alert for each missing score. Once a valid measurement exists, genuine failures still receive their own results.
5. Retain failed-attempt counts even when a later attempt completes. State separately whether retry and cleanup worked and whether a complete scored report exists.

Exercise transient recovery, deterministic failure without retries, and exhaustion with cleanup. Read-only probe retries do not authorize replaying writes whose effects are uncertain.

## 26. Diagnose Timed-Out Work From Its Transcript

A quiet gateway log does not prove a provider stalled. The timed-out session may contain repeated tool calls that the gateway log never records.

Correlate timeout records with the session's stable run identifiers, tool calls, results, and timing. Distinguish repeated work, provider errors, queue waits, and unknown causes. Several tool records from one run are not several independent incidents. Preserve unknown classifications when evidence is missing.

Repair the demonstrated cause. Repeated status checks may need a shared check budget and an enabled loop detector; a provider timeout requires provider evidence. Keep prompt instructions distinct from runtime enforcement: a model can disobey a one-check instruction, and a detector for identical calls can miss rephrased commands.

Verify effective configuration, including per-agent overrides, and exercise the actual scheduled path. Record configuration preservation, short behavioral checks, and the required reliability observation period separately. A configuration check can pass while historical runtime failures remain in the observation window. Keep those failures visible and retain the full required window before claiming reliability.

[Documentation evaluation and limits for both patterns](../reports/evals/2026-09-17-failure-boundaries-and-run-records.md).

## 27. Preserve Evidence and Check the Exact Run

Two successful runs can destroy each other's evidence when both write to a date-only filename. Giving each workload a name helps, but repeated runs of the same workload still collide.

1. **Name the workload and preserve every attempt.** Include a bounded workload label in the artifact name. Create files exclusively; if the name exists, choose another suffix and retry the exclusive creation. An existence check followed by an ordinary write leaves a race between writers.
2. **Return the path that was written.** Include it in both human-readable output and structured results. Pass that path to downstream checks instead of reconstructing a filename or selecting the newest date match.
3. **Verify identity as well as existence.** Check the exact expected item identifiers and count, and reject evidence older than the current run. Use a producer run identifier when available; a timestamp alone cannot distinguish concurrent runs.
4. **Record an empty result explicitly.** A run that finds nothing eligible can produce an artifact with an empty item set and a reason. Validate that outcome against the expected empty set; a missing file is still missing evidence.
5. **Keep evidence separate from permission to publish.** A complete artifact may contain a failed quality verdict. Checking its identity and freshness cannot turn that verdict into a pass.

Exercise a same-name second run and compare the first file byte for byte. Also try a stale file with matching item identifiers, a missing item, an explicit empty result, and a complete artifact with a failed verdict. Test concurrent writers separately before claiming the storage path is race-safe.

## 28. Count Completed Checks Separately From Passing Checks

A check that returns a defined failure verdict completed its measurement. A check that never ran, crashed before producing a verdict, or could not read its inputs did not. Reporting both as an unfinished run hides the repair that is needed.

Define each check's result contract, including which exit codes represent completed positive or negative verdicts and which mean the measurement was unavailable. Record completion and verdict separately. Do not infer those meanings from a universal rule that every nonzero exit is a crash.

Keep an expected check inventory independent of the returned results. Compare expected identifiers with completed identifiers as well as counts: three passes out of four required checks cannot produce an all-clear, and a duplicate result cannot replace a missing check. Preserve any genuine negative verdicts even when another check is unavailable.

Report the failed checks and the unavailable checks by name. Group consequences of a missing upstream measurement under that one cause. A healthy report requires complete coverage and the contract's passing verdicts; a completed run alone is insufficient.

[Documentation evaluation and limits](../reports/evals/2026-09-19-evidence-and-verification.md).

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
