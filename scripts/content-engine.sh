#!/usr/bin/env bash
set -euo pipefail

# Clawrari Content Engine — draft generator
# https://clawrari.com
#
# Turns recent repo activity (git commits + CHANGELOG) into reviewable content
# drafts. Produces a WEEKLY content pack or a MONTHLY rollup as markdown files.
#
# DRAFT-ONLY BY DESIGN. This script never sends, posts, or makes network calls.
# It only reads git history / files and writes markdown into the output dir.
# Drafts go through the human review gate before anything is published.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT_DEFAULT="$(cd "$SCRIPT_DIR/.." && pwd)"

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
# Defaults (overridable by config file then CLI flags)
# ──────────────────────────────────────────────
MODE=""
WINDOW_DAYS=""
OUTPUT_DIR="drafts"
REPO_ROOT="$REPO_ROOT_DEFAULT"
AS_OF="$(date +%Y-%m-%d)"
CONFIG_FILE=""
DRY_RUN="false"

usage() {
  cat >&2 <<EOF
${BOLD}Clawrari Content Engine — draft generator${NC}

Generates a weekly or monthly content draft from recent repo activity
(git commits + CHANGELOG). Draft-only: never posts or makes network calls.

${BOLD}Usage:${NC}
  scripts/content-engine.sh --mode weekly  [options]
  scripts/content-engine.sh --mode monthly [options]
  scripts/content-engine.sh --weekly                 # shorthand
  scripts/content-engine.sh --monthly                # shorthand

${BOLD}Options:${NC}
  --mode <weekly|monthly>   Which draft to generate (required unless shorthand)
  --weekly | --monthly      Shorthand for --mode
  --window <days>           Lookback window in days (default: weekly=7, monthly=30)
  --output-dir <dir>        Where drafts are written (default: drafts)
  --repo <path>             Repo to read history from (default: repo root)
  --as-of <YYYY-MM-DD>      Treat this date as "today" (default: today)
  --config <file>           Load defaults from a config file (shell-sourced)
  --dry-run                 Print the draft to stdout; write nothing
  -h, --help                Show this help

${BOLD}Examples:${NC}
  scripts/content-engine.sh --weekly
  scripts/content-engine.sh --monthly --output-dir drafts
  scripts/content-engine.sh --mode weekly --window 14 --dry-run
EOF
}

# ──────────────────────────────────────────────
# Parse args — first pass only to find --config
# ──────────────────────────────────────────────
args=("$@")
for ((i=0; i<${#args[@]}; i++)); do
  if [ "${args[$i]}" = "--config" ]; then
    CONFIG_FILE="${args[$((i+1))]:-}"
  fi
done

# Auto-discover a config file if none was passed.
if [ -z "$CONFIG_FILE" ]; then
  for candidate in \
    "$REPO_ROOT_DEFAULT/config/content-engine.conf" \
    "$SCRIPT_DIR/content-engine.conf"; do
    if [ -f "$candidate" ]; then CONFIG_FILE="$candidate"; break; fi
  done
fi

if [ -n "$CONFIG_FILE" ]; then
  [ -f "$CONFIG_FILE" ] || die "config file not found: $CONFIG_FILE"
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
  log "Loaded config: $CONFIG_FILE"
fi

# ──────────────────────────────────────────────
# Parse args — real pass (CLI overrides config)
# ──────────────────────────────────────────────
while [ $# -gt 0 ]; do
  case "$1" in
    --mode)       MODE="${2:-}"; shift 2 ;;
    --weekly)     MODE="weekly"; shift ;;
    --monthly)    MODE="monthly"; shift ;;
    --window)     WINDOW_DAYS="${2:-}"; shift 2 ;;
    --output-dir) OUTPUT_DIR="${2:-}"; shift 2 ;;
    --repo)       REPO_ROOT="${2:-}"; shift 2 ;;
    --as-of)      AS_OF="${2:-}"; shift 2 ;;
    --config)     shift 2 ;;  # already handled
    --dry-run)    DRY_RUN="true"; shift ;;
    -h|--help)    usage; exit 0 ;;
    *)            die "unknown argument: $1 (try --help)" ;;
  esac
done

[ -n "$MODE" ] || { usage; die "--mode is required (weekly or monthly)"; }
case "$MODE" in
  weekly|monthly) ;;
  *) die "--mode must be 'weekly' or 'monthly', got: $MODE" ;;
esac

# Mode-driven defaults for the lookback window.
if [ -z "$WINDOW_DAYS" ]; then
  if [ "$MODE" = "weekly" ]; then WINDOW_DAYS=7; else WINDOW_DAYS=30; fi
fi
[[ "$WINDOW_DAYS" =~ ^[0-9]+$ ]] || die "--window must be an integer, got: $WINDOW_DAYS"

