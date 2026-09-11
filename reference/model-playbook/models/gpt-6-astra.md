# GPT-6 Astra

**Runtime id:** `openai/gpt-6-astra` · **alias:** `astra` · **Codex CLI id:** `gpt-6-astra`
**Enabled:** 2026-09-09 as the OpenAI lane, replacing the retired GPT-5.6 Sol. Promotion followed a paired-task refresh eval; live provider performance in your own stack still needs its own smoke test.
**Specs (official model page):** 1,050,000 context · 922,000 max input · 128,000 max output · knowledge cutoff Apr 30 2026 · text+image in, text out · reasoning tokens · `reasoning.effort` ∈ {`low`, `medium`, `high`, `xhigh`, `max`} — **`none` unsupported**.
**Pricing (API, as published 2026-09-09):** $10/M input · $1/M cached input · $12.5/M cache writes · $50/M output. Requests over 272K input tokens bill 2× input / 1.5× output for the whole request. Batch/Flex 50%. Fast mode 2×. If your Codex route uses OAuth on a ChatGPT plan, API pricing applies only to direct API calls. Check the model page before quoting numbers.
**What it's for:** OpenAI's most capable model — computer use, browsing, software engineering, long multistep workflows, document creation. OpenAI reports fewer output tokens per task than GPT-5.6 Sol and a lower scope-overreach rate on its own eval; treat those as vendor claims until your own eval confirms them.

Sources (fetched 2026-09-09):
- Model page: <https://developers.openai.com/api/docs/models/gpt-6-astra>
- Using GPT-6 Astra (prompting best practices + migration quickstart): <https://developers.openai.com/api/docs/guides/latest-model>
- Launch post: <https://openai.com/index/gpt-6-astra/>
- Prior GPT-5.6 guidance still applicable where unchanged: <https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6>

---

## Routing

Astra owns the coding, review, artifact, and computer-use lanes. Fable 5.1 stays main/default and voice. Vary effort by task instead of adding a second OpenAI model:

- **Astra, xhigh:** substantial coding (Codex wrapper default), hard-work backup for Fable 5.1 xhigh, difficult SWE, substantial artifact/computer-use work.
- **Astra, high:** code/security review, complex implementation, evals, specialist escalation.
- **Astra, medium:** routine implementation, artifact creation, ordinary tool work, and fallback #1 for the Fable default chain.
- **Astra, low:** small code edits, mechanical artifact checks, bounded computer use, and anything the retired Sol ran at `minimal`/`none` — OpenAI's migration note: start at `low` and compare.

An explicit `max` override remains available on runtimes that expose it; Codex CLI caps at `xhigh`. Retired GPT-5.6 Sol/Luna stay reachable as `sol`/`luna` for comparisons only.

## What changed vs GPT-5.6 Sol (read before writing prompts)

1. **It asks more.** Astra is trained to ask a focused question when the answer could materially change the outcome, and to ask non-blocking questions while working. Where Sol assumed and persisted, Astra may stop. For unattended lanes (crons, night work, spawns) **always include the autonomy preamble** (below). In Codex it asks asynchronously and proceeds on sensible assumptions if unanswered, but waits on consequential decisions.
2. **It follows instructions harder — including your skills and AGENTS.md.** Stronger instruction following means more sensitivity to *every* file in context. Unclear or conflicting guidance in a SKILL.md can make it pause and block early. OpenAI **strongly recommends auditing skills and instruction files**. State instruction precedence explicitly (user > skill). Ask it to name the exact SKILL.md and quoted line when it pauses.
3. **It formats heavily.** Defaults to lists, tables, Markdown; may reuse stock phrases across sessions. Specify prose vs lists and hand it the slop blocklist (below). The blocklist overlaps the usual AI-writing tells ("delve", "leverage", "it's worth noting", "This isn't about X. It's about Y.", contrastive "X, not Y", invented compound labels, "Bottom line:", "In short:"), so it pairs well with a writing-quality gate.
4. **It delegates less than an orchestrator wants.** Trained for subagent parallelism but conservative by default — prompt for it explicitly (snippet below) or it will serialize.
5. **It over-tests small changes.** Thorough verification is default; calibrate it down for reversible low-impact edits or it burns time writing mirror tests.
6. **API surface deltas.** No `temperature`/`top_p`/`logprobs`. Tool calling requires the **Responses API** (Chat Completions works without tools). `prompt_cache_retention` → `prompt_cache_options.ttl: "30m"`. New: `async: true` on tools, mid-turn steering over WebSocket, `configuration_update` input item to change reasoning effort mid-conversation without breaking the cache prefix. Fast mode unavailable with EU residency. [inferred: an OpenClaw `openai/` provider should handle these; the source eval exercised only Codex CLI and OpenClaw spawn.]
7. **Codex: notes across context windows.** Codex can keep notes across context windows instead of compacting into one summary, with earlier windows searchable. Experimental toggle in the Codex config; OpenAI says it becomes Astra's default "in the coming weeks". [inferred: exact config key not verified — check `codex --help` or release notes before enabling.]
8. **Steering is safer.** Sol sometimes treated a mid-task correction as a new goal; Astra incorporates new requirements and answers side questions without dropping the original task. Good for long unattended runs.

