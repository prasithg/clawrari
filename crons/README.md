# Crons

Reference cron job definitions for a Clawrari setup.

## Recommended Schedule

### Every Heartbeat (~15 min)
- **Health check** — Verify workspace integrity, fix broken configs
- **RLHF scan** — Check feedback channels for human corrections
- **Annotation loop** — Process inline file annotations (@claw, TODO:, FEEDBACK:)

### Morning (before wake time)
- **Daily briefing** — Weather, calendar, priorities, overnight results
- **Content research** — Scan trends, gather material for posts

### 2-4x Daily
- **Calendar prep** — Upcoming meetings in next 2-4 hours
- **Email triage** — Flag urgent items
- **Task queue check** — Pick up async work

### Daily
- **Self-audit** — Performance review, what went well/didn't
- **Memory cleanup** — Prune stale entries, update long-term files
- **Content pipeline** — Draft posts, review queue

### Weekly
- **Security audit** — Permissions review, anomaly check
- **Skill updates** — Check ClawHub for new versions
- **Performance report** — Weekly summary of output

## Configuration

Cron jobs are configured in OpenClaw's gateway settings. See HEARTBEAT.md in your workspace for the active configuration.
