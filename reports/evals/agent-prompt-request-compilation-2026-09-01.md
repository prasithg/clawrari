# Agent-Prompt Request Compilation Eval

## Header

- **Change under test:** Add a request-compilation layer to the public agent prompt template.
- **Surface class:** prompt template.
- **Linked ticket:** N/A — recurring public-repo drift refresh.
- **Fault side:** `owner—model · fault:harness`. Casual requests were forwarded without a stable task contract; the prompt harness should resolve routine ambiguity before delegation.

## Task Set

1. A casual build request that names an outcome but omits verification and recovery.
2. A request with a consequential product choice that the agent must surface rather than silently decide.
3. A long independent run that may be resumed after context loss.

## Baseline vs New

| Task | Baseline | New | Expected delta |
| --- | --- | --- | --- |
| Casual build request | Prompt author invents fields ad hoc or forwards ambiguity | Compiler resolves outcome, sources, scope, done, authority, effort, execution, and recovery | More complete prompt without burdening the requester |
| Consequential choice | Agent may guess or ask about every missing detail | Compiler exposes only material conflicts and human-owned decisions | Fewer unnecessary questions without overstepping authority |
| Long run | Resume behavior depends on chat history | Prompt requires a durable run record and one terminal outcome | Lower duplicate-run and silent-restart risk |

## Metrics

- Coverage: PASS — all eight task-contract fields are named.
- Authority handling: PASS — routine compilation stays silent; consequential choices surface.
- Recovery handling: PASS — long runs require a durable record and resume semantics.
- Sanitization: PASS — no private organizations, people, project IDs, URLs, or credentials appear.

## Gaps + Fixes

- This is a static template eval, not a live multi-model prompt-following study.
- Follow-up: compare completion and clarification rates across representative agent models when enough public fixtures exist.

## Untested Surface

The eval does not measure whether every model family interprets the compiled contract equally well or whether the eight-field checklist adds unnecessary prompt length on trivial tasks.

## Verdict

**ship** — the change is small, generalizable, and closes a clear prompt-harness gap while naming the untested behavioral surface.

## Artifact Path

`reports/evals/agent-prompt-request-compilation-2026-09-01.md`

## Sign-off

- Run by: Clawrari Pulse automation
- Date: 2026-09-01
- Linked from: public agent-prompt template drift refresh