## Prompt shape

Astra reads compact structure well; the GPT-5.6 XML control blocks still work. Prefer the **outcome / constraints / autonomy / verification / done-when** shape, and keep the Sol-era "simplify first" lesson (leaner prompts scored +10–15% on OpenAI's internal coding evals): state the outcome, success criteria, stop conditions, safety constraints, and required output shape once; cut repeated rules and behavior it already does.

```xml
<goal>Concrete outcome.</goal>
<scope>Files, systems, evidence in bounds. Write scope explicit.</scope>
<autonomy>See preamble below — what it may decide vs what needs the operator.</autonomy>
<acceptance_criteria>Observable completion checks.</acceptance_criteria>
<verification>Which checks to run; how much testing this change deserves.</verification>
<done_when>Stop condition.</done_when>
```

### Official prompt snippets (verbatim from OpenAI, use as-is)

**Autonomy preamble — put this in every unattended Astra lane (crons, night work, Codex wrapper):**

> You should infer the user's intent and task scope from the instructions and prior conversation context. Your job is to bias towards action and carry the user's intended task to completion.
> When the user expresses intent to perform new work or fix an existing issue, persist until the user's intended goal is complete. Progress autonomously towards the user's goal (e.g. creating isolated worktrees / checkouts if needed, resolving merge conflicts, read-only actions, creating draft PRs etc.) unless they are clearly destructive or irreversible.

**Implied authorization ("can you…" = do it):**

> When the user's prompt indicates a request for action, such as "can you...", "I want to...", "help me..." and similar expressions, treat these as instructions to do the work and take action. Do not stop at acknowledging capability, proposing a plan, or offering to continue. Do not settle for a partial or "helpful enough" solution that does not fully satisfy the user's task to save time, effort or tokens. If a task requires sustained work, complete all the necessary work until the intended outcome is fulfilled.

**Approval only on a reviewable result (matches the SOUL.md hard gates):**

> Before asking the user clarifying questions, you should complete the work that is already authorized from context and necessary to make the proposed action concrete and reviewable. The user should be approving a concrete, reviewable result. For example, before deploying a change, writing to an external application, merging a PR or publishing a site, do all the required work first so that user approval is the final step. You don't need user permission for reversible tasks, read-only actions, reviews or fixes, or anything for which authorization is provided earlier in the session or strongly implied from the task instruction.
> Do not introduce unsolicited warnings, disclaimers, approval flows, or safety/compliance checklists due to hypothetical risk.

**Instruction precedence (skills vs user):**

> The user's instructions take precedence over guidelines provided in a skill. If explicit user instructions conflict with a skill's instructions, prioritize the user's instructions.

**Skill-pause transparency (use when debugging a stall):**

> If a skill causes you to ask for permission or confirmation, pause, leave requested work unfinished, or diverge from the user's intent, name and link to the exact SKILL.md file you read, quote the relevant instruction, and briefly explain how it applies. Distinguish explicit skill requirements from your interpretation of guidelines.

**Prose over formatting (operator-facing and public surfaces):**

> Default to using clear, concise paragraphs, each developing one main idea. Use lists only when the information is genuinely parallel, sequential, or easier to compare, and avoid nested lists unless the hierarchy cannot be expressed clearly in prose. Use plain, simple language: familiar words, concrete examples, and precise verbs. Prefer active voice and direct statements.
> Make sure to state the main point clearly and early, then develop it with the explanation and detail the reader needs.

**Slop blocklist (pair with your writing-quality gate):**

> Avoid using slop words or phrases like "Bottom Line:" in conclusions, "delve," "foster," "leverage," "it's worth noting," "importantly," "Question? Answer." or "This isn't about X. It's about Y.", "genuinely" or hyphenated compound descriptions and adjectives. Do not use concluding summary statements such as "In short:..", "The simplest mental model is:...".
> State the intended action directly. Avoid adding what you won't do, what will remain unchanged, or how you'll separate or categorize results. Do not use contrastive framing such as "X, not Y" or "X—not Y" that introduces an unprompted alternative that the user didn't ask about. Avoid invented compound labels like "exact-head checks" and "editorial-row layouts", vague qualifiers, and canned transitions; use plain verbs and prepositions to state the actual relationship directly.

**Subagent delegation (orchestrator lanes):**

> If at any point you can parallelize work by delegating tasks to another agent (no matter if you are the root or subagent), you should do so using collaboration tools if it could save time or improve quality.
> Messages that you send to other agents and your final answer may be read by a human, so ensure they are legible. Always put proper spaces between words and/or numbers.

**Testing calibration (coding lanes):**

> Do not write tests for reversible, low-impact changes that mirror the implementation. If you do choose to verify your work with tests, make sure that the tests are meaningful and necessary to verify implementation.
> Run tests appropriate to the change and complete required checks. Once those pass, broaden or repeat testing only when new changes, failures, or unresolved concerns justify it; otherwise, continue toward completing the task.

## Reasoning effort semantics

- Tiers: `low` < `medium` < `high` < `xhigh` < `max`. `none`/`minimal` are gone — migrate those to `low` and compare.
- Migration rule: otherwise preserve the effective effort you used on Sol.
- Change effort mid-conversation with a `configuration_update` input item rather than changing request-level `reasoning.effort` (keeps the cache prefix). [inferred: not exposed through OpenClaw's thinking selector as of 2026-09-09.]
- "Effort tier, not incantations" still holds: raise the tier, don't spam "think harder".

## Tool-calling conventions

- Responses API required for tools. Supported hosted tools: web_search, file_search, image_generation, code_interpreter, hosted_shell, apply_patch, skills, computer_use, mcp, tool_search.
- `async: true` per tool lets Astra keep reasoning/calling other tools while your harness runs it; return the result with the original `call_id`.
- Programmatic Tool Calling, structured outputs, streaming, prompt caching, persisted reasoning, compaction, and pro mode all carried over from GPT-5.6.
- No forced-tool-choice caveat here (that hazard belongs to Fable 5.1, not Astra).

## Verbosity controls

- Structural default is heavy (lists/tables). Control with the prose snippet above, not "be concise" spam. [inferred: the GPT-5.6 `text.verbosity` param still applies — not re-verified on the Astra page.]
- OpenAI trained Astra to "pull only the context that matters into outputs" — expect shorter artifacts than Sol by default.

## Failure modes

- **Stalls on a clarifying question in an unattended lane** → autonomy preamble missing. Fix the prompt, not the schedule.
- **Blocks early citing a skill** → conflicting/unclear SKILL.md guidance. Ask it to name the file and line; fix the skill.
- **Writes a test suite for a one-line change** → add the testing-calibration snippet.
- **Serializes work it could fan out** → add the delegation snippet.
- **Bullet-and-table soup on an operator-facing reply** → prose snippet plus your writing-quality gate.
- Do not claim tests passed without command evidence (unchanged).
- Do not let polished structure substitute for finishing the work (unchanged).
