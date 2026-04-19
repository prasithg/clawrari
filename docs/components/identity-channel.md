# Identity Channels

One of the fastest ways to make an assistant feel real is to give it a distinct communication identity instead of making it post as the human forever.

For Clawrari, that usually means Slack, but the pattern generalizes to any team or personal channel.

---

## The Pattern

Use a dedicated assistant identity for assistant-initiated output:

- briefings
- async updates
- stale-agent alerts
- research drops
- follow-up questions

Keep human-authenticated access only where it is truly needed for read-only visibility or specific actions.

That creates a clean split:

- human account for human messages
- assistant identity for assistant messages

---

## Why It Matters

Without a distinct identity:

- threads look like the human is talking to themselves
- feedback is harder to target
- write actions feel riskier
- demos are worse

With a distinct identity:

- the feedback loop is clearer
- channel behavior becomes configurable
- approvals and reactions are easier to interpret

---

## Recommended Slack Shape

- one dedicated assistant channel for direct back-and-forth
- read-only monitoring in other channels unless there is a reason to post
- a clear rule for where RLHF happens
- a clear rule for where briefings land

Keep channel behaviors explicit in `HEARTBEAT.md` or `TOOLS.md`. Do not leave them implicit.

---

## Token Split

If your platform supports it, the cleanest setup is usually:

- bot identity for assistant writes
- user token or human-linked auth only for approved read surfaces

That keeps the assistant visible without forcing it to impersonate the human everywhere.

---

## Public-Safe Default

For a fresh Clawrari install:

- start with one feedback channel
- make it the assistant's posting surface
- route reactions, replies, and corrections back into the RLHF loop

Once that works cleanly, expand to more channels.
