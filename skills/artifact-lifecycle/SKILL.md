---
name: "artifact-lifecycle"
description: "Route internal changes live-first, reserve skill tooling for real skills, and audit generated artifacts."
---

# Artifact Lifecycle

Implement authorized internal work directly. Do not turn every durable change into a skill.

## Classify the artifact

1. **Code, config, documentation, scripts, tests, or reports**
   - Edit the live artifact directly.
   - Verify it in the same run.
   - Do not create a skill proposal merely because the change is reusable or durable.

2. **A real agent skill**
   - Use the platform's governed skill workflow when one exists.
   - Use a skill only when triggerable procedural context or bundled reusable resources materially improve future execution.
   - If the operator asks to create, install, enable, or make the skill live, complete the governed workflow in the same run when validation passes.
   - Leave a proposal pending only when the operator explicitly asks for a draft or validation fails.
   - Never present a clean pending proposal as an approval chore.

3. **Temporary agent-generated material**
   - Keep it under an explicitly generated or temporary location, or name it clearly.
   - Record its owner and retention criterion when they are not self-evident.
   - Do not mix temporary output into canonical or human-authored files.

## Verify before landing

For material changes, run the smallest representative checks that prove the artifact works. Skill and core-workflow changes require a linked evaluation artifact following `reference/skill-change-eval-template.md`.

## Periodic hygiene

Audit agent-generated artifacts and pending skill proposals on a regular schedule.

- Identify duplicates, superseded variants, abandoned drafts, and stale temporary output.
- Preserve human-authored work and anything still referenced by live configuration, automation, tickets, skills, or documentation.
- Reject or quarantine proposals only through the governed skill workflow.
- Prefer reversible quarantine or archive over deletion when ownership or usage is uncertain.
- Report only actions taken, failures, or a decision that cannot be resolved from evidence.
- Do not create a new proposal merely to describe the cleanup.

## Hard boundaries

- Never bypass the governed workflow for actual skill creation or updates.
- Never delete or overwrite human-authored data.
- Never leave ordinary implementation work staged behind an approval queue.
- Never claim completion without verification and, where required, an evaluation.

## Verification evidence

See `reports/evals/2026-07-15-artifact-lifecycle-live-first.md` for the evaluated task set, results, and untested surface.
