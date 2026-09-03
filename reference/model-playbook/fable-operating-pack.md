# Claude Fable 5 family — Operating Pack (prompt library)

Source: Every, https://every.to/p/claude-fable-5-prompt-library (2026-07-02).
A pre-Fable discovery prompt + 13 templates from public Fable runs and interviews. The templates remain useful on Fable 5.1; apply the migration deltas in `models/fable.md`.

> **⚠️ Adaptation note:** Every's pack assumes **Claude Code + the Compound Engineering "LFG" plugin + CLAUDE.md**. This playbook targets **OpenClaw**. Translate before use:
> - "Claude Code / cursor" → OpenClaw main session on `/model fable` (+ Codex `gpt` as executor).
> - "LFG pipeline" → the night-work/coding-agent flow + `cross-review` + eval-before-Done gate.
> - "CLAUDE.md" → `SOUL.md` / `AGENTS.md` / `USER.md` / `MEMORY.md` + `memory/` register.
> - "skills" → the `skills/` system (same concept). "subagents/loops/dynamic workflows" → `sessions_spawn` + crons.
> - Compound Engineering plugin: https://github.com/EveryInc/compound-engineering-plugin (evaluate; not installed).

## When Fable is worth the wait
Use Fable when the job pulls from several sources, can keep moving without constant input, and ends in something testable. Use Codex/Claude Code (or a faster model) when you'll steer every few minutes or need a quick draft/answer/change.

---

## Master templates

### A. Find Fable-worthy work (pre-discovery)
Inspect real context; inventory active projects, repeated workflows, stalled decisions, messy backlogs, cross-tool work; score each candidate 1–5 on: multi-source context, delegation fit, judgment required, clear finish line, leverage, Fable fit. Down-rank short/obvious/highly-interactive/hard-to-verify work. Return top-10 ranked + evidence + deliverable + verification + tools/permissions + risks, and ready-to-run Fable Briefs for the top 3. **Stop before executing.**

### B. The Fable Brief (master assignment template)
```
I want you to solve this problem: [underlying problem]
The result I want is: [final outcome, what good looks like, how it's used]
Use these sources: [repos, docs, research, notes, threads, tools, accounts]
Important constraints: [audience, deadline, budget, scope, approvals, security, human-only decisions]

Use dynamic workflows, subagents, loops, verification, and installed skills when they fit.
Before executing: 1) inspect sources; 2) restate the problem; 3) name missing context, conflicts, assumptions; 4) decide loop vs dynamic workflow vs new infra vs direct; 5) show the approach + how you'll verify.
After approval, execute. Delegate independent work to subagents and keep going. Pause only for a destructive/irreversible action, a real scope change, or info only I can provide. Don't stop at analysis if you have tools+permission to ship.
Before reporting progress/completion, audit every claim against a tool result; if unverified, say so.
When finished return: 1) outcome in one sentence; 2) what you did + key decisions; 3) evidence it works; 4) what you couldn't verify; 5) what to save/improve for next run.
```

---

## Task templates (13)

**1. Delegate a task overnight** — "run unsupervised overnight; done means [X]; don't stop on a blocker — use mocks/stubs/documented assumptions and continue; by morning leave: completed / worked-around+why / needs-my-decision / evidence."

**2. Plan architecture before building** — "before code, plan [feature]; challenge infra/abstractions that don't fit this stage; work tradeoffs until we agree; then one shareable artifact (HTML/md) with diagrams, chosen arch, rejected alternatives + why."

**3. Visual verification loop** — "for every UI change attach evidence: exercise real flows on staging, screenshot every changed screen incl. error/edge states, record a video, review your own captures, return gallery+video+issues+remaining uncertainty."

**4. Port a codebase with a dynamic workflow** — "design the migration workflow first (map→spec→translate module-by-module→test each→adversarial review→document exclusions), show it, then run end-to-end; report where behavior may differ."

