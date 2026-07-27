# night-work — overnight autonomous build loop

**Status:** v0.1 — vended in full. Copy it, point it at your queue, make it yours.

## The one-line idea

Use overnight hours for the work that doesn't need a human in the loop: self-improvement, memory maintenance, workspace cleanup, backlog research, content prep, self-healing, and test coverage. Run a **bounded task loop** on the strongest autonomous model you have, log every outcome to a durable daily note, and stay silent unless something is truly urgent.

The value is in the discipline, not the ambition: one bounded task at a time, verify the observable result, log it, move on. A loop that runs unbounded and unlogged overnight is how you wake up to a broken workspace and no trail.

## When to use

- A nightly cron fires the overnight window.
- You explicitly kick off "run the night queue" before stepping away.

Do not use this lane for interactive, high-judgment, or externally-visible work — those wait for a supervised session.

## Model routing

Pick models by *lane*, not by vibe. A typical ladder (map these to whatever roster you run — see your model playbook if you keep one):

- **Hard autonomous planning / orchestration** → your strongest long-horizon model at its highest reasoning effort.
- **Substantial code execution + hard-autonomous fallback** → your strongest coding model at high/xhigh effort.
- **Terminal provider fallback** → a third, independent-provider model so a single provider outage doesn't stall the queue.
- **Routine / interactive default** → your everyday orchestrator at medium effort. This is *not* a night-work escalation.
- **Fast/bulk only** → a cheap fast model is allowed strictly for bounded preprocessing: classification, extraction, OCR, quick visual passes, corpus fan-out. It never owns hard judgment, final synthesis, strategy, voice, review, or autonomous execution.
- **Experimental models** must not appear in a production overnight chain.

The rule that matters: the fast/cheap model does the fan-out, the strong model owns the final spec and synthesis. Never let bulk-tier output ship as the answer.

## Coding execution

Delegate coding through checked-in wrappers and prompt files — never large inline shell prompts (long prompts break shell quoting). See the `coding-agent` skill for the wrappers.

```bash
REASONING_EFFORT=xhigh ~/scripts/run-codex.sh /path/to/project < /path/to/prompt.txt
```

The planning model plans, supervises, and verifies; the coding model executes substantial repository changes and is the fallback when the planner is unavailable. **If a coding run fails quickly, inspect the cause before changing routes — do not repeat the same failing launch three times.**

## Required work loop

1. Do one bounded task.
2. Verify the observable result (run the test, check the file exists, read the diff).
3. Log the outcome, evidence, and next action to today's daily note.
4. Continue to the next available task.
5. Stop only when: the queue is empty, the session safety valve fires (a hard wall-clock cap, e.g. 45 minutes), or three consecutive tasks fail.

Single-task no-progress timeout: ~10 minutes. Before stopping for any reason, leave durable recovery state (what's done, what's next, where the artifacts are) so the next session resumes instead of re-deriving.

## Test coverage

Every night, audit the repos changed that day for untested logic. Follow each repo's own conventions, write tests against named acceptance criteria, and run the narrowest meaningful test/lint/build gate before declaring anything complete. Pair this with `cross-review` before you mark a build done.

## Safety

- Respect your operating rules' authority gates. External sends, destructive actions, purchases, and material scope expansion still require the applicable confirmation — the overnight window does not relax them.
- Do not message a human overnight unless it's genuinely urgent. The daily note is the async channel; the loop reports at the next supervised session.
- Silence when the queue is empty is a valid, complete outcome. Log it and stop.
