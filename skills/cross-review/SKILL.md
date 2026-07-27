# cross-review — cross-model review handle for any build

**Status:** v0.1 — vended in full. Copy it, wire it to your two coding agents, make it yours.

## The one-line idea

**Agent reviews agent, and the reviewer is a different model family than the builder.** A model family reviewing its own output catches its own blind spots last — different training priors catch different fingerprints. So when one coding agent builds, the *other* family reviews: Codex reviews Claude Code's build, Claude Code reviews Codex's build. Cross-model review is the default for code work, not an upsell.

This skill is the canonical surface for that flow. It writes the right prompt for the right reviewer family, spawns the reviewer through your coding-agent wrappers, handles the sandbox-writes-to-`/tmp/` quirk, and appends a ledger row so the run is auditable.

## When to use

- After any non-trivial coding-agent run, before you declare the work done.
- Trigger phrases: `cross-review`, `review this build`, `second opinion on the build`, `Codex review` / `Claude Code review`, `QA pass on this`, `find P0s in <target>`.
- Implicitly: at the end of any overnight build loop (see `night-work`), before moving a build to review.

## Inputs

| Flag | Required | Default | Description |
|---|---|---|---|
| `--target <path>` | yes | — | Build artifact: PR URL, branch name, repo dir, report path, or a specific file. The reviewer reads this. |
| `--ac <path or inline>` | yes | — | Acceptance-criteria source: spec/work-order path, an AC list file, or `inline:<criteria>` for ad-hoc. |
| `--output <path>` | no | `reports/<basename(target)>-<reviewer>-review-YYYY-MM-DD.md` | Where the review report lands. |
| `--reviewer <codex\|claude>` | no | opposite of `--builder` | Reviewer family. |
| `--builder <codex\|claude>` | no | `claude` | Who built the artifact — used to pick the opposite reviewer. |
| `--workdir <dir>` | no | repo containing `--target` | Working dir for the reviewer wrapper. |

**Routing default:**
- Builder = Claude Code → Reviewer = **Codex**.
- Builder = Codex → Reviewer = **Claude Code**.
- Cross-family is the point. Same-family review is a degraded mode and must be flagged (`--same-family-ok` with a stated reason).

## Outputs

1. **Review report** at the resolved `--output` path. Sections enforced by the prompt:
   - **Verdict** — PASS / PASS WITH FIXES / NEEDS FIXES / FAIL, plus a P0/P1 count.
   - **Acceptance-criteria coverage** — per-AC PASS / PARTIAL / FAIL with `file:line` evidence.
   - **Findings** — per finding: severity (P0/P1/P2), confidence, evidence with `file:line`, risk, fix recommendation.
   - **Architecture / spec alignment.**
   - **Test assessment.**
   - **Untested surface (mandatory)** — one paragraph naming what this verdict does NOT cover: behavior with no test, integration/production paths not exercised, assumptions not validated, which ACs were graded by inspection vs by running code. A "green" verdict that omits this is incomplete — green ≠ correct. The reviewer must answer: *if this passes, what could still be broken?*
   - **Next steps.**
2. **Ledger row** appended to your run ledger (a simple append-only markdown table of agent runs) so the run is auditable.
3. **Log path** for the wrapper's stdout/stderr.

## Procedure

1. **Parse inputs**, resolve defaults, validate that the target and AC source exist. If `--target` is a branch, `cd` to the repo and capture `git rev-parse HEAD` + `git branch --show-current` for the prompt.
2. **Pick the reviewer family** per the routing default (or `--reviewer`). Refuse a same-family review unless `--same-family-ok` is passed with a reason.
3. **Build the review prompt** from `prompt-template.txt` (XML-tag style — works for Codex, preferred for Claude). It embeds:
   - `<context>` — target path, AC source, builder family, repo root + HEAD/branch.
   - `<acceptance_criteria>` — the AC list **inlined** (read from `--ac` and `cat` it in; never "see the docs").
   - `<architecture>` — an `ARCHITECTURE.md` excerpt if the repo has one.
   - `<task>` — the literal review instructions (grade every AC, find P0/P1/P2 with `file:line`, propose fixes, do NOT mutate code, write one report).
   - `<verification>` — run any test/lint/build commands the AC references, paste results, only declare done when the report file exists and is non-empty.
   - `{{FAMILY_BLOCK}}` — the model-specific nudge:
     - Codex → `family-codex.txt` (`<output_contract>`, `<completeness_contract>`, `<verification_loop>`).
     - Claude Code → `family-claude.txt` (positive framing, `<persistence>`, permission-to-disagree, "what's missing?").
4. **Spawn the reviewer via your coding-agent wrapper, prompt piped on stdin** — never inline as a positional arg (shell quoting breaks long prompts):
   - Codex: `printf '%s' "$prompt" | run-codex.sh "$workdir"`
   - Claude Code: `printf '%s' "$prompt" | run-claude-code.sh "$workdir"`
   - Capture the PID and the log path.
