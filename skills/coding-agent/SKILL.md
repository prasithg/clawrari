# coding-agent — delegate coding to Codex / Claude Code (bash-first)

**Status:** v0.1 — vended in full. Copy it, point it at your CLIs, make it yours.

## The one-line idea

Meaty implementation work belongs to a coding agent (Codex or Claude Code), driven from **bash** with optional background mode — not hand-authored patch-by-patch in your main session. This skill is the launch surface: how to spawn each agent correctly, when to delegate vs stay inline, and how to keep a human in the loop while the agent runs.

> **Repo conventions:** if you keep a canonical branch/commit/PR conventions doc for a project, tell the delegated agent to *read that file* rather than spelling out naming rules in the prompt. Keeps prompts short and the conventions in one place.

## Routing decision — delegate or declare (READ FIRST)

The naive rule is size-based ("one-liner → just edit; big build → delegate"). That rule quietly fails: interactive **ops / config / scripting / docs** work never trips a size threshold, so it never delegates, and a whole session drifts into hours of inline straight-model editing. This is the drift guardrail.

**Cumulative in-session trigger — mechanical, not a judgment call.** During any interactive session, keep a running count of your own code-bearing mutations (edits/writes against a real repo, script, or config file, and multi-file changes). When you cross **any** line below, STOP and run the checkpoint:

