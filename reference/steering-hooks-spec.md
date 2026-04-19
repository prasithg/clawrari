# Steering Hooks Spec — Pre-Completion Validation for Coding Agents

> **Status:** Draft v1.0 | **Author:** Claw | **Date:** 2026-03-19
> **Inspired by:** [Strands Agents — Steering Hooks](https://strandsagents.com/blog/steering-accuracy-beats-prompts-workflows/)

## Problem

Coding agents (Claude Code, Codex) complete tasks and declare "done" without verifiable proof. Failures are silent — the agent session ends, the expected output never materializes, and we discover it 2-48 hours later during a heartbeat check.

**Evidence from our work:**
- `claude-code-p0-fixes` (Mar 16): Agent ran, session completed, zero output files produced. Discovered stale 48hrs later.
- `FAIL-2026-03-08-community-scan`: Sub-agent spawned, completed handshake, expected report file never written.
- Both failures share the same pattern: **the agent was never required to prove it succeeded.**

## Core Principle

> **Just-in-time guidance at decision points beats front-loaded instructions.**

Strands' data: steering hooks achieved 100% accuracy across 600 evaluation runs, compared to 82.5% for prompt-based instructions. The mechanism: instead of hoping the model follows rules buried in a long prompt, you **intercept at the moment of the decision** and provide targeted, deterministic validation.

## Architecture

### Two Hook Points

```
┌─────────────────────────────────────────────────┐
│  Coding Agent Session                           │
│                                                 │
│  1. Agent reads task prompt                     │
│  2. Agent works (reads files, writes code, etc) │
│  3. Agent runs tests         ◄── HOOK: verify   │
│  4. Agent declares "done"    ◄── HOOK: validate  │
│  5. Output returned to Claw                     │
└─────────────────────────────────────────────────┘
```

**Pre-Completion Hook** (fires when agent is about to declare done):
- Deterministic checks against a checklist
- Blocks completion until all checks pass
- Returns `Guide` with specific correction if a check fails

**Post-Output Hook** (fires after agent session ends, before Claw presents results):
- Verifies expected output files exist
- Runs automated quality checks
- Flags results as `verified` or `needs-review`

### Hook Types

| Hook | Type | Cost | When |
|------|------|------|------|
| Output file exists | Deterministic | Free | Pre-completion |
| Tests executed + passed | Deterministic | Free | Pre-completion |
| Architecture compliance | Deterministic | Free | Pre-completion |
| Regression guard | Deterministic | Free | Pre-completion |
| Code quality (cross-family LLM) | LLM judge | ~$0.01 | Post-output |
| Tone/style (content work) | LLM judge | ~$0.01 | Post-output |

## Hook Specifications

### Hook 1: Output File Verification

**Trigger:** Agent about to send final "done" message
**Type:** Deterministic
**Logic:**
```
IF task.expectedOutput is defined:
  FOR each path in task.expectedOutput:
    IF file does not exist → Guide("Expected output not found: {path}. Write it before completing.")
    IF file is empty (0 bytes) → Guide("Output file {path} is empty. Verify content was written.")
```

**Implementation:** Add `expectedOutput` field to agent task prompts. Include in `systems/agent-registry/running.json` on spawn. Heartbeat already checks this but currently only post-hoc — this moves it to pre-completion.

**In prompt terms (for coding agents that don't have native hooks):**
```xml
<acceptance_criteria>
Before declaring this task complete, you MUST verify:
1. File exists: {expectedOutput}
2. File is non-empty
3. If test file: all tests pass
If any check fails, fix it. Do not declare done until all pass.
</acceptance_criteria>
```

### Hook 2: Test Execution Gate

**Trigger:** Agent about to send final "done" message
**Type:** Deterministic
**Logic:**
```
IF task has test files or test commands:
  Check agent's tool call history for test execution
  IF no test run found → Guide("Run tests before completing: {testCommand}")
  IF test run found but failed → Guide("Tests failed. Fix before completing.")
```

**Current gap:** Our agent prompts say "write tests" and "verify" but don't mechanically enforce it. This hook makes test execution a hard gate.

### Hook 3: Regression Guard

**Trigger:** Agent about to modify files matching a known regression pattern
**Type:** Deterministic
**Logic:**
```
Load memory/regressions.md
FOR each named regression:
  IF agent's changes touch the affected file/pattern:
    Guide("⚠️ Known regression [{name}]: {description}. Verify your change doesn't reintroduce this.")
```

**Example:** If regressions.md contains `REG-001: UTC timezone offset in normalizer`, and the agent modifies the normalizer, inject this warning at the moment it's about to write that file — not as a static prompt section it may ignore.

### Hook 4: Architecture Compliance

**Trigger:** Agent creates new files or modifies module boundaries
**Type:** Deterministic
**Logic:**
```
Load ARCHITECTURE.md for the project
IF agent creates file outside defined module boundaries → Guide("File {path} doesn't belong in this module. Check ARCHITECTURE.md.")
IF agent imports across layer boundaries → Guide("Import {import} crosses layer boundary. See ARCHITECTURE.md constraints.")
```

### Hook 5: Cross-Family LLM Quality Judge

**Trigger:** After agent session completes, before presenting results
**Type:** LLM judge (Gemini Flash primary, Llama 4 Scout fallback)
**Logic:**
```
Send agent's output + task requirements to judge model
Judge evaluates: completeness, correctness, style, test coverage
Returns: pass/fail + specific feedback
IF fail → flag for Claw review before presenting to the operator
```

**Cost:** ~$0.01-0.03 per judgment. Acceptable for all coding tasks.

## Implementation Strategy

### Phase 1: Prompt-Based (Now — No Code Required)

Encode hooks as structured `<acceptance_criteria>` XML blocks in agent task prompts. Not mechanically enforced, but the structured format + explicit checklist significantly improves compliance. This is what we do today, but more rigorous.

**Template addition to `reference/agent-prompt-template.md`:**
```xml
<pre_completion_checklist>
Before declaring done, verify ALL of the following:
- [ ] Expected output file(s) exist and are non-empty: {paths}
- [ ] All tests pass: {testCommand}
- [ ] No imports cross module boundaries (see ARCHITECTURE.md)
- [ ] Changes don't touch known regression areas without explicit verification
- [ ] If content work: tone matches writing-style.md guidelines
Failure to verify = task is NOT complete. Fix and re-verify.
</pre_completion_checklist>
```

### Phase 2: Script-Based (Next — Lightweight Tooling)

Write `scripts/verify-agent-output.sh` that runs after agent session ends:
- Checks file existence
- Runs test suite if applicable
- Outputs structured pass/fail JSON
- Claw reads the result before reporting to the operator

### Phase 3: Plugin-Based (Future — If OpenClaw Adds Hook API)

If OpenClaw exposes pre-tool or post-model hooks (like Strands' steering API), register deterministic validators as plugins. This is the ideal end state — mechanical enforcement, not prompt-based.

## Relation to Existing Systems

| System | Role | Hook Equivalent |
|--------|------|-----------------|
| `subagent-ledger.md` | Tracks spawned agents | Registry (data store) |
| `agent-registry/running.json` | Active agent tracking | Registry (data store) |
| `regressions.md` | Known failure patterns | Regression guard data source |
| `ARCHITECTURE.md` | Module boundaries | Architecture compliance data source |
| `sop-agent-task-workflow.md` | Process documentation | SOP (Phase 1 implementation) |
| `validation-agent-spec.md` | Cross-model review | Post-output LLM judge |
| `content-judge.mjs` | Content style enforcement | Post-output LLM judge (implemented) |

## Success Metrics

- **Silent agent failures → 0** (currently ~1 per week)
- **"Stale agent" heartbeat alerts → 0** (currently flags after 2+ hours)
- **Test coverage of agent output → 100%** of tasks with testable criteria
- **Content tone drift → caught before the operator sees it** (instead of being caught manually)

## Open Questions

1. Should failed hooks block the agent entirely, or allow completion with a warning flag?
   → Recommendation: **Block for deterministic hooks (file exists, tests pass), warn for LLM judges (tone, quality).**

2. How to handle hooks for agents that don't support native interception (Codex, Claude Code)?
   → Phase 1 (prompt-based) is the pragmatic answer. Phase 2 (post-hoc script) catches what prompts miss.

3. Should the post-output judge model be the same family as the agent, or always cross-family?
   → **Always cross-family.** Gemini judging Claude's code, or Llama judging GPT's content. Same-family blind spots are real.
