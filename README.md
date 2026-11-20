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

## What's New in v0.5.0

- **Refreshed model playbook** — [`reference/model-playbook/`](reference/model-playbook/) is resynced with the live stack after months of drift: a new `effort-ladder.md` (single source for effort levels and the default routing chain), per-model prompt guides, and updated overlays and orchestration routing.
- **Four new production skills**, sanitized for reuse: `cross-review` (opposite-family review with evidence-graded criteria), `night-work` (bounded overnight build loop), `coding-agent` (bash-first delegation to Codex/Claude Code), and `loop-watcher` (read-only external-loop scouting).
- **Matured harness patterns** in [`docs/harness/`](docs/harness/): the night-work pipeline now survives a dead orchestrator via an external finalizer, plus the executable regression suite, six-axis eval scorecard, and "no eval = not Done" skill gate.
- **Agent observability** — the `trace → usage → scorecard → report` chain with a zero-dependency morning-report skeleton ([`docs/observability.md`](docs/observability.md), [`templates/observability/`](templates/observability/)).
- **Distilled-patterns cadence** — ~13 field-tested docs landed since v0.4: make "done" falsifiable, the generator is not the grader, tier alerts by blast radius, guard the guardrail, and absorb the pattern not the dependency.
- **Memory promotion (the dreaming pass)** and reusable memory templates for the layered store ([`docs/memory-promotion.md`](docs/memory-promotion.md), [`templates/memory/`](templates/memory/)).

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
- [Roadmap](ROADMAP.md)
- [Contributing](CONTRIBUTING.md)
- [Memory](docs/components/memory.md)
- [Self-Improvement](docs/components/self-improvement.md)
- [Connectors](docs/components/connectors.md)
- [Persona Patterns](docs/components/persona.md)
- [Identity Channels](docs/components/identity-channel.md)
- [Philosophy](docs/philosophy.md)
- [Skills Catalog](skills/README.md)
- [Crons](crons/README.md)

## What's Next

Clawrari is moving into its **v0.5 discipline layer**: making self-improvement measurable instead of merely claimed. Highlights on deck:

- benchmarked self-improvement loop with eval harnesses
- promotion review tooling so good runs become defaults
- stronger validation gates around coding-agent output
- tighter visibility into queue health and memory freshness

Full plan in [ROADMAP.md](ROADMAP.md). If you want to help shape it, start with [CONTRIBUTING.md](CONTRIBUTING.md).

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
