# patterns/v3-structural.md — Structural AI-Tells (v3 layer)

This is the layer that catches a mature voice tripping its own template every day. A voice guide built to dodge v1 AI-isms ("short kickers, fragment rhythm, no em-dashes, lowercase headings") ossifies into a template. The template then grows its own fingerprint.

These rules catch the template.

## P0 — show up in nearly every draft, structural

### v3.01-not-x-y — Negative parallelism

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.01-not-x-y | P0 | `^Not\s.{1,30}\.\s+\w` (line starts with "Not X. Y.") OR `\bisn'?t\s.{1,40}\.\s+It'?s\s` (it's not X. it's Y.) OR `\bnot\s.{1,40},\s+\w{1,15}\.\s` ("not X, Y.") | rewrite without negative-parallel scaffolding; lead with the positive claim |

**Frequency:** the most common structural tell in a sharp-voice reply corpus — typically the #1 fingerprint. Every batch.

**Example tells:**
- "Not the request. The problem."
- "isn't wrong answers. It's correct work that never ships."
- "The brand follows the product. Not the other way."
- "aren't 'AI engineer' in the abstract. They're 'person who can set up the harness'"

**Variance rule:** in a batch of 5 pieces, max 1 may use this structure. If 2+ pieces in a batch use it, the batch fails the gate.

### v3.02-uniform-rhythm — The template fingerprint

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.02-uniform-rhythm | P0 | batch-level: ≥3 of N pieces follow `[data-dense opener] -> [1-4 word fragment] -> [mid-length explainer] -> [pivot] -> [1-4 word kicker]` | rewrite at least N-1 of them with different rhythm |

**Why this fires at batch level not piece level:** any one piece with this rhythm is fine. The fingerprint is the pattern repeating across pieces. Detector counts pieces in a batch matching all 5 beats; if ≥3 of N do, batch fails.

### v3.03-actual-real-inflation — Confidence intensifier inflation

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.03-actual-real-inflation | P0 | `\b(actual\|real)\s+(eval gap\|agent engineering work\|bottleneck\|unlock\|product\|problem)\b` OR more general: `\bthe\s+(actual\|real)\s+\w+\b` flagging if 2+ uses in piece | drop "actual/real" — usually nothing is lost |

**Carve-out:** keep "actual/real" only when creating a specific contrast where the reader would otherwise assume the abstract version (e.g. "the *actual* cost vs the quoted cost" where the contrast does work). If you can drop it without losing meaning, drop it.

**Example tells:**
- "the actual eval gap"
- "the actual agent engineering work"
- "what 'build in public' should actually mean"
- "the real bottleneck was always..."
- "the real unlock is the test suite"

### v3.04-most-x-are-y — Manufactured generalizations

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.04-most-x-are-y | P0 | `^Most\s\w+(\s\w+){0,4}\s+(aren'?t\|are not\|don'?t\|do not)\b` OR `\bMost\s\w+(\s\w+){0,4}\s+(I'?ve\s+seen\|I see\|out there)\s+(aren'?t\|are not)\b` | replace with a specific observation tied to a number or example. "Of the 12 agent failures I logged this month, 9 were handoff failures" beats "Most agent failures aren't model failures." |

**Why P0:** the "Most X are Y" template is doing the rhetorical work without evidence. Every reply trips it differently. Same template, different topic, every day.

**Example tells:**
- "Most agent failures I've seen aren't model failures. They're handoff failures."
- "Most AI 'failures' I've seen aren't model failures. They're problem-statement failures."
- "Most companies do not need more demos. They need operational harnesses."

### v3.05-isnt-obvious-deeper — Hot-take formula

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.05-isnt-obvious-deeper | P0 | `(The\s+\w+\s)?(worst\|biggest\|real)\s+\w+\s+(isn'?t\|aren'?t)\s.{1,60}\.\s+It'?s\s` | give the take without telegraphing it. Lead with the specific claim, not the "it's not obvious thing — it's deeper thing" reveal scaffolding |

This is structurally a sibling of v3.01 but worth pulling out separately because it's the engine of the "hot take" daypart. The "isn't obvious thing — it's deeper thing" structure telegraphs the rhetorical move before the substance lands.

## P1 — common, fixable

### v3.10-bare-np-bullets — Hook block bullets

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.10-bare-np-bullets | P1 | bullet list where ≥2 of 3+ bullets are bare noun phrases (no verb, no number) | rewrite each bullet as a full claim with verb + number, or convert the block to prose |

**Example tells:**
- "Mine session logs for recurring manual patterns" (verb but no number)
- "Cross-family review (Claude builds → Codex reviews, vice versa) was highest-frequency manual workflow" (this one is fine, has a verb and a comparative)
- "The brain confuses setup with completion" (bare-NP-ish)

Detector heuristic: in a bullet list, count tokens per bullet starting with a verb form vs starting with a noun phrase. If >50% are bare noun phrases (or noun-phrase + bare-verb without quantification), flag.

### v3.11-curious-excited — Confidence-calibration weasels

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.11-curious-excited | P1 | `^(Curious how\|Excited to see\|Excited about\|Surprisingly different)\b` | drop or replace with a specific observation |

**Example tells:**
- "Curious how plugin authors handle ranking"
- "Excited to see what this produces"
- "Surprisingly different..."

### v3.12-hollow-fragment-opener — One-word voice-as-template

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.12-hollow-fragment-opener | P1 | piece opens with `^(Same\|Yes\|Rare\|Right\|Exactly)\.\s` AND batch-level ≥2 of N pieces use this opener | vary openers; max 1 hollow-fragment opener per batch of 5 |

In isolation, "Same." or "Rare." reads as voice. Used across 4+ replies in a week, it reads as a fixed lead-in.

### v3.13-same-pattern-here — Reply-vouching template

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.13-same-pattern-here | P1 | `^Same pattern here\.\s` OR `^Seeing the same\b` OR `^Running this exact setup\b` | vary the vouching anchor; max 1 per batch |

### v3.14-manufactured-experience-cadence — Every reply has a personal-receipt anchor

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.14-manufactured-experience-cadence | P1 | batch-level: ≥4 of N reply drafts contain a personal-receipt clause ("Three nights running, my coding agents...", "Built this into the agent stack. 50 entries in 60 days.") | drop the receipt from at least 2 replies; lead with the observation without the personal anchor |

The receipts are real. The cadence — every reply has one — feels scripted because every reply gets one.

## P2 — judgment calls

### v3.20-round-number-specificity — Specificity-as-credibility shape

| id | severity | pattern | rewrite |
|---|---|---|---|
| v3.20-round-number-specificity | P2 | every original opens with `\b\d{1,3}\s+(nights\|days\|times\|entries)\b` | leave individual pieces alone; if batch shows 3+ pieces with this opener, vary at least 1 |

Real numbers, but pattern: every original has a specific count. It's a feature, not a bug, but worth noting that detectors flag the "specificity-as-credibility" shape.

## How to use

The detector applies these rules. Note that several are **batch-level**, not piece-level — the detector runs once per batch (e.g. 5 reply drafts + 1 original = 1 batch) and returns batch-level flags in addition to per-piece flags.

The variance rules in SKILL.md (max 1 of 5 may use "Not X. Y.", etc.) are the active enforcement of these patterns at the batch level.
