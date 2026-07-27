# /goal Reference Loop — Vasilescu "Second-Brain Compiler"

Source: nick vasilescu (@nickvasiles), X 2026-06-21 (tweet 2068828544797725075 → loop in 2068828549000413510).
Captured 2026-06-22. This is a reference exemplar of a well-structured Codex `/goal` spec — study it as a template for your own /goal-spec upgrades and knowledge-compiler runs.

## Why this is a strong /goal spec (the transferable patterns)
1. Orientation-first: inspect sources + write ORIENTATION-REPORT.md before authoring anything.
2. Hard checkpoints: pause for user approval at defined gates (after orientation; after smoke pass).
3. State + resumption files: INGESTION-LOG.md + state.json; MUST read both before new work after any interruption. (= a resumable progress-file pattern.)
4. Connector verification gate: document the actual connected account/workspace before ingesting; wrong account => blocked; SOURCE-MANIFEST.md.
5. Deterministic machinery (_tools/): scripts for wikilink/slug/secret/provenance/artifact/manifest validation. "Validated by scripts," not vibes.
6. Compiler process: parse -> thread/group -> classify -> extract -> canonicalize -> rehydrate provenance -> author -> validate links -> critic/audit.
7. Canonical-not-dumps: update existing note + append provenance; no duplicate entities. (= a no-session-dumps + signal-only memory rule.)
8. Intra-goal model routing: cheap model for parse/classify/extract; strongest for synthesis/critic/ambiguous. (= a cheap-model / strong-model split.)
9. Redaction policy: never copy secrets; summarize sensitive info; mark sensitivity in frontmatter.
10. Validation Hard Gates + COMPLETION-AUDIT.md mapping every requirement -> evidence path. "Never declare done without proof." (= a proof-of-work completion contract.)

---

/goal Build a mature, source-backed Obsidian vault brain for the user.

Primary Objective:
Create a local Obsidian-compatible vault that functions as a durable context layer for LLMs and agents. The output must be a working vault folder, not merely a report. The vault must be source-backed, resumable, validated by scripts, and organized around canonical knowledge rather than raw dumps.

Before doing substantive work, confirm:
1. The current working directory.
2. The intended output root directory.
3. The available source locations and connectors.
4. The connected account/workspace/organization for every external connector.

If the user has not provided an output root, create the compiled vault under the current working directory:

Compiled-Vaults/compiled-vault-brain-YYYY-MM-DD/

Do not write the final vault to an ambiguous location.

Core Memory Architecture:
The vault must distinguish between declarative memory, procedural memory, source traces, context packs, and runtime tools/connectors.

Required First Phase: Orientation:
Do not author the final vault immediately. First inspect available vaults, notes, documents, repos, generated examples, and connected tools.

Produce:

Reports/ORIENTATION-REPORT.md

Include confirmed working directory, output path, source inventory, connector inventory, account/workspace verification results, initial high-signal entities, proposed ingestion plan, and blockers.

Hard Checkpoint 1:
After ORIENTATION-REPORT.md is created, pause and ask the user whether to proceed. Do not begin broad ingestion until the user approves.

Connector Verification Gate:
Before ingesting from any external connector, retrieve and document the actual connected account/workspace/organization.

For each connector, record:
- Connector name.
- Account email or user ID if available.
- Workspace, organization, tenant, or team ID if available.
- Verification method.
- Timestamp.
- Read/write capability observed.
- Whether it is approved for ingestion.

Write this to SOURCE-MANIFEST.md.

If a connector is attached to the wrong account, workspace, or organization, mark it blocked. Do not use it for ingestion. Never send emails, messages, calendar invites, refunds, billing updates, database writes, or any external mutation without explicit user approval.

Required State And Resumption Files:
Create and maintain:

INGESTION-LOG.md
state.json

The job must be resumable from these files. Before doing new work after any interruption, read both files and continue from recorded state.

state.json must include output_path, current_phase, completed_phases, sources_discovered, sources_ingested, connector_status, batches_completed, canonical_notes_created, validation_status, next_actions, and blockers.

Required Compiler Process:
Use this repeatable compiler-style process:

parse -> thread/group -> classify -> extract -> canonicalize -> rehydrate provenance -> author -> validate links -> critic/audit

When re-encountering an existing entity, update the existing canonical note and append new provenance. Do not create a duplicate note unless there is clear evidence that it is a distinct entity.

For large ingestion passes, use a small or cheap model for parse, classify, and extract where available. Reserve the strongest model for synthesis, authoring, critic review, and ambiguous entity resolution.

Required Deterministic Machinery:
Create a tools folder inside the compiled vault:

_tools/

Write and run scripts for:

1. Wikilink validation:
   - Find all [[wikilinks]].
   - Mirror Obsidian resolution semantics: resolve links by note filename anywhere in the vault, support paths where specified, account for aliases/headings/blocks where practical, and flag only links that would not resolve in Obsidian.
   - Report unresolved and ambiguous links.

2. Slug/path validation:
   - Detect empty filenames.
   - Detect invalid paths such as People/.md, Projects/.md, Companies/.md.
   - Detect duplicate canonical slugs.
   - Detect unsafe filename characters.

3. Secret and credential scanning:
   - Scan output files for API keys, access tokens, private keys, passwords, recovery codes, bearer tokens, OAuth tokens, database URLs, SSH keys, webhook secrets, signing secrets, session cookies, and credential-like environment variables.
   - Redact before completion.

4. Source reference validation:
   - Confirm every promoted canonical note has provenance.
   - Confirm every source reference points to SOURCE-MANIFEST.md or Sources/.

5. Required artifact validation:
   - Confirm all required folders and files exist.

6. Manifest generation or validation:
   - Generate or verify SOURCE-MANIFEST.md from ingestion logs and connector checks.

Record script commands and results in VALIDATION-REPORT.md.

Redaction Policy:
Never copy secrets or credential values into the compiled vault. For ordinary personal information, avoid unnecessary raw dumps. Prefer summaries and provenance over copying long private messages. If sensitive personal, legal, medical, financial, or employment information is needed, summarize minimally and mark sensitivity in frontmatter.

Required Ingestion Plan:
Existing notes/vaults:
- Ingest useful Markdown broadly.
- Prioritize people, companies, projects, daily notes, meeting notes, tasks, reports, resources, decisions, procedures, glossaries, and planning files.
- Do not mutate the original vault unless explicitly approved.

Email, if verified:
- Smoke pass: 5-10 high-signal threads.
- Create sample notes, source traces, and validation outputs.
- Pause for user approval before broader ingestion.
- Recent broad pass: approximately 300-500 relevant threads from the last 60-120 days.
- Entity-targeted pass: 500-1,500 additional threads focused on high-signal entities.
- Deep historical pass: 2,000-5,000 additional threads only if explicitly approved.

Hard Checkpoint 2:
After the email or connector smoke pass, show:
- 3-5 sample canonical notes.
- 1 sample source trace.
- 1 sample context pack.
- Current SOURCE-MANIFEST.md.
- Current VALIDATION-REPORT.md.

Then ask the user whether to proceed to broader ingestion.

Required Vault Structure:
The compiled vault must contain:

People/
Companies/
Projects/
Products/
Topics/
Decisions/
Commitments/
Procedures/
Preferences/
Context Packs/
Sources/
Maps/
Reports/
_tools/
README.md
SOURCE-MANIFEST.md
VALIDATION-REPORT.md
COMPLETION-AUDIT.md
INGESTION-LOG.md
state.json

Note Format:
Use Obsidian-compatible Markdown with YAML frontmatter where useful, wikilinks, aliases, tags, source references, and clear provenance. Prefer durable canonical notes over shallow contact cards. Separate claims from source traces. Represent uncertainty explicitly. Do not invent facts.

Example People Note:
---
type: person
name: "Example Person"
aliases:
  - "E. Person"
tags:
  - person
source_status: source-backed
sensitivity: normal
last_verified: YYYY-MM-DD
---

# Example Person

## Summary
Example Person is a [role/relationship] connected to [[Example Company]] and [[Example Project]].

## Relationship To User
- Relationship: [customer / collaborator / investor / vendor / teammate / friend / unknown]
- Context: [brief source-backed explanation]
- Confidence: high / medium / low

