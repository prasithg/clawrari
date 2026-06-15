# Executable Regression Suite

Clawrari's `regressions.md` is one of its strongest patterns: every mistake worth preventing twice becomes a named guardrail. But a guardrail written in prose only works if someone remembers to read it at the right moment. Under time pressure, at 3am, in an unattended run, nobody reads it.

The fix is to make a subset of those guardrails executable. Each one becomes an assertion that passes or fails on its own, and the suite exits non-zero on any failure. Now a cron or a pre-commit hook enforces the guardrail instead of trusting a human to recall it.

This does not replace the prose log. The prose explains why a guardrail exists and how the failure happened. The executable suite enforces the ones that can be reduced to a check, and most of them can be.

## From prose to assertion

Take a real regression and ask: what observable condition would have caught this? That condition is your assertion.

| Prose guardrail | Executable assertion |
|---|---|
| "We committed a `.env` once. Never again." | `.env` must be absent from the tree |
| "The session brief grew to 400 lines and stopped being a brief." | `session-brief.md` is at most 60 lines |
| "A public doc shipped with em-dashes everywhere." | `README.md` contains no em-dash (U+2014) |
| "The build passed but the test script was empty." | `npm test` exits zero and its output matches an expected line |

## What the scaffold supports

`scripts/regression-check.mjs` reads a JSON spec of checks and runs each one. Supported check types:

- `file_exists` / `file_absent`: a path must be present or gone
- `file_contains` / `file_not_contains`: a regex must match, or must not, in a file
- `max_lines`: a file stays under a line budget
- `command_succeeds`: a shell command exits zero
- `command_output_matches`: a command's stdout matches a regex

Each check carries an `id`, a `description`, and an optional `severity`. The runner prints a PASS or FAIL line per check, a summary count, and exits 1 if anything failed. Pass `--json` for machine-readable output.

## Running it

```bash
# copy the sample, adapt it to your guardrails
cp config/regression-suite.example.json config/regression-suite.json

# run against your workspace
node scripts/regression-check.mjs --spec config/regression-suite.json --root .

# confirm the runner itself works
node scripts/regression-check.mjs --selftest
```

A natural home for this is the test stage of the [night-work pipeline](night-work-pipeline.md), or a pre-commit hook so a guardrail breach blocks the commit that would have introduced it.

## Where the line sits

Not every guardrail reduces to a check. "Match the voice in SOUL.md" needs judgment a regex cannot supply, though you can get partway there by asserting the absence of specific banned tokens (the AWDS lexical layer is a good source of those). The rule of thumb: if you can describe the failure as an observable condition on files or command output, make it a check. If it needs taste, leave it in prose and let the [eval scorecard](eval-scorecard.md) route it to human judgment.
