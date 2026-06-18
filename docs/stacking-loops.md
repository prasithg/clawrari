# Stacking Loops

The instinct when output quality stalls is to add another agent. One more reviewer, one more drafter, one more parallel worker fanning out on the same task. It rarely helps. Five agents writing five drafts give you five mediocre drafts and a merge problem. Quality does not come from more hands on the same step. It comes from stacking complementary feedback loops so each one's output feeds the next, and the whole thing compounds.

A stacking loop is the pattern of nesting feedback loops on top of each other, where each loop emits a measurable signal that the loop above it consumes. The inner loop makes one artifact better. The loop wrapping it judges that artifact against something the inner loop cannot see. The loop wrapping *that* watches the judgments themselves and tunes the gates. Each layer catches a class of failure the layer below is blind to.

## What counts as a loop

A loop, for this purpose, is three things: a step that produces a signal, a check that reads the signal, and a path back into the work when the check says "not yet." A generator with no check is a pipeline, not a loop. A check with no path back is a gate that only ever says no. The loop is the cycle that runs until the signal clears a bar.

Three loops worth stacking, from inside out:

1. **The craft loop.** Generate, evaluate, diagnose, improve. One artifact, one author, run until it scores well enough against its own rubric. This is the loop most setups already have.
2. **The cross-review loop.** A second model reads the artifact the craft loop produced and tries to break it. It does not rewrite. It returns a verdict and the defects it found. The craft loop runs again on those defects.
3. **The measured-gate loop.** Track how many defects slip past both inner loops and surface only later, in review or in production. That escape rate is the signal. When it drifts up, the gate thresholds were too loose, and you tighten them.

## The shape

```text
  +-----------------------------------------------------------+
  |  MEASURED-GATE LOOP                                        |
  |  reads: escape rate over a window of runs                 |
  |  acts:  tighten / loosen the gates below                  |
  |                                                           |
  |   +---------------------------------------------------+   |
  |   |  CROSS-REVIEW LOOP                                |   |
  |   |  reads: a scored artifact                         |   |
  |   |  acts:  second model finds defects, returns verdict|  |
  |   |                                                   |   |
  |   |    +-----------------------------------------+    |   |
  |   |    |  CRAFT LOOP                             |    |   |
  |   |    |  generate -> evaluate -> diagnose ->    |    |   |
  |   |    |  improve, until rubric score clears bar |    |   |
  |   |    +-----------------------------------------+    |   |
  |   |              |  emits: scored artifact            |   |
  |   |              v                                    |   |
  |   |       second model verdict + defect list          |  |
  |   +---------------------------------------------------+   |
  |              |  emits: review verdict, defects found      |
  |              v                                            |
  |       escape rate: defects that got past both loops       |
  +-----------------------------------------------------------+
              |  emits: gate thresholds for the next run
              v
        a record honest enough to trend over time
```

Read it inside out. The craft loop hands a scored artifact up to the cross-review loop. The cross-review loop hands a verdict and a defect count up to the measured-gate loop. The measured-gate loop hands tightened thresholds back down. Each arrow is a signal one loop produces and the next consumes. No loop has to trust the loop below it on faith, because the signal is the receipt.

## A worked example

Say the work is generating a weekly build-in-public post.

**Craft loop.** A drafter writes the post, scores it against a voice rubric (banned AI vocabulary, sentence-rhythm variance, no marketing fluff), diagnoses the lowest-scoring lines, and rewrites them. It runs three times and clears the rubric at 8/10. Left alone, this ships. The signal it emits is the score and the draft.

**Cross-review loop.** A second model, not the one that wrote it, reads the 8/10 draft cold. It is not asked to improve the post. It is asked one question: what would a sharp reader call out? It finds two claims with no supporting link and one sentence that reads like every other AI post on the timeline. It returns a verdict (`changes-requested`) and three defects. The craft loop runs again, this time aimed at those three. The artifact that leaves this loop carries both its rubric score and a clean cross-review verdict.

The craft loop could not have caught those defects, because it was grading against its own rubric and the rubric had no item for "this claim needs a link." The reviewer caught it because it was reading for a different failure mode. That is the whole point of stacking: the second loop sees what the first is structurally blind to.

**Measured-gate loop.** Over a month of posts, you log how often a defect surfaced *after* both loops passed it, when a human reader or an engagement drop flagged something the gates let through. That is the escape rate. If it climbs, the rubric and the reviewer prompt are missing a category, and you add it. If it stays at zero for weeks, the gates may be too tight and slowing the craft loop down for no return, so you loosen them. The gate loop never touches a single post. It tunes the two loops that do.

## Why stacking beats parallelism

Adding parallel agents multiplies effort on one step. Stacking loops multiplies the *kinds* of error you catch. Those are not the same lever, and only one of them compounds.

Three parallel drafters give you a sampling problem. You now have three drafts and still need a way to pick or merge, which is another step you have not built, run by an agent grading work in the same blind spots as the one that wrote it. The errors are correlated. Five samples from the same flawed process give you the same flaw five times.

Stacked loops give you decorrelated checks. The craft loop's blind spot (it grades against its own rubric) is exactly what the cross-review loop is built to cover. The cross-review loop's blind spot (it can be systematically too lenient or too harsh) is exactly what the measured-gate loop catches by watching escape rate over time. Each layer's output is the next layer's input, so quality at the top is the product of the layers, not the sum. Two loops that each catch 70% of their target defects leave 9% getting through, not 30%. A third honest layer takes that lower still.

There is a cost ceiling, and it is real. Each loop adds latency and tokens, and a loop whose signal you cannot read adds nothing but cost. Stack loops that each catch a distinct, nameable failure mode. Stop when the next loop cannot point at a class of error the existing stack misses. The discipline is the same one the [eval scorecard](harness/eval-scorecard.md) enforces on scoring: a loop you cannot justify is a loop you cut.

## How it stays honest

A stack of loops is only as trustworthy as the signals passing between them, which is where this pattern meets [observability](observability.md). The chain there is `trace → usage → scorecard → report`. Stacking loops is what fills the trace with something worth rolling up.

Each loop's signal is a field on the run trace. The craft loop's rubric score, the cross-review verdict and defect count, the gate thresholds in force at run time: all of it lands in the trace as the run finishes. The scorecard rolls a window of those traces into its six axes, and the escape rate the measured-gate loop reads is just a derived view over the same traces. The loops do not need a separate logging system. They emit into the one already documented.

The rule that keeps the observability layer honest keeps the loops honest too: **a metric you cannot read is `null`, never a guess.** A loop that gates on a signal it cannot actually measure is worse than no loop, because it manufactures a verdict out of nothing and every layer above it inherits the lie. If the cross-review model returns no parseable verdict, the trace records `null` and the gate loop counts that run as opaque, not as a pass. If token cost is not instrumented, the cost of running the stack reports `uninstrumented`, not zero, so you never fool yourself into thinking an expensive stack was free. An honest blank tells you which loop still needs wiring. A fabricated pass tells you nothing and quietly rots the trend the measured-gate loop runs on.

That is the through-line. Stacking loops is how quality compounds. Measurable signals between the loops are what make the compounding real instead of theater, and the null rule is what stops a stack from grading its own homework.

## See also

- [Agent Observability](observability.md) — the `trace → usage → scorecard → report` chain the loop signals feed into.
- [Eval Scorecard](harness/eval-scorecard.md) — the six axes and the "never fabricate a score you cannot ground" discipline.
- [The Harness](harness/README.md) — the pattern set that turns a model into a reliable operator.
- [Self-Improvement](components/self-improvement.md) — the loop that promotes validated feedback into better defaults.
