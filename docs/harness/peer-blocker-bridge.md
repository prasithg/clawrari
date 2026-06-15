# Peer-Blocker Bridge

Two agents collaborating through a shared file drop have a failure mode that is easy to miss until it costs you hours. Agent A writes a handoff that contains a blocking question and waits. Agent B never looks at the drop, because nothing tells it to. Both agents are now stuck, and neither is doing anything wrong. That is a deadlock built entirely out of good intentions.

The bridge pattern closes the gap. A small watcher monitors the inbox where peer handoffs land, and on every cycle it surfaces any handoff that blocks. A question that used to rot for hours gets answered within one cron cycle.

## The doorbell and the source of truth

The convention this assumes is worth stating plainly. A notification channel (chat, a webhook, anything that pings) is the doorbell. The shared directory is the source of truth. The problem is that a doorbell nobody monitors is just a decoration. The bridge makes the doorbell work by polling the source of truth on a schedule and pulling out the items that need a human or a peer to act.

## What counts as blocking

`scripts/peer-blocker-watch.sh` treats a handoff file as blocking if either signal is present:

- a `**Priority:**` line containing `high`, `blocking`, or `urgent`, or
- a `## Decisions needed` section whose body is non-empty and is not "none".

Everything else is noise the watcher stays quiet about. The goal is a low-false-positive alert, because a watcher that cries wolf gets ignored, which puts you right back in the deadlock.

## Dedup, so it alerts once

The watcher records each blocker it has seen, keyed by filename and modification time, in a small JSON state file. A handoff is flagged once. It will not re-fire on every cron tick unless the file changes. Run with `--mark` to advance the seen-state after you have acted; run without it to preview.

## Running it

```bash
# preview new blocking handoffs (or NO_NEW_BLOCKERS)
PEER_INBOX=/path/to/inbox scripts/peer-blocker-watch.sh

# same, then mark them seen so they are not re-flagged
PEER_INBOX=/path/to/inbox scripts/peer-blocker-watch.sh --mark

# widen the lookback window
PEER_INBOX=/path/to/inbox PEER_LOOKBACK_HOURS=48 scripts/peer-blocker-watch.sh

# confirm the watcher works end to end
scripts/peer-blocker-watch.sh --selftest
```

Wire the `--mark` form into a cron that runs every few minutes, and route its output to wherever the responding agent will see it. The selftest builds a temporary inbox with one blocking and one non-blocking handoff and asserts that only the blocker is flagged, then that marking it stops the re-flag.

## The root cause this fixes

The deadlock is not a model problem and not a tooling problem. It is a monitoring gap: a channel that was assumed to be watched but was not. The bridge is deliberately small because the fix is small. You do not need a message queue or a new protocol. You need one watcher that turns the shared directory into something a schedule reads on every tick.
