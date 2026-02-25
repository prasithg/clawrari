# Architecture

How the pieces of a Clawrari setup connect.

## Workspace Structure

```
~/.openclaw/workspace/
├── SOUL.md          # AI personality, values, operating principles
├── USER.md          # Human context: who they are, priorities, permissions
├── AGENTS.md        # Session protocol: what to read, how to behave
├── HEARTBEAT.md     # Cron definitions: health checks, briefings, periodic tasks
├── MEMORY.md        # Memory index: points to focused memory files
├── IDENTITY.md      # AI identity: name, birthdate, setup version
├── TOOLS.md         # Environment-specific tool notes
│
├── memory/          # Persistent memory
│   ├── YYYY-MM-DD.md       # Daily logs (raw, append-only)
│   ├── projects.md         # Active project tracking
│   ├── people.md           # Relationship context
│   ├── preferences.md      # Human's patterns and preferences
│   ├── operating-rules.md  # Learned rules and corrections
│   ├── regressions.md      # Failure-to-guardrail pipeline
│   ├── context-holds.md    # Active context filters with expiry
│   ├── predictions.md      # Prediction-outcome calibration
│   └── influences.md       # Credits/influences tracker
│
├── tasks/           # Async work queue
│   └── queue.md     # Night work, background tasks
│
├── drafts/          # Content awaiting review
├── reports/         # Generated analysis and research
├── ideas/           # Quick capture inbox
└── systems/         # Internal automation (annotation loop, etc.)
```

## Information Flow

```
Human Input (chat, annotations, Slack feedback)
    │
    ▼
┌─────────────────────┐
│  Session Bootstrap   │  ← Reads SOUL + USER + MEMORY + daily notes
│  (every conversation)│
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Task Execution     │  ← Uses skills (Slack, GitHub, Gmail, etc.)
│                      │  ← Spawns sub-agents for complex work
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Memory Write-back  │  ← Updates daily notes, long-term memory
│                      │  ← Logs decisions and outcomes
└─────────────────────┘
```

## Feedback Loops

1. **RLHF Channel** — Human reacts/replies to AI output → corrections applied to behavior
2. **Annotation Loop** — Human edits workspace files with inline feedback → AI processes and learns
3. **Self-Audit** — Daily cron reviews own performance → updates operating rules
4. **Memory Curation** — Stale info archived, not deleted. Relevance scoring over time.

## Meta-Learning Architecture

Nine feedback loops that compound across sessions, making the AI permanently better:

1. **Failure-to-Guardrail Pipeline** — Every mistake gets logged in `regressions.md`, diagnosed for root cause, and converted into a new operating rule. Failures don't repeat.

2. **Trust-Scored Memory** — Every fact carries metadata: `[trust:X|src:direct/observed/inferred|hits:N|used:date]`. High-hit memories resist archival. Low-trust memories get challenged.

3. **Prediction-Outcome Calibration** — AI logs predictions with confidence in `predictions.md`. When outcomes arrive, it scores itself. Overconfident? Recalibrate. Underconfident? Lean in.

4. **Nightly Extraction** — Automated daily review pulls patterns from the day's interactions. What worked, what didn't, what to remember.

5. **Friction Detection** — When the AI disagrees with a request, it logs the contradiction instead of silently complying. This surfaces blindspots.

6. **Active Context Holds** — `context-holds.md` stores filters with expiry dates. "For the next 2 weeks, prioritize X" — then auto-expires so stale context doesn't pollute.

7. **Epistemic Tagging** — Every claim carries a confidence tag: `[consensus]`, `[observed]`, `[inferred]`, `[speculative]`, `[contrarian]`. No more hallucination-as-fact.

8. **Creative Mode Directives** — Separate operating rules for creative vs. analytical work. The AI shifts gear based on task type.

9. **Recursive Self-Improvement** — Generate → evaluate → diagnose → improve → repeat. Hard stop after 3 iterations with <5% gain to prevent infinite loops.

Credit: [@AtlasForgeAI](https://x.com/AtlasForgeAI/status/2026380335249002843) for the meta-learning loop framework. [@johnsonmxe](https://x.com/johnsonmxe) for the vasocomputation concept behind active context holds.

## Security Model

- **Local-first** — All data stays on the machine
- **Permission tiers** — Internal actions (free) vs. external actions (require approval)
- **Weekly audits** — Automated permission and anomaly review
- **No data exfiltration** — Hard rule, no exceptions
