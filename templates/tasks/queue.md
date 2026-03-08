# Task Queue

Async and night-work tasks. Claw picks these up during off-hours or background sessions.

**Status machine:** `pending` → `claimed` → `in_progress` → `done` | `failed` | `blocked`

---

## 🔴 P1 — High Priority

### [P1] Example Task Name
- **Type:** code | research | ops | content
- **Goal context:** Why this task matters. Link to a project or strategic goal. The "why" prevents locally-correct/globally-wrong decisions.
- **Acceptance criteria:** Explicit done condition. What "done" looks like — observable, testable.
- **Sub-tasks:** (optional)
  - [ ] Step A
  - [ ] Step B
- **Status:** pending
- **Agent label:** *(filled when claimed)*
- **Started:** *(timestamp when claimed)*

---

## 🟡 P2 — Medium Priority

*(Add P2 tasks here)*

---

## 🟢 P3 — Low Priority / Backlog

*(Add P3/backlog tasks here)*

---

## ✅ Completed

| Date | Task | Output | Duration |
|------|------|--------|----------|
| YYYY-MM-DD | Example completed task | reports/example.md | ~25min |

---

## ❌ Failed / Needs Retry

See `systems/failures/` for structured failure records.

| Date | Task | Failure Mode | Status |
|------|------|--------------|--------|
| YYYY-MM-DD | Example failed task | Output file never written | needs-retry |

---

## Protocol

**Adding tasks:**
- Fill in all fields, especially `goal context` and `acceptance criteria`
- Goal context = the "why" that traces back to a meaningful objective
- Acceptance criteria = observable done condition, not "make it better"

**Claiming tasks (before spawning a sub-agent):**
1. Write `claimed (agent-label, YYYY-MM-DD HH:MM TZ)` to the Status field
2. Add a row to `memory/subagent-ledger.md`
3. Prevents duplicate spawning if heartbeats overlap

**On completion:**
- Update Status to `done`
- Move to Completed table
- Update subagent-ledger.md row

**On failure:**
- Update Status to `failed`
- Write a failure record to `systems/failures/YYYY-MM-DD-task-slug.md`
- Move to Failed table
