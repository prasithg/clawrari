# Crons

Reference cron job definitions for a Clawrari setup.

## Recommended Schedule

### Every Heartbeat (~15 min)
- **Health check** — Verify workspace integrity, fix broken configs
- **RLHF scan** — Check feedback channels for human corrections
- **Memory freshness** — Reindex or repair semantic search if you use it and it drifts stale
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
- **Night work prep** — Confirm `tasks/queue.md` is real, not vague

### Weekly
- **Security audit** — Permissions review, anomaly check
- **Skill updates** — Check ClawHub for new versions
- **Model freshness review** — Revisit routing and overlays in `reference/model-playbook/`
- **Performance report** — Weekly summary of output

## Configuration

Cron jobs are configured in OpenClaw's gateway settings. See HEARTBEAT.md in your workspace for the active configuration.
