# Clawrari

**The Ferrari of OpenClaw setups.**

> **Context Repo:** The full product development context — FRDs, blueprints, process docs, and work orders — is open-sourced at [github.com/prasithg/clawrari-context](https://github.com/prasithg/clawrari-context). Read it to understand the *why* behind every decision.

Clawrari is an opinionated, battle-tested reference configuration for people who want OpenClaw to feel less like a toy chatbot and more like an operating system for work.

It packages the patterns that matter:

- File-based memory that survives sessions
- Behavioral rules that keep the assistant sharp and predictable
- A self-improvement loop that turns feedback into better defaults
- A content engine for research, drafting, review, and publishing
- Connector patterns for search, GitHub, Google Workspace, project management, and coding agents

Clawrari is not a generic starter template. It is a strong point of view about how to run OpenClaw well.

## Why Clawrari

Most assistant setups fail in one of three ways:

- They forget everything between sessions
- They accumulate brittle prompts with no operating system around them
- They automate isolated tricks instead of building a durable workflow

Clawrari fixes that with three layers:

1. **Memory layer**: durable files, session briefs, daily logs, and local semantic indexing over human-readable notes.
2. **Behavioral layer**: `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, and `HEARTBEAT.md` define how the agent starts, thinks, checks itself, and asks for approval.
3. **Skill layer**: reusable skills wire the system to real work like briefings, research, coding, Slack, calendars, and night-time execution.

## Architecture

```text
                         +----------------------+
                         |      The Human       |
                         | review / approve /   |
                         | correct / redirect   |
                         +----------+-----------+
                                    |
                                    v
  +-------------------+    +--------+---------+    +-------------------+
  |   Memory Layer    |<-->| Behavioral Layer |<-->|    Skill Layer    |
  | files are source  |    | startup order,   |    | tools, connectors,|
  | of truth          |    | safety, routines |    | workflows         |
  +---------+---------+    +--------+---------+    +---------+---------+
            |                         |                        |
            v                         v                        v
  +-------------------+    +-------------------+    +-------------------+
  | SOUL / USER /     |    | AGENTS /          |    | morning-briefing  |
  | MEMORY / logs /   |    | HEARTBEAT /       |    | research /        |
  | session-brief     |    | model overlays    |    | night-work / gh   |
  +---------+---------+    +--------+----------+    +---------+---------+
            \___________________________|_______________________/
                                        |
                                        v
                           +---------------------------+
                           | OpenClaw runtime + local  |
                           | plugins + external APIs   |
                           +---------------------------+
```

## Repo Layout

```text
clawrari/
├── bootstrap/       # seed templates and bootstrap helpers
├── config/
│   ├── README.md
│   └── openclaw.example.json
├── crons/           # cron examples and notes
├── docs/            # architecture, philosophy, and adoption docs
├── reference/       # prompt and routing references
├── skills/          # catalog of the core skill surface
├── templates/       # starter memory and task files
├── CONTRIBUTING.md
├── ROADMAP.md
├── LICENSE
└── README.md
```

## Quickstart

Clawrari is best adopted as a forkable pattern library, not a black-box installer.

```bash
git clone https://github.com/<your-github-org>/clawrari.git
cd clawrari
cp config/openclaw.example.json ~/.openclaw/openclaw.json
```

Then:

1. Read [the build playbook](docs/playbook.md).
2. Create your workspace identity files: `IDENTITY.md`, `SOUL.md`, `USER.md`, `AGENTS.md`.
3. Create your memory skeleton: `MEMORY.md`, `memory/session-brief.md`, `memory/subagent-ledger.md`, `memory/YYYY-MM-DD.md`.
4. Install the core skills and connector profiles you actually use.
5. Turn on heartbeat and cron jobs only after the manual flow works.

## Documentation

- [Docs Index](docs/index.md)
- [Architecture](docs/architecture.md)
- [Memory System](docs/memory-system.md)
- [Self-Improvement](docs/self-improvement.md)
- [Content Engine](docs/content-engine.md)
- [Connectors](docs/connectors.md)
- [Night Work](docs/night-work.md)
- [Philosophy](docs/philosophy.md)
- [Build Playbook](docs/playbook.md)
- [Skills Catalog](skills/README.md)
- [Config Example](config/openclaw.example.json)

## Design Principles

- Files are the system of record.
- Optional local indexing is fine; hidden cloud memory is not.
- Good prompts beat fancy architecture most of the time.
- Review loops matter more than autonomy theater.
- Expensive models are justified when they save real human time.
- External actions should be gated; internal maintenance should be aggressive.

## Status

`v0.1` documents the current Clawrari operating model:

- core memory architecture
- self-improvement framework
- content pipeline
- connector and coding-agent patterns
- bootstrap playbook for a fresh install

See [ROADMAP.md](ROADMAP.md) for the next gaps.

## Contributing

Start with [CONTRIBUTING.md](CONTRIBUTING.md). Clawrari prefers practical patterns over theoretical ones. If you have not used a workflow in anger, it does not belong here yet.

## License

MIT.
