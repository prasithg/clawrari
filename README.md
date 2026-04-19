# Clawrari

**The Ferrari of OpenClaw setups.**

Clawrari is an opinionated, battle-tested OpenClaw operating system for people who want their assistant to behave like durable infrastructure instead of a stateless chatbot.

It packages the patterns that matter:

- file-first memory with session continuity
- explicit behavioral rules and startup order
- self-improvement loops that promote feedback into better defaults
- structured async work through queue + ledger patterns
- a published model playbook for routing and overlays

It is not a generic starter template. It is a strong point of view about how to run OpenClaw well.

## What's New in v0.4.0

- [`docs/playbook.md`](docs/playbook.md) is now the canonical install-and-adopt guide.
- `reference/model-playbook/` is public with routing, overlays, and per-model prompting notes.
- Core docs now reflect the current memory, self-improvement, connector, and architecture patterns.
- Persona overlays and assistant-owned identity channels are now documented.
- `bootstrap/init.sh` now generates the modern memory skeleton and no longer leaks raw template conditionals.

## Why Clawrari

Most assistant setups fail in one of three ways:

- they forget everything between sessions
- they accumulate brittle prompts with no operating system around them
- they automate isolated tricks instead of building a durable loop

Clawrari fixes that with three layers:

1. **Memory layer**: session brief, ledger, daily logs, durable files, and optional semantic retrieval.
2. **Behavioral layer**: `SOUL.md`, `USER.md`, `AGENTS.md`, `HEARTBEAT.md`, and model overlays define how the system behaves.
3. **Skill layer**: reusable workflows wire the system to real work like briefings, research, coding, messaging, and night-time execution.

## Quick Start

```bash
git clone https://github.com/prasithg/clawrari.git
cd clawrari
./bootstrap/init.sh
```

Then do the real setup work:

1. Read [the build playbook](docs/playbook.md).
2. Personalize `SOUL.md`, `USER.md`, `IDENTITY.md`, `HEARTBEAT.md`, and `AGENTS.md`.
3. Install the core skills and connector surfaces you actually use.
4. Wire your feedback channel, cron cadence, and model stack.
5. Start using `tasks/queue.md`, `memory/session-brief.md`, and `memory/subagent-ledger.md` immediately.

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
  | SOUL / USER /     |    | AGENTS /          |    | briefings /       |
  | MEMORY / logs /   |    | HEARTBEAT /       |    | coding / research |
  | session-brief     |    | model overlays    |    | connectors        |
  +---------+---------+    +--------+----------+    +---------+---------+
            \___________________________|_______________________/
                                        |
                                        v
                           +---------------------------+
                           | OpenClaw runtime + local  |
                           | tools + external APIs     |
                           +---------------------------+
```

Read [docs/architecture.md](docs/architecture.md) for the fuller breakdown.

## Core Docs

- [Build Playbook](docs/playbook.md)
- [Architecture](docs/architecture.md)
- [Process](docs/process.md)
- [Mission](MISSION.md)
- [Memory](docs/components/memory.md)
- [Self-Improvement](docs/components/self-improvement.md)
- [Connectors](docs/components/connectors.md)
- [Persona Patterns](docs/components/persona.md)
- [Identity Channels](docs/components/identity-channel.md)
- [Philosophy](docs/philosophy.md)
- [Skills Catalog](skills/README.md)
- [Crons](crons/README.md)

## Repo Layout

```text
clawrari/
├── bootstrap/       # bootstrap script + personalized core-file templates
├── crons/           # scheduling notes and cadence patterns
├── docs/            # playbook, architecture, philosophy, component docs
├── reference/       # model playbook, prompt patterns, planning templates
├── skills/          # catalog of the core skill surface
├── templates/       # memory and task starter templates
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── MISSION.md
└── README.md
```

## Design Principles

- Files are the system of record.
- Optional indexing is good; hidden memory is not.
- Strong defaults beat configuration sprawl.
- Review loops matter more than autonomy theater.
- External actions should be gated; internal maintenance should be aggressive.
- If a recurring workflow cannot be explained in docs, it is not ready to ship.

## License

MIT.
