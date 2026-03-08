# Sub-Agent Ledger

Append-only record of sub-agents spawned. Check for 🔄 rows at session start.
Any row >2 hrs old with no output file → flag as stale.

---

## Active / Recent

| Date | Label | Task | Expected Output | Status |
|------|-------|------|-----------------|--------|
| YYYY-MM-DD HH:MM | example-agent | Example research task | reports/example-YYYY-MM-DD.md | 🔄 IN PROGRESS |

---

## Archive

> Move completed/failed rows here after resolution. Keep Active table clean.

| Date | Label | Task | Output | Status |
|------|-------|------|--------|--------|
| YYYY-MM-DD HH:MM | example-agent | Example completed task | reports/example-YYYY-MM-DD.md | ✅ DONE |

---

## Status Legend

| Icon | Meaning |
|------|---------|
| 🔄 IN PROGRESS | Agent running or recently spawned |
| ✅ DONE | Completed, output file confirmed |
| ❌ FAILED | Agent failed or output never appeared |
| ⏳ STALE | >2h old, no output — needs investigation |
| 🔁 RETRY | Failed, queued for retry |

---

## Protocol

**Before spawning a sub-agent:**
1. Add a row to this ledger with status 🔄 IN PROGRESS
2. Include the exact output file path in Expected Output

**At session start:**
1. Scan this table for 🔄 rows
2. Check if the Expected Output file exists
3. If not: mark ⏳ STALE or ❌ FAILED, add to open loops in session-brief.md

**On completion:**
1. Update status to ✅ DONE
2. Confirm output file path is accurate
3. Archive the row at next cleanup