[ -d "$REPO_ROOT/.git" ] || git -C "$REPO_ROOT" rev-parse --git-dir >/dev/null 2>&1 \
  || die "not a git repo: $REPO_ROOT"
command -v git >/dev/null 2>&1 || die "git is required but not found in PATH"

# ──────────────────────────────────────────────
# Date math (portable: BSD/macOS date and GNU date)
# ──────────────────────────────────────────────
date_minus_days() {
  local base="$1" days="$2"
  if date -j >/dev/null 2>&1; then
    date -j -v-"${days}"d -f "%Y-%m-%d" "$base" +%Y-%m-%d 2>/dev/null
  else
    date -d "$base - $days days" +%Y-%m-%d
  fi
}

SINCE="$(date_minus_days "$AS_OF" "$WINDOW_DAYS")"
UNTIL="$AS_OF"

log "Mode: $MODE | window: ${WINDOW_DAYS}d | range: $SINCE .. $UNTIL | repo: $REPO_ROOT"

# ──────────────────────────────────────────────
# Gather commits in the window
# ──────────────────────────────────────────────
# Use a unit-separator so subjects with pipes don't break parsing.
US=$'\037'
COMMIT_LINES="$(git -C "$REPO_ROOT" log \
  --since="$SINCE 00:00:00" --until="$UNTIL 23:59:59" \
  --no-merges \
  --pretty=format:"%h${US}%s${US}%an${US}%ad" --date=short 2>/dev/null || true)"

COMMIT_COUNT=0
if [ -n "$COMMIT_LINES" ]; then
  COMMIT_COUNT="$(printf '%s\n' "$COMMIT_LINES" | grep -c . || true)"
fi

# Contributors
CONTRIBUTORS="—"
if [ -n "$COMMIT_LINES" ]; then
  CONTRIBUTORS="$(printf '%s\n' "$COMMIT_LINES" | awk -F"$US" '{print $3}' \
    | sort -u | paste -sd ', ' - )"
fi

# Group commits by conventional type prefix (text before the first ':').
# Returns the grouped markdown on stdout.
group_commits() {
  [ -n "$COMMIT_LINES" ] || { echo "_No commits in this window._"; return; }

  printf '%s\n' "$COMMIT_LINES" | awk -F"$US" '
    {
      subj=$2; hash=$1
      type="other"; desc=subj
      # Match "type:" or "type(scope):"
      if (match(subj, /^[a-zA-Z]+(\([^)]*\))?:[ ]*/)) {
        head=substr(subj, 1, RLENGTH)
        desc=substr(subj, RLENGTH+1)
        # extract the bare type word
        t=head
        sub(/[:(].*$/, "", t)
        type=tolower(t)
      }
      # bucket synonyms
      label=type
      if (type=="feat") label="Features"
      else if (type=="fix") label="Fixes"
      else if (type=="docs") label="Docs"
      else if (type=="refactor") label="Refactors"
      else if (type=="perf") label="Performance"
      else if (type=="test") label="Tests"
      else if (type=="chore") label="Chores"
      else if (type=="style") label="Style"
      else if (type=="site") label="Site / Landing"
      else if (type=="roadmap") label="Roadmap"
      else label="Other"

      key=label
      lines[key]=lines[key] sprintf("- %s `%s`\n", desc, hash)
      seen[key]=1
    }
    END {
      # stable, meaningful ordering over a fixed label list
      m=0
      labels[++m]="Features"; labels[++m]="Fixes"; labels[++m]="Performance"
      labels[++m]="Refactors"; labels[++m]="Docs"; labels[++m]="Site / Landing"
      labels[++m]="Roadmap"; labels[++m]="Tests"; labels[++m]="Chores"
      labels[++m]="Style"; labels[++m]="Other"
      for (i=1;i<=m;i++) {
        L=labels[i]
        if (seen[L]) {
          printf "### %s\n%s\n", L, lines[L]
        }
      }
    }
  '
}

# Top N most recent commit subjects (cleaned), for hooks/threads.
recent_subjects() {
  local n="$1"
  [ -n "$COMMIT_LINES" ] || return 0
  printf '%s\n' "$COMMIT_LINES" | awk -F"$US" '{print $2}' | head -n "$n"
}

# Pull the top (most recent) section of the CHANGELOG, if present.
changelog_head() {
  local cl="$REPO_ROOT/CHANGELOG.md"
  [ -f "$cl" ] || { echo "_No CHANGELOG.md found._"; return; }
  # Print from the first heading up to (but not including) the 2nd '## ' heading.
  awk '
    /^## / { sections++ }
    sections>=2 { exit }
    /^# [^#]/ { next }   # skip the top-level "# Changelog" title
    { print }
  ' "$cl"
}

