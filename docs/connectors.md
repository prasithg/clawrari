# Connectors

Clawrari is opinionated about connectors: use the ones that create leverage, avoid the ones that create constant operational drag.

## Principles

- Prefer connectors that map to recurring workflows.
- Keep external actions gated behind review or approval.
- Document auth and failure modes in plain language.
- Treat connectors as replaceable modules, not magical dependencies.

## Core Connector Families

## `gws-*` and Google Workspace

Purpose:

- calendar reads and inserts
- docs and drive workflows
- task and sheet helpers
- meeting prep and weekly digest recipes

Why it matters:

- calendar is a core input for briefings
- docs, sheets, and drive create repeatable operating workflows
- Gmail can be useful, but should be enabled carefully

Advice:

- start with calendar, drive, docs, and tasks
- add Gmail only if your review model is clear
- keep account-specific references out of shared docs

## `gh` and GitHub

Purpose:

- repository state
- pull requests
- issue workflows
- CI and code review support

Clawrari uses GitHub in two ways:

- as the home for code and docs
- as a document bus for auditable artifacts, diffs, and review history

Advice:

- prefer connector-backed reads for metadata
- use local git for branch, commit, and diff discipline
- open draft PRs by default unless a human asks otherwise

## `mcporter`

Purpose:

- centralized access to MCP-backed tools and internal connectors
- bridge into systems like Linear or meeting-note tools

Why it matters:

- it lets Clawrari talk to structured work systems without baking every integration into one prompt

Advice:

- keep connector registration documented
- separate generic config from workspace-local tokens
- test read-only actions first

## Coding Agents: Codex and Claude Code

Purpose:

- long-running implementation
- repo scaffolding
- refactors
- code review support
- overnight task execution

Pattern:

- use the main assistant as orchestrator
- delegate meaty build work to coding agents
- log outputs, paths, and follow-up state back into workspace files

Advice:

- use wrapper scripts instead of hand-built shell incantations
- prefer background execution for long jobs
- switch agent family if one path fails quickly
- keep a subagent ledger so background work never disappears

## Other Useful Connectors

- Slack: review channel, alerts, RLHF loop
- Linear: status system for active work
- Browser automation: web research, web-app workflows, fallback for tools with poor APIs
- Figma: design-system or implementation workflows when relevant

## Connector Maturity Model

Start with this order:

1. search and browser
2. GitHub
3. calendar
4. Slack
5. Linear
6. Drive, Docs, and Tasks
7. everything else

The reason is simple: a smaller connector surface with strong workflows beats a giant half-configured tool zoo.