## Known Preferences Or Patterns
- [Observed preference or pattern]  
  Source: [[Sources/example-source-id]]

## Related Projects
- [[Example Project]]

## Open Loops
- [[Commitments/example-commitment]]

## Provenance
- [[Sources/example-source-id]] — [brief description, date]

Example Decision Note:
---
type: decision
decision_date: YYYY-MM-DD
status: active
tags:
  - decision
source_status: source-backed
confidence: medium
---

# Decision: Example Decision Title

## Decision
[State the decision clearly.]

## Rationale
[Explain why this decision was made, based only on available evidence.]

## Alternatives Considered
- [Alternative 1]
- [Alternative 2]

## Consequences
- [Expected or observed consequence]
- [Operational implication]

## Related
- [[Example Project]]
- [[Example Person]]

## Provenance
- [[Sources/example-source-id]] — [what this source proves]

Example Context Pack:
---
type: context-pack
scope: "Example bounded task"
tags:
  - context-pack
last_updated: YYYY-MM-DD
---

# Context Pack: Example Task

## Use This When
Use this context pack when an agent needs to [specific task].

## Essential Context
- [[Example Project]] is the main project.
- [[Example Person]] is the key stakeholder.
- [[Decisions/example-decision]] governs the current approach.

## Current State
[Concise source-backed summary.]

## Relevant Procedures
- [[Procedures/example-procedure]]

## Open Loops
- [[Commitments/example-commitment]]

## Sources
- [[Sources/example-source-id]]

## Agent Instructions
- Do not assume facts not present in linked notes.
- Check SOURCE-MANIFEST.md for source freshness.
- If acting externally, ask for explicit approval first.

Required Content:
Create notes for important people, companies, projects, products, systems, topics, decisions, commitments, procedures, preferences, context packs, maps/indexes, and source traces.

Validation Hard Gates:
Do not declare this goal complete unless all of these pass:

- 0 placeholder source references.
- 0 broken internal wikilinks under Obsidian-style resolution.
- 0 empty slugs.
- 0 invalid paths such as People/.md, Projects/.md, Companies/.md.
- 0 copied secrets, API keys, tokens, passwords, private keys, recovery codes, or credential values.
- Every promoted canonical note has provenance.
- Every connector used is listed in SOURCE-MANIFEST.md.
- Every connector account/workspace/organization status is documented.
- README.md explains how the vault is organized and how agents should use it.
- VALIDATION-REPORT.md lists scripts run, commands used, pass/fail status, and remaining issues.
- COMPLETION-AUDIT.md maps every explicit requirement in this prompt to evidence in the output.
- INGESTION-LOG.md and state.json are current.
- The final vault opens as a normal Obsidian-compatible folder.

Completion Audit:
COMPLETION-AUDIT.md must map every major requirement in this prompt to:
- Status: pass / partial / blocked / fail.
- Evidence path.
- Notes created or scripts run.
- Remaining limitation, if any.

Execution Rules:
Work in phases. Continue across resumptions by reading INGESTION-LOG.md and state.json first. Avoid repeating completed work. Keep concise progress updates. Use source-of-truth checks over speculation. Prefer actual filesystem, connector, repo, and document evidence to memory. Preserve user-owned source files. Do not make destructive changes. Do not perform external writes or mutations without explicit approval.

Stop Conditions:
Pause and ask the user before:
- Broad connector ingestion beyond smoke pass.
- Deep historical email/chat ingestion.
- Any external write or mutation.
- Any destructive local file operation.
- Any ingestion likely to be expensive, slow, or privacy-sensitive.

Quality Bar:
The compiled vault should not be a dump. It should be a structured, source-backed operating memory that helps future agents understand who the user is, what they are working on, who and what matters, what has been decided, what remains open, what procedures work, what preferences matter, and which sources justify those conclusions.

Completion Rule:
Do not declare the goal complete until the compiled vault exists, validation scripts pass, and SOURCE-MANIFEST.md, VALIDATION-REPORT.md, COMPLETION-AUDIT.md, INGESTION-LOG.md, and state.json all exist and prove the requirements were satisfied. If blocked, continue with available sources and document the blocker precisely rather than silently degrading the output.
