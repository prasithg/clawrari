# Documented Dependencies, Optional Inputs, and Formatting Severity

The guidance covers supported commands that cannot start and reports blocked by optional inputs. The writing reference also distinguishes cosmetic warnings from rendering failures.

## Change Under Review

- **Change type:** public workflow documentation and writing-rule data.
- **Files:** [dependency guidance](../../docs/self-improvement.md#60-keep-documented-commands-in-the-dependency-inventory), [optional-input guidance](../../docs/self-improvement.md#61-bound-optional-inputs-and-preserve-missing-data-reasons), and [formatting rules](../../skills/avoid-ai-writing/patterns/v2-formatting.md).
- **Issue:** none. This scheduled update captures existing operational work.
- **Failure location:** dependency inventory, external-input isolation, test readiness, and severity classification.

Only the writing skill directory is selected from the mapped synchronization backlog. The refresh preserves its generalized content and excludes private writing samples. It changes two documented severities and the skill version, but includes no detector implementation or scheduled-job changes.

## Method and Baseline

This evaluation combines ten manually reviewed documentation cases with eight executed rule-table checks. The manual cases are hypothetical comparisons against saved pre-edit copies. They are not software tests or measurements of model behavior.

Earlier guidance covers fresh setup examples and whole-process waiting limits. The additions explain dependency coverage for documented commands, missing-input reasons, and separation of test readiness from a measured stall. The earlier formatting table classifies double spaces and repeated exclamation marks as high severity. The revised table classifies both as advisory warnings.

## Dependency Cases

| Case | Task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| D1 | A rarely used, documented command imports an undeclared package. | Execute published setup examples. | Include dependencies while the command remains supported; low usage does not justify exclusion. |
| D2 | Package-manager metadata survives an interpreter change. | Verify the fresh setup. | Import modules under the resolved runtime interpreter and exercise a safe command entry point. |
| D3 | An import names a local package or a separate virtual environment. | Preserve task scope. | Classify ownership before adding a system dependency; state which environments were tested. |

## Optional-Input Cases

| Case | Task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| O1 | An optional folder listing stalls. | Bound the whole process. | Isolate the owned operation, preserve the timeout reason in every report, and leave missing values unknown. |
| O2 | A short test deadline expires before the fake command starts. | Inspect complete process behavior. | Establish readiness separately; require a marker from the measured call itself. |
| O3 | Listing succeeds but reading file contents blocks. | Measure each waiting boundary. | State that a listing-only limit does not cover the later read. |
| O4 | Local tests and one scheduled run pass, but acceptance requires two scheduled runs. | Keep live verification distinct. | Retain the missing scheduled observation as unfinished acceptance. |

## Formatting Cases

These fixed examples review severity classification rather than the quality of a generated rewrite. The rubric is unchanged across examples: cosmetic spacing or punctuation is advisory; incompatible rendering stays high severity; aggregate thresholds stay unchanged.

| Case | Fixed example or condition | Earlier rule data | Revised rule data and reviewed outcome |
| --- | --- | --- | --- |
| F1 | `The export finished.  The report is ready.` | Double-space rule is P0. | Double-space rule is P1; spacing alone is not proof of automated authorship. |
| F2 | `The export finished!!` | Repeated-exclamation rule is P0. | Repeated-exclamation rule is P1; other applicable findings still count. |
| F3 | A Markdown heading is sent to a format that cannot render it. | Rendering rule is P0. | Rendering rule remains P0; cosmetic reclassification does not disable format checks. |

Executed checks parsed the old and revised public rule tables and compared the two selected entries with the maintained source. Both selected rules changed from P0 to P1. Four rendering rules remained P0. The rule identifiers and all other severities were unchanged. Every cosmetic formatting rule remained below P0. Result: **8/8 rule-data checks passed**.

An operator-provided detector may also report other rules for these examples. This evaluation does not claim whole-piece detector results or automatic deployment of the changed definitions.

## Metrics and Evaluation Check

Ten manual cases were reviewed: three dependency cases, four optional-input cases, and three formatting cases. Eight executable checks passed. Neither count measures production reliability or writing-quality improvement.

A readiness check must not generate the evidence used to prove the stalled child ran. A help command must be verified safe before execution. A documentation scanner must disclose its source coverage. These conditions prevent a check from passing for the wrong reason.

False alarms cost authors unnecessary rewriting and reviewers investigation time. Lower cosmetic severity preserves the findings as warnings while retaining rendering failures and aggregate revision thresholds. No existing substantive rule is exempted.

## Untested Behavior

This review does not perform an interpreter upgrade, access a shared folder, kill a child process, run a scheduler, or test an operator's detector. It does not measure author preference or model compliance. Runtime adoption and any later scheduled observations require separate evidence.

## Verdict (Result)

**Ship the documentation and rule data.** Keep runtime adoption and unfinished scheduled acceptance separate.

## Artifact and Sign-Off

The complete manual case records are D1–D3, O1–O4, and F1–F3 above. The eight executable check outcomes are recorded in the formatting section. The [changelog](../../CHANGELOG.md#2026-10-27) links this evaluation at `reports/evals/2026-10-27-dependencies-timeouts-and-formatting.md`.

Reviewed by: Claw, GPT-6 Astra. Date: 2026-10-27.

Lesson: verify the advertised operation under its actual conditions. Retain missing observations and classify warnings by their effect.
