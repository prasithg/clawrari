# Content Engine

Clawrari treats content as a production pipeline, not a burst of inspiration.

The loop is:

```text
research -> cluster signal -> draft -> review -> publish -> learn
```

## Stage 1: Research

Use a dedicated research workflow to gather:

- web signal
- community signal
- personal signal
- trend shifts worth commenting on

Good research artifacts are:

- source-linked
- grouped by claim, not by website
- useful for builders right now

Clawrari prefers signal over volume. Ten weak links are worse than three sharp observations.

## Stage 2: Draft

Drafts are generated for specific surfaces:

- X and other short-form posts
- LinkedIn hooks and bullet structures
- longer research or memo-style pieces
- internal thought-leadership notes

Recommended drafting rules:

- one clear claim per short post
- practical, non-hype tone
- tag whether a take is observed, inferred, speculative, or contrarian
- keep drafts short enough to review quickly

## Stage 3: Review

The review loop is where Clawrari becomes different from autopost junk.

The mandatory first pass is the **anti-AI-tell gate**. The canonical ruleset and scoring for that gate is the [`avoid-ai-writing` (AWDS) skill](../skills/avoid-ai-writing/SKILL.md) — it is the single source of truth for voice and anti-AI-tell rules, and nothing in this pipeline overrides it. Every draft is scored CLEAN / PATCH / REWRITE before human review; REWRITE-verdict pieces never ship.

Review can happen in:

- markdown files
- a queue
- a dedicated feedback channel

Common review actions:

- tighten hook
- remove unsupported claim
- sharpen one example
- downgrade a speculative take
- hold for later if timing is wrong

## Stage 4: Publish

Clawrari separates drafting from sending.

That means:

- draft freely
- schedule or publish only with explicit approval
- keep source markdown after publish
- capture what performed well for future reuse

## Stage 5: Learn

Post-publish learning closes the loop.

Track:

- what hooks worked
- what topics earned real discussion
- what fell flat
- what style corrections came back during review

The best learnings go into:

- content strategy docs
- writing-style guidance (a local subset that defers to the [`avoid-ai-writing` (AWDS) skill](../skills/avoid-ai-writing/SKILL.md); new voice/anti-AI-tell rules land in AWDS, not in a parallel list)
- repeatable templates
- the self-improvement layer

## Recommended Deliverables

Daily:

- one research digest
- three short-form drafts
- one stronger LinkedIn-style hook

Weekly:

- one deep-research memo
- one long-form draft
- one summary of what themes are compounding

## Draft Generator (CLI)

The repo ships a runnable generator that turns recent repo activity (git commits
+ CHANGELOG) into reviewable drafts. It is **draft-only** — it writes markdown
into `drafts/` and never sends, posts, or makes network calls.

```bash
# Weekly "what shipped this week" pack (last 7 days)
./scripts/content-engine.sh --weekly

# Monthly rollup (last 30 days)
./scripts/content-engine.sh --monthly

# Preview without writing, custom window / backdate
./scripts/content-engine.sh --weekly --window 14 --dry-run
./scripts/content-engine.sh --monthly --as-of 2026-05-31
```

Output lands in `drafts/weekly/weekly-content-<date>.md` and
`drafts/monthly/monthly-content-<date>.md`. Defaults (output dir, window,
as-of date) can be set in a local config — copy
[`config/content-engine.example.conf`](../config/content-engine.example.conf) to
`config/content-engine.conf`. CLI flags always override the config.

For scheduling, see [`crons/content-engine.md`](../crons/content-engine.md).
Drafts still pass through the human approval gate before anything is published.

## Why This Matters

For Clawrari, content is not just marketing. It is:

- a forcing function for clear thinking
- a way to compound research
- a feedback source for what ideas resonate
- a visible artifact of the operating system itself
