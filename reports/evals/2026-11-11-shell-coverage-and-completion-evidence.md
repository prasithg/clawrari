# Evaluation: Shell Coverage and Completion Evidence

## Header

- **Change under test:** documentation additions in the [self-improvement guide](../../docs/self-improvement.md#verify-protection-in-the-agents-actual-shell) and one targeted refresh of the [writing-review skill](../../skills/avoid-ai-writing/SKILL.md#report-research-execution-and-source-coverage-separately).
- **Change type:** workflow documentation and skill instructions.
- **Linked ticket:** not applicable; scheduled documentation maintenance based on completed operational work.
- **Fault side:** command-launch environment for missing enforcement; reporting logic for unsupported completion claims; research orchestration for conflating input limits with execution failure.

## Method and Task Set

The author manually applied the pre-edit and revised instructions to the twelve synthetic cases below. Only the instructions were reviewed. The repository protection, reporting software, and research workers were not executed. The existing text was preserved for comparison before editing.

Acceptance requires a specific decision limited by the evidence for each case without granting permission to change another writer's files, claiming unsupported delivery, or relaxing promotion requirements. The case inputs and outcomes below are the review record.

## Shell Cases

| Task | Baseline instructions | Revised decision | Result |
| --- | --- | --- | --- |
| S1. A terminal resolves the protecting command, but a fresh agent resolves the underlying executable. | Isolate integration; no explicit test of executable resolution in the agent session. | Treat agent coverage as unverified and check the actual launch environment before relying on it. | Pass: terminal success cannot stand in for agent coverage. |
| S2. A hook detects replaced files only after checkout. | Protect scheduled data; no hook-timing requirement. | Require interception before replacement. Detection after replacement does not establish prevention. | Pass: timing determines the protection claim. |
| S3. Protected records are dirty while a separate checkout needs integration and the shared checkout needs a read. | Isolate integration and preserve unrelated files. | Retain that boundary and explicitly test permitted reads and isolated integration alongside refusals. | Pass: protection has a positive control. |
| S4. A desktop client bypasses the command-search path while another process appends between inspection and execution. | Active-writer risk is named; these enforcement limits are unstated. | Name both bypass and concurrent-write limits. Require coordinated access for a stronger guarantee. | Pass: the documentation does not promise universal protection. |

## Reporting Cases

| Task | Baseline instructions | Revised decision | Result |
| --- | --- | --- | --- |
| D1. A tracker says complete, and its description cites an existing commit that introduced a failure. | Existing guidance requires observable completion but does not address this citation context. | Keep delivery unverified; an existing failure citation cannot prove a successful repair. | Pass: relevance and existence are separate. |
| D2. A notification task has a successful, confirmed delivery after its relevant change. | Existing run-recovery guidance accepts verified effects. | Accept the evidence for the notification task while making no deployment claim. | Pass: valid success remains reportable. |
| D3. Code is published, but the owner declined deployment and withdrew the old numerical target. | Implementation and live deployment are already distinct. | Preserve the unapplied decision, show measured values without the withdrawn target, and do not reopen the request. | Pass: evidence cannot override the decision. |
| D4. A delay report combines current deliveries with replayed and backfilled records. | Existing event guidance excludes skipped events, but does not give this reporting rule. | Exclude non-live records from live latency, disclose exclusions and counts, and investigate implausible values. | Pass: the measurement retains its population boundary. |

## Research Cases

| Task | Baseline instructions | Revised decision | Result |
| --- | --- | --- | --- |
| R1. One declared optional input is unavailable; the remaining samples meet the declared minimum and both reviewers complete. | Lists the sources and dual review without a partial-coverage outcome. | Report completed execution with the missing source and its limits. | Pass: missing optional input is not a required-reviewer failure. |
| R2. All inputs are unavailable, leaving no usable samples. | No explicit no-analysis branch. | Save a dated no-analysis result; do not launch reviewers or report a clean review. | Pass: absence of input cannot become a favorable assessment. |
| R3. One required reviewer fails and the other returns valid findings. | Requires two reviewers but does not define the partial outcome. | Preserve partial findings, report the failed requirement, and disable promotion. | Pass: surviving output does not satisfy dual review. |
| R4. Both required reviewers finish successfully with zero candidates; confirmation is delayed. | Zero findings are compatible with the loop, but retry behavior is unstated. | Inspect the saved terminal result; accept zero candidates and avoid a duplicate review launch. | Pass: confirmation reads do not repeat the work. |

## Metrics

- Manual documentation decisions: 12 of 12 meet the stated acceptance criterion.
- Mapped artifact groups refreshed: one, the writing-review skill directory.
- Executable changes: none. No runtime reliability or model-quality gain is measured.
- Source records published: none. All case inputs above are synthetic.

## Grader / Evaluation-Fault Check

The same author drafted the changes and reviewed the cases. This is not an independent model comparison. The baseline is the public text before this edit, not a historical execution. Existing guidance that already handles a case is retained rather than counted as a new runtime improvement.

The source research procedure contains inconsistent guidance about promotion after a required reviewer fails. This refresh preserves the existing dual-review requirement and explicitly disables promotion for that incomplete run. It does not copy a weaker threshold or certify the source implementation.

For a future command check, false refusals cost the operator an interrupted repository operation; permitted-operation controls help expose that cost. Overly narrow completion evidence can hide valid work, so the reporting cases include a confirmed success. These are risks to test, not measured false-alarm rates.

## Untested Behavior

No live agent shell, Git hook, scheduler, delivery service, concurrent writer, research reviewer, or detector was exercised by this evaluation. The review does not measure behavior change in future agents or the completeness of protection against command bypasses. It does not run a promotion or change writing scores.

## Result

**Ship the documentation.** The cases support the stated distinctions and limits. Adopters must verify their own implementations before claiming those protections or execution outcomes.

## Artifact Path

`reports/evals/2026-11-11-shell-coverage-and-completion-evidence.md` contains the complete synthetic case inputs, baseline interpretations, and reviewed outcomes. No private operational evidence is required to read the cases.

## Sign-off

- Run by: documentation-maintenance agent (GPT-6), manual case review.
- Date: 2026-11-11.
- Linked from: repository changelog, self-improvement guide, writing-review skill, and skill changelog.
- Lesson: verify the environment that executes a protection and the evidence relevant to the claimed outcome; keep missing evidence separate from completed work.
