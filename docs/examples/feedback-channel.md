# Example: Feedback Channel Setup

A walkthrough for wiring up a dedicated assistant feedback channel — the backbone of the RLHF loop described in [self-improvement.md](../self-improvement.md).

---

## What You Get

A single channel (Telegram, Slack, or Discord) where:
- The assistant posts drafts, summaries, alerts, and research drops
- The human replies with corrections, approvals, or sharper instructions
- Corrections get promoted into workspace files automatically

---

## Minimal Setup (Telegram)

Prasith's primary control channel is Telegram. Here's the working config:

### 1. Create a dedicated bot

```
@BotFather → /newbot → name it something recognizable
```

Save the bot token. This is the assistant's identity.

### 2. Wire it to OpenClaw

In `~/.openclaw/config.yaml`:

```yaml
channels:
  telegram:
    adapter: telegram
    token: <bot-token>
    allowedUsers:
      - <your-telegram-user-id>
    # This makes the bot your primary control surface
    default: true
```

### 3. Define the feedback contract

Add to your `AGENTS.md` or `HEARTBEAT.md`:

```markdown
## Feedback Channel Rules

- Assistant posts drafts, alerts, and research drops to the primary channel.
- Human replies with:
  - ✅ or "looks good" → approved, proceed
  - Correction text → apply and log the lesson
  - ❌ or "no" → stop, do not send/execute
- Corrections get promoted:
  - Style → SOUL.md or USER.md
  - Workflow → AGENTS.md
  - Tool gotchas → TOOLS.md
  - Repeated mistakes → memory/regressions.md
```

### 4. Add a regression log

Create `memory/regressions.md`:

```markdown
# Regressions

| Date | Pattern | Root Cause | Fix | Promoted To |
|------|---------|-----------|-----|-------------|
| 2026-04-09 | Used `gws docs +write` for full doc creation | Wrong tool for the job | Use google-doc-publish skill | TOOLS.md |
```

This file is the durable record of "things that broke and how we made them not break again."

---

## Alternative: Slack

The same pattern works with Slack's bot tokens:

```yaml
channels:
  slack:
    adapter: slack
    botToken: xoxb-...
    appToken: xapp-...
    defaultChannel: "#assistant"
```

Key differences:
- Use `#assistant` as the dedicated feedback channel
- Reactions (👍/👎) map to approval/rejection
- Thread replies keep context clean

---

## Alternative: Discord

```yaml
channels:
  discord:
    adapter: discord
    botToken: ...
    guildId: ...
    defaultChannelId: <feedback-channel-id>
```

Discord works well if you're already in a server. Thread-based feedback keeps the main channel clean.

---

## What Good Looks Like

A healthy feedback channel has:

1. **Clear identity** — you can tell which messages are from the assistant vs. you
2. **Consistent format** — drafts, alerts, and updates follow a predictable structure
3. **Visible corrections** — when you correct something, the assistant acknowledges and logs it
4. **Quiet when idle** — no spam, no noise. Posts only when there's something worth your attention
5. **Traceable improvements** — corrections land in workspace files, not just chat history

## Anti-Patterns

- **Everything in one channel.** Keep assistant output separate from your human conversations.
- **Corrections that vanish.** If you correct the assistant in chat but it doesn't update a file, the lesson is lost next session.
- **No approval gate.** If the assistant sends externally without your review, trust erodes immediately.
- **Over-posting.** If you're muting the channel, the assistant is too noisy. Raise the bar for what warrants a post.

---

## Integration with Self-Improvement Loop

The feedback channel feeds directly into the [RLHF loop](../self-improvement.md#1-rlhf-channel-pattern):

```
Human correction in channel
  → Assistant acknowledges
  → Root cause analysis
  → Promote to appropriate workspace file
  → Next session loads the fix automatically
```

This is the core mechanic that makes Clawrari get better over time. Without a structured feedback channel, corrections are ephemeral. With one, every correction makes the system permanently harder to break.
