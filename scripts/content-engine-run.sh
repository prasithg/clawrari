#!/usr/bin/env bash
set -euo pipefail

# Clawrari Content Engine — cron wrapper entrypoint (PRA-122)
# https://clawrari.com
#
# One command the weekly/monthly crons call. It chains three steps:
#   1. generate  — run scripts/content-engine.sh to write a dated draft
#   2. AWDS gate — run every draft through the AI-Writing Defense System
#                  (avoid-ai-writing v0.1) BEFORE any notification fires
#   3. notify    — post the AWDS-gated preview to Slack #prasclaw-content
#
# HARD RULES (baked in, not configurable):
#   - DRAFT ONLY. No external publish (X / LinkedIn / email / web). Ever.
#   - Slack #prasclaw-content is the ONLY destination. It is a draft preview +
#     human approval request, never an auto-publish. (Mirrors the Content
#     Morning Batch approval pattern: draft -> Slack preview -> human approves.)
#   - The AWDS gate runs before the Slack post. If the gate cannot run, we do
#     NOT post — the gate is mandatory, not best-effort.
#   - Idempotent: if a draft for the period already exists we skip generation
#     and skip the Slack post (no double-posting), unless --force is passed.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ──────────────────────────────────────────────
# Fixed config (the standing automation exception only covers THIS channel)
# ──────────────────────────────────────────────
SLACK_CHANNEL="slack"
SLACK_TARGET="C0B1BENB3EC"          # #prasclaw-content
OUTPUT_DIR="docs/content-engine/drafts"

# AWDS detector lives in the OpenClaw workspace (outside this repo). Override
# with AWDS_DETECT=/path/to/awds-detect.mjs if your checkout differs.
AWDS_DETECT="${AWDS_DETECT:-$HOME/.openclaw/workspace/scripts/awds-detect.mjs}"

# ──────────────────────────────────────────────
# Colors (suppressed when not a TTY)
# ──────────────────────────────────────────────
if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi
log()  { echo -e "${CYAN}$*${NC}" >&2; }
ok()   { echo -e "  ${GREEN}✓${NC} $*" >&2; }
warn() { echo -e "${YELLOW}$*${NC}" >&2; }
die()  { echo -e "${RED}error:${NC} $*" >&2; exit 1; }

# ──────────────────────────────────────────────
# Args
# ──────────────────────────────────────────────
MODE=""
FORCE="false"
NOTIFY="true"
AS_OF="$(date +%Y-%m-%d)"

usage() {
  cat >&2 <<EOF
${BOLD}Clawrari Content Engine — cron wrapper${NC}

Generates a dated draft, runs it through the AWDS gate, and posts an
AWDS-gated preview to Slack #prasclaw-content. Draft-only. No external publish.

${BOLD}Usage:${NC}
  scripts/content-engine-run.sh --weekly   [options]
  scripts/content-engine-run.sh --monthly  [options]

${BOLD}Options:${NC}
  --weekly | --monthly   Which draft to run (required)
  --as-of <YYYY-MM-DD>   Treat this date as "today" (default: today)
  --no-notify            Run generate + AWDS gate but skip the Slack post
                         (local testing; the gate still runs)
  --force                Regenerate + re-post even if the draft already exists,
                         and bypass the monthly last-Friday guard
  -h, --help             Show this help

${BOLD}Notes:${NC}
  - Monthly self-gates to the LAST Friday of the month. The monthly cron fires
    every Friday; on non-last Fridays this is a no-op (exit 0) unless --force.
  - AWDS detector path: \$AWDS_DETECT (default ~/.openclaw/workspace/scripts/awds-detect.mjs)
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --weekly)    MODE="weekly"; shift ;;
    --monthly)   MODE="monthly"; shift ;;
    --as-of)     AS_OF="${2:-}"; shift 2 ;;
    --no-notify) NOTIFY="false"; shift ;;
    --force)     FORCE="true"; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)           die "unknown argument: $1 (try --help)" ;;
  esac
done

[ -n "$MODE" ] || { usage; die "--weekly or --monthly is required"; }
command -v node >/dev/null 2>&1 || die "node is required for the AWDS gate but was not found in PATH"

# ──────────────────────────────────────────────
# Date helpers (portable: BSD/macOS and GNU date)
# ──────────────────────────────────────────────
dow() { # ISO day-of-week (1=Mon..7=Sun) for a YYYY-MM-DD
  local d="$1"
  if date -j >/dev/null 2>&1; then
    date -j -f "%Y-%m-%d" "$d" +%u
  else
    date -d "$d" +%u
  fi
}
plus_days_ym() { # YYYY-MM of (date + N days)
  local d="$1" n="$2"
  if date -j >/dev/null 2>&1; then
    date -j -v+"${n}"d -f "%Y-%m-%d" "$d" +%Y-%m
  else
    date -d "$d + $n days" +%Y-%m
  fi
}

is_last_friday() { # 0 (true) if $AS_OF is the last Friday of its month
  local d="$1"
  [ "$(dow "$d")" = "5" ] || return 1
  # A Friday is the last one of its month iff the next Friday is in a new month.
  [ "$(plus_days_ym "$d" 7)" != "${d:0:7}" ]
}

# ──────────────────────────────────────────────
# Monthly last-Friday guard
# ──────────────────────────────────────────────
if [ "$MODE" = "monthly" ] && [ "$FORCE" != "true" ]; then
  if ! is_last_friday "$AS_OF"; then
    log "Monthly run is a no-op: $AS_OF is not the last Friday of the month."
    log "(The monthly cron fires every Friday; it only acts on the last one. Use --force to override.)"
    exit 0
  fi
fi

