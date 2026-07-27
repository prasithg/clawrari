# Roadmap

Clawrari ships in layers. The first releases established the core operating system; the next ones should deepen proof, polish, and optional expansion.

## Shipped

### v0.1

- public documentation baseline
- architecture framing
- initial component docs

### v0.2

- meta-learning loop packaging
- trust-scored memory patterns
- predictions, holds, and recursive improvement docs

### v0.3

- session brief
- subagent ledger
- structured queue
- failure artifacts and task-management docs

### v0.4

- verified bootstrap parity
- build playbook
- published model playbook
- process docs
- persona and identity-channel patterns
- broader context sync from the live workspace

### v0.5

- refreshed public model playbook: `effort-ladder.md` (single source for effort levels + default routing chain), per-model prompt guides, updated overlays and orchestration routing, plus a Fable long-horizon operating pack
- four new production skills ported and sanitized: `cross-review`, `night-work`, `coding-agent`, `loop-watcher`
- harness pattern set: night-work pipeline (now with an external finalizer for dead orchestrators), executable regression suite, six-axis eval scorecard, "no eval = not Done" skill gate, and the peer-blocker bridge
- agent observability pattern: run-trace schema, scorecard roll-up, and a zero-dependency morning-report HTML skeleton (`docs/observability.md`, `templates/observability/`)
- memory promotion (the dreaming pass) docs and reusable memory templates (`docs/memory-promotion.md`, `templates/memory/`)
- stacking-loops and human-facing-message-standard patterns, plus ~13 distilled field-tested pattern docs landed since v0.4 (make "done" falsifiable, generator-is-not-the-grader, tier alerts by blast radius, guard the guardrail, absorb the pattern not the dependency)
- cadence recovery hygiene: GitHub CI/selftest workflow, structured issue templates, and eval artifacts

## Next

Focus:

- expand the skill eval harness so every ported skill ships with a trigger + content eval
- port more skills from the drift backlog (the live workspace is ahead of the public surface)
- site refresh so the landing pages track the v0.5 playbook and harness docs
- richer visibility into queue health, stale agents, and memory freshness

The goal is simple: Clawrari should be able to show that it improved, not just claim it.

## After That

Potential directions:

- richer creator/research ingestion pipelines
- optional work/personal persona separation
- stronger proactive intelligence workflows

## Near-Term TODOs

- ~~document one canonical feedback-channel setup end to end~~ ✅ (v0.4.1)
- ~~add an example `TOOLS.md`~~ ✅ (v0.4.1)
- ~~add a lightweight semantic-memory freshness recipe~~ ✅ (v0.4.1)
- ~~tighten the website around the build playbook and model playbook~~ ✅ (v0.4.2)
- ~~add more recipes (night-work setup, content-engine config, connector auth walkthrough)~~ ✅ night-work + connector auth (v0.4.2)
- add content-engine config recipe
