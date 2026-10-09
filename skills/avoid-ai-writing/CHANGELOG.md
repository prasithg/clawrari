# CHANGELOG — AWDS (avoid-ai-writing skill)

Skill versioning: minor bump for pattern file edits, major bump for scoring rubric or workflow shifts. Every change should carry a linked eval artifact (the repo's "no eval = not Done" rule, `reports/evals/`).

## 2026-10-09: Complete Draft Retention

The logging instructions now explicitly retain passing drafts as well as rejected ones. Each attempt keeps its own artifact, and reviewers check that a later run does not replace an earlier record.

Private drafts stay in an approved private store. This documentation update adds no storage implementation and leaves detector scoring and the v0.2 rule set unchanged.

The [documentation evaluation](../../reports/evals/2026-10-09-waiting-results-and-draft-retention.md#draft-retention-cases) records four manual cases and the limits of that review.

## 2026-10-05: Historical-Writing Guidance

The skill now explains how historical samples can support cosmetic preferences for a specific author and publication format. Substantive problems and unexplained internal vocabulary still require review, regardless of how often they occur in old posts.

The instructions require supporting evidence and preserve the existing rules when preference data is unusable. This documentation update leaves pattern severities, scoring, and the v0.2 rule set unchanged. It includes no preference-learning implementation or private writing samples.

The [documentation evaluation](../../reports/evals/2026-10-05-worker-evidence-and-repeat-failures.md#historical-writing-cases) records the synthetic cases and untested behavior.

## v0.2 — 2026-09-07

**Shipped:**
- Added three sanitized, reusable candidates to `patterns/v4-emerging.md`: recycled credential callbacks, confession-shaped reversals, and first-person receipts that end in generic open questions.
- Kept all three candidates observation-only. They do not change verdict scoring unless fresh corpus evidence earns promotion into the stable pattern layer.
- Added synthetic positive and boundary examples so future promotion decisions have a fixed comparison set.

**Eval:** `reports/evals/2026-09-07-awds-emerging-pattern-refresh.md`.

## v0.1

**Inception.** The documented single source of truth for Clawrari's anti-AI-tell voice rules.

**Shipped:**
- `SKILL.md` — workflow, scoring rubric, variance rules, autoresearch loop, hard rules, integration points.
- `patterns/v1-lexical.md` — lexical fingerprints (banned vocab, em-dashes, openers, hashtags, emoji).
- `patterns/v2-formatting.md` — mechanical formatting fingerprints (double-spaces, list shape, restricted-mrkdwn leakage, round-number cadence).
- `patterns/v3-structural.md` — structural fingerprints (Not X. Y., uniform rhythm, actual/real inflation, manufactured generalizations, hot-take formula, bare-NP bullets, manufactured-experience cadence).
- `patterns/v4-emerging.md` — autoresearch layer; format spec + illustrative candidates.

**Authority model:** every other voice/writing-style/persona/publish doc in this repo defers to this skill and loses on conflict. Cross-references wired from `bootstrap/templates/SOUL.md.tmpl`, `docs/content-engine.md`, `docs/recipes/content-engine-setup.md`, `skills/publish-pipeline/SKILL.md`, and `skills/README.md`.

**Detector:** the gate is run by an operator-provided detector (in a real Clawrari workspace this is `awds-detect.mjs`, referenced by `scripts/content-engine-run.sh` via `$AWDS_DETECT`). The detector implements the scoring math in `SKILL.md` against the regex/structural rules in `patterns/*`. The rules — not a specific binary — are the canonical artifact.

## How to release

1. Edit pattern files.
2. Run your eval set against the detector — must be green.
3. Update this CHANGELOG with the diff.
4. Bump the skill version.
5. Link the eval artifact in the diff entry.
