#!/usr/bin/env bash
set -euo pipefail

# Thin operator CLI for the Clawrari content engine.
# It owns slug workspaces and delegates generation + AWDS scoring to the
# existing content-engine-run.sh recipe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORK_DIR="${CLAWRARI_CONTENT_WORK_DIR:-$REPO_ROOT/docs/content-engine/work}"
RUN_SCRIPT="${CLAWRARI_CONTENT_RUN_SCRIPT:-$SCRIPT_DIR/content-engine-run.sh}"

usage() {
  cat <<'EOF'
Clawrari content CLI

Usage:
  clawrari content new <slug>
  clawrari content run <slug> [--weekly|--monthly] [--as-of YYYY-MM-DD] [--force]
  clawrari content --help

Direct script usage:
  scripts/clawrari-content.sh new <slug>
  scripts/clawrari-content.sh run <slug> --weekly --as-of 2026-07-01

Commands:
  new   Create a timestamped markdown workspace for a content piece.
  run   Run the existing content-engine recipe with AWDS scoring and print the verdict.

Notes:
  run delegates to scripts/content-engine-run.sh and always passes --no-notify.
  This wrapper never sends Slack messages or publishes externally.
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

utc_stamp() {
  date -u +%Y%m%dT%H%M%SZ
}

utc_iso() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

validate_slug() {
  local slug="$1"
  [ -n "$slug" ] || die "slug is required"
  case "$slug" in
    *[!A-Za-z0-9._-]*)
      die "slug may only contain letters, numbers, dots, underscores, and hyphens"
      ;;
  esac
}

latest_piece_file() {
  local slug="$1"
  local dir="$WORK_DIR/$slug"
  [ -d "$dir" ] || return 1
  find "$dir" -maxdepth 1 -type f -name "*.md" | sort | tail -n1
}

cmd_new() {
  local slug="${1:-}"
  validate_slug "$slug"

  local stamp iso dir dest
  stamp="$(utc_stamp)"
  iso="$(utc_iso)"
  dir="$WORK_DIR/$slug"
  dest="$dir/${stamp}-${slug}.md"

  mkdir -p "$dir"
  [ ! -e "$dest" ] || die "content file already exists: $dest"

  cat > "$dest" <<EOF
---
slug: $slug
created_at: $iso
status: draft
---

# $slug

## Hook

<one sharp opener>

## Bullets

- <point one>
- <point two>
- <point three>

## CTA

<one concrete next step or question>
EOF

  echo "Created content workspace: ${dest#"$REPO_ROOT"/}"
  echo "$dest"
}

cmd_run() {
  local slug="${1:-}"
  validate_slug "$slug"
  shift || true

  local mode="weekly"
  local as_of=""
  local force="false"

  while [ $# -gt 0 ]; do
    case "$1" in
      --weekly) mode="weekly"; shift ;;
      --monthly) mode="monthly"; shift ;;
      --as-of) as_of="${2:-}"; [ -n "$as_of" ] || die "--as-of needs a date"; shift 2 ;;
      --force) force="true"; shift ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown run argument: $1" ;;
    esac
  done

  [ -x "$RUN_SCRIPT" ] || die "content engine run script is not executable: $RUN_SCRIPT"

  local piece_file
  piece_file="$(latest_piece_file "$slug" || true)"
  [ -n "$piece_file" ] || die "no content workspace found for '$slug'; run 'clawrari content new $slug' first"

  local args=("--$mode" "--no-notify")
  if [ -n "$as_of" ]; then args+=("--as-of" "$as_of"); fi
  if [ "$force" = "true" ]; then args+=("--force"); fi

  local output draft_path gate_json verdict log_dir log_path stamp
  output="$("$RUN_SCRIPT" "${args[@]}")"
  draft_path="$(printf '%s\n' "$output" | awk 'NF { last=$0 } END { print last }')"
  [ -n "$draft_path" ] || die "content engine did not print a draft path"
  [ -f "$draft_path" ] || die "content engine draft path does not exist: $draft_path"

  gate_json="${draft_path%.md}.awds.json"
  [ -f "$gate_json" ] || die "AWDS gate artifact not found: $gate_json"

  command -v node >/dev/null 2>&1 || die "node is required to read AWDS gate output"
  verdict="$(node -e 'const fs=require("fs");const j=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));console.log(j.verdict||"UNKNOWN")' "$gate_json")"

  stamp="$(utc_stamp)"
  log_dir="$WORK_DIR/$slug"
  log_path="$log_dir/run-${stamp}.log"
  {
    echo "slug=$slug"
    echo "piece_file=$piece_file"
    echo "mode=$mode"
    if [ -n "$as_of" ]; then echo "as_of=$as_of"; fi
    echo "draft_path=$draft_path"
    echo "gate_json=$gate_json"
    echo "verdict=$verdict"
  } > "$log_path"

  echo "VERDICT: $verdict"
  echo "Draft: ${draft_path#"$REPO_ROOT"/}"
  echo "AWDS: ${gate_json#"$REPO_ROOT"/}"
  echo "Run log: ${log_path#"$REPO_ROOT"/}"
}

main() {
  if [ "${1:-}" = "content" ]; then shift; fi

  case "${1:-}" in
    new) shift; cmd_new "$@" ;;
    run) shift; cmd_run "$@" ;;
    -h|--help|"") usage ;;
    *) die "unknown command: $1 (try --help)" ;;
  esac
}

main "$@"
