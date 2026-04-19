# Validation Agent Spec — v0.1

> **IAA Framework:** Intent → **Action** → **Audit** ← this is the Audit step.
> The validation agent runs after every coding agent completes, before Claw presents results to the operator.

---

## Why This Exists

BCG data shows AI-assisted coding delivers 45% faster deploys but 69% more quality problems. The current flow — generate → present — skips a critical gate. This spec adds **generate → validate → present** as standard orchestration.

The key insight: a model reviewing its own output has a systematic blind spot. Cross-model review (Claude builds → Codex validates, Codex builds → Claude validates) catches what self-review misses.

---

## Where This Fits in the Workflow

```
Operator → Claw (orchestrates)
              ↓ spawns
         Build Agent (Claude Code OR Codex)
              ↓ completes, writes handoff note + episode
         Validation Agent (OPPOSITE model, one-shot)
              ↓ returns structured JSON verdict
         Claw evaluates verdict
              ↓
         PASS → present to the operator
         PASS WITH ISSUES → present with issues surfaced
         FAIL → fix or escalate before presenting
```

---

## Model Routing (Cross-Model Default)

| Build Agent | Validator |
|---|---|
| Claude Code | Codex CLI (`codex exec --full-auto`) |
| Codex CLI | Claude (`claude --print`) via wrapper |
| sessions_spawn (any) | Claude via wrapper |
| Unknown / both | Claude as default validator |

**Why cross-model?** Claude and Codex have different training priors, different failure modes. What Claude hallucinates, Codex flags. What Codex drifts on, Claude catches. This is already the philosophy in sop-agent-task-workflow.md — we're just making it mechanical.

---

## When Validation Runs

