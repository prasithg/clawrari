# Content Engine — Cadence & Editorial Calendar

> **Note:** This is the cadence baseline. AC5 (cron wiring into the existing content-engine cron with Prasith approval gate) is decision-pending — see PRA-99 Linear comment for the Decision Card.

---

## Posting Cadence

How the 3 templates plug into the existing content-engine cron. Spec only — no new crons registered.

### Schedule

| Template | Cadence | Day | Draft Deadline | Approval Gate |
|---|---|---|---|---|
| Weekly Build-in-Public | Weekly | Friday post, Thursday draft | Thursday 6 PM ET | Prasith reviews Thursday evening or Friday morning |
| Monthly Retro | Monthly | Last Friday of the month | Wednesday before | Prasith reviews Thursday |
| Contributor Highlight | As-earned | Any weekday | 48h before target post date | Prasith reviews + contributor consent confirmed |

### Queue Location

Drafts staged in: `docs/content-engine/drafts/`

File naming (matches the automation in `scripts/content-engine.sh` / `scripts/content-engine-run.sh`, per PRA-122):
- Weekly: `{YYYY-MM-DD}-weekly.md`
- Monthly: `{YYYY-MM}-monthly.md`
- Contributor: `contributor-{handle}-{YYYY-MM-DD}.md` (manual, not yet automated)

### Draft-Staging Path

1. **Draft created** in `drafts/` using the template from `templates/`
2. **Self-review** against voice guardrails checklist (bottom of each template)
3. **Prasith review** — tagged for approval in the task queue
4. **Approved** — moved to `ready/` subfolder (or published directly via content-engine skill)
5. **Published** — posted to platform, link logged in `published-log.md`

### Fallback if No Draft is Ready

- **Weekly:** If nothing shipped that week (unlikely given the every-2-day commit cadence), skip the post. Silence beats filler. Do not post a "quiet week" update.
- **Monthly:** Always ships. If it's thin, the "Broken" section should explain why.
- **Contributor:** Only post when earned. No obligation to post on any schedule.

---

## First 4 Weeks of Editorial Calendar

Starting week of 2026-05-26.

### Week 1: May 26 – May 30

**Template:** Weekly Build-in-Public
**Topic anchor:** Content engine launch — the templates themselves are the story
**Hook type:** Behind-the-Scenes (hooks.md #6)
**Draft angle:** "We built a content engine for an OSS project with 0 users. Here's why that's not as dumb as it sounds."
**Dependencies:** PRA-99 templates must be merged (this ticket)

### Week 2: June 2 – June 6

**Template:** Weekly Build-in-Public
**Topic anchor:** Phase 1 build progress (PRA-87 children — discipline layer)
**Hook type:** Playbook Hook (hooks.md #1)
**Draft angle:** What the discipline layer is, what shipped, what problem it solves for real users
**Dependencies:** At least 1-2 Phase 1 PRs merged to the Clawrari repo

### Week 3: June 9 – June 13

**Template:** Weekly Build-in-Public
**Topic anchor:** Community infrastructure + onboarding UX (PRA-95, PRA-96)
**Hook type:** Discovery Hook (hooks.md #5)
**Draft angle:** What we learned standing up community infra from scratch — what worked, what we'd skip next time
**Dependencies:** PRA-95 (community infra) in progress or shipped

### Week 4: June 16 – June 20

**Template:** Weekly Build-in-Public + Monthly Retro (first retro covers May 14 – June 20, the charter-to-first-retro window)
**Topic anchor:** First Clawrari monthly retro — charter to now
**Hook type:** Proof Hook (hooks.md #2) for the retro
**Draft angle:** "Clawrari has been public for 5 weeks. Here's the honest scorecard." — metrics against the 90-day charter targets, honest assessment of where we stand
**Dependencies:** All growth workstream tickets (PRA-93 through PRA-99) should have initial progress to report

### Cross-Week Notes

- Contributor Highlight is not scheduled in weeks 1-4. We don't have external contributors yet. First highlight fires when someone ships a real contribution.
- Each week's draft should be started by Wednesday, reviewed Thursday, posted Friday.
- If a week's planned topic falls through (e.g., the dependency didn't ship), swap to a different angle from `content-angles.md` rather than skipping.
- Rotate hook types. Don't use the same hook formula two weeks in a row.
