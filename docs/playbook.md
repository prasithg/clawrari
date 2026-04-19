# Build Playbook

This is the Clawrari way.

If you want a minimal starter, stop here. If you want a fast, opinionated OpenClaw workspace that compounds across sessions, do this exactly once and then iterate on top of it.

---

## 1. Prereqs

You need:

- OpenClaw installed and runnable from `openclaw`
- `git`, `gh`, `jq`, `rg`, and a working shell
- A local workspace path at `~/.openclaw/workspace/`
- At least one main model and one subagent/coding path configured in OpenClaw

Recommended before you start:

- `gh auth login`
- your preferred browser connector working
- one feedback surface ready for RLHF: Slack, Telegram, or a local file/review habit

---

## 2. Bootstrap

```bash
git clone https://github.com/prasithg/clawrari.git
cd clawrari
./bootstrap/init.sh
```

The bootstrap is verified for `v0.4.0`. It now generates the modern memory skeleton:

- `memory/session-brief.md`
- `memory/subagent-ledger.md`
- split rule layers
- `TOOLS.md`
- memory conventions and heartbeat state

What the bootstrap does not do:

- log you into connectors
- install every skill
- schedule your cron jobs for you
- decide your model stack

It gets the file system right. You still need to wire the system.

---

## 3. Personalize The Core

Do this immediately after bootstrap. Do not leave the generated defaults untouched for a week and expect good behavior.

### `SOUL.md`

Set:

- tone and sharpness
- what the assistant should push back on
- how aggressive it should be about self-improvement
- the active overlay line if you use the model playbook

### `USER.md`

Add:

- real priorities
- what requires approval
- the kinds of work you actually do
- communication preferences that matter every day

### `IDENTITY.md`

Set:

- assistant name
- human name
- setup version
- any stable persona marker you want the system to remember

### `HEARTBEAT.md`

Decide:

- what the feedback channel is
- what counts as a heartbeat
- what should run daily vs weekly
- which checks are read-only vs allowed to self-heal

### `AGENTS.md`

Keep this short. It should point, not explain forever.

Make sure it reflects:

- the startup read order
- when `MEMORY.md` is loaded
- what counts as safe internal work
- where the model routing and task workflow docs live

### `TOOLS.md`

Document the boring but critical stuff:

- connector aliases
- account names
- auth gotchas
- wrapper commands

This prevents “I know this worked once” drift.

---

## 4. Install Core Skills

Use [`skills/README.md`](../skills/README.md) as the starting list, then install from ClawHub.

The minimum useful stack:

- Slack or equivalent messaging
- Google Workspace
- GitHub
- browser automation
- web fetch/search
- one coding path

If you want the Clawrari shape specifically, make sure you have equivalents for:

- `gws`
- `gh`
- `mcporter`

Names vary across installs. Some setups expose older aliases. Record the exact command names you end up with in `TOOLS.md` and keep the playbook logic the same.

Do not install twenty skills on day one. Install the small set you will actually call this week.

---

## 5. Wire The Connectors

### Google Workspace (`gws` or equivalent)

Use it for:

- calendar reads
- document access
- briefing prep

Default posture:

- read freely
- write only with explicit approval

### GitHub (`gh`)

Use it for:

- code review
- issue and PR triage
- release hygiene

Default posture:

- read freely
- pushes, merges, and issue writes require intent

### Browser / relay (`mcporter` or equivalent)

Use it for:

- logged-in workflows
- “help me with this page” work
- websites with no good API

Default posture:

- separate research profile from human browsing when possible
- only use the shared browser when the task is explicitly about what the human sees

### Messaging

Clawrari is strongest when there is a designated feedback channel.

That channel becomes:

- the RLHF inbox
- the place for morning briefings
- the place stale-agent alerts surface

If you use Slack, read [`docs/components/identity-channel.md`](components/identity-channel.md) before you let the assistant post as you forever.

---

## 6. Schedule The Crons

Use [`crons/README.md`](../crons/README.md) and your gateway docs as the source for cadence. The opinionated default is:

- heartbeat every 15 minutes
- morning briefing before wake time
- 2-4 daily check-ins for calendar/comms
- daily self-audit
- weekly model and security review

Do not start with every possible automation turned on. Start with:

1. heartbeat
2. morning briefing
3. daily self-audit
4. one weekly review block

If those run clean for a week, add more.

---

## 7. Enable Night Work

Night work is not “let the agent improvise for eight hours.” It is a controlled queue plus a review loop.

Use:

- `tasks/queue.md` for scoped work
- `memory/subagent-ledger.md` for continuity
- `memory/session-brief.md` for carry-forward state
- [`reference/sop-agent-task-workflow.md`](../reference/sop-agent-task-workflow.md) for claim/work/complete
- [`reference/model-playbook/`](../reference/model-playbook/) for model routing

Rules:

- queue real tasks before you sign off
- every task needs goal context and acceptance criteria
- coding work gets validation
- stale rows get surfaced the next session, not ignored

If the queue is empty, night work is empty. Good. Empty is better than vague.

---

## 8. First Week Loop

This is where Clawrari starts compounding.

### Day 1

- bootstrap
- wire the core connectors
- set the feedback channel
- run one briefing manually

### Days 2-3

- use the system normally
- capture every correction in the feedback channel or memory files
- log failures in `memory/regressions.md`

### Days 4-5

- promote repeated corrections into rules
- tighten `SOUL.md`, `AGENTS.md`, and `HEARTBEAT.md`
- start using `tasks/queue.md` for async work

### Days 6-7

- review regressions, predictions, and friction
- prune noise from the session brief
- adjust your model routing using the playbook

The first week loop is:

`feedback channel → regressions → rules/templates/docs → better next session`

If you skip the feedback capture, you are not running Clawrari. You are just using a repo.

---

## 9. Upgrades

When a new Clawrari release lands:

```bash
cd ~/path/to/clawrari
git pull origin main
```

Then reapply deliberately:

1. Review `CHANGELOG.md`
2. Diff `bootstrap/templates/` and `templates/`
3. Pull useful changes into your live workspace files
4. Review `reference/model-playbook/` for routing or overlay updates
5. Run one manual heartbeat and one manual briefing before trusting the automations

Do not blindly overwrite your live `SOUL.md`, `USER.md`, or memory files with repo defaults.

---

## 10. Troubleshooting

### Bootstrap ran but the workspace still feels generic

You did not personalize the core files enough. Fix `SOUL.md`, `USER.md`, `HEARTBEAT.md`, and `AGENTS.md` before you add more automation.

### The assistant keeps forgetting what matters

Your `memory/session-brief.md` is either stale or overloaded. Rewrite it. Keep it short.

### Night work is unreliable

Your queue is vague, or you are not using the ledger. Tighten acceptance criteria and review stale rows every morning.

### Connectors work in one session and fail in another

You have alias drift. Record exact commands and auth notes in `TOOLS.md`.

### Search feels stale

Your semantic layer is stale or optional and you forgot that it is optional. Files stay the source of truth. Reindex if you use semantic search. Fall back to direct file reads when needed.

### The assistant keeps sounding wrong even though the files are right

That is usually a model-routing or overlay issue, not a memory issue. Check `reference/model-playbook/`.

---

## 11. The Point

Clawrari is not a pile of markdown files. It is a loop:

- durable context
- explicit feedback
- scoped async execution
- regular maintenance
- deliberate upgrades

Run the loop and it compounds. Skip the loop and it decays.
