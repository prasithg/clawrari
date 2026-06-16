# Agent Observability and the Morning Report

A night-work agent finishes, exits zero, and goes quiet. The cron log says `SUCCESS`. You wake up, open the repo, and find three half-written files and a commit that broke the build. Green status was never the same thing as good work.

Observability is how you close that gap. You instrument every agent run, capture what it cost and what it actually produced, roll those runs into a scorecard, and render one HTML page a human can read in two minutes. The chain is simple: **trace → usage → scorecard → report**. This doc explains each link and the data model that ties them together.

It builds directly on the [eval scorecard](harness/eval-scorecard.md). The scorecard answers "how good was the session." Observability answers the question underneath it: "do I have the receipts to say that at all."

## Why bother

You cannot improve what you do not measure, and an unattended agent is the easiest thing in the world to fool yourself about. Three failure modes show up again and again:

- **Green-but-empty.** The run exited clean because it did almost nothing. Nothing crashed because nothing happened.
- **Expensive-but-thin.** Two hours and a pile of tokens produced one paragraph of docs. You only find out when the bill arrives.
- **Busy-but-throwaway.** The agent wrote forty files into a scratch directory and zero into the repo. Lots of motion, no durable output.

A status code catches none of these. A trace plus an artifact count catches all three. The goal is not a dashboard you stare at all day. It is a record honest enough that "the session went fine" becomes a claim you can check instead of a feeling you have.

## The data model

Three things get captured, in order. Each one is plain JSON so any tool can read it without a library.

### 1. The run trace

One record per agent run. It is the atomic unit of everything downstream. A trace says who ran, when, whether it exited clean, what it produced, and what it cost:

```json
{
  "run_id": "night-3-laneC",
  "agent": "claude",
  "started_at": "2026-06-15T01:00:00Z",
  "ended_at": "2026-06-15T01:34:00Z",
  "exit_code": 0,
  "artifacts": ["docs/observability.md", "templates/observability/trace.schema.json"],
  "metrics": { "tokens_in": 18400, "tokens_out": 5200, "cost_usd": 0.42 },
  "notes": "ported observability pattern"
}
```

The schema lives at [`templates/observability/trace.schema.json`](../templates/observability/trace.schema.json). Two fields carry most of the weight: `artifacts` (the durable things this run left behind) and `metrics` (what it spent). Everything else is context.

Write one trace per run as a line in a JSONL index. Append-only. The index is the source of truth; the scorecard and report are derived views you can throw away and regenerate.

### 2. Usage extraction

`metrics` is the part agents lie about by omission. Some runtimes hand you per-run token and cost receipts. Many do not. The rule that keeps the whole system honest:

**A metric you cannot read is `null`, never a guess.**

When the runtime exposes receipts, sum them. When it does not, record `null` and mark the run opaque. Do not estimate tokens from wall-clock. Do not back into a cost from a model's list price. An honest blank tells you which runs you still need to instrument; a fabricated number tells you nothing and quietly poisons every trend you build on top of it.

So a roll-up reports one of three states for token visibility:

- `measured` — every run in the window had real receipts.
- `partial` — some did, some were opaque. Report the sum you have and the count you are missing.
- `opaque` — none did. Report no token total at all.

### 3. Durable-artifact counting

Not every file an agent touches counts. A scratch file in `/tmp`, a log line, a re-read of an existing doc — none of that is output. A durable artifact is something that survives the session and a human would care about: a committed file, a new template, a doc that ships.

Count durable artifacts, deduplicated, and keep the list, not just the number. "4 artifacts" is a metric; the four paths are the evidence. When you later ask "was the session any good," the paths are what you actually look at. The count just tells you where to look first.

A useful sharpening: weight artifacts that made it into a commit over ones that only sit in the working tree. A file the agent wrote but never committed is a draft, not a deliverable, and the report should not let it pad the count.

## The scorecard roll-up

The scorecard reads a window of traces and produces the six-axis read documented in [eval-scorecard.md](harness/eval-scorecard.md): Output, Throughput, Intelligence, Collaboration, Autonomy, Safety. Observability is what feeds it. Without traces it has nothing to roll up; with them, the same honesty rules apply end to end:

- Judgment axes (Intelligence, Collaboration, Autonomy) emit `null` with a `needs: qa-judgment` marker and attach the evidence a reviewer should read. They never print a made-up 1-5.
- Throughput is capped and labelled `uninstrumented` until real token metrics exist, so an opaque run cannot inflate the score.
- Safety defaults to held and drops to the floor on a recorded breach, which caps the whole session regardless of how much got built.

A starter scorecard shape lives at [`templates/observability/scorecard.template.json`](../templates/observability/scorecard.template.json). It is the contract between the roll-up and the report: fill in the axes and evidence, and the report knows how to render it.

## The morning-report contract

The last link is one HTML file. The contract is strict on purpose, because a report nobody reads is just more noise:

- **One file, zero dependencies.** Inline CSS, no fonts to fetch, no scripts to load. It opens offline, from a phone, from an email attachment, from a file path with no server. If it needs a network to render, it fails the contract.
- **Two-minute read.** A verdict line at the top, the scorecard axes, the durable artifacts as links, the cost, and a short "what to check" list. Anything that does not help a human decide "ship, fix, or dig in" gets cut.
- **Honest about gaps.** Opaque tokens show as "not instrumented," not as zero. A `null` judgment axis says "needs review," not "5/5." The report inherits the trace's honesty; it never launders a blank into a number.
- **Self-contained snapshot.** The report is generated once from the traces and never edited by hand. If the numbers are wrong, you fix the trace and regenerate, the same way you would rebuild a derived view.

The skeleton lives at [`templates/observability/night-report.template.html`](../templates/observability/night-report.template.html). It uses `{{PLACEHOLDER}}` tokens a generator fills in. Copy it, swap your own values in, and keep the zero-dependency rule no matter how fancy you are tempted to make it.

## Wiring it together

In a night-work setup the pieces line up like this:

1. Each agent run appends a trace line to the JSONL index as it finishes.
2. A usage step reads each run's receipts where they exist and fills `metrics`, marking the rest opaque.
3. The scorecard rolls the window into six axes plus evidence.
4. The report generator turns the scorecard and the artifact list into one HTML page.
5. A human reads the page over coffee and decides what to do.

Steps 1 through 4 are mechanical and run unattended. Step 5 is the only one that needs a person, which is the whole point: you spend human attention on the judgment, not on reconstructing what happened from a wall of logs.

## See also

- [The Harness](harness/README.md) — the pattern set this extends.
- [Eval Scorecard](harness/eval-scorecard.md) — the six axes and the honesty discipline behind them.
- [Night-Work Pipeline](harness/night-work-pipeline.md) — the staged runner that produces the runs you trace.
