# Model Effort Ladder

**This file is the single source of truth for model routing** (SOUL.md and TOOLS.md point here; do not duplicate the roster in either). `models.yaml` supplies runtime IDs and intent defaults to any workspace routing helper; both must agree. Choose effort for the task, not a different model for each difficulty.

The roster below is an example stack. It shows how one workspace routes work; it does not assume every user has access to every provider named here. Substitute your own approved models while keeping the shape: two primaries with task-varied effort, a bounded utility lane, and resilience-only tails.

## Two models, effort-varied

**Fable 5.1** (`amazon-bedrock/us.anthropic.claude-fable-5-1`, alias `fable`) owns main/default sessions, crons, routine delegation, research synthesis, and voice-sensitive work. **GPT-6 Astra** (`openai/gpt-6-astra`, alias `astra`) is used liberally for independent reviews, coding/Codex/SWE, artifacts, and computer-use subagents. Astra does not replace Fable as main/default.

| Effort | Fable 5.1 task classes | GPT-6 Astra task classes |
|---|---|---|
| `low` | Light interaction, bounded operational checks | Small code edits, mechanical artifact checks, bounded computer use |
| `medium` | Routine tickets, delegation, research synthesis, content drafts | Routine implementation, artifact creation, ordinary tool work |
| `high` | Difficult synthesis, voice polish, alternate independent review | Code/security review, complex implementation, eval analysis |
| `xhigh` | Hard autonomous orchestration and consequential long-horizon synthesis | Hard autonomous coding, difficult SWE, substantial artifact/computer-use work |

Set effort explicitly; the classified task difficulty overrides route defaults. Codex wrappers default to `xhigh` for substantial coding. An explicit `max` override remains available on runtimes that expose it; it is not an extra model lane. Unattended Astra prompts carry the autonomy, instruction-precedence, and testing-calibration guidance in `models/gpt-6-astra.md`.

### Runtime routes

- **Ticket/agent execution default:** Fable 5.1 medium → GPT-6 Astra medium → Grok 4.5 high → Muse Spark 1.3 high.
- **Main interactive session default:** Fable 5.1 medium → GPT-6 Astra medium → Grok 4.5 high → Muse Spark 1.3 high.
- **Backup / reviewer / coding:** GPT-6 Astra high → Fable 5.1 high → Grok 4.5 high → Muse Spark 1.3 high.
- **Hard autonomous work:** Fable 5.1 xhigh → GPT-6 Astra xhigh → Grok 4.5 high → Muse Spark 1.3 high.
- **Quick interactive:** Fable 5.1 low → GPT-6 Astra low → Grok 4.5 high → Muse Spark 1.3 high.
- **Specialist escalation:** GPT-6 Astra high → Fable 5.1 high → Grok 4.5 high → Muse Spark 1.3 high.

The last two items in each chain are resilience only: invoke them after both primaries have failed, never as a chosen task lane. Main/default and voice keep Fable; the coding, review, artifact, and computer-use task lanes choose Astra with task-appropriate effort.

## Utility lanes

- **Fast/bulk only:** Gemini 3.7 Flash low → GPT-6 Astra low → Fable 5.1 low.
- Flash is limited to bounded classification, extraction, and OCR. It never owns strategy, architecture, voice, review, autonomous execution, or final synthesis. A task merely mentioning bulk or speed does not qualify.
- **Fast/bulk candidate:** GLM 5.3 high (`openrouter/z-ai/glm-5.3`); bounded classification/extraction only pending its own utility eval. Flash remains the default utility route. GLM 5.3 is never a live default or fallback.
- A search provider (Perplexity in this stack) supplies search evidence only; Fable or Astra owns synthesis and judgment.

### Weekly model-freshness check

Once a week, compare every configured, aliased, or allowlisted model ID against newer same-provider or same-family catalog versions, then check an independent model index for discovery gaps.

When declining an upgrade, record the exact current/newer version pair, decision, reason, and date. Verify both versions against the required catalog before treating that acknowledgement as effective. Keep the acknowledged pair visible in the report while suppressing its repeated upgrade alert. A later version needs a new decision; an acknowledgement must never exempt an entire model family or provider.

Report an unavailable required catalog or an unverified version pair as incomplete coverage. A declined upgrade and an inability to check for upgrades are different outcomes. Preserve any confirmed upgrade findings alongside the coverage gap. Review findings and smoke upgrades; never auto-promote or change a council seat from the check alone.