| Trigger | Run Validation? |
|---|---|
| Night work (tasks/queue.md tasks) | ✅ Always |
| Coding agent spawned during session | ✅ Default yes |
| Quick fix / single-file edit | ⚙️ Optional (Claw's call) |
| Research/content subagent | ❌ Skip (different review pattern) |
| ExecPlan exists for the project | ✅ Always |

**v0.1 default: always run for any coding agent.** Later: make configurable via task metadata.

---

## Validation Prompt Template

Use this when spawning the validation agent. Match XML pattern from `reference/agent-prompt-template.md`.

```
Review the output of a coding agent and return a structured validation verdict.

<goal>
You are a code reviewer, not a builder. Your job is to catch what the build agent missed.
Read the build output, handoff note, and episode. Compare against the spec, architecture, and acceptance criteria.
Return a structured JSON verdict. Do NOT suggest fixes — just surface the issues clearly.

Build agent: [claude-code | codex]
Task label: [task label from subagent ledger]
</goal>

<context>
Key files to review:
- Build output: [list of files changed / created by the build agent]
- Handoff note: [notes/<task-label>-handoff.md if exists]
- Episode: [notes/episode-YYYY-MM-DD-<task-label>.md if exists]

Spec / requirements:
- ExecPlan: [reference/execplan-<project>.md — or "none"]
- Architecture: [<project>/ARCHITECTURE.md — or "none"]
- Work order: [path to WO or task description]
- Original acceptance criteria:
  [paste the acceptance_criteria block from the original prompt]

Known issues / prior patterns to check against:
- [Any relevant items from ideas/inbox.md or memory files]
- [Prior lessons learned on this project if applicable]
</context>

<constraints>
- Do NOT modify any files. Read-only review.
- Do NOT suggest rewrites — flag issues, don't fix them.
- Do NOT hallucinate file contents — only review what you can actually read.
- Be specific: "line 42 of auth.ts has no error handling" not "error handling could be better."
- Complete your review in a single pass. Do not ask for more information.
</constraints>

<acceptance_criteria>
This work is complete when:
- [ ] All acceptance criteria from the original prompt are evaluated (pass/fail/partial)
- [ ] Completeness score assigned (0-100)
- [ ] Consistency score assigned (vs architecture/plan) (0-100)
- [ ] Risk flags identified (or explicitly noted as none)
- [ ] Test coverage assessed
- [ ] Verdict returned as valid JSON matching the schema below
</acceptance_criteria>

<output>
Return ONLY a JSON object matching the ValidationResult schema.
Write it to: notes/validation-<task-label>-YYYY-MM-DD.md
Format: markdown code block wrapping the JSON.
No prose outside the JSON block.
</output>
```

---

## Output Schema (ValidationResult)

```json
{
  "$schema": "validation-result-v0.1",
  "task_label": "string — matches subagent ledger label",
  "validated_by": "claude | codex",
  "build_agent": "claude-code | codex",
  "timestamp": "ISO 8601",
  "verdict": "PASS | PASS_WITH_ISSUES | FAIL",

  "scores": {
    "completeness": "0-100 — how much of the acceptance criteria is satisfied",
    "consistency": "0-100 — alignment with ExecPlan + ARCHITECTURE.md (null if neither exists)",
    "test_coverage": "0-100 — are the ACs covered by tests or verifiable steps"
  },

  "acceptance_criteria_review": [
    {
      "criterion": "string — exact AC text",
      "status": "PASS | FAIL | PARTIAL | UNTESTABLE",
      "note": "string — brief evidence or reason for status"
    }
  ],

  "risk_flags": [
    {
      "severity": "P0 | P1 | P2",
      "location": "file:line or module name",
      "description": "string — specific, actionable description of the risk"
    }
  ],

  "summary": "string — 2-4 sentence human-readable summary. This is what the operator reads first."
}
```

**Severity definitions:**
- `P0` — blocks merge/deploy. Regressions, security issues, broken ACs, data loss risk.
- `P1` — significant concern. Missing tests for key paths, architecture drift, hardcoded values.
- `P2` — minor. Style issues, docs gaps, non-blocking improvements.

---

## Verdict Thresholds

| Verdict | Condition |
|---|---|
| `PASS` | completeness ≥ 85, consistency ≥ 80, no P0 flags |
| `PASS_WITH_ISSUES` | completeness ≥ 70 AND no P0 flags (P1/P2 flags OK) |
| `FAIL` | completeness < 70 OR any P0 flag |

---

## Escalation Protocol

### PASS
- Claw presents output to the operator with ✅ validation badge
- Ledger entry updated: `reviewStatus: approved`
- No action required from the operator unless they want to dig in

### PASS WITH ISSUES
- Claw presents output with a **ISSUES FOUND** callout block
- Surface the P1 flags inline: "2 issues worth knowing: [...]"
- The operator decides: ship it or have Claw fix the issues first
- Ledger updated: `reviewStatus: approved (issues noted)`

### FAIL
- Claw does NOT present to the operator as "done"
- Claw either:
  a. **Auto-retry** (night work): spawn build agent again with P0 flags added to constraints
  b. **Escalate** (session work): surface to the operator immediately with FAIL details
- Auto-retry capped at **1 retry**. If retry also fails → escalate.
- Ledger entry: `reviewStatus: changes-requested` with P0 notes

---

## Integration with Subagent Ledger

Add a `validation_output` column to ledger rows for coding tasks:

```markdown
| Date | Label | Task | Output Path | Status | Validation | Notes |
| 2026-03-18 | my-task | Build feature X | notes/episode-... | ✅ done | ✅ PASS | ... |
```

Validation values: `✅ PASS` / `⚠️ PASS_WITH_ISSUES` / `❌ FAIL` / `⏭️ skipped`

---

## Implementation: How Claw Runs the Validator

After any coding agent completes, Claw runs validation via exec (not sessions_spawn — this is a one-shot read-only task, no need for a full subagent session):

**Claude validating Codex output:**
```bash
ANTHROPIC_API_KEY= claude --print --dangerously-skip-permissions -p "$(cat /tmp/validation-prompt.txt)" > notes/validation-<label>-YYYY-MM-DD.md
```

**Codex validating Claude output:**
```bash
codex exec --full-auto < /tmp/validation-prompt.txt > notes/validation-<label>-YYYY-MM-DD.md
```

Use wrapper scripts when available:
```bash
cat /tmp/validation-prompt.txt | ./scripts/run-claude-code.sh [workdir]
```

The validation prompt is written to `/tmp/validation-prompt-<label>.txt` before execution (avoids shell quoting issues — same pattern as the wrapper scripts).

---

## Skill vs Reference Doc vs SOP

**v0.1 decision: reference doc + SOP update, not a skill.**

Reasoning:
- A skill makes sense when there's a discrete invocable command pattern ("validate this output")
- Right now validation is embedded in the orchestration loop — Claw decides when/how to run it
- The right place is: this spec in `reference/` + a note in `sop-agent-task-workflow.md` pointing here
- Promote to skill when there's a need to trigger it standalone (e.g., "Claw, validate the last build")

**Future v0.2 upgrade path:** Add a `validate` skill that accepts `--task-label` and auto-runs the validation loop. But not now.

---

## What This Does NOT Cover (v0.1 Scope Limits)

- Static analysis, linting, or type-checking (use the project's own CI for that)
- Runtime testing (the build agent's responsibility per acceptance criteria)
- Content/research agent validation (different pattern — use self_reflection block instead)
- Multi-step agentic chains (validation is per-task, not per-pipeline)

---

## References

- `reference/agent-prompt-template.md` — XML prompt structure
- `reference/sop-agent-task-workflow.md` — board lifecycle + cross-model review rule
- `reference/execplan-template.md` — ExecPlan format
- `memory/subagent-ledger.md` — where validation results are tracked
