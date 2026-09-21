# Retry Boundaries and Observable Contracts: Documentation Evaluation

## Header

- **Change under test:** [interrupted-job recovery](../../docs/self-improvement.md#31-recover-interrupted-jobs-from-verified-effects), [configuration comparison](../../docs/self-improvement.md#32-define-what-must-match-before-comparing-configuration), and [observable acceptance criteria](../../reference/agent-prompt-template.md#turn-vague-requirements-into-checks).
- **Surface class:** workflow documentation and agent prompt template.
- **Linked ticket:** N/A; scheduled distillation of real maintenance work and one mapped public artifact refresh.
- **Fault side:** external-action recovery belongs to the tool and orchestration boundary; an incorrect comparison belongs to the grader or task contract. Neither is repaired by telling a model to be more careful.
- **Method:** author-reviewed scenarios against the saved public baseline and edited text. These are documentation walkthroughs, not runtime or live-service experiments.

The source work observed successful external effects before a scheduled job timed out. Follow-up probes reproduced retry defects despite a passing existing local suite. A separate configuration read-back showed that the intended setting and generated metadata had changed, while a strict byte-identity premise rejected the result. The repair remained incomplete. This publication captures those failure boundaries without claiming the proposed repair works or exposing private run records.

The mapped prompt source already contains worked condition-and-result requirements for malformed input, warm-cache performance, and generated documentation. The public baseline contains the skeleton but not those worked examples. This refresh ports only that missing guidance and preserves the public template's existing review and handoff sections.

## Task Set

1. Decide whether to repeat a publication or its summary after an interrupted run.
2. Compare an applied setting change under an explicit byte-level or functional contract.
3. Convert vague parser, performance, and documentation requirements into observable checks.

## Baseline vs New

| Case | Synthetic scenario | Baseline coverage | Decision supported by new text | Manual walkthrough |
| --- | --- | --- | --- | --- |
| R1 | Publication is confirmed, but its status message is absent | Existing text separates exit status from side effects without defining per-action recovery | Recover only the missing summary. Do not repeat the publication. | Pass |
| R2 | Destination accepts a message; the process stops before saving its receipt | Existing text preserves local artifacts but does not cover the cross-system interruption gap | Reuse destination-supported idempotency or reconcile the exact operation. Uncertain evidence does not authorize a repeated write. | Pass |
| R3 | Existing tests pass, but a repeated update reports a different state from a subsequent read | Existing text warns that a passing check can be wrong | Preserve the reproduced failure, test states and external-effect counts, and keep live acceptance open. | Pass |
| C1 | A requested time-limit edit also changes only two explicitly allowed generated metadata fields | Existing text recognizes incidental service fields without defining the comparison contract | Preserve both snapshots and metadata values; verify the intended setting and all remaining functional settings. | Pass |
| C2 | The same edit unexpectedly changes the destination | General verification rules already reject unintended changes | Reject the functional change; the metadata allowance cannot hide it. | Pass |
| C3 | A strict byte-equality requirement encounters one removed trailing newline | Existing text requires exact acceptance evidence | Report that literal criterion as unmet. Resolve the contract explicitly; do not relabel the comparison as passing. | Pass |

## Template Refresh Cases

| Case | Baseline input | Source-derived improvement | Required evidence and limit | Manual walkthrough |
| --- | --- | --- | --- | --- |
| T1 | Parser behavior is described as robust | Name the malformed-input trigger, exact exit status, and error output | Run the actual parser with a fixture; written expected output is not observed output. | Pass |
| T2 | Cache performance is described as good | Name warm state, request count, percentile, and threshold | Run a benchmark under the stated conditions; example values do not constitute a performance result. | Pass |
| T3 | Documentation is described as clean | Name generation, non-empty output, and the project's linter | Attach command results. Formatting alone cannot establish content accuracy; use separate review evidence. | Pass |

## Metrics

- Nine of nine manual scenarios have explicit decisions or evidence requirements in the edited text.
- Exactly one mapped public artifact is refreshed: the agent prompt template.
- The self-improvement document gains two reusable lessons. The changelog and this report record their scope and limits.
- Local validation checks the edited files, links, and private-reference patterns; its output is retained in [the validation record](2026-09-21-retry-boundaries-and-contracts.validation.txt).
- No runtime code, job configuration, time limit, receipt implementation, model route, or skill catalog is changed.
- No claim of improved live reliability, exactly-once delivery, model behavior, latency, or cost follows from these walkthroughs.

## Grader / Eval-Fault Check

The baseline already separates side effects from process status, requires verification, and keeps missing evidence visible. This evaluation credits that coverage. The additions explain where local receipts stop providing assurance, define configuration comparison scope, and add worked requirements to the existing template.

The retry cases are synthetic review inputs. Their decisions describe what an implementation must establish; they are not evidence that a receipt helper, destination API, or concurrent scheduler provides those guarantees. The unfinished source repair remains unfinished.

The metadata allowance is explicit and bounded before comparison. Case C2 is a negative control: it remains a rejected change. Case C3 preserves the literal contract even when the difference appears harmless.

**False-alarm cost:** an overbroad comparison can block a valid configuration edit; an overbroad exemption can conceal a wrong destination. Operators bear both costs. No new alert or automatic exception is installed here.

## Untested Surface

No live send, push-recovery experiment, interrupted scheduler, concurrent writer, repaired receipt implementation, model A/B, or independent reviewer was exercised as part of this evaluation. Documentation checks do not install or prove enforcement. The publication itself is verified separately by the repository's landing tool.

## Verdict

**Ship** this documentation update. It records observed failure boundaries and source-derived acceptance examples. Runtime recovery and live acceptance require their own implementation and verification.

## Artifact Path

This report contains the scenario inputs, baseline comparisons, decisions, and manual results. [The validation record](2026-09-21-retry-boundaries-and-contracts.validation.txt) contains local check output. Private source evidence is intentionally not a public dependency.

## Lessons Learned

Verify external effects independently of process status. Test the gap between an accepted action and its saved receipt. Define the comparison contract before interpreting differences, and keep written acceptance criteria separate from executed evidence.

## Sign-off

- Run by: Codex, GPT-6.
- Date: 2026-09-21.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-21), Self-Improvement, and the agent prompt template.
