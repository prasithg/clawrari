# Model Effort Ladder

The intent route owns effort. Do not infer effort only from model strength. **This file is the single source of truth for model routing** (SOUL.md and TOOLS.md point here; do not duplicate the roster in either).

## Default routing chain

- **Ticket and agent execution:** Fable 5 medium → GPT-5.6 Sol medium → Kimi K3 high. Use the strongest reliable reasoning route as the routine executor; do not reserve it only for exceptional tasks.
- **Main interactive sessions:** Bedrock Opus 4.8 medium, with per-session overrides when the task calls for another route.
- **Backup / reviewer / coding:** GPT-5.6 Sol high; Fable 5 high is the alternate reviewer.
- **Hard autonomous work:** Fable 5 xhigh → GPT-5.6 Sol xhigh → Grok 4.5 high.
- **Fast/bulk only:** Gemini 3.5 Flash low (classification, extraction, OCR/quick vision, bounded summaries, fan-out).
- **Quick interactive (explicit):** GPT-5.6 Luna low for fast conversational/light tasks; never a standing fallback or hard-work route.
- **Quick Anthropic (explicit):** Sonnet 5 low for fast interactive tasks; never a standing fallback or hard-work route.
- **Kimi:** Kimi K3 high through OpenRouter as the current third-best general fallback and for direct comparisons/user-selected runs.
- **Specialist escalation:** Grok 4.5 high. **Experimental only:** GLM 5.2 high (no production fallback until an eval promotes it).
- **Search:** Perplexity supplies evidence; a frontier route owns final synthesis.
- **Retired routes (do not reach for):** GPT-5.6 Terra, older GPT, Gemini Pro, older Sonnet, Haiku, older GLM. If output feels generic or off-voice, fix the prompt/effort — do not resurrect a retired model.

## Effort levels

| Level | Use |
|---|---|
| `xhigh` | Hard autonomous work and difficult long-horizon coding. Fable primary, Sol backup. |
| `high` | Review, coding, specialist escalation, difficult evals. |
| `medium` | Default interactive work, general orchestration, research synthesis, and conversational/light GPT work through Sol. |
| `low` | Bounded fast/bulk extraction, classification, OCR, and mechanical scans. |
| `max` | Explicit benchmarks only; never a standing default. |

## Model defaults

- Opus 4.8: medium.
- GPT-5.6 Sol: medium for conversational/light work; high for review/coding; xhigh for hard-work backup.
- GPT-5.6 Luna: low for explicit quick/light interactive work only.
- Sonnet 5: low for explicit quick Anthropic work only.
- Kimi K3: high for explicit user-selected runs and comparisons only.
- Fable 5: medium for routine ticket and agent execution; xhigh for hard autonomous work; high for review.
- Grok 4.5: high.
- Gemini 3.5 Flash: low and fast/bulk only.
- GLM 5.2: high and experimental only.

## Guardrails

- Flash never owns strategy, architecture, voice-critical writing, code review, or autonomous work.
- Luna never enters default, review/coding, or autonomous fallback chains; invoke it explicitly for speed.
- Sonnet never enters default, review/coding, or autonomous fallback chains; invoke it explicitly for speed.
- Kimi is the current third-best general fallback after Opus and GPT-5.6 Sol; use it for general continuity, while keeping it explicit for specialized comparisons.
- Routine agent execution should start on the strongest tested default route. A cheaper model belongs in bounded fast/bulk lanes, not as an invisible quality tax on every task.
- Hard autonomous work never silently drops below Fable xhigh or Sol xhigh; if both are unavailable, Grok high is the terminal fallback.
- Main-session outages cross provider families: Anthropic -> OpenAI -> xAI/OpenRouter.
- Perplexity supplies search results; it is not a substitute for the selected synthesis route.
