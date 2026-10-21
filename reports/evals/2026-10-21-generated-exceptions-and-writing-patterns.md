# Generated-File Exceptions and Writing-Review Candidates

The documentation explains how a generated-data exception can hide maintained instructions. It also adds three writing-review candidates with synthetic examples and explicit limits.

## Change Under Review

- **Change type:** public workflow documentation and one existing writing-skill pattern file.
- **Files:** [self-improvement guide](../../docs/self-improvement.md#57-keep-generated-file-exceptions-narrow) and [writing candidates](../../skills/avoid-ai-writing/patterns/v4-emerging.md#2026-10-21-generalized-writing-review-candidates).
- **Issue:** none. This scheduled documentation update captures work already performed.
- **Failure location:** the audit's classification and matching rules. A generated-folder exception can hide a maintained instruction file unless the matcher checks each file's role.

Only the writing-pattern file is selected from the mapped synchronization backlog. No installed skill, runtime detector, model route, or scheduled-job setting changes in this public commit.

## Method

This is a manual documentation evaluation. The tables compare the saved pre-edit documents with the proposed instructions on twelve hypothetical cases. These are reasoning checks, not executed audit tests, model trials, or measured writing-quality improvements.

The earlier guide discusses limited exceptions and acceptance evidence but does not cover instruction files nested inside generated directories. The earlier candidate file does not contain these three review patterns. Existing guidance remains unchanged.

## Exception Cases

| Case | Representative task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| E1 | Review generated JSON with a known writing job and a narrow, documented exception. | General exception guidance; this classification is unspecified. | Permit the exception after classification; show the path and reason. |
| E2 | Review an instruction file inside the same generated directory. | No explicit per-file protection at this boundary. | Keep the instruction file under review despite the directory match. |
| E3 | Review source code nested beside generated output. | No explicit source-file check inside an exception. | Review the source file separately; generated output can remain excluded. |
| E4 | Review one document containing generated output and maintained guidance. | Ownership treatment is unspecified. | Keep the document under review and separate the uses when ownership is unclear. |
| E5 | Read an invalid exception list or an empty review window. | No explicit combined boundary treatment. | Report invalid configuration as incomplete verification; test the empty window independently. |
| E6 | Review a hand-edited data file whose extension looks generated. | No limitation stated for this case. | State that file-type checks cannot resolve it; require separate review when the role changes. |

## Writing Cases

| Case | Representative task | Earlier guidance | Revised guidance and reviewed outcome |
| --- | --- | --- | --- |
| W1 | Review an unsupported claim that everyone chooses one factor while another is decisive. | This candidate is absent. | Question both claims and retain only the supported relationship. |
| W2 | Review a sourced comparison of two measured bottlenecks. | This candidate's boundary is absent. | Preserve a useful, supported contrast. |
| W3 | Replace an analogy that stands in for response-time evidence. | This candidate is absent. | Use measurements only if available; otherwise label the impression or remove the claim. |
| W4 | Review attributed feedback describing how a tool feels. | This candidate's boundary is absent. | Retain the attribution; do not present feedback as a measurement. |
| W5 | Rewrite a decorative claim of honesty before a compatibility limitation. | This candidate is absent. | State the verified limitation directly. |
| W6 | Review the distinction between an actual value and an estimated value. | This candidate's boundary is absent. | Preserve the factual adjective; a word match alone is insufficient. |

## Metrics and Evaluation Check

All twelve manual cases have an explicit, appropriate outcome under the revised text. Six concern file exceptions and six concern writing candidates. No latency, cost, accuracy, or production-success claim is made.

The writing examples are deliberately synthetic. The review checks that a rewrite preserves evidence and does not invent a benchmark result. It also checks that proposed severity labels are not presented as installed enforcement.

False alarms would send legitimate generated output or useful comparisons back for unnecessary review. The operator or editor would pay that cost. Wrong exclusions could hide instruction changes; wrong rewrites could delete a useful distinction. Both kinds of error need negative examples before automation is adopted.

## Untested Behavior

No audit implementation or writing detector is executed by this evaluation. It does not test arbitrary file extensions, mixed-author data, live scheduled runs, or natural-language detector precision. The source work still needs its required later scheduled observations; this documentation update does not complete those observations.

## Verdict (Result)

**Ship the documentation and manual-review candidates.** Automatic promotion remains separate and requires recurrence evidence plus false-positive tests.

## Artifact and Sign-Off

The complete case records are the E1–E6 and W1–W6 tables in this file: `reports/evals/2026-10-21-generated-exceptions-and-writing-patterns.md`. The [changelog](../../CHANGELOG.md#2026-10-21) links this evaluation.

Reviewed by: Claw, GPT-6 Astra. Date: 2026-10-21.

Lesson: validate the actual files an exception matches, and preserve the distinction between a review candidate and a running check.
