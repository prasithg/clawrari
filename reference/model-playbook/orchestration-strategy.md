# Orchestration Strategy

**The routing brain.** Given a task, pick: (1) the right model, (2) the right prompt style, (3) the right depth.

This is documentation, not a hard router. Follow it by default; deviate with a labeled reason.

Built: 2026-04-18 from prompting guides (OpenAI GPT-5.4, Anthropic Claude 4.7, Vertex Gemini 3, z.ai GLM 5.1) + observed behavior in this workspace.

---

## TL;DR Routing Table

| Task Type | Primary | Fallback | Why |
|---|---|---|---|
| **Main session** (orchestration, conversation, planning) | Opus 4.7 | GPT-5.4 → Opus 4.6 | Best instruction-follow + tool decision-making at orchestrator level |
| **Deep research** (multi-source synthesis) | Gemini 3.1 Pro | Opus 4.7 | 1M context, grounded synthesis, native search |
| **Websearch-heavy task** | Gemini 3.1 Pro | GPT-5.4 | Native search + grounding patterns |
| **YouTube / video analysis** | Gemini 3.1 Pro | — | Only model with strong native video |
| **Coding — long-horizon autonomous (hours)** | **GLM 5.1** | GPT-5.4 → Opus 4.7 | SOTA on SWE-Bench Pro (58.4); built for 8-hour autonomous execution |
| **Coding — heavy build (interactive)** | GPT-5.4 (via Codex CLI) | Opus 4.7 (via Claude Code) | Codex strongest on interactive multi-step coding |
| **Coding — review / bug hunt** | Opus 4.7 | GPT-5.4 | +11pp recall on bug-finding evals |
| **Subagent — default execution** | **GLM 5.1** | Sonnet 4.6 | Workspace default; frontier-competitive at medium-low cost |
| **Subagent — tool-heavy / cheap** | GLM 5.1 | Sonnet 4.6 | Same pick — GLM 5.1 handles both |
| **Cross-model review** | GPT-5.4 if main = Opus; Opus 4.7 if main = GPT | — | Always different family than writer |
| **Content drafting** | Sonnet 4.6 | Opus 4.7 (voice-critical) | Sonnet for drafts; Opus for voice |

> Aliases: see `models.yaml`. GLM 5.1 is z.ai's flagship (released late 2026). Workspace `openclaw.json` pins it as the default subagent.

---

## Decision Tree (when in doubt)

```
Task arrives
│
├─ Is it conversation/orchestration with the user?
│  └─ MAIN SESSION model (current overlay decides). No spawn needed.
│
├─ Does it need the web, YouTube, or >200k context synthesis?
│  └─ Gemini 3.1 Pro (deep_research intent)
│
├─ Is it building/refactoring code?
│  ├─ Heavy + long-horizon? → Codex CLI (GPT-5.4) via your preferred wrapper
│  └─ Quick edit + needs Claude's style? → Claude Code (Opus 4.6) via your preferred wrapper
│
├─ Is it reviewing code for bugs?
│  └─ Opus 4.7 — and use the "report every finding with confidence/severity" framing
│
├─ Is it long-horizon autonomous work (multi-hour continuous execution)?
│  → GLM 5.1 (built for this; SOTA on SWE-Bench Pro)
│
├─ Is it tool-driving / executing a documented workflow?
│  → GLM 5.1 (default subagent) OR Sonnet 4.6 if ecosystem integration matters
│
├─ Is it cross-model review of an output I just produced?
│  └─ DIFFERENT family than the writer (GPT if I wrote it on Opus, Opus if on GPT)
│
└─ Default subagent → Sonnet 4.6
```

---

## Prompt Style by Family

| Family | Style | Don't |
|---|---|---|
| **Anthropic (Opus, Sonnet)** | XML tags OR Markdown both work; consistent tag names; nest naturally; positive examples > negative instructions | Don't bury negative constraints; do state scope explicitly for 4.7 |
| **OpenAI (GPT-5.4)** | XML BLOCKS are first-class: `<output_contract>`, `<persistence>`, `<tool_persistence_rules>`, `<verification_loop>`, `<completeness_contract>`, `<empty_result_recovery>`, `<dependency_checks>`, `<parallel_tool_calling>`, `<missing_context_gating>`, `<action_safety>`, `<citation_rules>`, `<task_update>` | Don't skip explicit completion criteria; don't leave tool routing implicit |
| **Google (Gemini 3.1 Pro)** | Pick ONE: XML or Markdown — never both. Place core request + negative constraints LAST. Default temperature MUST be 1.0. | Don't use blanket "do not infer"; don't mix formats; don't lower temp |
| **z.ai (GLM 5.1)** | OpenAI-compatible markdown; `thinking: {type: enabled}` for reasoning/coding; coding endpoint base URL for agent harnesses | Don't disable thinking for reasoning tasks; do use `/api/coding/paas/v4` URL for Claude Code/Cline/Roo harness integration |

Read the matching `models/<model>.md` file for full conventions, system prompt template, and gotchas.

---

## Cost Awareness Layer

