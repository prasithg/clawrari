# Failure Boundaries and Run Records: Documentation Evaluation

## Header

- **Change under test:** [attachment handling](../../docs/self-improvement.md#keep-optional-attachment-failures-local), [measurement recovery](../../docs/self-improvement.md#25-recover-the-measurement-without-changing-the-score), [timeout diagnosis](../../docs/self-improvement.md#26-diagnose-timed-out-work-from-its-transcript), and the [agent prompt template](../../reference/agent-prompt-template.md#compile-the-request-before-delegating).
- **Surface class:** workflow documentation and prompt template.
- **Linked ticket:** N/A; scheduled distillation of maintenance work and one existing public-artifact refresh.
- **Fault side:** optional-download aggregation belongs to the tool; failed measurement recovery belongs to the evaluation runner; repeated checking can involve both model behavior and runtime configuration. Missing evidence does not establish a fault side.
- **Method:** manual walkthroughs of synthetic scenarios against saved baseline text and the edited documents. These are instruction-coverage checks, not executed application tests or measurements of agent behavior.

The source work repaired attachment-read outcomes, bounded transient probe retries, and classified timed-out runs from session evidence. The template refresh carries existing workspace rules for prompt storage, duplicate prevention, and read-only recovery inspection. Private reports, accounts, file identifiers, transcripts, and configuration values are excluded. No source implementation or skill is ported.

## Task Set

1. Read messages with optional attachments while preserving file validation and credential boundaries.
2. Recover a failed measurement without treating an unavailable result as a score.
3. Diagnose timed-out work and separate configuration repair from reliability evidence.
4. Inspect or resume a delegated run without exposing prompts or creating duplicate workers.

## Baseline vs New

### Attachment Cases

| Synthetic input | Baseline text | Decision supported by edited text | Walkthrough |
| --- | --- | --- | --- |
| A message page completes; one optional attachment fails and two download correctly | Requires run failure when a requested supported attachment cannot be retrieved | Keep the page and two valid files; report one file failure. If all attachments are required, the overall task remains incomplete. | Pass |
| The message-page request fails before attachments are enumerated | File validation is described, but the page/file success boundary is not explicit | Fail the read. Per-file tolerance cannot substitute for its required message output. | Pass |
| A message contains an external-provider file object | Validates response type and length without stating a provider boundary | Make no credentialed request to an unauthorized destination, including through redirects. Skip with a reason or use a separately authorized provider adapter. | Pass |

### Measurement Cases

| Synthetic input | Baseline text | Decision supported by edited text | Walkthrough |
| --- | --- | --- | --- |
| A read-only probe hits a recognized transient session failure, then completes | Instrument errors are distinguished from health results; retry policy is unspecified | Retry within a fixed budget using a fresh isolated session; clean up the failed session and retain the attempt evidence. Score only the completed measurement. | Pass |
| A probe cannot authenticate or uses an invalid option | No explicit transient/permanent retry boundary | Stop retries and report the prerequisite failure. Do not tune behavioral thresholds. | Pass |
| Every allowed attempt fails | Inspection failure cannot establish healthy behavior; cleanup and terminal retry behavior are unspecified | Clean up only probe-owned sessions; mark the measurement unavailable and retain failed-attempt counts. A valid but unfavorable score is not eligible for this retry rule. | Pass |

### Timeout Cases

| Synthetic input | Baseline text | Decision supported by edited text | Walkthrough |
| --- | --- | --- | --- |
| Gateway logs are quiet, but one session contains many repeated status checks | Distinguishes runtime defects from broken checks without defining this diagnostic source | Classify the repeated work from the session evidence. Several calls in the same run do not become several independent incidents; quiet logs alone do not prove a provider stall. | Pass |
| Some timed-out sessions have no usable transcript | No explicit timeout classification rule for missing evidence | Retain unknown classifications. Do not change provider timeouts on unsupported attribution. | Pass |
| A repaired configuration passes short cases, but the required observation period is unfinished | Activation and remaining-failure rules already limit broad success claims | Verify effective overrides, preserve historical failures, and keep configuration preservation, behavior checks, and reliability completion separate. | Pass |

### Run-Record Cases

| Synthetic input | Baseline text | Decision supported by edited text | Walkthrough |
| --- | --- | --- | --- |
| A launcher records a prompt digest but also puts the full prompt in its command arguments | Requires a digest and durable recovery record without an explicit raw-prompt storage boundary | Keep the body out of process arguments and the lifecycle ledger. Store any recovery copy in an access-controlled task artifact. | Pass |
| A matching run is already active | Says recovery must not launch an untracked duplicate | Reject the duplicate before launch. The launcher must enforce this; the prompt is not an implementation. | Pass |
| A duplicate-prevention lock has uncertain ownership and a status command could relaunch work | Requires inspecting existing output when a child is missing, but does not address uncertain locks | Refuse the new launch until inspection resolves ownership and the existing run's status. Status and recovery inspection remain read-only; any replacement is a separate explicit launch. | Pass |

## Metrics

- **12 of 12 manual scenarios** have an explicit, bounded decision in the edited text.
- One mapped artifact is refreshed: the agent prompt template.
- Three recent-work lessons are captured in the existing Self-Improvement document.
- No runtime code, live settings, credentials, scoring thresholds, or observation windows change.
- Latency, cost, and production reliability are not measured by this documentation evaluation.

## Grader / Eval-Fault Check

The baseline already distinguishes an inspection failure from a health result and warns against duplicate recovery. The additions specify failure scope, retry eligibility, credential destinations, evidence for timeout attribution, and launcher responsibilities. The tables credit those existing protections rather than treating them as absent.

Manual coverage cannot prove that a downloader blocks a redirect, a retry classifier recognizes every transient error, or a launcher rejects concurrent starts. A passing walkthrough is evidence about the instructions only.

The writing detector initially received raw Markdown and flagged headings, links, and anchors using Slack-specific formatting rules. Rechecking the rendered prose produced no high-severity flags. The raw result is retained in private run evidence; Markdown structure remains part of the public document format.

**False-alarm cost:** no alert is added. Escalating an optional file failure can hide a useful completed read; suppressing a required file failure can falsely report completion. Reporting every dependent check as a separate behavioral defect can also waste the operator's investigation time. Per-file reporting and unavailable-measurement status preserve the distinction.

## Untested Surface

No live download, redirected credential transfer, provider outage, retry storm, session cleanup, concurrent launch, lock takeover, or scheduled-agent behavior was exercised here. The required long-term reliability observation is not performed or claimed. The public documentation does not certify the private source implementations.

## Verdict

**Ship** the bounded documentation update. The walkthroughs support publication of the instructions; they do not establish runtime enforcement or production reliability.

An independent Claude Code review found no material factual, privacy, or contradiction issue. It verified the new local links and anchors and the twelve-case count. Its optional clarification was applied: an uncertain duplicate-prevention lock explicitly blocks a new launch until resolved. The review covered documentation, not runtime behavior.

## Artifact Path

`reports/evals/2026-09-17-failure-boundaries-and-run-records.md` contains the synthetic inputs, baseline comparisons, decisions, and manual results.

## Sign-off

- Run by: Codex, GPT-6.
- Independent reviewer: Claude Code.
- Date: 2026-09-17.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-17), Self-Improvement, and the agent prompt template.
