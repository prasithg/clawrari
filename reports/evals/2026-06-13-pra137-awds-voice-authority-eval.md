# Eval — PRA-137: AWDS voice-authority consolidation (clawrari repo)

**Date:** 2026-06-13
**Ticket:** PRA-137 (Clawrari cadence recovery)
**Type:** voice-rule / doc change → eval required ("no eval = not Done")

## What changed and why

The OpenClaw workspace (PRA-114) made `skills/avoid-ai-writing/` (AWDS) the single
source of truth for anti-AI-tell voice rules, with every other voice doc deferring
to it. That landed in the workspace, not in this public `clawrari` repo. This repo
mirrors/distributes our skills and docs, but it did **not** contain the AWDS skill at
all — `skills/` only held `README.md`, `github.md`, `google-workspace.md`, `slack.md`,
while scripts/crons referenced an external `awds-detect.mjs` in the workspace. Voice
rules were scattered: hype-word lists duplicated across three content templates and a
`writing-style.md` recipe describing its own "banned patterns".

This change ports the AWDS skill into the repo (sanitized of private content) and wires
every voice doc to defer to it, so the repo has one canonical, evolving voice ruleset.

### Added (skill, ported + sanitized from the workspace)
- `skills/avoid-ai-writing/SKILL.md` — workflow, CLEAN/PATCH/REWRITE scoring, variance
  rules, autoresearch loop, hard rules, integration points.
- `skills/avoid-ai-writing/patterns/v1-lexical.md` — lexical fingerprints.
- `skills/avoid-ai-writing/patterns/v2-formatting.md` — mechanical formatting fingerprints.
- `skills/avoid-ai-writing/patterns/v3-structural.md` — structural fingerprints (the template-drift layer).
- `skills/avoid-ai-writing/patterns/v4-emerging.md` — autoresearch layer (format + illustrative candidates).
- `skills/avoid-ai-writing/CHANGELOG.md` — skill versioning + authority model.
- `skills/publish-pipeline/SKILL.md` — publish-stage stub that defers to AWDS for voice.

### Sanitization (private/secret content removed in the port)
- Private Slack channel names (`#prasclaw-content`, `#prasclaw-briefings`) → generic
  "human-review channel" / "external surface".
- Public-account handle and X-API specifics → generic "your drafted + shipped output".
- Internal cron names (Content Morning Batch, AI Talk Draft) and model-vendor routing
  (Bedrock Opus / Codex GPT) → generic "draft pipeline" and "two reviewers from
  different model families".
- Private corpus/eval/autoresearch file inventories, internal tickets (PRA-111/112),
  and the v4 backfill-incident note → dropped; `corpus/` documented as operator-local,
  append-only, kept out of version control.
- Detector binary references kept only as an operator-provided gate (`$AWDS_DETECT`),
  consistent with the repo's existing `scripts/content-engine-run.sh`.

### Cross-refs wired (defer-to-AWDS)
- `bootstrap/templates/SOUL.md.tmpl` — "Voice rules live in one place" note; AWDS wins on conflict.
- `docs/content-engine.md` — Stage 3 Review (mandatory AWDS gate) + Stage 5 Learn (writing-style defers).
- `docs/recipes/content-engine-setup.md` — `writing-style.md` is a positive-voice subset; banned rules live in AWDS.
- `skills/README.md` — added `avoid-ai-writing` as canonical; `publish-pipeline` defers.
- `docs/content-engine/templates/{weekly-build-in-public,monthly-retro,contributor-highlight}.md`
  — Voice Guardrails checklists noted as convenience subsets of AWDS.
- `CHANGELOG.md` — repo changelog entry (2026-06-13).

## Verify

### 1. AWDS skill files present
```
skills/avoid-ai-writing/CHANGELOG.md
skills/avoid-ai-writing/SKILL.md
skills/avoid-ai-writing/patterns/v1-lexical.md
skills/avoid-ai-writing/patterns/v2-formatting.md
skills/avoid-ai-writing/patterns/v3-structural.md
skills/avoid-ai-writing/patterns/v4-emerging.md
skills/publish-pipeline/SKILL.md
```

### 2. No conflicting voice rules left — every voice doc defers to AWDS
`grep -rni "AWDS wins\|defers to\|single source of truth\|defer to .* on .*conflict"` across
`skills/`, `docs/content-engine.md`, `bootstrap/templates/SOUL.md.tmpl`,
`docs/recipes/content-engine-setup.md`, and the three content templates confirms an
explicit deferral statement in each. The remaining banned-word lists (the three content
templates' "No hype words" boxes) are each prefixed with a note that they are a
convenience subset of AWDS and lose on conflict — so no doc carries an *independent*
competing ruleset. AWDS `patterns/*` is the only authoritative list.

Authority statements found (one per voice surface):
- `SKILL.md`: "Every other voice/writing-style/persona/publish doc in this repo defers to this skill and loses on any conflict."
- `SOUL.md.tmpl`: "When anything below conflicts with AWDS, AWDS wins."
- `docs/content-engine.md` (Review): "it is the single source of truth … nothing in this pipeline overrides it."
- `docs/content-engine.md` (Learn): "a local subset that defers to … AWDS."
- `docs/recipes/content-engine-setup.md`: "On any conflict, AWDS wins."
- `skills/publish-pipeline/SKILL.md`: "On any conflict between this stub and AWDS, AWDS wins."
- `skills/README.md`: "content-engine, content-autopilot, ai-talk-draft, and publish-pipeline all defer to it on any conflict."
- 3× content templates: "defer to AWDS on any conflict."

### 3. No private markers leaked into the ported skill
`grep -rniE "prasclaw|prasith|@prasithg|bedrock|gpt-?5|jobleap|PRA-1[0-9][0-9]"` over
`skills/avoid-ai-writing/` and `skills/publish-pipeline/` → no private channel names,
handles, vendor routing, internal tickets, or personal/company names. The only
"Claude/Codex" occurrences are generic cross-model *example sentences* inside pattern
illustrations (a public technique, not secret).

### 4. Commit landed

Landing commit (the change above): `6b484f6`.

`git log -1` (at the time the change landed on the work branch):
```
commit 6b484f61b0ca6cf1805f5dda8ad48b4b6076207b
Author: prasithg <prasithg@gmail.com>
Date:   Sun Jun 14 01:12:58 2026 -0400

    feat(skills): make avoid-ai-writing (AWDS) the canonical voice authority (PRA-137)

    Port the AWDS skill into the public repo (sanitized of private content) and
    consolidate all anti-AI-tell voice rules behind it. ...
    16 files changed, 685 insertions(+), 2 deletions(-)
```

`git status` (clean tree; only the unrelated, gitignored-by-policy `.openclaw/` workspace dir untracked):
```
On branch claw/pra-137-awds-voice-authority
Untracked files:
	.openclaw/
nothing added to commit but untracked files present
```

This eval is itself part of `6b484f6`; this section is recorded in a small follow-up
commit on the same branch. Both commits fast-forward onto `main` and push to origin —
see the final handoff summary for the merge + push confirmation.

## Verdict

PASS. The clawrari repo now contains the AWDS skill as the documented single source of
truth for voice/anti-AI-tell rules, sanitized of private content, with every voice
surface explicitly deferring to it. No competing independent ruleset remains.
