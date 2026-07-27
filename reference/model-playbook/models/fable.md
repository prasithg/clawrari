# Model Playbook — Claude Fable 5 (Bedrock)

**Model id:** `amazon-bedrock/us.anthropic.claude-fable-5` · **alias:** `fable`
**Enabled:** 2026-07-02 (data-retention gate + live test — see `TOOLS.md`).
**Specs:** 1M context, 128K max output, adaptive thinking always-on, knowledge cutoff Jan 2026. Cost-covered on a credit/free Bedrock tier where available.
**What it's for:** Anthropic's most capable widely-released model — hardest reasoning + long-horizon agentic work (multi-hour/multi-day runs, first-shot correctness on well-specified systems, dispatching/sustaining parallel subagents). Use it on your **hardest unsolved problems**; testing it only on easy work undersells it.

Sources: Anthropic "Prompting Claude Fable 5", "Introducing Fable 5", "Effort" docs (fetched 2026-07-02); Every "Compound Engineering" (`memory/influences.md`); Every "Fable 5 Prompt Library" (members-only, not yet ingested).

---

## The 3 things that are DIFFERENT from Opus 4.8 (don't skip these)

1. **⚠️ Never instruct it to echo/reproduce/explain its reasoning as response text.** "Show your thinking", "explain your reasoning", visible epistemic tags, "narrate your chain of thought" → can trigger the **`reasoning_extraction` refusal** → silent fallback to Opus 4.8. Raw thinking is never returned on Fable; adaptive thinking is always on. If you need reasoning visibility, read the structured `thinking` blocks (summarized), don't ask for it in prose. **This is the #1 migration hazard for prompts/skills/SOUL.**
2. **Effort default is `high`, not `xhigh`.** (Opus 4.8 starts higher for coding/agentic work.) On Fable: `high` = default; `xhigh` = hardest long-horizon/agentic (30min+, million-token budgets); `medium`/`low` = routine. Fable at *low* often beats prior models at xhigh. Always pair high/xhigh with a **large max_tokens** — thinking + response share the cap (a 128K config + a maxTokens hotpatch are load-bearing here).
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
- **Reroute-awareness — official (Anthropic "Prompting Claude Fable 5", cross-checked 2026-07-15).** Fable runs safety classifiers over three domains: offensive cybersecurity (exploits/malware/attack tooling), biology + life sciences (lab methods, molecular mechanisms), and extraction of its summarized thinking. **Benign** cyber and beneficial life-sciences work can also trip them → `stop_reason: "refusal"`. The official fix is not prompt-wording gymnastics — it's configuring server-side/client-side fallback to Opus 4.8 (the recommended chain routes Fable→Sol xhigh→Grok; confirm a Fable→Opus refusal fallback is wired for benign-but-flagged runs). Frame legitimate security/bio work as such; don't ask it to echo its thinking (the `reasoning_extraction` hazard above is the third classifier).

## Orchestration (Fable's superpower)

- **Delegate readily.** Fable is markedly better at dispatching + sustaining **parallel subagents** and peer-agent comms. `Delegate independent subtasks to subagents and keep working while they run. Intervene if one goes off track or lacks context.`
- **Fresh-context verifier subagents > self-critique.** For long runs: `Establish a method to check your own work at interval [X]; run it every [X], verifying against the spec with subagents.`
- **Fable → Codex executor pattern (the default for requirements-driven coding work):** Fable plans, decomposes, dispatches, and verifies; **Codex (`gpt` alias, `run-codex.sh`) is the executor** that writes code. Cross-family review built in.
- **Memory system it rewards:** one lesson per file, one-line summary at top, record corrections + confirmed approaches + *why*, no duplicates, delete wrong notes. Bootstrap: "reflect on past sessions via subagents, extract themes/lessons, store in [file]."

## OpenClaw wiring / working model

- **Drive the main session:** `/model fable` (keeps Opus 4.8 the global default). Consider a sticky main primary only if committing to Fable as daily driver.
- **Fallback:** use **GPT-5.6 Sol xhigh**, then **Grok 4.5 high**. This preserves the cross-provider policy instead of falling back to another Anthropic route.
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
- **Cost note.** Every measured ~30M input tokens / ~$130 for one 6-slide deck; Kieran's on pace for ~$750k/yr. If your Bedrock account runs Fable on a credit/free tier, the token-cost governor everyone else fights doesn't apply — be aggressive with effort and orchestration.