5. **T+60s alive check.** If the reviewer process is dead within 60s, fall back to the other family **once**. If the second spawn also dies within 60s, fail loudly to the ledger row and the calling shell — do not retry indefinitely.
6. **Wait for completion**, then **verify the report exists** at `--output`.
7. **Sandbox artifact rescue (mandatory).** Some sandboxed coding agents write to a temp dir (e.g. `/tmp/` or `/private/tmp/...`) instead of the workspace path. Search the temp dir for a file whose basename matches the expected output OR contains the target slug + today's date. If found and `--output` is missing/empty, `cp` it into place and note the rescue in the ledger row + report header. **This step is non-optional** — skipping it silently produces a blank report at `--output` and a falsely "done" build.
8. **Append a ledger row**: time, label, review scope, reviewer family + model, PID/session, log path, expected output path, status (✅ done / ❌ failed / ⚠️ needs-rescue if a temp-dir copy was needed).
9. **Return** the report path + verdict + ledger row so the orchestrator can quote evidence.

## Stopping condition

- Stops the moment the report file exists at `--output` (after the rescue if needed) **and** the ledger row is appended.
- If the second-family fallback also dies within 60s, stop and fail loudly.
- If you use the same eval loop to improve *this skill*: stop after 3 iterations or <5% improvement between iterations. Do not rewrite forever.

## Example — Codex reviews a Claude Code build

Claude Code built a feature on branch `feat/voice-agent`. Acceptance criteria live in `docs/frd-012.md`.

```bash
cross-review \
  --target ~/dev/marketplace-api \
  --ac ~/dev/marketplace-api/docs/frd-012.md \
  --output reports/voice-agent-codex-review-2026-05-05.md \
  --builder claude \
  --reviewer codex
```

Flow: resolves reviewer = Codex → reads the AC + `ARCHITECTURE.md`, inlines the AC list → pipes the prompt to `run-codex.sh` via stdin → Codex writes to its sandbox temp dir → the rescue step copies it to the `reports/` path → appends a ledger row with status `⚠️ needs-rescue` → `✅ done`.

## Example — Claude Code reviews a Codex spec

Codex drafted an exec plan at `reports/x-execplan.md`. You want a different-family pass before the build.

```bash
cross-review \
  --target reports/x-execplan.md \
  --ac inline:"anti-spam heuristics specified; rate-limit math concrete; kill-switch surface enumerated; fixture coverage in test plan; prompt-injection guard on classification; approval-gate failure modes covered" \
  --output reports/x-execplan-claude-review.md \
  --builder codex \
  --reviewer claude
```

Flow: reviewer = Claude Code → inline AC embedded in `<acceptance_criteria>` → pipes to `run-claude-code.sh` → Claude writes directly to the workspace path (respects it, so the rescue finds nothing) → ledger row `✅ done`.

## Hard rules

- **Pipe prompts via stdin.** Never inline, never positional — long prompts break shell quoting and the reviewer never starts.
- **No code mutation by the reviewer.** Review is read-only by contract; the prompt forbids edits.
- **No external sends, no public posts.** The report stays local until the orchestrator decides to attach it to a ticket or PR.
- **Cross-family is required** unless the caller passes `--same-family-ok` with a reason. Same-family review is a degraded mode.
- **Every verdict names its blind spot.** The *Untested surface* section is mandatory. A loop that goes green is not a loop that is correct — it satisfied the verifier you gave it, and quality is capped by verifier quality. State what was NOT verified so the gap is visible, not silent.
- **The sandbox-temp-dir quirk is the skill's problem, not the caller's.** The rescue step is mandatory and worth a smoke test.

## Implementation notes

- Reviewer wrappers are the coding-agent launchers you already use (`run-codex.sh` / `run-claude-code.sh`); see the `coding-agent` skill. Do not reimplement them here.
- Keep the wrapper small (<150 lines) — most logic lives in the embedded prompt template (`prompt-template.txt`) and the two family blocks (`family-codex.txt`, `family-claude.txt`), all vended alongside this file.
- The "run ledger" is just an append-only markdown table of agent runs. Any equivalent audit log works.

## Failure modes to watch

1. **Sandbox writes to a temp dir and the rescue step is silently skipped** → blank report at `--output`, build falsely marked done. Mitigation: make the rescue mandatory + record it in the ledger row.
2. **Same-family review by accident** (Claude reviewing Claude). Mitigation: routing default + explicit `--same-family-ok` opt-in.
3. **Prompt inlined as a positional arg** → shell quoting breaks, reviewer never starts. Mitigation: always `printf '%s' "$prompt" | run-*.sh`.
4. **AC source not embedded inline** → the reviewer hallucinates the AC list and grades a different bar than the build was held to. Mitigation: `cat` the AC into the prompt; "see the docs" is forbidden.
5. **Ledger row appended to a stale date section** → audit confusion. Mitigation: create today's section if missing, use a local timestamp.
