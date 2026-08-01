# Bootstrap-parity harness — run note

**Harness:** `scripts/test-bootstrap-parity.sh`
**Last run:** 2026-08-01 — **RESULT: PASS (63/63 assertions), exit 0, temp dir cleaned up.**

## What it does

Drives `bootstrap/init.sh` non-interactively against a throwaway `mktemp -d`
workspace, feeding answers derived from `bootstrap/questions.json`, then asserts
the generated workspace reaches parity with the canonical setup. Fully
self-contained and reversible: it writes **only** inside the temp dir (via
`OPENCLAW_WORKSPACE`), a trap cleans up on every exit, and it never mutates the
repo or the live workspace.

## Parity checks (real assertions — not a pass-through stub)

1. **Canonical root templates all render.** The expected set is *derived
   dynamically* from `bootstrap/templates/*.tmpl` — the same source `init.sh`
   loops over — so adding/removing a canonical template is caught here instead
   of silently passing a frozen checklist. (Currently 10: AGENTS, HEARTBEAT,
   IDENTITY, MEMORY, SOUL, TOOLS, USER, context-holds, predictions, regressions.)
2. **Seeded memory/tasks/ideas files exist** — dated daily note, session-brief,
   subagent-ledger, heartbeat-state.json, queue, inbox, and the index files.
3. **Directory scaffold exists** (memory, memory/reference, tasks, drafts,
   reports, ideas, systems, systems/failures, reference).
4. **Value parity** — answers propagate to the right files: IDENTITY.md (AI
   name, human, born date), USER.md (name, timezone, role, priorities 1-3,
   topics, writing style, tone), session-brief.md (priorities, personality),
   daily-note setup line.
5. **`heartbeat-state.json` is valid JSON** (`jq -e`).
6. **No unrendered `{{...}}` placeholders** remain in any rendered template.

Exits **non-zero** on any failed assertion and prints the concrete failure list.

## How answers are derived

14 answers from `questions.json` defaults via `jq`, in the exact order `init.sh`
reads them. The two required fields with empty defaults (name, role) get fixed
test values ("Parity Tester", "QA engineer…") so `ask_required` doesn't loop;
every other value is the `questions.json` default verbatim — that IS the parity
contract. `questions.json`'s `slack_workspace` is intentionally unused (init.sh
never reads it), so exactly 14 piped answers line up with 14 read prompts.
Pointing `OPENCLAW_WORKSPACE` at a fresh non-existent subdir also sidesteps
init.sh's "overwrite existing files?" prompt.

## Verification performed this session

- `bash -n scripts/test-bootstrap-parity.sh` → exit 0 (syntax OK).
- `./scripts/test-bootstrap-parity.sh` → PASS 63/63, exit 0.
- Born date rendered as today's date (2026-08-01), confirming live run.
- `git status --porcelain` after run shows no stray/tracked-file changes beyond
  the intended edits; leftover temp dirs: none (trap cleanup verified).

## Dependencies

`bash` (3.2-compatible), `jq` (`/usr/bin/jq`), `perl` (used by init.sh). No new deps.

## Notes / history

A working version of this harness already existed (built under PRA-205). This
session verified it still passes on current repo state and hardened it: the root
template expectation is now derived from the canonical `bootstrap/templates/`
dir rather than hardcoded, closing a drift gap. Not committed, not pushed.
