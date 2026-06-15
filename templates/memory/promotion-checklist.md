# Promotion Checklist (Dreaming Pass)

A repeatable nightly pass that reads the day's raw log and decides what graduates into durable memory. Think of it as the consolidation step: the day's events get reviewed, the few that matter get filed where they will be found again, and the rest stay as history.

Run it once per day, ideally as part of night work. It should take a few minutes against one daily log.

## Inputs
- today's `memory/YYYY-MM-DD.md`
- the thematic files that are promotion targets (`projects.md`, `people.md`, `preferences.md`, `regressions.md`, `rules-*.md`)
- `memory/session-brief.md`

## Steps

1. **Scan the daily log top to bottom.** Read every tagged entry.

2. **Apply the graduation test to each entry.**
   - Still matters tomorrow? It belongs in the session brief.
   - Still matters next month? Promote it into the right thematic file.
   - Should it change future behavior? Capture it as a rule, regression, or preference.
   - Matters only today? Leave it in the daily log as history.

3. **Promote with tags intact.** Carry the `[type:...]` and `[trust:...]` block across. Bump `hits` and set `used` to today when you touch an existing entry.

4. **Resolve contradictions.** If a promoted fact conflicts with an existing one, build or extend a supersede chain. If you cannot tell which is correct, flag both for human review rather than picking one.

5. **Decay and archive.** For each thematic file:
   - drop ~1 trust point on facts unused for a month
   - flag anything below trust 3 for review
   - archive anything below trust 1, and resolved regressions older than 30 days
   - move stale projects and dormant people to their archive sections

6. **Rewrite the session brief.** Keep it under ~50 lines. It is the scored subset of what is live, not a log.

7. **Update the index.** If you created a new thematic file, add its pointer to `MEMORY.md` the same night.

## Monthly deep pass

Once a month, do the steps above plus:
- flag every memory with 0 hits in 60 days
- downgrade trust on unused `inferred` facts
- check semantic-index freshness if you run one, and reindex if it lags the files
- confirm the session brief still reflects reality

## Output

Log the pass in the daily file: how many entries promoted, how many archived, any contradictions flagged for the human. That record is how you prove the memory store is curated, not just accumulating.
