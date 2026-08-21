# Live-First Artifact Lifecycle Eval

## Header

- **Change under test:** Live-first artifact routing through `skills/artifact-lifecycle/SKILL.md`, plus bounded periodic cleanup.
- **Surface class:** skill + core workflow + automation policy.
- **Linked ticket:** N/A — public distillation of an internally evaluated workflow.

## Task Set

1. Land an authorized automation-policy change without creating an unnecessary skill proposal.
2. Create and activate a real agent skill when the operator explicitly asks for a live workflow.
3. Clean an existing proposal queue without asking the operator to approve each clean or superseded artifact.
4. Preserve human-authored and canonical files while scheduling bounded cleanup of clearly agent-generated artifacts.

## Baseline vs New

| Task | Baseline behavior | New behavior | Delta |
| --- | --- | --- | --- |
| 1 | Durable changes were sometimes mislabeled as skills and left pending. | The existing automation was updated directly and verified live. | Removed an unnecessary approval and staging step. |
| 2 | A clean proposal was created, reported as pending, and handed back to the operator. | The proposal was created through the governed workflow and applied in the same run after validation. | A real skill still uses governed transport without becoming an approval chore. |
| 3 | Clean or superseded proposals accumulated in the queue. | Valid proposals were applied and a duplicate was rejected because the live configuration already contained the behavior. | Removed queue debt with evidence-based lifecycle actions. |
| 4 | Periodic cleanup only proposed commands and required later approval. | Cleanup may move only clearly agent-owned, stale, unreferenced artifacts to reversible quarantine; human-authored, canonical, referenced, or uncertain files remain audit-only. | Cleanup became automatic within an ownership-bounded safety fence. |

## Metrics

- **Task success:** 4/4 pass.
- **Skill validation:** the platform skill check exited successfully and the skill was visible.
- **Proposal queue:** four pending proposals before cleanup; zero pending afterward.
- **Automation validation:** the periodic job remained enabled with bounded-cleanup and proposal-audit rules.
- **Qualitative verdict:** Ordinary artifacts no longer become skills merely because they are durable, while real skills retain governed creation and validation.

## Untested Surface

The periodic cleanup was inspected but not force-run because the full health scan sends an external status message and has a long runtime. The first scheduled run remained responsible for testing live quarantine behavior; unknown ownership stays audit-only by design.

## Verdict

**ship** — adopt the live-first routing rule and retain the bounded hygiene pass.

## Artifact Path

This public report contains the sanitized evaluation summary. Private raw fixtures and internal automation identifiers are intentionally excluded.

## Sign-off

- Run by: agent operator and independent evaluator.
- Date: 2026-07-15.
- Linked from: `skills/artifact-lifecycle/SKILL.md`.