GROUPED="$(group_commits)"
CHANGELOG_TOP="$(changelog_head)"

# ──────────────────────────────────────────────
# Render drafts
# ──────────────────────────────────────────────
render_weekly() {
  local hook_items
  hook_items="$(recent_subjects 3 | sed 's/^/- /')"
  [ -n "$hook_items" ] || hook_items="- (no commits this week — pull from notes/CHANGELOG)"

  cat <<EOF
# Weekly Content Pack — Week of $UNTIL

> **DRAFT ONLY — do not publish.** Generated by \`scripts/content-engine.sh\`
> on $AS_OF from $COMMIT_COUNT commit(s) in $SINCE .. $UNTIL.
> Review before posting. Strip \`[epistemic]\` tags before publishing.
> Nothing here is sent anywhere automatically — this is a review artifact.

## What Shipped This Week

$GROUPED

## Weekly Thesis

<!-- One sentence: what theme connected this week's work? Edit before posting. -->
_Draft prompt: what's the throughline across the shipped items above?_

## LinkedIn Draft

**Bucket:** <pick a bucket>
**Source/trigger:** this week's shipped work

Here's what shipped this week and the one decision behind it:

$hook_items

The part worth talking about: <add the non-obvious tradeoff or lesson>. [inferred]

Question for others: <open question>

## X / Twitter Drafts

$(recent_subjects 5 | awk '{printf "%d. Shipped: %s — <sharpen into a standalone take>\n", NR, $0}' || true)

## Blog / Long-Form Candidates

- <which shipped item deserves a deeper writeup, and why>

## Quality Review

- Strongest draft:
- Weakest draft:
- Claims to verify (mark anything not \`[observed]\` or \`[consensus]\`):
- Suggested next experiment:

---

## Source Data (do not publish)

- Window: $SINCE .. $UNTIL (${WINDOW_DAYS} days)
- Commits: $COMMIT_COUNT
- Contributors: $CONTRIBUTORS

### CHANGELOG head

$CHANGELOG_TOP
EOF
}

render_monthly() {
  cat <<EOF
# Monthly Content Rollup — $UNTIL

> **DRAFT ONLY — do not publish.** Generated by \`scripts/content-engine.sh\`
> on $AS_OF from $COMMIT_COUNT commit(s) in $SINCE .. $UNTIL.
> Broader than the weekly pack: themes, highlights, and long-form candidates.
> Review before posting. Strip \`[epistemic]\` tags before publishing.
> Nothing here is sent anywhere automatically — this is a review artifact.

## The Month in One Line

<!-- The single sentence you'd use to describe this month's progress. -->
_Draft prompt: what compounded this month?_

## What Shipped This Month

$GROUPED

## Themes That Compounded

- <theme 1 — which shipped items reinforce it> [inferred]
- <theme 2>
- <theme 3>

## Highlight Reel (LinkedIn / Newsletter)

**Bucket:** <pick a bucket>

This month I shipped <N> things. The three that mattered:

$(recent_subjects 3 | awk '{printf "%d. %s — <why it mattered>\n", NR, $0}' || true)

What I'd do differently next month: <reflection>

## Long-Form Candidates

- <topic that earned a deep writeup this month, and the angle>
- <topic 2>

## Numbers (verify before posting)

- Commits this window: $COMMIT_COUNT [observed]
- Contributors: $CONTRIBUTORS [observed]

## Quality Review

- Strongest narrative:
- Underfed theme:
- Claims to verify:
- Next month's content bet:

---

## Source Data (do not publish)

- Window: $SINCE .. $UNTIL (${WINDOW_DAYS} days)
- Commits: $COMMIT_COUNT
- Contributors: $CONTRIBUTORS

### CHANGELOG head

$CHANGELOG_TOP
EOF
}

if [ "$MODE" = "weekly" ]; then
  CONTENT="$(render_weekly)"
  SUBDIR="weekly"
  FILENAME="weekly-content-${UNTIL}.md"
else
  CONTENT="$(render_monthly)"
  SUBDIR="monthly"
  FILENAME="monthly-content-${UNTIL}.md"
fi

if [ "$DRY_RUN" = "true" ]; then
  printf '%s\n' "$CONTENT"
  warn "(dry-run: nothing written)"
  exit 0
fi

DEST_DIR="$REPO_ROOT/$OUTPUT_DIR/$SUBDIR"
mkdir -p "$DEST_DIR"
DEST="$DEST_DIR/$FILENAME"
printf '%s\n' "$CONTENT" > "$DEST"

ok "Wrote $MODE draft: ${OUTPUT_DIR}/${SUBDIR}/${FILENAME}"
log "Draft-only. No external sends. Review before publishing."
echo "$DEST"
