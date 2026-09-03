# Model Effort Ladder

The intent route owns effort. Do not infer effort only from model strength. **This file is the single source of truth for model routing** (SOUL.md and TOOLS.md point here; do not duplicate the roster in either).

## Default routing chain

- **Ticket and agent execution:** Fable 5.1 medium → GPT-5.6 Sol max → Kimi K3 high. Use the strongest reliable reasoning route as the routine executor; do not reserve it only for exceptional tasks.
- **Main interactive sessions:** Fable 5.1 medium, with effort raised or lowered for the task instead of changing the primary model by habit.
- **Backup / reviewer / coding:** GPT-5.6 Sol max; use xhigh where a runtime caps effort below max. Fable 5.1 high is the alternate reviewer.
- **Hard autonomous work:** Fable 5.1 xhigh → GPT-5.6 Sol max → Grok 4.5 high.
- **Fast/bulk only:** Gemini 3.5 Flash low (classification, extraction, OCR/quick vision, bounded summaries, fan-out).
- **Quick interactive (explicit):** GPT-5.6 Luna low for fast conversational/light tasks; never a standing fallback or hard-work route.
- **Quick Anthropic (explicit):** Sonnet 5 low for fast interactive tasks; never a standing fallback or hard-work route.
- **Kimi:** Kimi K3 high through OpenRouter as the third-place emergency general fallback and for direct comparisons/user-selected runs.
- **Specialist escalation:** Grok 4.5 high. **Experimental only:** GLM 5.2 high (no production fallback until an eval promotes it).
- **Search:** Perplexity supplies evidence; a frontier route owns final synthesis.
- **Retired routes (do not reach for):** Opus 4.8, GPT-5.6 Terra, older GPT, Gemini Pro, older Sonnet, Haiku, older GLM. If output feels generic or off-voice, fix the prompt/effort — do not resurrect a retired model.

## Effort levels

| Level | Use |
|---|---|
| `xhigh` | Hard autonomous work and the ceiling for runtimes that do not expose `max`. Fable primary, Sol backup. |
| `high` | Review, coding, specialist escalation, difficult evals. |
| `medium` | Default interactive work, general orchestration, routine agents, and research synthesis on Fable. |
| `low` | Bounded fast/bulk extraction, classification, OCR, and mechanical scans. |
| `max` | Sol backup, review, and coding when the runtime supports it; otherwise use xhigh and record the ceiling. |

## Model defaults

- Opus 4.8: retired; retained only as a historical prompting reference.
- GPT-5.6 Sol: max for backup/reviewer/coding; xhigh where max is unavailable.
- GPT-5.6 Luna: low for explicit quick/light interactive work only.
- Sonnet 5: low for explicit quick Anthropic work only.
- Kimi K3: high for emergency continuity, explicit user-selected runs, and comparisons.
- Fable 5.1: medium for routine ticket and agent execution; xhigh for hard autonomous work; high for review. At low effort it retrieves less, so state when search is required or raise effort.
- Grok 4.5: high.
- Gemini 3.5 Flash: low and fast/bulk only.
- GLM 5.2: high and experimental only.

## Guardrails

- Flash never owns strategy, architecture, voice-critical writing, code review, or autonomous work.
- Luna never enters default, review/coding, or autonomous fallback chains; invoke it explicitly for speed.
- Sonnet never enters default, review/coding, or autonomous fallback chains; invoke it explicitly for speed.
- Kimi is the third-place emergency fallback after Fable 5.1 and GPT-5.6 Sol; use it for continuity and explicit comparisons.
- Routine agent execution starts on the strongest tested default route. A cheaper model belongs in bounded fast/bulk lanes, not as an invisible quality tax on every task.
- Hard autonomous work never silently drops below Fable xhigh or Sol xhigh; if both are unavailable, Grok high is the terminal fallback.
- Main-session outages cross provider families: Anthropic -> OpenAI -> xAI/OpenRouter.
- Perplexity supplies search results; it is not a substitute for the selected synthesis route.
- A retired model may remain documented, but no active intent may reference it. `node scripts/validate-model-playbook.mjs` enforces that boundary.
