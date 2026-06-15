# MEMORY.md: Index

This file is the map of the memory system. It is not where facts live. It points to the files where they live.

Keep it short. An index that grows into a second copy of the memory store stops being an index. Aim for one line per pointer, under ~150 characters each.

## Load order at session start

1. `SOUL.md`: identity and stable behavior
2. `USER.md`: who the human is, permissions, risk boundaries
3. `memory/session-brief.md`: what matters right now
4. `memory/subagent-ledger.md`: background work that may have stalled
5. today's and yesterday's `memory/YYYY-MM-DD.md`: recent activity
6. this file (`MEMORY.md`) for full orientation on longer sessions

## Pointers

### Constitutional (rarely changes)
- [SOUL.md](../SOUL.md): values, voice, operating principles
- [USER.md](../USER.md): human profile, approval model
- [rules-constitutional.md](rules-constitutional.md): hard limits, high stability
- [rules-tactical.md](rules-tactical.md): evolving conventions and playbooks

### Strategic (review each quarter)
- [projects.md](projects.md): active projects, status, blockers
- [people.md](people.md): relationship context and communication preferences
- [preferences.md](preferences.md): observed human patterns
- [context-holds.md](context-holds.md): temporary priority overrides with expiry
- [predictions.md](predictions.md): calibration log

### Operational (high churn, archive after 30 days)
- [YYYY-MM-DD.md](.): daily logs
- [regressions.md](regressions.md): failures turned into guardrails
- [session-brief.md](session-brief.md): preconscious buffer
- [subagent-ledger.md](subagent-ledger.md): delegated-work tracking

## Rules for this file

1. One line per entry. If you need a paragraph, it belongs in the target file.
2. When you add a thematic file, add its pointer here the same day.
3. Prune dead pointers. A link to a file you deleted is worse than no link.
4. Lines past 200 may get truncated by the loader, so stay dense.
