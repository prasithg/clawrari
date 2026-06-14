# patterns/v4-emerging.md — Emerging Patterns (autoresearch output)

**Status:** the AWDS Pattern Research loop appends new pattern candidates here. Promotion path: v4 → v3 after 2 consecutive weeks of recurring detection in fresh corpus.

This file is the living layer. v1–v3 are stable; v4 is where the system records tells it has caught itself producing recently that don't yet fit the stable layers. Entries below are illustrative candidates that show the format and the kind of structural drift this layer is meant to catch — your own corpus mining will replace them.

## Format

Each entry:

```markdown
### v4.NN-<slug> — <name>

**Detected:** YYYY-MM-DD by <reviewer: model-a / model-b / both>
**Severity proposal:** P0 / P1 / P2
**Confidence:** strong (both reviewers flagged) / weak (only one)

**Detect rule:** <regex or structural rule>

**Rewrite:** <example>

**Example matches:**
- <quote>
- ...

**Promotion candidate:** Y/N (Y after 2 consecutive weeks of recurring detection in fresh corpus)
```

## Pruning

Operators prune false positives by adding entries to `patterns/v4-rejected.md` (created on first rejection). The autoresearch loop checks against rejections before re-flagging.

## Open candidates (illustrative)

### v4.01-scare-quote-buzzword-deflation — Scare-quoted buzzword then deflationary redefine

**Detected:** by model-a
**Severity proposal:** P1
**Confidence:** weak (one reviewer)

**Detect rule:** Piece quotes an industry buzzword then redefines it down within the same/next sentence. Regex: `['"‘’“”](AI engineer|autonomous agent|self-healing|agentic|build in public|agent accessible|AI-first|production-ready|enterprise-grade)['"‘’“”]\s.{0,80}?(might be|is actually|should actually mean|was aspirational|is the right|in the abstract|not (a |the )?(description|capability))`. Batch: flag if ≥2/N pieces use scare-quote-then-redefine.

**Rewrite:** Drop the quoted-buzzword scaffolding; lead with the concrete claim. `Your "autonomous agent" might be a completion endpoint with a hopeful name.` → `Half the wrappers I audited this month had no shell or filesystem access. The label was aspirational.`

**Example matches:**
- `Your "autonomous agent" might be a completion endpoint with a hopeful name.`
- `"Agentic" was aspirational documentation from when we built it.`
- `This is what 'build in public' should actually mean.`

**Promotion candidate:** Y (recommended for promotion if it recurs)

---

### v4.02-chiasmus-role-swap — Mirrored A/B role-swap clauses

**Detected:** by model-a
**Severity proposal:** P1
**Confidence:** weak (one reviewer)

**Detect rule:** Two adjacent short clauses where subject/predicate roles swap, or a denial-then-mirror. Structural: `The \w+ (don'?t|doesn'?t) \w+\.\s+The \w+ do(es)?\.` OR `The \w+ (follows|drives|leads) the \w+\.\s+Not the other way`. Variance: max 1 chiasmus mirror per batch of 5.

**Rewrite:** Pick one direction, write it concretely. `Claude builds, Codex reviews. Codex builds, Claude reviews.` → `Whichever model writes the code, a different family reviews it.`

**Example matches:**
- `Claude builds, Codex reviews. Codex builds, Claude reviews.`
- `The agents don't remember. The tests do.`
- `The brand follows the product. Not the other way.`

**Promotion candidate:** Y

---

### v4.03-imperative-kicker-closer — Verb-initial imperative kicker

**Detected:** by model-a
**Severity proposal:** P2
**Confidence:** weak (one reviewer)

**Detect rule:** Piece closes with a 3-7 word verb-initial imperative, often with `not Y` contrast. Regex: final body line `^(Audit|Start|Stop|Look|Build|Drop|Cut|Test|Measure|Ship|Read|Skip|Watch|Trust|Question)\b[^.!?]{2,40}([,.]\s+not\s+[^.!?]{2,30})?\.`. Batch: flag if ≥3/N pieces close this way. P2 because verb-initial fragments are often a deliberate voice choice.

**Rewrite:** End on an observation/number/question. `Audit the runtime, not the README.` → `That wrapper had been routing to a completion endpoint for six weeks before anyone checked.`

**Example matches:**
- `Audit the runtime, not the README.`
- `Start measuring delivery.`
- `Look backward before building forward.`

**Promotion candidate:** N (P2, voice-adjacent; needs strong recurrence)

---

### v4.04-diagnostic-fragment-burst — Telemetry/status fragment burst as proof

**Detected:** by both
**Severity proposal:** P1
**Confidence:** strong (both reviewers touched it)

**Detect rule:** Within one piece, ≥2 adjacent telemetry/status fragments: `\b(Zero|Never|No|Did it)\s+[A-Z]?[\w\s-]{1,40}\.` or comma-run `No X, no Y, no Z`. Batch: P1 if ≥3 pieces in the 7-day window use the burst. Narrower than v3.02 rhythm — specifically diagnostic-checklist fragments used as proof.

**Rewrite:** Collapse the staccato checklist into one concrete sentence. `Never committed. Never pushed. Repo untouched at 6 AM.` → `The code was clean, but the repo stayed untouched at 6 AM: no commit, no push, no CI run.`

**Example matches:**
- `Never committed. Never pushed. Repo untouched at 6 AM.`
- `Zero tool calls. Zero files written.`
- `No shell access, no file system, no tools.`

**Promotion candidate:** Y (cross-reviewer overlap on first detection)

---

### v4.05-same-abstraction-transfer — "Same shape/lesson" pattern-equivalence assertion

**Detected:** by model-b
**Severity proposal:** P1
**Confidence:** weak (one reviewer)

**Detect rule:** Batch-level: flag when ≥3 pieces use `\b(?:same|exact same)\s+(?:shape|class|lesson|failure|skeleton|prompt skeleton|philosophy|setup)\b` to assert pattern equivalence without naming the concrete shared mechanism. Exclude exact v3.13 opener `Same pattern here.`

**Rewrite:** Name the mechanism. `Fact checking is the same shape` → `Fact checking also needs an independent reviewer: a model with different training priors from the one that produced the claim.`

**Example matches:**
- `Best find: same cross-model review skeleton getting rebuilt by hand 12 times.`
- `Fact checking is the same shape.`
- `Same lesson that keeps showing up in production AI systems.`

**Promotion candidate:** Y

## Promoted to v3

_(empty — entries move to `patterns/v3-structural.md` and the entry here is replaced with a stub linking to the v3 id.)_
