# Memory System

Clawrari uses files first, retrieval second.

The goal is continuity without mystery: the assistant should remember what matters, but every durable fact should still live in a file you can open, diff, and edit.

## Core Layout

```text
workspace/
├── IDENTITY.md
├── SOUL.md
├── USER.md
├── MEMORY.md
└── memory/
    ├── session-brief.md
    ├── subagent-ledger.md
    ├── YYYY-MM-DD.md
    ├── projects.md
    ├── people.md
    ├── preferences.md
    ├── regressions.md
    ├── rules-constitutional.md
    ├── rules-tactical.md
    ├── context-holds.md
    ├── predictions.md
    └── reference/
```

## What Each File Does

`IDENTITY.md`
- One-screen orientation: name, vibe, creature, emoji, operating principles.

`SOUL.md`
- Personality and stable behavior.
- Where the assistant learns how direct, concise, opinionated, and proactive it should be.

`USER.md`
- The human profile: priorities, writing style, approval model, preferences, and risk boundaries.

`MEMORY.md`
- Index of the memory system.
- Explains where each category of knowledge lives.

`memory/session-brief.md`
- The most important file in the whole system.
- Tight, current, high-signal context only.
- Think active priorities, recent decisions, blocked items, expiring holds, runtime state.

`memory/subagent-ledger.md`
- Append-only log of delegated tasks.
- Lets the main assistant recover from background work that stalled, finished, or went sideways.

`memory/YYYY-MM-DD.md`
- Raw daily notes.
- Recent activity gets written here before it deserves promotion elsewhere.

Thematic files
- `projects.md`, `people.md`, `preferences.md`, `regressions.md`, `rules-*`, `context-holds.md`, `predictions.md`.
- These hold durable patterns, not session chatter.

## Startup Discipline

The memory system only works if the assistant loads it in the right order.

Recommended load order:

1. `SOUL.md`
2. `USER.md`
3. `memory/session-brief.md`
4. `memory/subagent-ledger.md`
5. today and yesterday in `memory/YYYY-MM-DD.md`
6. `MEMORY.md` for main sessions

That order gives you:

- identity
- user context
- active priorities
- background continuity
- recency
- broader archival orientation

## Promotion Model

Do not dump everything into long-term memory.

Use a graduated path:

1. Raw event lands in the daily log.
2. If it still matters tomorrow, it belongs in the session brief.
3. If it matters next month, promote it into the correct thematic file.
4. If it should change future behavior, capture it as a regression, rule, or preference.

## Regressions and Guardrails

`memory/regressions.md` is one of Clawrari's strongest patterns.

Use it for mistakes worth preventing twice:

- repeated bad prompt behavior
- tool misuse
- stale config drift
- unsafe defaults
- workflow failures that need an explicit guardrail

Each regression should record:

- name
- failure pattern
- context
- fix or guardrail
- status

## Context Holds

Some instructions should persist temporarily, not forever.

`memory/context-holds.md` is for things like:

- "optimize for shipping this week"
- "treat task X as blocked until decision Y"
- "use draft-only mode for public content until Friday"

Every hold should have an expiry or review condition.

## Local Semantic Retrieval

Clawrari supports local semantic indexing over the markdown memory store.

Important distinction:

- The markdown files are the truth.
- The index is just a lookup accelerator.

That keeps the system:

- auditable
- cheap
- portable
- recoverable after failures

## Journal Canonical Writes Before Publishing Them

When a derived index trusts content hashes or a publication manifest, a direct edit to an authoritative file can create a nasty split: the file on disk is current, but retrieval still serves the last trusted version. Treat every canonical write as a transaction, not a loose file edit.

A safe write path should:

1. validate that the writer is allowed to change the target,
2. record the before and after hashes in an append-only journal,
3. apply the file change atomically,
4. rebuild the derived index, and
5. verify that the published manifest now contains the new hash.

Fail closed when an authoritative file changes without a matching journal entry. Do not silently index it as trusted truth. But pair that guard with a bounded **adoption path** for legitimate direct edits: record the observed content as a journaled no-op, then rebuild and verify. A fail-closed gate with no recovery route turns one bypass into a permanent stale-index deadlock.

The reusable rule is simple: **authoritative content and derived retrieval state advance together, with a receipt.** The index remains disposable; the journal makes every trusted transition explainable.

## Give Temporary Handoff Aliases an Expiry

