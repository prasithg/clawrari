# Cross-Agent Eval Scorecard

How do you know a work session was good? "It felt productive" is not an answer you can track over time or compare across agents. The scorecard pattern gives you a structured read on a window of agent runs, scored on six axes, with one rule that matters more than the axes themselves: never fabricate a number you cannot ground.

## The six axes

| Axis | What it measures |
|------|------------------|
| **Output** | Durable artifacts produced, runs completed, clean exits |
| **Throughput** | Work per unit time and cost |
| **Intelligence / Quality** | How good the work actually is |
| **Collaboration** | In multi-agent sessions: blocking-question latency, redundancy, symmetry |
| **Autonomy** | How much ran without human steering, split into execution and direction |
| **Safety** | Did every guardrail hold |

## The honesty discipline

The point of the scorecard is not to produce six tidy numbers. It is to produce numbers you can defend and nulls you can explain. The scaffold (`scripts/eval-scorecard.mjs`) bakes in four rules:

**Tokens are summed only where they exist.** A run whose token and cost metrics are null is counted as an opaque run and never estimated. On plans that do not expose per-run receipts, the roll-up reports `token_visibility: opaque` rather than inventing a figure. Mixing measured and opaque runs reports `partial`.

**Judgment axes emit null, not a guess.** Output quality, Intelligence, Collaboration, and Autonomy need a human or QA read. The scorecard emits `score: null` with `needs: "qa-judgment"` and attaches the evidence a reviewer should look at: the artifact list, the agents involved, the non-zero exit count. It never prints a fabricated 1-5 for an axis it cannot measure.

**Throughput is capped until instrumented.** With no token receipts, throughput caps at 3 and is labelled `uninstrumented`, so an opaque run cannot inflate the score. Once real metrics exist, the axis opens up to QA judgment.

**A safety breach caps the session.** Safety defaults to 5 (held). Record a breach and it drops to 1, which is the signal that the whole session is compromised regardless of how much got built.

Autonomy is reported as two separate ratios, execution and direction, and never blended. An agent can execute a hundred steps without help (high execution autonomy) while still needing a human to decide what to do next (low direction autonomy). Averaging those into one number hides the thing you most want to know.

## Input format

The tool reads a JSONL index, one run per line:

```json
{"agent":"claude","started_at":"2026-06-15T01:00:00Z","ended_at":"2026-06-15T01:30:00Z","exit_code":0,"artifacts":["docs/a.md"],"metrics":{"tokens_in":null,"tokens_out":null,"cost_usd":null}}
```

Missing fields degrade gracefully. The roll-up keeps whatever is present and reports what it could not measure.

## Running it

```bash
# JSON scorecard for the last 18h
node scripts/eval-scorecard.mjs --index runs.jsonl

# human-readable, named, orchestrated session
node scripts/eval-scorecard.mjs --index runs.jsonl --print \
    --session-name "night port" --mode orchestrated

# record a guardrail breach (caps Safety at 1)
node scripts/eval-scorecard.mjs --index runs.jsonl --guardrail-breach

# confirm the tool, including the honesty rules, works
node scripts/eval-scorecard.mjs --selftest
```

The selftest asserts the rules directly: an opaque-only agent reports null tokens, a breach caps Safety at 1, solo mode marks Collaboration not-applicable. If those ever regress, the selftest fails.

## Why null beats a guess

A made-up score is worse than an honest blank, because it pollutes every trend you build on top of it. Six months of fabricated throughput numbers tell you nothing except that you fabricated them. Six months of honest nulls tell you exactly which axis you still need to instrument. The scorecard is built to make the gaps visible, not to paper over them.
