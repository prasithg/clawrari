# Connectors

The pipes that connect your AI to the world. Every connector follows the same principle: **read freely, write with permission.**

---

## Slack — slkcli

The primary communication channel. Your AI lives in Slack.

### Capabilities

| Action | Permission |
|--------|-----------|
| Read channels, threads, DMs | Internal (free) |
| Search messages | Internal (free) |
| Post messages | External (approval required) |
| React to messages | External (approval required) |
| Update own messages | External (approval required) |

### Setup

```bash
openclaw skill install slkcli
# Configure with your Slack workspace token
```

### How It's Used

- **Morning briefing** — Reads unreads, summarizes threads
- **Responsive scanning** — Flags unanswered DMs
- **Content sharing** — Posts to #ai-talk with approval
- **RLHF** — Your reactions/replies to AI messages become feedback

---

## Google Workspace — gog

Calendar, Gmail, Drive, Docs, Sheets. The productivity backbone.

### Capabilities

| Service | Read | Write |
|---------|------|-------|
| Calendar | ✅ Free | ✅ With approval |
| Gmail | ✅ Free | ❌ Disabled (security) |
| Drive | ✅ Free | ✅ With approval |
| Docs | ✅ Free | ✅ With approval |
| Sheets | ✅ Free | ✅ With approval |

### Key Commands

```bash
gog calendar list --limit 10      # Upcoming events
gog gmail search "from:boss"      # Search emails
gog drive ls                      # List Drive files
```

### Notes

- Gmail write is disabled by default. See [security.md](security.md) for why.
- Calendar is heavily used for meeting prep and morning briefings.
- Drive/Docs used for report generation and document drafting.

---

## GitHub — gh CLI

Code and project management.

### Capabilities

| Action | Permission |
|--------|-----------|
| List repos, PRs, issues | Internal (free) |
| Read code, diffs, CI status | Internal (free) |
| Create issues | External (approval required) |
| Create/merge PRs | External (approval required) |
| Push code | External (approval required) |

### Setup

```bash
# gh CLI with browser OAuth
gh auth login
```

### How It's Used

- **PR reviews** — AI reads diffs, provides analysis
- **Issue triage** — Summarizes new issues, suggests priority
- **CI monitoring** — Flags failed builds in morning briefing
- **Code generation** — Drafts code, creates branches (with approval)

---

## Browser Automation

Two browser profiles for different use cases.

### Isolated Profile (openclaw)

A dedicated browser instance managed by OpenClaw.

- Persistent sessions — logins survive restarts
- Used for: X research, Reddit browsing, LinkedIn, web scraping
- Port 18800, headless
- Your AI's own browser — separate from your personal browsing

### Chrome Relay Profile

Connects to your actual Chrome browser via the Browser Relay extension.

- Used when you need the AI to see what you're seeing
- Human-initiated: you click the toolbar icon to attach a tab
- Used for: pair debugging, form filling, website testing
- Port 18792, your Chrome instance

### When to Use Which

- **Research, automated workflows** → Isolated profile
- **"Help me with this page"** → Chrome Relay
- **Logged-in sites the AI needs access to** → Isolated profile (log in once, stays logged in)

---

## X/Twitter

Dual approach: API for posting, browser for research.

### Posting — x-api

Uses the official Twitter API with OAuth 1.0a authentication.

```bash
openclaw skill install x-api
```

- Post tweets and threads
- Like, retweet, quote tweet
- All posts require human approval

### Research — Browser

The browser profile is logged into X. The AI can:

- Search trending topics
- Read your timeline, likes, bookmarks
- Monitor specific accounts or hashtags
- Screenshot interesting threads for analysis

Browser-based research is better than API for personalized results — it sees your actual algorithmic feed.

---

## iMessage

Read and send messages via Apple's Messages framework.

- Read recent conversations for context
- Send messages with approval
- Useful for personal communications the AI needs context on

---

## Apple Notes & Reminders

Native Apple integrations for quick capture.

- **Notes:** Read/write for idea capture and quick memos
- **Reminders:** Create reminders from tasks, sync with task queue

These are lightweight connectors — not primary tools, but useful bridges for the Apple ecosystem.

---

## Adding New Connectors

Clawrari uses OpenClaw skills for connectors. To add a new one:

### 1. Check ClawHub

```bash
openclaw skill search <service-name>
```

If a skill exists, install it and add configuration to your workspace.

### 2. Build a Custom Skill

If no skill exists, you can build one. A skill is:

- A CLI tool or API wrapper the AI can invoke
- A `SKILL.md` file describing capabilities and commands
- Installed in OpenClaw's skill directory

### 3. Principles for New Connectors

- **Read/write separation** — Reading should always be free. Writing should always be gated.
- **Fail gracefully** — If the service is down, log it and move on. Don't block the pipeline.
- **Log usage** — Every external call should be traceable in daily logs.
- **Minimal permissions** — Request only the scopes you need. Don't grab admin when read-only works.

### 4. Register in TOOLS.md

After adding a connector, document it in your workspace's `TOOLS.md`:

```markdown
## new-service
- Account: your@email.com
- Auth: OAuth / API key / token
- Capabilities: what it can do
- Gotchas: known issues or limitations
```

This ensures the AI knows the connector exists and how to use it.
