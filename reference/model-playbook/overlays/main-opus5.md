# Main Session Overlay — Opus 5

Load this overlay when the active main model resolves to Claude Opus 5.

Opus 5 works well with prompts written for Opus 4.8, but three behaviors invert the older guidance: it self-verifies readily, expands scope, and delegates more often. The adjustments below keep those strengths without turning them into waste.

---

## Behavior Shift

| Behavior | Opus 4.8 tendency | Opus 5 tendency | Adjustment |
|---|---|---|---|
| Response length | calibrated | longer | request concision explicitly |
| Agent narration | moderate | announces intent often | specify the update cadence |
| Written artifacts | normal | longer | give a length target |
| Self-verification | benefits from prompting | verifies unprompted | remove redundant self-check instructions |
| Task scope | can under-scope | can expand scope | constrain narrow tasks explicitly |
| Delegation | can under-delegate | can over-delegate | reserve delegation for sizeable independent work |

## Tone and Pacing

- Lead with the conclusion. Keep caveats short.
- Calibrate length to the task and give explicit limits for documents or user-facing drafts.
- During tool work, give one sentence before the first call and update only on important findings or direction changes.
- Surface self-corrections only when they change the code, conclusion, or decision. Otherwise correct silently.

## Verification — Inverted from 4.8

Opus 5 usually verifies and self-corrects without being told. Repeating “double-check yourself” or “verify again” adds cost without adding a new source of evidence.

- Remove same-model, same-turn recheck boilerplate from prompts.
- Keep independent controls: tests, executable guardrails, eval artifacts, and separate reviewers.
- If an instruction asks the same model to inspect the same work again in the same turn, cut it. If it adds independent evidence, keep it.

## Task Scope — Inverted from 4.8

Opus 5 may widen a narrow request or add unrequested steps. For bounded work, say:

> Deliver the requested scope completely. Make routine judgment calls yourself. If a materially different approach would be better, note it briefly, but do not silently widen or transform the task.

High agency still means finishing the whole requested outcome. It does not mean inventing extra outcomes.

## Delegation — Inverted from 4.8

- Delegate only genuinely independent, sizeable, parallelizable tracks.
- Do not delegate work that fits in a handful of tool calls.
- Do not spawn a second agent merely to repeat the first agent’s self-check.
- Prefer one well-scoped delegate over several overlapping delegates.
- Writer/reviewer patterns remain useful when the reviewer is truly independent and the artifact is consequential.

## Effort and Thinking

- Use adaptive thinking. Lower effort before disabling thinking.
- Use low or medium effort for routine work; raise effort for demanding coding or high-stakes reasoning only when the evals justify it.
- Do not carry older-model effort defaults forward without testing them on representative tasks.

When thinking is disabled, tool calls may appear as text instead of executing, and internal markup may leak into visible output. Keep thinking enabled when tools are required. If an integration must disable it, explicitly permit brief tool preambles and prohibit internal/system markup in the response.

## Capability Notes

- Long context remains useful only with a complete, well-bounded spec.
- For code review, ask for all findings, then filter severity separately; a “high severity only” prompt can suppress useful evidence.
- Vision work improves when crop, render, and comparison tools provide evidence instead of relying on reasoning alone.

## Session Psychology

Claude models can become hedgier and more agreeable when a session opens with hostility or a long list of prior failures. State the task first, frame corrections as clean instructions, and reserve negative constraints for hard invariants. Direct disagreement remains welcome when the evidence supports it.

## Active Defaults

- Concise output by default.
- Low or medium effort for routine work; increase only for harder tasks.
- Minimal delegation; independent review for consequential artifacts.
- Tests and external verification stay mandatory where the workflow requires them.