- **≥3 code/script/config edits** against real files this session, OR
- **≥2 multi-file changes** (one logical change touching 2+ files), OR
- you are about to hand-author a **new script/module** more than trivially long, OR
- you hand-wrote and re-ran a script that **failed a second time** (that's the signal a real editor + run-loop would already have caught it).

**Checkpoint (say it in one line, then act):**

> "This has become a build slice (N inline edits). Delegating to <Codex|Claude Code> in a worktree with a test loop" — OR — "Keeping this inline because <specific reason: single obvious edit / config flip / faster here and no test loop needed>."

Bias toward delegating when the work has any of: file exploration, a test/lint/build loop, more than ~30 lines of new code, or repetition across files. Bias toward inline only for a genuinely bounded single edit, a config value flip, or reading.

**Why declare instead of silently continue:** the point is a *visible* decision, not a hard block. A conscious "keeping inline because X" is fine and auditable; silent drift is the failure. Don't retro-delegate work that's already essentially done — apply the trigger to the *next* slice.

This trigger does not apply to: automated overnight/cron lanes (they already delegate by design — see `night-work`), pure investigation/read passes, or note-writing that isn't code.

## ⚠️ Execution mode: Codex needs PTY, Claude Code doesn't

For **Codex**, PTY is required (it's an interactive terminal app):

```bash
# ✅ Correct for Codex
exec pty:true command:"codex exec 'Your prompt'"
```

For **Claude Code** (`claude` CLI), use `--print --permission-mode bypassPermissions` instead. `--print` keeps full tool access and avoids interactive confirmation:

```bash
# ✅ Correct for Claude Code (no PTY needed)
cd /path/to/project && claude --permission-mode bypassPermissions --print 'Your task'

# For background execution: use background:true on the exec tool

# ❌ Wrong for Claude Code
exec pty:true command:"claude --dangerously-skip-permissions 'task'"
```

### Exec tool parameters

| Parameter    | Type    | Description                                                            |
| ------------ | ------- | --------------------------------------------------------------------- |
| `command`    | string  | The shell command to run                                              |
| `pty`        | boolean | **Use for Codex.** Allocates a pseudo-terminal for interactive CLIs   |
| `workdir`    | string  | Working directory (the agent sees only this folder's context)         |
| `background` | boolean | Run in background, returns a sessionId for monitoring                 |
| `timeout`    | number  | Timeout in seconds (kills the process on expiry)                     |

### Process tool actions (for background sessions)

| Action      | Description                                          |
| ----------- | ---------------------------------------------------- |
| `list`      | List running/recent sessions                          |
| `poll`      | Check if a session is still running                   |
| `log`       | Get session output (with optional offset/limit)       |
| `write`     | Send raw data to stdin                               |
| `submit`    | Send data + newline (like typing and pressing Enter) |
| `kill`      | Terminate the session                                 |

---

## Quick start: one-shot tasks

```bash
# Quick chat (Codex needs a git repo!)
SCRATCH=$(mktemp -d) && cd $SCRATCH && git init && codex exec "Your prompt here"

# In a real project — with PTY
exec pty:true workdir:~/projects/myproject command:"codex exec 'Add error handling to the API calls'"
```

**Why `git init`?** Codex refuses to run outside a trusted git directory. A temp repo solves this for scratch work.

## The pattern: workdir + background + pty

```bash
# Start in the target directory (with PTY)
exec pty:true workdir:~/project background:true command:"codex exec --full-auto 'Build a snake game'"
# Returns a sessionId

process action:log sessionId:XXX     # monitor progress
process action:poll sessionId:XXX    # check if done
process action:submit sessionId:XXX data:"yes"   # answer a prompt (data + Enter)
process action:kill sessionId:XXX    # kill if needed
```

**Why workdir matters:** the agent wakes up in a focused directory and doesn't wander off reading unrelated files.

---

## Codex CLI

**Model:** whatever you've set in `~/.codex/config.toml` (a strong coding model at high reasoning is the usual choice).

| Flag            | Effect                                             |
| --------------- | -------------------------------------------------- |
| `exec "prompt"` | One-shot execution, exits when done                |
| `--full-auto`   | Sandboxed but auto-approves in the workspace       |
| `--yolo`        | NO sandbox, NO approvals (fastest, most dangerous) |

```bash
# Quick one-shot (auto-approves) — remember PTY
exec pty:true workdir:~/project command:"codex exec --full-auto 'Build a dark mode toggle'"

# Background for longer work
exec pty:true workdir:~/project background:true command:"codex --yolo 'Refactor the auth module'"
```

### Reviewing PRs

**⚠️ Never review PRs inside your agent's own state/workspace directory.** Clone to a temp folder or use a git worktree.

```bash
# Clone to temp for safe review
REVIEW_DIR=$(mktemp -d)
git clone https://github.com/user/repo.git $REVIEW_DIR
cd $REVIEW_DIR && gh pr checkout 130
exec pty:true workdir:$REVIEW_DIR command:"codex review --base origin/main"

# Or a git worktree (keeps main intact)
git worktree add /tmp/pr-130-review pr-130-branch
exec pty:true workdir:/tmp/pr-130-review command:"codex review --base main"
```

### Batch PR reviews (parallel)

```bash
git fetch origin '+refs/pull/*/head:refs/remotes/origin/pr/*'
exec pty:true workdir:~/project background:true command:"codex exec 'Review PR #86. git diff origin/main...origin/pr/86'"
exec pty:true workdir:~/project background:true command:"codex exec 'Review PR #87. git diff origin/main...origin/pr/87'"
process action:list
gh pr comment <PR#> --body "<review content>"
```

---

## Claude Code

**Model:** whatever you've set in `~/.claude/settings.json`.

```bash
# Foreground
exec workdir:~/project command:"claude --permission-mode bypassPermissions --print 'Your task'"

# Background
exec workdir:~/project background:true command:"claude --permission-mode bypassPermissions --print 'Your task'"
```

**Wrapper script (recommended for overnight work — handles API-key conflicts):**

```bash
echo "Your task" | ~/scripts/run-claude-code.sh ~/project
```

A thin wrapper around each CLI (`run-claude-code.sh`, `run-codex.sh`) is worth keeping: it handles API-key conflicts, shell quoting, `git init` for scratch, and completion notification in one place. `cross-review` and `night-work` both call these wrappers instead of the CLIs directly.

---

## Parallel issue fixing with git worktrees

```bash
git worktree add -b fix/issue-78 /tmp/issue-78 main
git worktree add -b fix/issue-99 /tmp/issue-99 main

exec pty:true workdir:/tmp/issue-78 background:true command:"pnpm install && codex --yolo 'Fix issue #78: <description>. Commit and push.'"
exec pty:true workdir:/tmp/issue-99 background:true command:"pnpm install && codex --yolo 'Fix issue #99 from the approved ticket summary. Implement only in-scope edits and commit after review.'"

process action:list
cd /tmp/issue-78 && git push -u origin fix/issue-78
gh pr create --repo user/repo --head fix/issue-78 --title "fix: ..." --body "..."
git worktree remove /tmp/issue-78
```

---

## ⚠️ Rules

1. **Right execution mode per agent:** Codex → `pty:true`; Claude Code → `--print --permission-mode bypassPermissions` (no PTY).
2. **Respect tool choice.** If the user asks for Codex, use Codex. In orchestrator mode, do NOT hand-code patches yourself — if an agent fails/hangs, respawn it or ask for direction, don't silently take over.
3. **Be patient.** Don't kill sessions just because they're "slow."
4. **Monitor with `process action:log`** — check progress without interfering.
5. `--full-auto` for building; vanilla for reviewing.
6. **Parallel is fine** — run many Codex processes at once for batch work.
7. **NEVER start a coding agent inside your agent's own state directory** — it'll read your operating/soul docs and get strange ideas about the org chart.
8. **NEVER checkout branches in your live agent-runtime repo** — that's the running instance.
9. **Honor the cumulative routing trigger** at the top — delegate-or-declare once you cross the edit thresholds; silent inline drift is the failure mode this skill exists to prevent.

---

## Progress updates (critical)

When you spawn coding agents in the background, keep the user in the loop:

- Send 1 short message when you start (what's running + where).
- Then update only when something changes: a milestone completes, the agent asks a question, you hit an error, or the agent finishes (include what changed + where).
- If you kill a session, immediately say you killed it and why.

This prevents the user from seeing only "Agent failed before reply" with no idea what happened.

## Auto-notify on completion

For long background tasks, append a wake trigger so your harness is notified the moment the agent finishes instead of waiting for the next heartbeat:

```
... your task here.

When completely finished, run this command to notify me:
openclaw system event --text "Done: [brief summary of what was built]" --mode now
```

## Learnings

- **PTY is essential for Codex.** Without `pty:true`, output breaks or the agent hangs.
- **Git repo required for Codex.** Use `mktemp -d && git init` for scratch work.
- **`exec` is your friend.** `codex exec "prompt"` runs and exits cleanly — perfect for one-shots.
- **`submit` vs `write`:** `submit` sends input + Enter; `write` sends raw data without a newline.
- **Wrapper scripts preferred for overnight work.** They centralize API-key handling, shell quoting, `git init`, and completion notification. Always pipe prompts through them for background tasks.
- **Claude Code auth:** unset `ANTHROPIC_API_KEY` to use plan-based OAuth; the wrapper handles this.
- **Inline drift is real.** Interactive ops/config sessions default to hand-editing and rarely trip a size threshold — that's why the cumulative trigger is mechanical. If you hand-author a script and it fails twice, that IS the trigger.
