# Content Engine

The strongest component. ~80% automated, human-approved, multi-platform.

Your AI researches trends, drafts posts, maintains your voice, and publishes — all you do is review and hit approve. Or don't, and it holds the draft until you do.

---

## Daily Digest Pipeline

Every day, the content engine runs a four-stage pipeline:

### 1. Research

- Pull trending topics from X, LinkedIn, HackerNews, Reddit
- Scan bookmarks, saved articles, and conversation history for ideas
- Cross-reference against your topic rotation schedule
- Check what's already been posted (avoid repetition)

### 2. Draft

- Generate 1-3 content pieces based on research
- Apply voice from `SOUL.md` — your AI writes like you, not like ChatGPT
- Tag each claim with epistemic status (see below)
- Format for target platform (thread for X, long-form for LinkedIn, casual for Slack)

### 3. Review

- Draft lands in `drafts/` directory
- Human gets a notification (morning briefing or Slack ping)
- Options: approve, edit, reject, defer
- AI learns from edits — patterns get logged in `preferences.md`

### 4. Publish

- Approved content gets posted to the target platform
- Post metadata logged (URL, engagement baseline, topic tags)
- Engagement tracked for 48 hours, then summarized

---

## Multi-Platform Support

| Platform | Tool | Capabilities |
|----------|------|-------------|
| X/Twitter | x-api + browser | Post, thread, quote, reply, research via timeline |
| LinkedIn | Browser automation | Post, article publish |
| Slack #ai-talk | slkcli | Share insights, link drops, discussion starters |

Each platform has its own formatting rules:

- **X:** Punchy, opinionated, max impact in 280 chars. Threads for deep dives.
- **LinkedIn:** More context, professional angle, longer paragraphs OK.
- **Slack:** Casual, conversational, link-first with brief commentary.

---

## Topic Rotation

The engine maintains a topic rotation to prevent monotony:

```markdown
## Weekly Rotation
- Mon: AI/ML insights
- Tue: Engineering & building
- Wed: Career/leadership
- Thu: Hot takes / contrarian
- Fri: Community / sharing others' work
- Weekend: Personal / reflections
```

This isn't rigid — breaking news overrides the rotation. But without a schedule, you end up posting about the same thing 5 days in a row.

### Trend Detection

The AI watches for:
- Spikes in topic mentions across your network
- New papers/announcements in your domains
- Conversations where your perspective would add value
- Gaps — topics no one's covering well

When a trend is detected, it bumps the topic to the front of the queue with a note on why.

---

## Voice Consistency

This is make-or-break. AI content that sounds like AI content is worse than no content.

### How Voice Works

1. `SOUL.md` defines the AI's personality, which mirrors your writing voice
2. The content engine pulls voice guidelines before every draft
3. After human edits, the AI notes what changed:
   - "Removed hedge words" → note: be more direct
   - "Added personal anecdote" → note: include personal touches
   - "Changed opening" → note: current opening style preferred

4. Over time, the drafts need fewer edits. That's the goal.

### Anti-Patterns (What the Engine Avoids)

- "Great question!" energy
- Bullet-point-itis (not everything needs a list)
- Hedge stacking ("It might be possible that perhaps...")
- AI tell-words ("delve", "landscape", "comprehensive", "it's worth noting")
- False balance ("on the other hand" when there's a clear answer)

---

## Epistemic Tagging for Content

Public content carries responsibility. Every factual claim gets tagged:

- **[consensus]** — Safe to state directly. "Transformers are the dominant architecture."
- **[observed]** — Based on your data. "My posts about X get 3x more engagement."
- **[inferred]** — Logical but not proven. Needs a hedge. "This suggests..."
- **[speculative]** — Educated guess. Must be framed as opinion. "I think..."
- **[contrarian]** — Against mainstream. Needs strong framing. "Unpopular opinion:"

Tags are stripped before publishing — they're internal quality control, not visible to readers.

---

## The Human Approval Gate

Nothing goes public without human sign-off. This is non-negotiable.

### Why

- AI can't fully model reputational risk
- Context the AI doesn't have (private conversations, politics, timing)
- Legal/compliance implications
- "Would I actually say this?" is a human judgment call

### How It Works

1. Draft ready → notification sent
2. Human reviews (in workspace, Slack, or mobile)
3. Three actions: ✅ Approve → publishes immediately | ✏️ Edit → revise and re-queue | ❌ Reject → archive with reason
4. If no response in 24 hours, draft stays in queue (never auto-publishes)
5. Rejection reasons feed back into the content engine to avoid similar drafts

The goal is ~80% approval rate. Lower means the engine needs calibration. Higher means it's nailing your voice.