# ──────────────────────────────────────────────
# Resolve the period draft path (must match scripts/content-engine.sh)
# ──────────────────────────────────────────────
if [ "$MODE" = "weekly" ]; then
  PERIOD_LABEL="$AS_OF"
  DRAFT_PATH="$REPO_ROOT/$OUTPUT_DIR/${AS_OF}-weekly.md"
else
  PERIOD_LABEL="${AS_OF:0:7}"
  DRAFT_PATH="$REPO_ROOT/$OUTPUT_DIR/${AS_OF:0:7}-monthly.md"
fi
DRAFT_REL="${DRAFT_PATH#"$REPO_ROOT"/}"
PIECE_ID="$(basename "$DRAFT_PATH" .md)"

# ──────────────────────────────────────────────
# Idempotency: existing draft -> skip (no double-post)
# ──────────────────────────────────────────────
if [ -f "$DRAFT_PATH" ] && [ "$FORCE" != "true" ]; then
  warn "Draft already exists for this period: $DRAFT_REL"
  warn "Skipping generation and Slack post (idempotent). Use --force to regenerate + re-post."
  echo "$DRAFT_PATH"
  exit 0
fi

# ──────────────────────────────────────────────
# Step 1 — generate the draft
# ──────────────────────────────────────────────
log "[1/3] Generating $MODE draft (as-of $AS_OF)…"
GEN_PATH="$("$SCRIPT_DIR/content-engine.sh" --mode "$MODE" --as-of "$AS_OF" --output-dir "$OUTPUT_DIR" | tail -n1)"
[ -f "$GEN_PATH" ] || die "generator did not produce a draft file (got: '$GEN_PATH')"
ok "Draft written: ${GEN_PATH#"$REPO_ROOT"/}"

# ──────────────────────────────────────────────
# Step 2 — AWDS gate (mandatory, before any notification)
# ──────────────────────────────────────────────
log "[2/3] Running AWDS v0.1 gate…"
[ -f "$AWDS_DETECT" ] || die "AWDS detector not found at: $AWDS_DETECT (set AWDS_DETECT). Gate is mandatory — refusing to notify."

GATE_JSON="${GEN_PATH%.md}.awds.json"
PIECE_TMP="$(mktemp -t awds-piece.XXXXXX)"
trap 'rm -f "$PIECE_TMP"' EXIT

# Build the piece JSON via node so draft content (backticks, $, quotes) is never
# shell-interpolated.
node -e 'const fs=require("fs");fs.writeFileSync(process.argv[2],JSON.stringify({piece_id:process.argv[3],original_text:fs.readFileSync(process.argv[1],"utf8")}))' \
  "$GEN_PATH" "$PIECE_TMP" "$PIECE_ID"

node "$AWDS_DETECT" --json "$PIECE_TMP" --out "$GATE_JSON" \
  || die "AWDS detector failed to run. Gate is mandatory — refusing to notify."

VERDICT="$(node -e 'const j=require(process.argv[1]);console.log(j.verdict)' "$GATE_JSON")"
P0="$(node -e 'const j=require(process.argv[1]);console.log(j.flags.filter(f=>f.severity==="P0").length)' "$GATE_JSON")"
P1="$(node -e 'const j=require(process.argv[1]);console.log(j.flags.filter(f=>f.severity==="P1").length)' "$GATE_JSON")"
CATS="$(node -e 'const j=require(process.argv[1]);console.log((j.categories_touched||[]).join(", ")||"none")' "$GATE_JSON")"
FLAG_IDS="$(node -e 'const j=require(process.argv[1]);console.log([...new Set(j.flags.map(f=>f.id))].join(", ")||"none")' "$GATE_JSON")"
ok "AWDS verdict: $VERDICT (P0:$P0 P1:$P1 | categories: $CATS)"
log "AWDS gate artifact: ${GATE_JSON#"$REPO_ROOT"/}"

# ──────────────────────────────────────────────
# Step 3 — Slack preview (draft-only, approval gate)
# ──────────────────────────────────────────────
if [ "$MODE" = "weekly" ]; then PRETTY="Weekly build-in-public"; else PRETTY="Monthly retro"; fi

SLACK_MSG="$(cat <<EOF
:memo: Clawrari content draft ready for review — ${PRETTY}
Period: ${PERIOD_LABEL}
Draft: ${DRAFT_REL}

AWDS v0.1 gate: ${VERDICT}  (P0:${P0} P1:${P1} | categories: ${CATS})
Flagged: ${FLAG_IDS}
Note: this is a pre-edit review draft (markdown headings/bold + <placeholders>),
so v2 markdown-format flags are expected. The signal to fix before publishing is
the v1 (lexical) and v3 (structural) tells. Full gate JSON: ${GATE_JSON#"$REPO_ROOT"/}

DRAFT ONLY. Nothing was published. No external post to X / LinkedIn / email.
To approve: open the file, edit against the template voice guardrails, then
publish manually. Reply here to approve or request changes.
EOF
)"

if [ "$NOTIFY" != "true" ]; then
  warn "[3/3] --no-notify set: skipping Slack post. Preview that WOULD post:"
  printf '%s\n' "$SLACK_MSG" >&2
  echo "$GEN_PATH"
  exit 0
fi

log "[3/3] Posting AWDS-gated preview to Slack #prasclaw-content…"
openclaw message send --channel "$SLACK_CHANNEL" --target "$SLACK_TARGET" -m "$SLACK_MSG" \
  || die "Slack post failed. Draft + gate artifact are on disk; re-run with --force to retry the post."
ok "Posted draft preview to Slack (#prasclaw-content)."

log "Done. Draft-only run complete. No external publish."
echo "$GEN_PATH"
