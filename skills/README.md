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
- Publishing-stage workflow for reviewed content.

## Execution and Improvement

`coding-agent`
- Delegates meaty implementation work to Codex or Claude Code.

`night-work`
- Overnight queue runner for coding, research, maintenance, and cleanup.

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
6. `night-work`
7. `self-improving-agent`
8. `slack`
9. `linear`
10. selected `gws-*` skills

The rule is simple: install skills that map to recurring workflows first. Leave novelty skills for later.
