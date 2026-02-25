# Memory

An AI that forgets everything between sessions is a search engine with extra steps.

Clawrari's memory system is structured, tiered, and trust-scored. It's designed so your AI gets smarter over time instead of starting from zero every conversation.

---

## Three-Tier Memory

Not all memories are equal. Some should last forever, some should expire.

### Tier 1: Constitutional (Never Expires)

Core identity and operating principles. These are the bedrock.

- `SOUL.md` — Who the AI is, values, personality
- `USER.md` — Who the human is, permissions, context
- `AGENTS.md` — Session protocol
- `operating-rules.md` — Learned rules from corrections and RLHF

Constitutional memory is never auto-archived. Changes require human review.

### Tier 2: Strategic (Quarterly Refresh)

Medium-term context that shapes priorities and planning.

- `projects.md` — Active projects, status, blockers
- `people.md` — Relationship context, communication preferences
- `preferences.md` — Human's patterns (editing habits, schedule, style preferences)
- `context-holds.md` — Temporary priority overrides with expiry
- `predictions.md` — Prediction log for calibration

Strategic memory gets a quarterly review. Stale projects get archived. People who haven't come up in 90 days get moved to a "dormant" section. Preferences get validated against recent behavior.

### Tier 3: Operational (30-Day Auto-Archive)

Day-to-day context. High volume, high churn.

- `memory/YYYY-MM-DD.md` — Daily logs
- `regressions.md` — Recent failures (resolved ones archive after 30d)
- `drafts/` — Content in progress
- `tasks/queue.md` — Active task queue

Operational memory older than 30 days gets moved to an archive. Not deleted — archived. Because sometimes you need to look back.

---

## Trust Scoring

Every fact in memory carries metadata:

```
[trust:8|src:direct|hits:12|used:2026-02-24]
```

| Field | Meaning |
|-------|---------|
| `trust` | 1-10 confidence score |
| `src` | Source: `direct` (human said it), `observed` (AI witnessed it), `inferred` (AI concluded it) |
| `hits` | How many times this fact has been accessed |
| `used` | Last access date |

### Trust Rules

- **Direct > Observed > Inferred.** If the human says "I hate morning meetings," that's trust:10. If the AI notices they always decline morning invites, that's trust:7.
- **Hits matter.** High-hit memories are clearly useful. They resist archival even if they're old.
- **Decay is real.** A fact unused for 60 days drops 1 trust point per month. Eventually it falls below threshold and gets archived.
- **Contradictions trigger review.** If new information contradicts a stored fact, both get flagged for human resolution.

---

## Daily Logs

`memory/YYYY-MM-DD.md` files are the raw journal. Append-only, never edited after the day ends.

### What Gets Logged

- Key decisions and their rationale
- Human feedback (corrections, praise, redirections)
- Tasks completed and outcomes
- New information learned
- Errors and how they were handled

### What Doesn't Get Logged

- Routine operations (file reads, standard searches)
- Redundant information (same fact logged twice)
- Private content that shouldn't persist (human can mark things `[ephemeral]`)

Daily logs are the source material for nightly extraction. The AI reviews them and promotes important facts to structured memory files.

---

## Structured Memory Files

### projects.md

```markdown
## Active

### Clawrari — Open source AI ops framework
- Status: v0.2.0 shipping
- Next: Documentation, X announcement
- Blockers: None

## Completed
### Q4 Dashboard — [archived 2026-01-15]
```

### people.md

```markdown
## Active

### Sarah Chen — Engineering lead at Acme
- Relationship: Colleague, works on shared API project
- Communication: Prefers Slack, hates long emails
- Last interaction: 2026-02-20
- Notes: Moving to Seattle in March

## Dormant
### Mike R. — Met at conference [last: 2025-11-01]
```

### preferences.md

```markdown
## Writing
- Always edits opening lines → lead with the hook, skip preamble
- Prefers short paragraphs (3 sentences max)
- Hates corporate jargon ("synergy", "leverage", "utilize")

## Schedule
- Deep work: 9-11 AM (never interrupt)
- Meetings: afternoon preferred
- Fridays: light schedule, good for reviews
```

### operating-rules.md

```markdown
## Communication
1. Never send external messages without approval
2. Slack: always check channel topic before posting
3. Email: disabled as attack vector — do not send

## Content
14. Match the voice in SOUL.md — no corporate drone mode
15. All public content needs human approval gate
16. Epistemic tags required on thought leadership posts
```

---

## Memory Decay

Memory isn't a landfill. It needs curation.

### How Decay Works

1. **Hit counting** — Every time a memory is accessed, `hits` increments. High-hit memories are clearly useful.
2. **Recency weighting** — Recent memories get a boost. A fact used yesterday matters more than one used 3 months ago.
3. **Trust floor** — When trust drops below 3, the memory is flagged for review. Below 1, auto-archived.
4. **Archive, don't delete** — Archived memories move to `memory/archive/`. They can be restored if needed.

### Monthly Decay Run

The nightly cron includes a monthly deep clean:
- Flag memories with 0 hits in 60 days
- Downgrade trust on unused inferred facts
- Archive resolved regressions older than 30 days
- Move completed projects to archive section

---

## Supersede Chains

When information changes, you don't just overwrite — you create a chain.

```markdown
## Prasith's role
- [2026-01-01] CEO at Acme [trust:10|src:direct] — SUPERSEDED
- [2026-02-15] CEO at Jobleap [trust:10|src:direct] — CURRENT
```

### Why Chains Matter

- **Audit trail** — You can always see what changed and when
- **Context preservation** — Old facts might still be relevant ("used to work at Acme" is useful context)
- **Contradiction resolution** — When two facts conflict, the chain shows which is newer
- **Rollback** — If a supersede was wrong, you can restore the previous version

The AI checks for supersede chains when it encounters seemingly contradictory information. If a chain exists, it uses the latest. If not, it flags the contradiction for human resolution.
