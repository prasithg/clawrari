# Skills Catalog

This repo does not vend every skill directly. It documents the core skill mix used in a real Clawrari-style workspace so you can rebuild the same operating surface in your own install.

## Core Daily Drivers

`morning-briefing`
- Generates the weekday operating brief from calendar, team activity, tasks, and one strategic focus.

`responsive`
- Scans for messages that need a reply, tracks follow-up state, and surfaces what should be handled.

`daily-digest`
- Runs the evening research-to-draft loop for short-form content and trend tracking.

`research`
- Deep-dive research across web, community, and personal-signal sources.

`meeting-debrief`
- Converts meeting notes into action items, takeaways, and follow-up context.

## Content and Brand

`content-engine`
- Shared content operating system: strategy, deliverables, curation rules, and writing style.

`content-autopilot`
- Higher-automation layer for recurring content generation.

`ai-talk-draft`
- One-format drafting workflow that can be folded into a broader content system.

`publish-pipeline`
- Publishing-stage workflow for reviewed content. Defers to `avoid-ai-writing` for all voice rules. Stub vended at [`publish-pipeline/SKILL.md`](publish-pipeline/SKILL.md).

`avoid-ai-writing` (AWDS)
- The single source of truth for voice and anti-AI-tell rules. A four-layer detector (lexical / formatting / structural / emerging) plus a self-improving autoresearch loop. Mandatory pre-ship gate for generated content. `content-engine`, `content-autopilot`, `ai-talk-draft`, and `publish-pipeline` all defer to it on any conflict. Vended in full at [`avoid-ai-writing/`](avoid-ai-writing/SKILL.md).

## Execution and Improvement

`coding-agent`
- Delegates meaty implementation work to Codex or Claude Code, with a mechanical delegate-or-declare trigger that stops interactive sessions from silently drifting into hours of inline editing. Vended in full at [`coding-agent/SKILL.md`](coding-agent/SKILL.md).

`cross-review`
- The default review handle for any code work: the *opposite* model family reviews the build (Codex reviews Claude Code, and vice versa), grades every acceptance criterion with `file:line` evidence, and must name its own untested surface. Vended in full at [`cross-review/SKILL.md`](cross-review/SKILL.md).

`night-work`
- Overnight autonomous build loop: one bounded task at a time, verify, log, move on — for coding, research, maintenance, and cleanup. Vended in full at [`night-work/SKILL.md`](night-work/SKILL.md).

`loop-watcher`
- Scouts emerging repeatable agent loops from external sources (social feeds, community loop libraries), dedupes against a shared seen-ledger, classifies each net-new candidate with a deterministic rubric, and drafts a digest for human review — never auto-files, never posts. Pattern scaffold at [`loop-watcher/SKILL.md`](loop-watcher/SKILL.md).

`self-improving-agent`
- Captures failures, learnings, corrections, and feature requests for later promotion.

`summarize`
- Fast synthesis helper used across content, research, and workflow cleanup.

## Integrations

`slack`
- Actions and review-loop workflows for message reads, reactions, pins, and sends.

`mcporter`
- Browser relay / desktop bridge for logged-in or human-visible workflows.

`linear`
- Project-management bridge for issues, projects, and workload views.

`figma`
- Design-system or implementation workflows when design work matters.

`google-doc-publish`
- Document publishing utility.

`openai-whisper-api`
- Voice-note ingestion for voice journals and fast capture.

`tts`
- Listen mode and audio output.

## Google Workspace Family

Clawrari-style workspaces often install a large `gws-*` surface, then use only a smaller daily subset.

Common useful members:

- `gws-calendar`
- `gws-calendar-agenda`
- `gws-docs`
- `gws-docs-write`
- `gws-drive`
- `gws-gmail`
- `gws-sheets`
- `gws-tasks`
- `gws-workflow-*`

Advice:

- install the family only if you will document which sub-skills are actually in play
- avoid turning Gmail on by default unless your approval model is explicit

## Persona Overlays

These are useful as optional role packs:

- `persona-exec-assistant`
- `persona-project-manager`
- `persona-researcher`
- `persona-content-creator`
- `persona-team-lead`
- `personal-advisor` — a context-grounded advisor: durable `plan`/`learnings`/`eval` context-files plus a satisfaction-loop self-check that gates advice against a stated bar. Unlike the `persona-*` packs above, this one is **vended in full** at [`personal-advisor/SKILL.md`](personal-advisor/SKILL.md).

They work best as overlays on top of the shared base, not as replacements for it.

## Specialist Utilities

Useful but not core to every install:

- `mac-screenshots`
- `video-to-spec`
- `x-api`
- `x-reply-guy`
- `auto-board-sync`
- `data-ingestion`

## Recommended Install Order

1. `research`
2. `morning-briefing`
3. `responsive`
4. `daily-digest`
5. `coding-agent`
6. `cross-review`
7. `night-work`
8. `self-improving-agent`
9. `slack`
10. `linear`
11. selected `gws-*` skills

The rule is simple: install skills that map to recurring workflows first. Leave novelty skills for later.