**5. Fix a broken agent workflow (Nityesh)** — *the regression/cron use case.*
```
Here is a session log from an agent attempting this workflow: [workflow]
It struggled with: [time, cost, errors, poor outputs, repeated failures]
Find the ROOT CAUSE instead of patching the latest symptom. Inspect session logs, tools, skills, source files.
Build the smallest reusable improvement: a skill, CLI tool, hook, workflow, context file, or system change.
Test the upgraded workflow against a comparable task; use a fresh verifier to compare old vs new on quality/time/cost/failure-rate.
Return: 1) root cause; 2) the change; 3) before/after; 4) infra cheaper models can reuse; 5) any failure you couldn't resolve.
```

**6. GTM strategy from source data (Austin)** — "analyze [area] from the source pack; test assumptions against evidence, don't treat internal consensus as fact; return 10 highest-leverage findings + ranked ship/test/stop list + evidence + source conflicts/stale rules; flag single-source conclusions; stop for my choice; then execute approved work + verify, don't deploy without approval."

**7. Turn feedback into one batch of changes (Kieran)** — "collect feedback from [Slack/support/recordings/logs/calls]; group into themes; separate actionable / needs-judgment / conflicts-with-strategy / evidence; track what's processed to avoid dupes; one plan; after approval implement as ONE batch; return changed/skipped/needs-review + evidence; leave merging to me."

**8. Build v1 from a product spec (Willie)** — "build first working version of [X]; spec/users/domain/edge-cases/required-behavior/acceptable-rough-edges; keep to scope; test in real env; return try-instructions + key decisions + omissions + test evidence + areas to review."

**9. Design a dynamic workflow before executing (Nityesh)** — "use dynamic workflows to orchestrate: break into phases w/ completion tests, decide parallel vs dependent, assign research/build/test/adversarial-review to separate subagents, persist intermediate findings, re-plan when evidence invalidates path; show workflow + failure points + human checkpoints; execute end-to-end."

**10. Turn repeated work into a loop (Dan Shipper)** — *compound engineering core.*
```
Turn this recurring job into a loop: [recurring input, desired output, current process, frequency]
Examples (incl. failures + human corrections): [attach]
Design+test a loop that: detect new input; track processed (no dupes); decide actionable; plan+delegate; produce/ship; verify against explicit standards; route human-judgment items; retry recoverable failures, record unrecoverable; capture corrections and update the system so next run improves.
Identify trigger, schedule, context, tools, permissions, state, memory, model-routing. Use Fable for hard judgment; faster models for routine stages. Build smallest working version.
Return: loop map + implementation(plan) + human checkpoints + verification + how learning is saved between runs.
```

**11. Organize context so Fable can use it (Katie Parrott)** — *the memory/skills/SOUL audit.*
```
Audit the context available for this body of work: [project/role/workflow]
Current sources: [folders, docs, DBs, repos, notes, style guides, examples, memory files]
Design an agent-ready context system that: gives ONE concise starting file; explains what each source contains + when to use it; separates stable rules from temporary project context; identifies conflicts, duplication, stale guidance, missing info; includes examples of excellent output + known failure modes; keeps large sources available without loading everything every run; moves repeatable procedures into skills instead of bloating the starting file; defines how new decisions/corrections get saved.
Create the directory/index/templates to make it usable; implement when you have tools+permission.
Return: new context map + what changed + unresolved conflicts + how to keep it current.
```

**12. Exploratory writing partner (Katie Parrott)** — "develop [idea] from [transcripts/notes/drafts]; explore before drafting: find tensions/surprises/unresolved questions, interview me on judgment calls, propose several argument shapes + what each emphasizes/omits, wait for my choice; then outline for a reader without my context, then draft; keep exploratory material separate; flag assumptions/thin-evidence/drift."

**13. Compound a successful run (Austin)** — *the compound step.*
```
After every completed session, ask me "Do you want to compound this session?" — don't auto-run; wait for approval.
Review this session [prompt, plan, outputs, tool calls, test evidence, human feedback, result]. Determine what to learn.
Separate: durable lessons / project-specific facts / personal-team preferences / tool-workflow improvements / mistakes that should NOT become rules / one-offs not to save.
For each proposed learning: cite session evidence, say where it's stored, show the exact change, check conflicts with existing instructions.
Store durable solutions with title/metadata/vocabulary/cross-links a future agent can find; update the always-loaded file only for concise universal instructions; put procedures in skills; keep each change small.
Return: what you saved / where / what you deliberately didn't / how next run improves.
```