[Documentation refresh evaluation](../../reports/evals/2026-09-19-bounded-exceptions.md#version-acknowledgement-cases).

## Resilience fallback

Grok 4.5 high (`openrouter/x-ai/grok-4.5`) is fallback #2 after **both** Fable 5.1 and Astra fail; Muse Spark 1.3 high (`openrouter/meta/muse-spark-1.3`) is fallback #3. GLM 5.3 is a ladder-only candidate, never in live fallback chains (keep them three deep). An Astra-primary job tries Fable first; a Fable-primary job tries Astra first. No self-fallbacks. Record the degraded route and verify its result. Scheduled jobs keep their existing primary and first fallback; any leftover GLM fallback is replaced by Muse. The default/main chain ends at Muse.

**Anthropic-family backup:** Opus 5 high (`amazon-bedrock/us.anthropic.claude-opus-5`) covers Fable-specific outages while the provider is still available. Same family as Fable: never a council seat, never a substitute for the cross-provider chain. The `fable5` alias remains comparison-only.

Kimi K3 high is comparison-only for explicit user-selected runs; Muse replaces its former optional fourth council role. Never include Kimi in a fallback chain. Sonnet 5 remains comparison-only.

## Council third seat

Standing seats: Fable 5.1, GPT-6 Astra, and **Grok 4.5 high**. Optional fourth lane: Muse Spark 1.3 high for strategy/positioning, or GLM 5.3 high for product/integration. A seated model must not be the sole synthesizer: use a non-seated synthesizer or dual Fable 5.1 xhigh + Astra xhigh grading and report the gap.

**Grok 4.6 is pinned out of standing routing: re-test on at least three tasks before promoting.** Comparison-only until that decision changes. **Muse Spark 1.3 is runnable** once the OpenRouter account attestation is complete. Independent angle / best provocateur; not correctness-critical review. Never use a contributor or data-sharing tier for workspace material.

## Retired

Retired from live routing: Opus 4.8 and earlier Opus, GPT-5.6 Sol, GPT-5.6 Luna, GPT-5.6 Terra, older GPT, Gemini 3.1 Pro, Gemini 3.5 Flash, Kimi K2.x, Fable 5 (non-5.1), and GLM 5.2. Retired comparison aliases may remain in catalogs and historical guides; no current route may select them. If output feels generic or off-voice, fix the prompt and effort — do not resurrect a retired model. `node scripts/validate-model-playbook.mjs` enforces the boundary.

## Guardrails

- Flash never owns strategy, architecture, voice-critical writing, code review, or autonomous work.
- Kimi K3, Sonnet 5, Fable 5, and Grok 4.6 never enter default, review/coding, or autonomous fallback chains; invoke them explicitly for comparisons.
- Grok 4.5 and Muse are resilience, not lanes. A job that "prefers" Grok is a routing bug.
- Routine agent execution starts on the strongest tested default route. A cheaper model belongs in bounded fast/bulk lanes, not as an invisible quality tax on every task.
- Hard autonomous work never silently drops below Fable xhigh or Astra xhigh; if both are unavailable, record the degraded route before continuing on Grok.
- Main-session outages cross provider families: Anthropic → OpenAI → OpenRouter (xAI, then Meta). Same-family Opus 5 is only for a Fable-specific outage with the provider still up.
- Fable 5.1 at `low` searches and retrieves less; state when retrieval is required or raise effort.
- A retired model may remain documented, but no active intent may reference it.

## Decision history

Prior states, preserved for context. The live sections above govern execution.

- **2026-09-10:** Muse Spark 1.3 becomes fallback #3 and the optional fourth strategy/positioning council lane after its provider attestation cleared. GLM 5.3 drops to a ladder-only utility candidate. Kimi stays comparison-only.
- **2026-09-09:** Grok 4.5 high becomes the standing third council seat and fallback #2; Kimi K3 leaves every fallback chain; Opus 5 becomes the same-family backup; GLM 5.2 retires in favor of GLM 5.3; Grok 4.6 is pinned pending re-test.
- **2026-09-09:** GPT-6 Astra replaces the now-retired GPT-5.6 Sol as the OpenAI lane in every default, fallback, reviewer, and cron route. Sol and Luna stay reachable as comparison aliases only. Astra asks more, follows skill files harder, and over-tests small changes; read `models/gpt-6-astra.md` before writing an Astra prompt. Astra does not replace Fable 5.1 as main/default; use it liberally everywhere else.
- **2026-09-02:** Two-model doctrine. Fable 5.1 for everything with effort varied by task; the OpenAI lane at max/xhigh as backup/reviewer/coder. Opus 4.8 retired. Fable 5 replaced by Fable 5.1 after a paired head-to-head eval; same price, cheaper cache reads.
- **2026-08-05:** Routine ticket/agent execution moves to the strongest tested default at medium effort instead of reserving it for exceptional tasks.
- **2026-07-15 to 07-21:** OpenAI lane consolidated on Sol; Kimi K3 added through OpenRouter and later promoted to third general fallback (since reversed).
