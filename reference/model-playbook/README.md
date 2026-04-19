# Model Playbook

Single source of truth for **which model to use, when, and how to prompt it**.

Last updated: 2026-04-18 — built from official model prompting guides plus observed behavior in live OpenClaw-style workflows.

---

## What's here

| File | Purpose |
|---|---|
| `orchestration-strategy.md` | **Read first.** Decision tree: task type → model + prompt style. The routing brain. |
| `models.yaml` | Single source of truth for model ids, aliases, capabilities, costs, and prompt style. |
| `models/opus.md` | Claude Opus 4.6 + 4.7 prompting (covers main-session orchestration + heavy reasoning subagents). |
| `models/gpt-5.4.md` | OpenAI GPT-5.4 prompting (alternate main + Codex CLI coding agent). |
| `models/gemini-3.1-pro.md` | Gemini 3.1 Pro prompting (deep research, websearch-heavy, multimodal). |
| `models/glm-5.1.md` | z.ai GLM 5.1 prompting (flagship, SOTA SWE-Bench Pro, long-horizon autonomous work, default subagent). |
| `models/sonnet-4.6.md` | Claude Sonnet 4.6 prompting (Anthropic-ecosystem fallback, content drafts). |
| `models/haiku-4.5.md` | Claude Haiku 4.5 prompting (cheap Anthropic-family — candidate, not active in workspace). |
| `overlays/main-opus.md` | Loaded when main session = Opus. Behavioral nudges that don't belong in SOUL.md. |
| `overlays/main-gpt54.md` | Loaded when main session = GPT-5.4. Behavioral nudges + XML-block scaffolding. |

## How to use

**Routine sub-agent spawn:** Look at the routing table at the top of `reference/agent-prompt-template.md`. It tells you which model file to consult. Most cases stop there.

**Edge case / unfamiliar task:** Read `orchestration-strategy.md` decision tree, then the relevant `models/<model>.md` for prompt patterns.

**Switching main session model:** Update SOUL.md's `ACTIVE_MAIN_OVERLAY` line to point at the right file in `overlays/`. Nothing else needs to change.

**Building a new prompt or skill:** Use the model file's "system prompt template" section as your starting point. Test against the model's known failure modes listed at the bottom of each model file.

## Update cadence

- **Per-model files:** Update when a new model version drops or a quirk is discovered (write to `memory/regressions.md` first, then update the model file).
- **`orchestration-strategy.md`:** Update when a new task type emerges or routing proves wrong in practice. Document why in the changelog at the bottom.
- **`models.yaml`:** Update when adding/removing a model. Bump `version` field.

## Related

- `reference/agent-prompt-template.md` — XML-tagged prompt scaffolding (now model-aware via routing table at top)
- `reference/prompt-engineering-patterns.md` — Cross-cutting XML block library
- `memory/regressions.md` — Failure-to-guardrail log; check before adding new prompt patterns
- Optional local helper scripts can sit on top of this playbook, but the playbook itself is the source of truth.
