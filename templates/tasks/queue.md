# Task Queue

Async and night-work tasks. Claim the task, do the work, close it with verification.

**Status machine:** `pending` → `claimed` → `in_progress` → `done` | `failed` | `blocked`

## P1

### [P1] Example Task Name
- **Type:** code | research | ops | content
- **Goal context:** Why this matters beyond the local task.
- **Acceptance criteria:** Observable, testable done state.
- **Status:** pending
- **Claimed by:** unassigned
- **Executor model:** unset
- **Output path:** reports/example-output.md

## P2

_Add medium-priority tasks here._

## P3

_Add backlog tasks here._

## Completed

| Date | Task | Output | Notes |
|------|------|--------|-------|
| YYYY-MM-DD | Example completed task | reports/example.md | Validation passed |

## Failed / Needs Retry

See `systems/failures/` for structured failure records.

| Date | Task | Failure Mode | Status |
|------|------|--------------|--------|
| YYYY-MM-DD | Example failed task | Output file never written | needs-retry |
