# 🏎️ Clawrari

**The Ferrari of OpenClaw setups.**

Not a template. Not a starter kit. This is a fully-loaded, battle-tested, opinionated AI operations system. It's what happens when you stop treating your AI assistant like a chatbot and start treating it like a cofounder.

Clawrari is [Prasith Govin's](https://x.com/prasithg) actual production setup — open sourced, documented, and bootstrappable. Point a fresh OpenClaw install at it, answer a few questions, and get a second brain, content engine, and life ops system in minutes.

---

## What You Get

### 🧠 Second Brain
Structured long-term memory with daily logs, semantic search, and auto-curation. Your AI remembers what matters and forgets what doesn't.

### ✍️ Content Engine
Research, draft, review, publish. Multi-platform (X, LinkedIn, Slack). Topic rotation, trend detection, voice consistency. The strongest component — ~80% automated.

### ⚡ Proactive Intelligence
Morning briefings, calendar prep, responsive scans. Your AI doesn't wait to be asked — it anticipates.

### 🔁 Self-Improvement Loops
RLHF from your feedback. Daily self-audits. Auto-skill updates. Your AI gets better every day without you doing anything.

### 🔄 Meta-Learning Loops
Nine feedback loops that make your AI permanently better: failure-to-guardrail pipeline, trust-scored memory with decay, prediction-outcome calibration, nightly extraction, friction detection, active context holds, epistemic tagging, creative mode directives, and recursive self-improvement. Inspired by [@AtlasForgeAI](https://x.com/AtlasForgeAI/status/2026380335249002843).

### 📋 Structured Task Management
A proper async task system for background and night work. Structured queue format with goal ancestry (the "why" that prevents locally-correct/globally-wrong decisions), a sub-agent tracking ledger, failure artifact system, and atomic task claiming to prevent duplicate work. Borrowed patterns from company orchestration systems, distilled for personal use.

### 🔌 First-Class Connectors
Slack, Calendar, Gmail, GitHub, iMessage, Reddit, X. The pipes are already laid.

### 🔒 Security by Default
Weekly audits, local-first architecture, clear permission model. Your data stays yours.

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/prasithg/clawrari.git
cd clawrari

# Run the bootstrap
./bootstrap/init.sh
```

The bootstrap script will:
1. Ask you about yourself (name, timezone, role, priorities, writing style)
2. Generate personalized workspace files (SOUL.md, USER.md, HEARTBEAT.md, etc.)
3. Set up your memory structure
4. Configure recommended cron jobs
5. Install curated skills from ClawHub

Total time: ~5 minutes. Result: a setup that took months to build.

---

## Philosophy

**Opinionated defaults.** Not 47 options. THE setup, with rationale for every choice.

**Battle-tested.** Everything here runs in production daily. If it's in Clawrari, it works.

**Your AI should have a personality.** Not a corporate drone. Not a sycophant. A sharp, resourceful partner with opinions.

**Memory is not optional.** An AI that forgets everything between sessions is a search engine with extra steps.

**Proactive > reactive.** The best assistant doesn't wait to be asked.

**Errors are bugs, not cosmetics.** If a cron job fails, that's not a footnote. Fix it or escalate.

---

## Architecture

```
~/.openclaw/workspace/
├── SOUL.md          # AI personality and operating principles
├── USER.md          # About the human (context, preferences, permissions)
├── AGENTS.md        # Workspace structure and session protocol
├── HEARTBEAT.md     # Cron jobs, health checks, periodic tasks
├── MEMORY.md        # Long-term memory index
├── IDENTITY.md      # AI identity and name
├── memory/          # Daily logs + structured memory files
│   ├── session-brief.md     # Preconscious buffer — read FIRST at session start
│   ├── subagent-ledger.md   # Append-only sub-agent tracking ledger
│   ├── YYYY-MM-DD.md        # Daily logs
│   ├── projects.md          # Active projects
│   ├── people.md            # Relationships
│   ├── preferences.md       # Human patterns/preferences (type-tagged)
│   ├── operating-rules.md   # Learned rules, RLHF corrections
│   ├── regressions.md       # Failure-to-guardrail pipeline
│   ├── context-holds.md     # Active context filters with expiry
│   ├── predictions.md       # Prediction-outcome calibration
│   └── influences.md        # Credits/influences tracker
├── tasks/           # Task queue for async/night work (structured format)
├── drafts/          # Content drafts awaiting review
├── reports/         # Generated reports and analyses
├── ideas/           # Captured ideas inbox
├── systems/         # Internal systems (agent registry, failure artifacts)
│   └── failures/    # Structured failure records for failed sub-agent tasks
└── reference/       # Prompt engineering and agent templates
    ├── agent-prompt-template.md    # XML-structured prompt template for sub-agents
    └── prompt-engineering-patterns.md  # LLM prompting patterns cheat sheet
```

See [docs/architecture.md](docs/architecture.md) for the full breakdown.

---

## Components

| Component | Status | Docs |
|-----------|--------|------|
| Second Brain | ✅ Production | [docs/components/memory.md](docs/components/memory.md) |
| Content Engine | ✅ Production | [docs/components/content-engine.md](docs/components/content-engine.md) |
| Task Management | ✅ Production | [docs/components/task-management.md](docs/components/task-management.md) |
| Proactive Intelligence | 🟡 Partial | [docs/components/proactive.md](docs/components/proactive.md) |
| Self-Improvement | ✅ Production | [docs/components/self-improvement.md](docs/components/self-improvement.md) |
| Connectors | 🟡 Partial | [docs/components/connectors.md](docs/components/connectors.md) |
| Security | ✅ Production | [docs/components/security.md](docs/components/security.md) |

---

## Who This Is For

- OpenClaw users who want a real setup, not a toy
- Builders who believe AI assistants should be opinionated
- Anyone tired of starting from scratch every time

## Who This Is NOT For

- People who want 47 configuration options
- Anyone looking for a "minimal" setup
- If you want your AI to say "Great question!" — look elsewhere

---

## License

MIT. Take it, use it, make it yours.

---

## Links

- **Site:** [clawrari.com](https://clawrari.com)
- **OpenClaw:** [openclaw.com](https://openclaw.com)
- **Author:** [@prasithg](https://x.com/prasithg)
