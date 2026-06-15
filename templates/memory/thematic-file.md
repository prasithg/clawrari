# [Theme] (e.g. projects.md, people.md, preferences.md)

Durable facts for one theme. This is a promotion target: entries arrive here from the daily log once they prove they matter past a single day.

Every entry carries a type tag, and a trust block when it is something you may act on. Use supersede chains when a fact changes rather than overwriting, so the audit trail survives.

## Active

### [Entry name]
- One claim per bullet, tagged.
- Example: Prefers short replies, no trailing summaries [type:pref|trust:9|src:direct|hits:12|used:YYYY-MM-DD]
- Example: Ships behind a feature flag by default [type:habit|trust:8|src:observed|hits:5|used:YYYY-MM-DD]

## Supersede chains

When a fact changes, mark the old one SUPERSEDED and add the new one as CURRENT. Keep both.

```
## Role history
- [2026-01-01] Engineering lead at Company A [type:fact|trust:10|src:direct] (SUPERSEDED)
- [2026-02-15] Founder at Company B [type:fact|trust:10|src:direct] (CURRENT)
```

When you hit a contradiction:
1. Check for an existing chain. If one exists, trust the CURRENT entry.
2. If no chain exists, flag both entries for human resolution rather than guessing.

## Dormant / Archived

Move entries here when they stop being live but might still be useful as context. Archived is not deleted. Restore if a topic comes back.

### [Entry name] ([archived YYYY-MM-DD])
- (entry)

## Maintenance

- Trust decays: a fact unused for ~60 days drops roughly 1 point per month.
- Below trust 3, flag for review. Below 1, move to archive.
- High `hits` resists archival even when old, because it is clearly useful.
- `direct` outranks `observed` outranks `inferred` when two facts conflict.
