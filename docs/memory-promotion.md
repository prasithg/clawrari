# Memory Promotion (the Dreaming Pass)

A memory system that only appends gets slower and noisier every day. One that only overwrites loses its audit trail. Clawrari's answer is a graduated promotion path with a nightly consolidation step, borrowed from how sleep consolidates a day into long-term memory. We call it the dreaming pass.

The short version: events land in a daily log, the dreaming pass reviews them, and the few that matter graduate into durable files. Everything else stays as history.

## Why a separate pass

If you promote facts inline while a session runs, two things go wrong. You interrupt the work to do bookkeeping, and you promote too eagerly because the fact feels important in the moment. A batched pass at the end of the day fixes both. It is cheap, it runs while nothing else needs the runtime, and it judges the day's facts with a night's distance.

## The graduation path

Every fact moves through tiers, and most never leave the first one.

1. **Raw event** lands in `memory/YYYY-MM-DD.md`. Append freely. This is the journal.
2. **Still matters tomorrow** so it moves into `memory/session-brief.md`, the preconscious buffer read first at every session start.
3. **Still matters next month** so it gets promoted into the right thematic file: `projects.md`, `people.md`, `preferences.md`.
4. **Should change future behavior** so it becomes a `[type:rule]`, a regression, or a preference that future sessions load automatically.

The test at each step is one question: will this still be load-bearing at the next tier's timescale? If not, it stays where it is.

## What the pass does each night

Read the day's log top to bottom. For each tagged entry, apply the graduation test and file it where it belongs. Carry the type and trust tags across so the next pass can reason about decay. When you touch an existing entry, bump its `hits` and set `used` to today.

Then run decay on the thematic files. A fact unused for about 60 days drops roughly one trust point per month. Below trust 3 it gets flagged for review. Below trust 1 it moves to an archive rather than getting deleted, because sometimes you need to look back.

Finish by rewriting the session brief so it reflects what is actually live, and update `MEMORY.md` if you created a new thematic file.

The full step-by-step lives in `templates/memory/promotion-checklist.md`. Copy it into your workspace and run it as part of night work.

## Contradictions and supersede chains

When a promoted fact conflicts with one already stored, do not overwrite. Build a supersede chain: mark the old entry SUPERSEDED, add the new one as CURRENT, keep both.

```markdown
## Role history
- [2026-01-01] Engineering lead at Company A [type:fact|trust:10|src:direct] (SUPERSEDED)
- [2026-02-15] Founder at Company B [type:fact|trust:10|src:direct] (CURRENT)
```

Chains give you an audit trail, preserve old context that may still be useful, and make rollback possible if a supersede turns out to be wrong. When you cannot tell which fact is correct, flag both for the human rather than guessing.

## Type and trust tags

Promotion only works if entries are tagged when they are written. Two tags carry the weight.

The type tag sets the decay rate. A `[type:pref]` decays very slowly, a `[type:event]` decays fast and never leaves the daily log. Without it, a preference that should last forever and an event that should expire in a day look identical as plain bullets.

The trust block records where a fact came from and how confident you are: `[trust:8|src:direct|hits:12|used:2026-02-24]`. Direct beats observed beats inferred. High `hits` means a fact is clearly useful, so it resists archival even when old. See `docs/components/memory.md` for the full taxonomy.

## Monthly deep pass

Once a month the dreaming pass goes deeper: flag every memory with zero hits in 60 days, downgrade trust on unused inferred facts, archive resolved regressions older than 30 days, and reindex the semantic layer if it has drifted from the files.

## What you get

The store stays small where it needs to be fast and complete where it needs to be durable. The session brief stays tight. The thematic files stay honest because decay prunes what stopped being used. And because every step writes to plain markdown you can open and diff, the whole thing stays auditable. The semantic index, if you run one, is only an accelerator on top of files that remain the source of truth.
