#!/usr/bin/env bash
# night-work-pipeline.sh — generic night-work scaffold for Clawrari.
#
# Runs one task through four stages: plan -> build -> test -> completion-sweep.
# Each stage is a hook script you provide. The pipeline's job is ordering, logging,
# and safety valves, not the work itself. Nothing here is project-specific.
#
# Stage hooks (all optional; a missing hook is treated as a no-op PASS):
#   <stage-dir>/plan.sh        — produce a plan; write success criteria somewhere durable
#   <stage-dir>/build.sh       — do the work
#   <stage-dir>/test.sh        — run the narrowest meaningful test/lint/build gate
#   <stage-dir>/sweep.sh       — completion sweep: verify the work is actually finished
#
# Each hook gets these env vars: NW_TASK, NW_LOG, NW_LEDGER, NW_STAGE.
# A hook signals failure with a non-zero exit code.
#
# Logging: appends to a daily log and an append-only ledger so a stalled or failed
# run is visible at the next session start (see docs/components/memory.md).
#
# Usage:
#   night-work-pipeline.sh --task "TASK-12 port memory docs" --stage-dir ./stages
#   night-work-pipeline.sh --task "..." --stage-dir ./stages --dry-run
#   night-work-pipeline.sh --selftest
#
# Env overrides:
#   NW_WORKSPACE   default: current directory
#   NW_LOG         default: $NW_WORKSPACE/memory/$(date +%F).md
#   NW_LEDGER      default: $NW_WORKSPACE/memory/subagent-ledger.md
#   NW_MAX_FAILS   default: 1   (consecutive stage failures before aborting)
set -euo pipefail

WORKSPACE="${NW_WORKSPACE:-$(pwd)}"
TASK=""
STAGE_DIR=""
DRY_RUN=0
SELFTEST=0
MAX_FAILS="${NW_MAX_FAILS:-1}"

while [ $# -gt 0 ]; do
  case "$1" in
    --task)      TASK="${2:-}"; shift 2 ;;
    --stage-dir) STAGE_DIR="${2:-}"; shift 2 ;;
    --dry-run)   DRY_RUN=1; shift ;;
    --selftest)  SELFTEST=1; shift ;;
    -h|--help)   grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

LOG="${NW_LOG:-$WORKSPACE/memory/$(date +%F).md}"
LEDGER="${NW_LEDGER:-$WORKSPACE/memory/subagent-ledger.md}"
STAGES=(plan build test sweep)

ts() { date "+%Y-%m-%d %H:%M:%S"; }

log_line() {
  # log_line "<message>"
  mkdir -p "$(dirname "$LOG")"
  printf '%s — %s\n' "$(ts)" "$1" >> "$LOG"
}

ledger_row() {
  # ledger_row "<status>" "<note>"
  mkdir -p "$(dirname "$LEDGER")"
  if [ ! -f "$LEDGER" ]; then
    {
      echo "# Subagent Ledger"
      echo
      echo "| Date | Label | Task | Status | Note |"
      echo "|------|-------|------|--------|------|"
    } >> "$LEDGER"
  fi
  printf '| %s | night-work-pipeline | %s | %s | %s |\n' \
    "$(ts)" "${TASK//|/\\|}" "$1" "${2//|/\\|}" >> "$LEDGER"
}

run_stage() {
  # run_stage <stage-name>
  local stage="$1"
  local hook="$STAGE_DIR/$stage.sh"
  export NW_TASK="$TASK" NW_LOG="$LOG" NW_LEDGER="$LEDGER" NW_STAGE="$stage"

  if [ ! -f "$hook" ]; then
    log_line "stage=$stage SKIP (no hook at $hook)"
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    log_line "stage=$stage DRY-RUN (would run $hook)"
    return 0
  fi

  log_line "stage=$stage START"
  if bash "$hook"; then
    log_line "stage=$stage PASS"
    return 0
  fi
  log_line "stage=$stage FAIL (exit $?)"
  return 1
}

pipeline() {
  [ -n "$TASK" ] || { echo "--task is required" >&2; exit 2; }
  [ -n "$STAGE_DIR" ] || { echo "--stage-dir is required" >&2; exit 2; }

  log_line "=== night-work-pipeline START task='$TASK' ==="
  ledger_row "running" "pipeline started"

  local fails=0
  for stage in "${STAGES[@]}"; do
    if ! run_stage "$stage"; then
      fails=$((fails + 1))
      if [ "$fails" -ge "$MAX_FAILS" ]; then
        log_line "=== ABORT after $fails failure(s) at stage=$stage ==="
        ledger_row "failed" "aborted at stage=$stage"
        exit 1
      fi
    fi
  done

  log_line "=== night-work-pipeline DONE task='$TASK' ==="
  ledger_row "done" "all stages passed"
}

selftest() {
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  mkdir -p "$tmp/stages" "$tmp/memory"
  echo 'exit 0' > "$tmp/stages/plan.sh"
  echo 'exit 0' > "$tmp/stages/build.sh"
  echo 'exit 0' > "$tmp/stages/test.sh"
  echo 'exit 0' > "$tmp/stages/sweep.sh"

  NW_WORKSPACE="$tmp" NW_LOG="$tmp/memory/log.md" NW_LEDGER="$tmp/memory/ledger.md" \
    bash "$0" --task "selftest task" --stage-dir "$tmp/stages" >/dev/null

  grep -q "all stages passed" "$tmp/memory/ledger.md" || { echo "FAIL: ledger missing done row"; exit 1; }
  grep -q "pipeline DONE" "$tmp/memory/log.md" || { echo "FAIL: log missing done line"; exit 1; }

  # failing stage should abort and write a failed row
  echo 'exit 1' > "$tmp/stages/build.sh"
  if NW_WORKSPACE="$tmp" NW_LOG="$tmp/memory/log2.md" NW_LEDGER="$tmp/memory/ledger2.md" \
      bash "$0" --task "fail task" --stage-dir "$tmp/stages" >/dev/null 2>&1; then
    echo "FAIL: pipeline should have aborted on failing build stage"; exit 1
  fi
  grep -q "aborted at stage=build" "$tmp/memory/ledger2.md" || { echo "FAIL: missing abort row"; exit 1; }

  echo "selftest OK"
}

if [ "$SELFTEST" -eq 1 ]; then
  selftest
else
  pipeline
fi