Cost matters but isn't the primary gate; correctness is. Use these rules of thumb:

1. **Premium tier (Opus 4.7):** main session, code review, voice-critical content, anything where being wrong is expensive
2. **High tier (GPT-5.4, Gemini 3.1 Pro):** deep research, interactive heavy builds, when premium isn't justified
3. **Medium tier (Sonnet 4.6):** content drafts, tasks where Anthropic ecosystem matters
4. **Medium-low tier (GLM 5.1):** **default subagent**, long-horizon coding, autonomous engineering loops. Frontier-competitive despite lower cost.

If a lower-tier job loops or fails twice, escalate. Don't try a third time at the same tier.

---

## Architectural Pattern (from LLMRouter, simplified)

We use one useful pattern from LLMRouter without adopting the full router:

**Service-based config** — `models.yaml` declares each model with its capabilities, costs, and prompt-style key. Both docs and any local helpers can read from it. When a model is added, removed, or upgraded, **one file changes** and the rest follows.

What we explicitly don't take:
- Trained classifier routers (KNN, MLP, BERT-based) — overkill for ~10 task types
- Per-call routing — would add latency for no benefit; our routing is task-type-driven
- Round-robin API keys / load balancing — single user workspace, no scale problem

---

## Main-Session Overlay Mechanism

SOUL.md and IDENTITY.md are model-agnostic. Model-specific behavior lives in `overlays/`:

- `overlays/main-opus.md` — loaded when main = Opus (4.6 or 4.7)
- `overlays/main-gpt54.md` — loaded when main = GPT-5.4

To switch: update SOUL.md's `ACTIVE_MAIN_OVERLAY` line (or the openclaw config that injects it). No other file changes.

---

## Enforcement

Pure documentation fails. We enforce in three lightweight ways:

1. **`agent-prompt-template.md` has the routing table at the top** — anyone (including future me) writing a sub-agent prompt sees it before opening the editor.
2. **Optional local helpers** can print the right model id + prompt file path, but the routing table here remains the authoritative source.
3. **REG-012** in `memory/regressions.md` says: "When spawning a sub-agent or writing a coding-agent prompt, declare the target model and consult the matching model file. Don't reuse a generic prompt across model families."

If a sub-agent fails because of prompt-style mismatch, log it as a REG-012 instance and tighten the model file.

---

## Common Pitfalls (collected, not theoretical)

1. **GPT-5.4 with Anthropic-style prompt** → underperforms on completeness; missing `<output_contract>` and `<completeness_contract>` causes early termination on lists. **Fix:** add the XML blocks explicitly.

2. **Gemini 3.1 Pro with mixed XML+Markdown** → drops constraints. **Fix:** pick one format per prompt and stick with it.

3. **Opus 4.7 with "be conservative" code review** → reports fewer findings than 4.6. **Fix:** "report every finding with confidence + severity, separate filtering step will rank."

4. **GLM 5.1 with thinking disabled on a reasoning task** → produces wrong answer fast. **Fix:** `thinking: {type: enabled}` for anything beyond pure formatting.

7. **GLM 5.1 wired into Claude Code/Cline at regular paas/v4 URL** → suboptimal routing. **Fix:** use `/api/coding/paas/v4` base URL for agent harness integration.

5. **Sonnet 4.6 asked for a tool call without all params** → may guess values. **Fix:** prompt with "If a required parameter is missing, ask before calling the tool."

6. **Opus 4.7 handed a prompt that worked on 4.6** → may underperform on broad-application tasks (literal interpretation). **Fix:** state scope ("apply to every section, not just the first").

---

## Model Version Verification Log

| Model | Version | Released | Last verified | Status |
|---|---|---|---|---|
| Claude Opus | 4.7 | 2026-04-16 GA | 2026-04-18 | CURRENT |
| GPT | 5.4 | 2026-03-05 | 2026-04-18 | CURRENT |
| Gemini | 3.1 Pro | 2026-02-19 | 2026-04-18 | CURRENT |
| Claude Sonnet | 4.6 | 2026-02-17 | 2026-04-18 | CURRENT |
| GLM | 5.1 | late 2026 | 2026-04-18 | CURRENT |
| Claude Haiku | 4.5 | 2025-10-15 | 2026-04-18 | CURRENT, active:false |

**Next check:** 2026-05-18, or sooner if a model misbehaves / a new release is announced.

## Changelog

- **v3 (2026-04-18):** Verified all model versions are current. Added Haiku 4.5 (candidate, not active). Added GPT-5.4-Pro variant note. Updated Sonnet 4.6 context window to 1M. Added Future Candidates section to `models.yaml` (Gemini 3.1 Flash-Lite, GPT-5.4-Pro, Qwen 3.5+, DeepSeek V3.2, Grok 4.20).
- **v2 (2026-04-18):** Corrected GLM 4.6 → GLM 5.1 throughout. Repositioned GLM from "cheap tool-driver" to "frontier-competitive default subagent" (SOTA on SWE-Bench Pro). Added long-horizon autonomous coding as a distinct intent.
- **v1 (2026-04-18):** Initial version. Built from official prompting guides + workspace observations.
