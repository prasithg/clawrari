# Tool Contracts and Child Steering: Documentation Evaluation

## Header

- **Change under test:** three maintenance patterns in [Self-Improvement](../../docs/self-improvement.md#19-command-help-must-have-no-side-effects), plus the [existing-child steering section](../../reference/agent-prompt-template.md#steer-an-existing-child) in the public agent prompt template.
- **Surface class:** workflow documentation and prompt template.
- **Linked ticket:** N/A; scheduled capture of tested maintenance components and one existing-template refresh.
- **Fault side:** command parsing and side-effect defaults belong to the harness; missing checkout dependencies belong to the workspace environment; download validation belongs to the tool. Child addressing belongs to orchestration. These repairs must reach their owning components.
- **Method:** manual walkthroughs of synthetic scenarios against the old and refreshed documentation. These are instruction-coverage checks, not executed runtime comparisons.

The source material includes maintenance evaluations and standing child-steering guidance. Private records, downloaded files, service identifiers, and internal links are excluded. Runtime-specific wrappers are not part of this port.

## Task Set

1. Request help, pass an invalid selection, and diagnose one failing check without triggering a scheduled alert.
2. Preserve required checkout inputs and durable evidence while excluding disposable output.
3. Accept a valid attachment, reject a misleading response, and preserve existing output when downloading is disabled.
4. Correct an existing child, resolve an ambiguous handle, and recover after a missing acknowledgement.

## Baseline vs New

### Command-interface cases

| Synthetic task | Baseline documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| Ask for help on a runner that can send alerts | General verification guidance does not specify help side effects | Parse first; return usage successfully with no checks, reports, or sender calls | Pass |
| Supply a missing or unknown selection | No rule for accidental broadening or empty success | Reject before work; neither run everything nor report a zero-check pass | Pass |
| Run one failing check, then a scheduled failing run | Alert guidance does not distinguish the invocation modes | Focused failure stays local and returns failure; the scheduled positive control reaches a fake sender | Pass |

### Checkout and evidence cases

| Synthetic task | Baseline documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A tracked launcher imports an untracked helper with a common filename | Workspace audit lacks a dependency inventory procedure | Review path-qualified consumers and classify the helper; lack of a text match does not prove it unused | Pass |
| An ignore proposal covers JSON fixtures and raw logs | No paired durable/disposable ignore-rule check | Test both classes in a temporary repository; use specific disposable locations | Pass |
| Deferred dependency decisions are stored only in a pruned log | General provenance guidance does not address this storage failure | Keep the inventory and completion evidence durably; handle already-tracked log retention separately | Pass |

### Attachment cases

| Synthetic task | Baseline documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| A request returns successful-status HTML instead of a supported file | No download-specific validation contract | Treat it as a failed fetch and save no attachment | Pass |
| Metadata exceeds the limit, or received bytes differ from the expected length | No pre-fetch versus pre-save distinction | Skip policy-excluded metadata before fetching; fail a length mismatch before saving | Pass |
| Compare output with downloading off, then retrieve one valid file | No optional-feature compatibility rule | Preserve old output when off; report a saved file only after validation and restricted local storage | Pass |

### Child-steering cases

| Synthetic task | Baseline documentation | Decision supported by refreshed text | Walkthrough |
| --- | --- | --- | --- |
| Requirements change while a child is running | Run identities are recorded, but send-time resolution is unspecified | Resolve one matching child and send a scoped correction with an ID | Pass |
| A recovered task handle matches multiple children | No explicit ambiguous-handle decision | Inspect and resolve ambiguity before messaging or replacing any child | Pass |
| A correction acknowledgement times out | Generic recovery forbids an untracked duplicate but gives no acknowledgement distinction | A slow acknowledgement is not proof of absence; inspect state and durable output before a distinct replacement | Pass |

## Metrics

- **12 of 12 manual cases** find the required decision in the refreshed text. This measures documentation coverage, not runtime reliability.
- One mapped public artifact is refreshed: the agent prompt template. Three recent-work patterns are distilled separately.
- No model benchmark, live send, download, or checkout restoration ran as part of this evaluation.
- Latency and cost are not used to grade this documentation change.

## Grader / Eval-Fault Check

A keyword match alone would not establish the right decision. The walkthroughs check the consequence: help causes no work, a focused failure remains a failure, unsupported metadata differs from a failed fetch, and a timeout does not authorize a duplicate worker.

A correction ID is a receiver-side deduplication convention. The template does not claim exactly-once delivery. A metadata and length check is not proof that an attachment is safe to execute.

**False-alarm cost:** no live validator or alert is added by this change. An implementation of the command pattern should retain the scheduled failing-run positive control, so disabling every sender cannot appear to fix the problem.

## Untested Surface

No live child dispatch, duplicate-delivery enforcement, concurrent recovery, clean-checkout execution, credential redirect handling, malicious file content, or streaming resource limit was tested. Checking a fully received body before saving does not prove a bounded download-memory footprint. Public instructions do not certify the private implementations.

## Verdict

**Ship** the documentation and template refresh within those limits. The change supplies missing decisions without publishing private operational artifacts or claiming an end-to-end runtime test.

## Artifact Path

`reports/evals/2026-09-13-tool-contracts-and-child-steering.md` contains the synthetic inputs, baseline comparison, and walkthrough results.

## Sign-off

- Run by: Codex, GPT-6 Astra.
- Date: 2026-09-13.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-13), Self-Improvement, and the agent prompt template.
