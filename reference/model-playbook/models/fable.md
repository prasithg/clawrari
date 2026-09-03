# Model Playbook — Claude Fable 5.1 (Bedrock)

**Model id:** `amazon-bedrock/us.anthropic.claude-fable-5-1` · **alias:** `fable` (`fable5` retains the previous generation for controlled comparisons)
**Enabled:** 2026-09-02 after availability, gateway, tool-use, and paired-task checks.
**Specs:** 1M context, 128K max output, adaptive thinking always-on. Same per-token price as Fable 5; cache reads are four times cheaper.
**What it's for:** Anthropic's most capable widely-released model — hardest reasoning + long-horizon agentic work (multi-hour/multi-day runs, first-shot correctness on well-specified systems, dispatching/sustaining parallel subagents). Use it on your **hardest unsolved problems**; testing it only on easy work undersells it.

Sources: Anthropic's "Migrating to Claude Fable 5.1" and "Prompting Claude Fable 5.1" guides (fetched 2026-09-02), plus the prior Fable 5 guidance where behavior is unchanged.

---

## 5.1 deltas from Fable 5

1. **Do not force tool choice.** `tool_choice: {type:"any"}` and forced named-tool selection return an error. Name the required tool in the instruction and use strict schemas where available. `auto` and `none` remain supported.
2. **Treat thinking blocks as conversation-bound.** Replaying them in another conversation, changing earlier turns, or mixing model generations invalidates later thinking blocks. Keep long transcripts append-only.
3. **Prompt for independent tool batching.** In long loops, 5.1 may request one implied read at a time. Ask it to identify the next independent inputs privately, then request them together.
4. **Request progress updates when they matter.** Higher-effort runs narrate less between tool calls. Specify a short opening update, material checkpoints, and a standalone recap for long asynchronous jobs.
5. **Raise effort or require retrieval explicitly.** At `low`, 5.1 is more likely to answer from memory instead of searching.
6. **Re-run effort sweeps.** The largest gains over Fable 5 appear at `high` and `xhigh`; `medium` is the routine default. Effort labels do not imply identical thinking budgets across generations.
7. **Keep adaptive thinking on and omit prefills.** Manual thinking budgets, disabled thinking, and assistant-message prefills remain unsupported.

## The 3 things that are DIFFERENT from Opus 4.8 (don't skip these)

1. **⚠️ Never instruct it to echo/reproduce/explain its reasoning as response text.** "Show your thinking", "explain your reasoning", visible epistemic tags, "narrate your chain of thought" → can trigger the **`reasoning_extraction` refusal**. Raw thinking is never returned on Fable; adaptive thinking is always on. If you need reasoning visibility, use the platform's summarized thinking blocks rather than asking for prose chain-of-thought.
2. **Effort is task-specific.** Use `medium` for routine work, `high` for review, and `xhigh` for the hardest long-horizon jobs. Always pair high/xhigh with a large output allowance because thinking and the response share the same cap.
3. **Longer turns by default.** Single requests can run many minutes; autonomous runs, hours. Build **async** (scheduled check-ins, a cron/night-work harness) instead of blocking. Don't surface a context-budget countdown to it (makes it prematurely wrap up); if it must see one, reassure "ample context remaining."

## Prompting patterns (Fable-tuned)

- **Prompt the outcome, not the process.** State the goal, the desired end state, and what "done" looks like. Drop "think step by step" and step-by-step reasoning scaffolds — they can hurt.
- **Give the reason, not just the request.** `I'm working on [larger task] for [who]; they need [what it enables]. With that in mind: [request].` Intent lets it connect the task to the right context.
- **Front-load the whole job.** Put all docs/constraints/background up front so it plans with the full picture (1M context makes this cheap).
- **Steer with a brief instruction, not enumerations.** Instruction-following is strong enough that one line ("lead with the outcome", "pause only for X") beats listing every case. Over-prescriptive prompting *degrades* Fable.
- **Boundaries + checkpoint rule** (maps to the two hard gates): `Pause for the user only when the work genuinely requires it: a destructive/irreversible action, a real scope change, or input only they can provide. Otherwise proceed. Don't end on a promise — if your last paragraph is a plan/question/"I'll…", do that work now with tool calls.`
- **Anti-fabrication (critical for long runs):** `Before reporting progress, audit each claim against a tool result from this session. Report only what you can point to evidence for; if unverified, say so. If tests fail, say so with output.`
- **Anti-overplanning:** `When you have enough information to act, act. Don't re-derive established facts, re-litigate settled decisions, or narrate options you won't pursue. If weighing a choice, give a recommendation, not a survey.`
- **Anti-scope-creep at high effort:** `Don't add features, refactor, or introduce abstractions beyond what the task requires. Do the simplest thing that works. Only validate at system boundaries.`
- **Readability addendum for user-facing output:** final summary = re-grounding for a reader who saw none of the work. Drop working shorthand, arrow-chains, hyphen-stacks, invented labels. Complete sentences. Outcome first.
- **Reroute-awareness.** Fable applies safety classifiers to offensive cybersecurity, biology/life-sciences, and attempts to extract summarized thinking. Benign work can still be refused. Configure a cross-provider fallback rather than trying to evade classifiers with wording changes, and never ask the model to reproduce hidden reasoning.

