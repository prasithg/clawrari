# Proactive Intelligence

The best assistant doesn't wait to be asked.

Most AI setups are reactive — you type, it responds. Clawrari flips that. Your AI monitors, anticipates, and acts on your behalf (within the permission model).

---

## Morning Briefings

Every morning, before you open Slack, your AI has already prepared:

### What's In the Briefing

- **Calendar:** Today's meetings with context pulled from `people.md` and `projects.md`
- **Tasks:** Open items from `tasks/queue.md`, prioritized by urgency
- **Slack:** Unreads summarized, threads you need to respond to flagged
- **Content:** Draft status (what's ready for review, what published yesterday and how it performed)
- **Blockers:** Anything the AI needs your input on

### Delivery

The briefing drops in your preferred channel (Slack DM, workspace file, or both) at wake time. You configured this in the bootstrap.

### What Makes It Good

It's not a data dump. The AI triages:
- 🔴 **Urgent** — needs response before your first meeting
- 🟡 **Important** — handle today
- ⚪ **FYI** — context you might want, no action needed

---

## Meeting Prep

15 minutes before any calendar event, the AI auto-pulls:

1. **Attendee context** — From `people.md`. Who are they, last interaction, communication preferences.
2. **Project context** — If the meeting relates to an active project, current status and blockers.
3. **Previous meeting notes** — Last time you met with this person/group, what was discussed.
4. **Open threads** — Slack conversations or email threads with attendees that are unresolved.
5. **Suggested agenda** — Based on open items and context.

This lands in a Slack DM or workspace file. By the time the meeting starts, you're the most prepared person in the room.

---

## Responsive Scanning

The AI periodically scans for things that need attention:

### What Gets Scanned

- **Unanswered Slack messages** — DMs and mentions older than 2 hours without a response
- **Stale PRs** — GitHub PRs waiting on your review for >24 hours
- **Overdue tasks** — Items in the task queue past their deadline
- **Calendar conflicts** — Double-bookings or back-to-back meetings with no buffer
- **Draft expiry** — Content drafts that have been waiting for review >48 hours

### Nudge System

When something needs attention, the AI doesn't nag. It sends one nudge:

```
📌 3 items need your attention:
- Slack DM from Sarah (4h ago, seems urgent)
- PR #142 waiting on your review (26h)
- Draft "Meta-learning loops" ready for review (posted yesterday)
```

One message. Prioritized. No repeated reminders unless you ask for them.

---

## Night Work

While you sleep, the AI processes the task queue:

### What Happens Overnight

- **Nightly extraction** — Review the day's interactions, update memory files
- **Content prep** — Research and draft tomorrow's content
- **Inbox processing** — Triage emails, flag what's important
- **Report generation** — Weekly summaries, project status updates
- **Maintenance** — Memory decay, archive stale data, clean up drafts

### Rules for Night Work

- **Only internal actions.** No Slack messages, no posts, no external writes.
- **Log everything.** Morning briefing includes a "what I did overnight" section.
- **Stop on errors.** If something fails, log it and move on. Don't retry indefinitely.
- **Respect the queue.** Tasks are processed in priority order, not FIFO.

Night work is one of the highest-value features. You go to bed with a full task queue and wake up to a clean one.

---

## Heartbeat System

The AI runs health checks every 15 minutes to make sure everything is working.

### What Gets Checked

- **Service connectivity** — Can we reach Slack, GitHub, Gmail, Calendar?
- **Cron health** — Are scheduled jobs running on time?
- **Workspace integrity** — Are critical files present and uncorrupted?
- **Memory consistency** — Any orphaned references or broken links?
- **Queue depth** — Is the task queue growing faster than it's being processed?

### Heartbeat Response

- ✅ **All clear** — Logged silently, no notification
- ⚠️ **Warning** — Logged + included in next briefing
- 🔴 **Critical** — Immediate notification (Slack DM)

### Configuration

Heartbeat checks are defined in `HEARTBEAT.md`. You can add custom checks:

```markdown
## Custom Checks

### API quota monitor
- Frequency: every 6 hours
- Check: GitHub API rate limit remaining
- Alert if: < 100 requests remaining
```

The heartbeat system ensures you never discover something's broken by accident. The AI knows before you do.