Short phrases are useful session handoffs: “resume the migration review” can restore a large context bundle without making the human repeat it. They are also ambiguous and easy to strand in a daily note that the next session never loads.

Register each handoff alias in the smallest canonical file that every relevant session reads. Store four fields:

- the exact phrase,
- the context or action it resolves to,
- the registration date, and
- an expiry date.

When a session receives an unfamiliar short phrase, check the handoff registry before improvising an interpretation. Remove the alias when consumed, and run a deterministic expiry sweep on a schedule. If no explicit expiry exists, use a short default such as seven days and report entries that cannot be parsed.

This makes temporary continuity deterministic without letting stale aliases become permanent hidden instructions.

## Hardening the Retrieval Layer

A semantic index is a piece of infrastructure, and infrastructure fails quietly. Three patterns, learned the hard way, keep a local retrieval layer honest.

### 1. Monitor the *effective* backend, not just the outcome

The most dangerous failure is the silent fallback: config says you're on the fast/smart backend, but the process quietly fell back to a degraded path — and every query still returns *a* result, so nothing looks broken. A state like this can fester for weeks because the only signal being watched is "did a result come back," not "which backend actually served it."

Build a canary that checks three things on a known query:

1. the **configured** backend (what config claims),
2. the **effective** backend (proof the intended engine actually booted — a startup marker, a health field, a version string), and
3. **index health** (the canary query returns the hit it should).

Config says X but the effective marker is absent == silent fallback == alert. Outcome-only monitoring will never catch this.

### 2. Dedupe on content identity, before truncating the window

If a query fans out across multiple collections or aliases that point at the same underlying data, the same chunk can come back twice — and it eats a slot in your top-`k` window, halving the diversity the model actually sees.

A docid- or URL-keyed dedupe does **not** catch this: the ids and source prefixes differ across aliases even when the bytes are identical. The only reliable identity is the **content coordinate** — the collection-stripped path plus line range. Dedupe on that key, keeping the higher-scored copy, *before* you truncate to `maxResults`. Fixing the symptom at the merge layer is safe and reversible; removing the redundant alias upstream is the deeper cleanup but a destructive live-state op — do it deliberately, not as a side effect.

### 3. Fuse mixed-scale signals with rank, not raw score

When you blend two retrieval signals — e.g. a lexical/keyword pass for exact-token queries and a vector pass for semantic ones — their score scales rarely match. A common trap: lexical (BM25) scores are unbounded (~1.0–1.5) while vector cosine scores are 0–1. Merge them with an **additive boost** and any lexical hit outranks every vector hit — you recover the exact-token query but *displace* a better-contextualized semantic chunk. Net zero, or worse.

Use **Reciprocal Rank Fusion (RRF)** instead: fuse on each result's *rank* within its own list, not its raw score, so the two scales stop fighting. This is the ecosystem-standard hybrid approach for exactly this reason. In a real bake-off, switching additive→RRF recovered the exact-token miss with zero regressions on the golden set. Caveat: hybrid only fires when the *query itself* carries a token shape — a natural-language question that never mentions the id still needs query-side expansion.

### 4. Treat extracted claims as proposals, not truth

LLM extraction is not deterministic just because temperature is zero. Entity names, predicates, and even the chosen claims can drift between identical runs. A graph edge without an exact source span is therefore a suggestion, not durable memory.

Promote an extracted claim only when it carries:

- a content-hashed source id,
- an exact, verified source span,
- a deterministic assertion id,
- observation and validity times where relevant,
- review state and extractor version, and
- a tombstone path that preserves the audit trail.

Fail closed when the span is missing or does not support the claim. Cache raw structured responses by source hash plus extractor version so projections are reproducible. Measure **cached reproducibility** separately from **fresh-extraction stability**; a stable cache does not prove the model will extract the same claims again.

**Meta-lesson:** every one of these is an eval-gated change. "It returns results" is not "retrieval is proven." Green means "beats baseline on a fixed golden set," and the untested surface (live path under load, fault-injected fallback, fusion-constant sensitivity) gets named explicitly, not assumed.

## Rules of Thumb

- Keep `session-brief.md` aggressively small.
- Append to the daily log freely; promote sparingly.
- Create new thematic files only when the category is stable.
- Search first, then read targeted sections.
- Prefer rewriting summaries over letting them grow indefinitely.
