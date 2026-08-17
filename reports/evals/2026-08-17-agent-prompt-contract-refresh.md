# Agent Prompt Contract Refresh Eval

## Header

- **Change under test:** add audience-fit, surgical-code, observable-acceptance, and completion-proof contracts to the public agent prompt template.
- **Surface class:** prompt template.
- **Linked ticket:** N/A — scheduled public-sync refresh.
- **Fault side:** `owner` — the public copy had fallen behind the tested internal prompt structure.

## Task Set

1. Draft a decision memo comparing three infrastructure options for a technical lead.
2. Add a validation rule to an existing command-line tool without refactoring adjacent modules.
3. Produce a multi-file documentation update whose completion depends on link and lint checks.

## Baseline vs New

This was a static prompt-contract evaluation rather than three paid model runs. Each representative task was checked against both template versions.

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| Decision memo | Named the goal and constraints, but not the reader or wrong artifact class | Requires the audience, use context, reader knowledge, and adjacent artifact to avoid | Better artifact fit |
| CLI validation | Allowed broad coding guidance with no edit-to-requirement traceability | Requires a minimal plan, surgical edits, traceability, and a narrow verification command | Lower scope-creep risk |
| Documentation update | Could count file creation as completion | Requires per-criterion verification, output checks, a named untested surface, and a handoff | Stronger completion evidence |

## Metrics

- Task success: 3/3 representative tasks expose the intended contract at the point of use.
- Privacy review: examples and blocks contain no organization names, people, private URLs, internal identifiers, credentials, or financial details.
- Qualitative verdict: the new blocks improve prompt specificity without binding users to a particular model, provider, or internal toolchain.

## Grader / Eval-Fault Check

No model outputs were graded. The evaluation checks template coverage only, so there are no model failures to attribute. The main limitation is `fault:grader`: static coverage cannot measure downstream answer quality or compliance rates.

## Untested Surface

This eval did not run live agents, compare token use, test model-family differences, or measure whether agents obey every contract under long context or tool failure.

## Verdict

**ship** — publish the generalized contracts. Run a live paired evaluation if the template later becomes prescriptive about a particular model or execution harness.

## Artifact Path

This file contains the full static evaluation. The changed surface is `reference/agent-prompt-template.md`.

## Sign-off

- Run by: Claw (scheduled public-sync run)
- Date: 2026-08-17
- Linked from: `reference/agent-prompt-template.md`
