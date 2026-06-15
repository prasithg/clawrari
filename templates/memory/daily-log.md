# YYYY-MM-DD Daily Log

Raw journal for one day. Append freely during the day. Do not edit entries after the day ends; promote what matters and leave the rest as history.

This is the source material for the nightly promotion pass (see `docs/memory-promotion.md`).

## What belongs here
- key decisions and the reason behind them
- human feedback: corrections, approvals, redirections
- tasks finished and how they turned out
- new facts learned
- errors hit and how they were handled

## What does not belong here
- routine reads and standard searches
- the same fact logged twice
- content the human marked `[ephemeral]`

## Tagging

Tag each durable entry so the promotion pass can sort it. Use a type tag, and add a trust block when the entry is a fact or preference you may act on later.

Type tags:
- `[type:fact]` stable facts, slow decay
- `[type:pref]` preferences and patterns, very slow decay
- `[type:rule]` guardrails and hard limits, no decay until retired
- `[type:goal]` active objectives, medium decay
- `[type:event]` things that happened, fast decay, stays in this file
- `[type:habit]` recurring patterns, slow decay
- `[type:context]` situational, active until released

Trust block: `[trust:N|src:S|hits:H|used:YYYY-MM-DD]`
- `trust` 1-10 confidence
- `src` one of `direct` (human said it), `observed` (you saw it), `inferred` (you concluded it)
- `hits` access count, starts at 0 or 1
- `used` last access date

## Entries

### HH:MM
- Example fact worth keeping past today [type:fact|trust:7|src:observed|hits:1|used:YYYY-MM-DD]
- Example preference the human stated outright [type:pref|trust:10|src:direct|hits:1|used:YYYY-MM-DD]
- Example thing that happened, no promotion needed [type:event]

### HH:MM
- (next entry)
