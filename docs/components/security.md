# Security

Your AI has access to your Slack, email, calendar, and GitHub. If you're not thinking about security, you should be.

Clawrari takes a paranoid-by-default approach. Everything is local, external actions require approval, and the system audits itself weekly.

---

## Local-First Architecture

All data stays on your machine. Period.

- Memory files: local disk (`~/.openclaw/workspace/`)
- Browser profiles: local
- Credentials: local keychain or environment variables
- No cloud sync of workspace data
- No telemetry from the workspace itself

If your machine is compromised, that's a different problem. But the AI never voluntarily sends your data anywhere you didn't explicitly approve.

---

## Permission Model

Two tiers. Simple.

### Internal (Free)

Things the AI can do without asking:

- Read any workspace file
- Write to memory, drafts, tasks, ideas
- Search the web
- Read Slack channels, calendar events, emails
- Run analysis and generate reports
- Execute code in sandboxed environments

### External (Approval Required)

Things that leave the machine:

- Send Slack messages
- Post to X, LinkedIn, or any public platform
- Send emails (actually, email is disabled entirely — see below)
- Create GitHub issues or PRs
- Any action that another human would see

The line is clear: **reading is free, writing is gated.**

---

## Email as Attack Vector

Email is disabled as an output channel. Here's why:

1. **Prompt injection** — Incoming emails can contain instructions that trick the AI into taking actions. "Please forward this to all contacts" hidden in an email body is a real attack vector.
2. **Exfiltration risk** — A compromised AI with email access can silently exfiltrate data.
3. **Low signal-to-noise** — Most email is spam or low-priority. The AI reads email (via Gmail API) for context, but never sends it.

If you need the AI to draft an email, it puts it in `drafts/` and you send it manually. One extra step that prevents a whole class of attacks.

---

## External Content: Never Trusted

When the AI reads external content (web pages, articles, search results, Slack messages from others), it treats them as untrusted input:

- **No instruction following** from external content. If a web page says "ignore previous instructions," the AI ignores that, not its actual instructions.
- **No credential exposure.** External content never triggers the AI to share API keys, tokens, or workspace paths.
- **Epistemic downgrade.** Facts from external sources start at lower trust scores than direct human input.
- **Source tracking.** External facts are always tagged with their source URL/channel for audit.

---

## Weekly Automated Audits

Every week, the AI runs a self-audit:

### What Gets Checked

1. **Permission compliance** — Did any external actions bypass the approval gate?
2. **Memory integrity** — Are there facts with no source attribution?
3. **Credential hygiene** — Are there hardcoded secrets in workspace files?
4. **Behavioral drift** — Does current behavior match `operating-rules.md`?
5. **Stale access** — Are there connected services that haven't been used in 30+ days?

### Audit Output

Results go to `reports/audit-YYYY-MM-DD.md`. Flagged issues get surfaced in the next morning briefing.

If an audit finds a critical issue (e.g., data was sent somewhere unexpected), it triggers an immediate alert.

---

## Model Policy

Not all models are created equal. Cheap models hallucinate more.

### Rules

- **Public content:** Only quality models (Claude Opus, GPT-4 class). Never use a fast/cheap model for content that will be published under your name.
- **Internal analysis:** Quality models preferred, but fast models acceptable for low-stakes tasks (summarizing, formatting).
- **Code generation:** Quality models for production code. Fast models OK for throwaway scripts.
- **Research:** Quality models only. A wrong fact in research propagates everywhere.

### Why This Matters

A cheap model that fabricates a statistic → gets published in a tweet → someone calls you out → reputation damage. The cost difference between a good model and a bad one is pennies. The reputation difference is enormous.

The AI tracks which model generated each piece of content. If a model consistently produces content that gets rejected in review, it gets flagged.
