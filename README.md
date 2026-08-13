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

## Structure

Clawrari has three layers:

1. **Memory layer**: session brief, ledger, daily logs, durable files, and optional semantic retrieval.
2. **Behavioral layer**: `SOUL.md`, `USER.md`, `AGENTS.md`, `HEARTBEAT.md`, and model overlays define how the system behaves.
3. **Skill layer**: reusable workflows wire the system to real work like briefings, research, coding, messaging, and night-time execution.

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

Read [the architecture guide](docs/architecture.md) for the fuller breakdown.

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

Key references:

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

## Verify Gates

Run verification from the repository root. The CI workflow uses Node.js 20; the bootstrap parity harness also requires Bash and `jq`.

**Commit and pull-request guard**

```bash
git diff --check
```

Before committing, inspect the diff and apply the checklist in [the pull-request template](.github/pull_request_template.md): keep the change focused, sanitize public examples, and remove secrets, private hostnames, account IDs, and customer identifiers.

**Shell syntax**

```bash
bash -n bootstrap/init.sh
bash -n scripts/content-engine.sh
bash -n scripts/content-engine-run.sh
bash -n scripts/night-work-pipeline.sh
bash -n scripts/peer-blocker-watch.sh
bash -n scripts/test-bootstrap-parity.sh
```

**Harness self-tests and bootstrap parity**

```bash
bash scripts/night-work-pipeline.sh --selftest
bash scripts/peer-blocker-watch.sh --selftest
node scripts/regression-check.mjs --selftest
node scripts/eval-scorecard.mjs --selftest
bash scripts/test-bootstrap-parity.sh
```

The parity harness builds a throwaway workspace, checks generated files and rendered values against the bootstrap inputs, and removes the workspace when it exits.

**Eval artifacts**

Changes to a skill, core workflow, orchestration playbook, prompt template, or cron policy are not complete without an eval artifact. Start with [`reference/skill-change-eval-template.md`](reference/skill-change-eval-template.md), include the mandatory untested-surface disclosure, save the result under `reports/evals/`, and link it from the pull request.

## Contributing

Contributions should sharpen the operating model: safer defaults, clearer documentation, and workflows proven in real use. Keep each pull request focused and every public example sanitized. Read [CONTRIBUTING.md](CONTRIBUTING.md) for scope, rules, and review expectations.

## What's New in v0.5.0

- **Refreshed model playbook** — [`reference/model-playbook/`](reference/model-playbook/) is resynced with the live stack after months of drift: a new `effort-ladder.md` (single source for effort levels and the default routing chain), per-model prompt guides, and updated overlays and orchestration routing.
- **Four new production skills**, sanitized for reuse: `cross-review` (opposite-family review with evidence-graded criteria), `night-work` (bounded overnight build loop), `coding-agent` (bash-first delegation to Codex/Claude Code), and `loop-watcher` (read-only external-loop scouting).
- **Matured harness patterns** in [`docs/harness/`](docs/harness/): the night-work pipeline now survives a dead orchestrator via an external finalizer, plus the executable regression suite, six-axis eval scorecard, and "no eval = not Done" skill gate.
- **Agent observability** — the `trace → usage → scorecard → report` chain with a zero-dependency morning-report skeleton ([`docs/observability.md`](docs/observability.md), [`templates/observability/`](templates/observability/)).
- **Distilled-patterns cadence** — ~13 field-tested docs landed since v0.4: make "done" falsifiable, the generator is not the grader, tier alerts by blast radius, guard the guardrail, and absorb the pattern not the dependency.
- **Memory promotion (the dreaming pass)** and reusable memory templates for the layered store ([`docs/memory-promotion.md`](docs/memory-promotion.md), [`templates/memory/`](templates/memory/)).

## Design Principles

- Files are the system of record.
- Optional indexing is good; hidden memory is not.
- Strong defaults beat configuration sprawl.
- Review loops matter more than autonomy theater.
- External actions should be gated; internal maintenance should be aggressive.
- If a recurring workflow cannot be explained in docs, it is not ready to ship.

## License

MIT.
