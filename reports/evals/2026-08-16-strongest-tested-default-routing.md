# Strongest-Tested-Default Routing Eval

- **Change under test:** make Fable 5 medium the routine ticket/agent executor while keeping specialized routes for fast/bulk, review, coding, and hard autonomous work.
- **Surface class:** model-routing playbook.
- **Baseline:** a flat Fable 5 medium route for every task.
- **Verdict:** **ship**.

## Task Set

Eleven fixed task classes covered bulk extraction, bounded classification, hard autonomous work, routine ticket work, research synthesis, main-session interaction, specialist analysis, security review, code building, eval review, and quick interaction.

Seven task classes completed paired live comparisons. Four provider-specific classes were excluded because credentials were unavailable in the headless runner; excluded runs did not contribute to either arm's score.

## Results

| Arm | Quality | Reported tokens | Median latency | Failure rate |
| --- | ---: | ---: | ---: | ---: |
| Intent router | 90.5% | 281,566 | 12.64 s | 0% |
| Flat Fable 5 medium | 90.5% | 326,733 | 13.63 s | 0% |

The routed arm matched the strongest-tested default's measured quality while using fewer reported tokens and slightly less median latency. The result supports two complementary rules:

1. Routine outcome-owning work can safely start on Fable 5 medium instead of a weaker cost-first route.
2. Explicit fast/bulk and specialist lanes can reduce cost without lowering measured quality on the evaluated task set.

## Untested Surface

This run did not evaluate four provider-specific routes, tool-using tasks, images, long-context inputs, fallback execution, repeated-run variance, rate-limit behavior, adversarial task descriptions, human semantic grading, or dollar-denominated cost. The fixed rubric measured bounded answer correctness, not full autonomous completion.

## Verdict

**ship** — use the strongest tested route as the routine executor, then route bounded fast/bulk and specialist work explicitly. Re-run the paired suite when the roster, provider access, or task mix changes materially.