## Orchestration (Fable's superpower)

- **Delegate readily.** Fable is markedly better at dispatching + sustaining **parallel subagents** and peer-agent comms. `Delegate independent subtasks to subagents and keep working while they run. Intervene if one goes off track or lacks context.`
- **Fresh-context verifier subagents > self-critique.** For long runs: `Establish a method to check your own work at interval [X]; run it every [X], verifying against the spec with subagents.`
- **Fable → Codex executor pattern (the default for requirements-driven coding work):** Fable plans, decomposes, dispatches, and verifies; **Codex (`gpt` alias, `run-codex.sh`) is the executor** that writes code. Cross-family review built in.
- **Memory system it rewards:** one lesson per file, one-line summary at top, record corrections + confirmed approaches + *why*, no duplicates, delete wrong notes. Bootstrap: "reflect on past sessions via subagents, extract themes/lessons, store in [file]."

## OpenClaw wiring / working model

- **Drive the main session:** `/model fable`; the alias should resolve to Fable 5.1. Keep the older `fable5` alias comparison-only.
- **Fallback:** follow `models.yaml`: GPT-5.6 Sol, then Kimi K3 for general continuity or Grok 4.5 for hard autonomous work.
- **Effort exposure:** confirm how OpenClaw maps `thinking`/effort onto the Bedrock Converse path for Fable before relying on `xhigh`. [verify TODO]
- **Sampling:** temperature 1.0/unset, top_p ≥0.99 & <1.0/unset, top_k unsupported — leave config clean, add no overrides.
- **Scaffolding to revisit:** older skills/overlays built for prior models are often too prescriptive → review/prune when driving with Fable (Fable also updates skills on the fly). A `send_to_user`-style verbatim-delivery pattern helps for long async agents.

## Compound Engineering frame (Every)

Plan → Work → Review → **Compound**. The *compound* step — codifying each run's lessons back into skills/regressions/docs — is what makes the system improve instead of repeat. Fable is built to run this loop (long-horizon + memory + self-verification). Every Fable run on a hard problem should end by writing back what it learned.

## Real-world patterns (Every "Fable Power User Camp", 2026-06)

Field-tested usage from the people running Fable hardest (Dan Shipper, Kieran Klaassen, Jack, Nityesh):

- **Gardener, not sculptor.** Don't collaborate with Fable or do work *for* it. Create the *conditions* for it to do the work, then evaluate output to improve the conditions. Set conditions → observe → adjust the trellis. That feedback cycle *is* the loop.
- **The value only shows at orchestration scale.** Used like a chat assistant (collaborative writing, Q&A), Fable feels incremental or even worse (it's slower). The "holy shit" only appears when you do **multi-agent orchestration / overnight loops** — delegating 3–4 hour jobs. Self-improvement-as-a-loop is the right shape; don't judge Fable by chat feel.
- **⭐ Point it at the ambitious/structural goal, not the surface task.** Nityesh's deck was only marginally better when asked to "make the deck." Asked to *diagnose why decks keep failing and fix the root cause*, Fable built a whole PowerPoint CLI tool that improved every future deck. **Ask "why does this keep breaking — diagnose the structural gap and build the fix," not "fix this instance."** This is the single biggest lever.
- **Batching (Kieran's "factory").** Fable can batch 20 feedback items into ONE PR instead of 20 (no prior model could). Scheduled pulse (AM/PM) reads Slack, reacts 👀, processes into one brainstorm→PR. "Automate yourself out of everything." Goal: build the *system* that ships any proposed task at high quality, not do the individual task.
- **Loops vs dynamic workflows.** Loop = "do X until goal satisfied." Dynamic workflow = Fable orchestrates phases across subagents for process-oriented work. Fable *designs* good workflows — ask it to design the workflow first.
- **Low effort is a real tool, not just a cheap tier.** Power users run Fable at **low effort** for fast, interactive, real-time work (live doc editing, small reliable tasks) because it's quick and *still* trustworthy — reserve high/xhigh for delegated hard/overnight jobs. Match effort to whether you're collaborating live (low/med) vs delegating deep work (high/xhigh).
- **Two-agent stance:** one agent you fully delegate to (don't watch), one you work with live in the same file. 
- **Sweep pattern:** an agent watches a file/surface on an interval, picks up `TK`/bracket markers you leave while writing, executes them, moves finished items to a Done section. Self-building: point Fable at its own repo + a task doc and let it improve itself.
- **Connect all sources + set the environment up to succeed.** "The agent should have access to everything"; the prep work is *knowing what you want*. When something breaks, tell it "compound this knowledge" → write to AGENTS.md/memory so it doesn't recur.
- **Fight capability blindness.** "Tried it before, didn't work" is a trap — re-test old impossible ideas on each new model. Fable clears bars prior models couldn't.
- **Cost note.** Long orchestration runs can consume tens of millions of input tokens. If a provider credit covers that usage, spend the budget on hard, verifiable work; otherwise set explicit cost and checkpoint limits.
