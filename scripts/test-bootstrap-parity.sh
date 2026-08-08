#!/usr/bin/env bash
#
# test-bootstrap-parity.sh — validates bootstrap/init.sh non-interactively.
#
# Feeds answers derived from bootstrap/questions.json into init.sh against a
# throwaway temp workspace, then asserts the generated files/dirs and key
# config values match what questions.json implies. Prints PASS/FAIL and exits
# non-zero on any failed assertion. The temp dir is always cleaned up on exit.
#
# Everything is reversible: it writes ONLY inside a mktemp -d directory. It
# never touches the live workspace (it sets OPENCLAW_WORKSPACE to a fresh
# non-existent subdir, which also sidesteps init.sh's overwrite prompt).

set -uo pipefail

# ── Locate repo + inputs ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT_SH="$REPO_ROOT/bootstrap/init.sh"
QUESTIONS="$REPO_ROOT/bootstrap/questions.json"
TEMPLATES_DIR="$REPO_ROOT/bootstrap/templates"   # canonical template source init.sh renders from

for f in "$INIT_SH" "$QUESTIONS"; do
  if [ ! -f "$f" ]; then
    echo "FATAL: required input missing: $f" >&2
    exit 2
  fi
done
if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "FATAL: canonical templates dir missing: $TEMPLATES_DIR" >&2
  exit 2
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "FATAL: jq is required but not found in PATH." >&2
  exit 2
fi

# ── Throwaway workspace + cleanup trap ───────────────────────────────
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/clawrari-parity.XXXXXX")"
WS="$TMP_ROOT/workspace"          # non-existent until init.sh creates it
INIT_LOG="$TMP_ROOT/init-run.out"

cleanup() { rm -rf "$TMP_ROOT"; }
trap cleanup EXIT

# ── Derive answers from questions.json ───────────────────────────────
# Read the default for a question id.
q_default() { jq -r --arg id "$1" '.questions[] | select(.id==$id) | .default' "$QUESTIONS"; }

# For required questions with an empty default, supply deterministic test
# values so ask_required doesn't loop forever. Everything else uses the
# questions.json default verbatim — that IS the parity contract.
TEST_NAME="Parity Tester"
TEST_ROLE="QA engineer running the harness"

E_NAME="$TEST_NAME"
E_PRONOUNS="$(q_default pronouns)"
E_TIMEZONE="$(q_default timezone)"
E_ROLE="$TEST_ROLE"
E_PRIORITY_1="$(q_default priority_1)"
E_PRIORITY_2="$(q_default priority_2)"
E_PRIORITY_3="$(q_default priority_3)"
E_WAKE_TIME="$(q_default wake_time)"
E_WRITING_STYLE="$(q_default writing_style)"
E_TONE="$(q_default tone)"
E_AI_NAME="$(q_default ai_name)"
E_AI_PERSONALITY="$(q_default ai_personality)"
E_PLATFORMS="$(q_default platforms)"
E_TOPICS="$(q_default topics)"

# Answer order MUST match the sequence of read prompts in init.sh.
ANSWERS=(
  "$E_NAME"
  "$E_PRONOUNS"
  "$E_TIMEZONE"
  "$E_ROLE"
  "$E_PRIORITY_1"
  "$E_PRIORITY_2"
  "$E_PRIORITY_3"
  "$E_WAKE_TIME"
  "$E_WRITING_STYLE"
  "$E_TONE"
  "$E_AI_NAME"
  "$E_AI_PERSONALITY"
  "$E_PLATFORMS"
  "$E_TOPICS"
)

TODAY="$(date +%Y-%m-%d)"

# ── Run bootstrap non-interactively ──────────────────────────────────
echo "== Clawrari bootstrap-parity test =="
echo "Temp workspace: $WS"
echo "Feeding ${#ANSWERS[@]} answers derived from questions.json"
echo ""

if ! printf '%s\n' "${ANSWERS[@]}" | OPENCLAW_WORKSPACE="$WS" bash "$INIT_SH" >"$INIT_LOG" 2>&1; then
  echo "FATAL: init.sh exited non-zero. Last 30 lines of its output:" >&2
  tail -30 "$INIT_LOG" >&2
  exit 1
fi

# Guard: init.sh must have written to the temp workspace, nowhere else.
if [ ! -d "$WS" ]; then
  echo "FATAL: init.sh did not create the target workspace at $WS" >&2
  exit 1
fi

# ── Assertion framework ──────────────────────────────────────────────
PASS=0
FAIL=0
FAILED_MSGS=()

ok()   { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); FAILED_MSGS+=("$1"); printf '  FAIL  %s\n' "$1"; }

assert_file() {
  if [ -f "$WS/$1" ]; then ok "file exists: $1"; else bad "file missing: $1"; fi
}
assert_dir() {
  if [ -d "$WS/$1" ]; then ok "dir exists: $1"; else bad "dir missing: $1"; fi
}
# assert_contains <relpath> <literal-substring> <label>
assert_contains() {
  local rel="$1" needle="$2" label="$3"
  if [ ! -f "$WS/$rel" ]; then bad "$label (file $rel missing)"; return; fi
  if grep -Fq -- "$needle" "$WS/$rel"; then ok "$label"; else bad "$label — '$needle' not found in $rel"; fi
}
# assert_not_contains <relpath> <literal-substring> <label> — needle must be ABSENT.
assert_not_contains() {
  local rel="$1" needle="$2" label="$3"
  if [ ! -f "$WS/$rel" ]; then bad "$label (file $rel missing)"; return; fi
  if grep -Fq -- "$needle" "$WS/$rel"; then bad "$label — '$needle' unexpectedly present in $rel"; else ok "$label"; fi
}
assert_json_valid() {
  if [ ! -f "$WS/$1" ]; then bad "json missing: $1"; return; fi
  if jq -e . "$WS/$1" >/dev/null 2>&1; then ok "valid JSON: $1"; else bad "invalid JSON: $1"; fi
}
# assert_no_unrendered <relpath> — no leftover {{...}} template placeholders
assert_no_unrendered() {
  local rel="$1"
  if [ ! -f "$WS/$rel" ]; then bad "placeholder-check: $rel missing"; return; fi
  if grep -Fq '{{' "$WS/$rel"; then
    bad "unrendered placeholder(s) remain in $rel: $(grep -o '{{[^}]*}}' "$WS/$rel" | tr '\n' ' ')"
  else
    ok "fully rendered (no {{...}}): $rel"
  fi
}

echo ""
echo "-- Assertions --"

# 1. Rendered root templates must all exist.
# Parity is against the CANONICAL template set, derived the same way init.sh
# does (loop bootstrap/templates/*.tmpl, strip .tmpl). Deriving instead of
# hardcoding means adding/removing a canonical template is caught here rather
# than silently passing a frozen checklist.
ROOT_TEMPLATE_FILES=()
for tmpl in "$TEMPLATES_DIR"/*.tmpl; do
  [ -e "$tmpl" ] || continue
  ROOT_TEMPLATE_FILES+=("$(basename "$tmpl" .tmpl)")
done
if [ "${#ROOT_TEMPLATE_FILES[@]}" -eq 0 ]; then
  bad "no *.tmpl templates found in $TEMPLATES_DIR"
else
  echo "  (canonical templates: ${#ROOT_TEMPLATE_FILES[@]} → ${ROOT_TEMPLATE_FILES[*]})"
fi
for f in "${ROOT_TEMPLATE_FILES[@]}"; do assert_file "$f"; done

# 2. Seeded memory/tasks/ideas files must exist.
SEEDED_FILES=(
  "memory/$TODAY.md"
  memory/projects.md memory/people.md memory/preferences.md
  memory/operating-rules.md memory/rules-constitutional.md memory/rules-tactical.md
  memory/session-brief.md memory/subagent-ledger.md
  memory/regressions.md memory/context-holds.md memory/predictions.md
  memory/influences.md memory/reference/conventions.md memory/heartbeat-state.json
  tasks/queue.md ideas/inbox.md
)
for f in "${SEEDED_FILES[@]}"; do assert_file "$f"; done

# 3. Directory scaffold.
SCAFFOLD_DIRS=(memory memory/reference tasks drafts reports ideas systems systems/failures reference)
for d in "${SCAFFOLD_DIRS[@]}"; do assert_dir "$d"; done

# 4. Key config values derived from answers land in the right files.
assert_contains IDENTITY.md "**Name:** $E_AI_NAME"   "IDENTITY.md AI name = $E_AI_NAME"
assert_contains IDENTITY.md "**Human:** $E_NAME"     "IDENTITY.md human = $E_NAME"
assert_contains IDENTITY.md "**Born:** $TODAY"       "IDENTITY.md born date = $TODAY"

assert_contains USER.md "**Name:** $E_NAME"          "USER.md name"
# Pronouns default is empty; assert the label line still renders cleanly so the
# field stays wired even on the empty-optional path.
assert_contains USER.md "**Pronouns:**"              "USER.md pronouns label"
assert_contains USER.md "**Timezone:** $E_TIMEZONE"  "USER.md timezone"
assert_contains USER.md "**Notes:** $E_ROLE"         "USER.md role/notes"
assert_contains USER.md "1. $E_PRIORITY_1"           "USER.md priority 1"
assert_contains USER.md "2. $E_PRIORITY_2"           "USER.md priority 2"
assert_contains USER.md "3. $E_PRIORITY_3"           "USER.md priority 3"
assert_contains USER.md "$E_TOPICS"                  "USER.md topics"
assert_contains USER.md "$E_WRITING_STYLE"           "USER.md writing style"
assert_contains USER.md "$E_TONE"                    "USER.md tone"

assert_contains "memory/session-brief.md" "Top priority: $E_PRIORITY_1"   "session-brief priority 1"
assert_contains "memory/session-brief.md" "Secondary focus: $E_PRIORITY_2" "session-brief priority 2"
assert_contains "memory/session-brief.md" "Personality set to $E_AI_PERSONALITY" "session-brief personality"

assert_contains "memory/$TODAY.md" "Clawrari bootstrap completed" "daily note setup line"

# wake_time lands only in HEARTBEAT.md's Morning Briefing header.
assert_contains HEARTBEAT.md "Morning Briefing (daily, $E_WAKE_TIME)" "HEARTBEAT.md wake time"

# 4b. Personality conditional rendering (SOUL.md): the branch matching the
# chosen personality must survive and the OTHER two must be stripped entirely.
# assert_no_unrendered only proves no {{...}} markers remain — it can't catch a
# render bug that keeps the wrong branch's prose. Expected markers are selected
# from E_AI_PERSONALITY so this stays correct if questions.json's default flips.
SHARP_MARK="holy shit"
WARM_MARK="real partner, not a tool"
NEUTRAL_MARK="Minimal personality injection"
case "$E_AI_PERSONALITY" in
  sharp)   KEEP="$SHARP_MARK";   DROP=("$WARM_MARK" "$NEUTRAL_MARK") ;;
  warm)    KEEP="$WARM_MARK";    DROP=("$SHARP_MARK" "$NEUTRAL_MARK") ;;
  neutral) KEEP="$NEUTRAL_MARK"; DROP=("$SHARP_MARK" "$WARM_MARK") ;;
  *)       KEEP=""; DROP=() ;;
esac
if [ -n "$KEEP" ]; then
  assert_contains SOUL.md "$KEEP" "SOUL.md $E_AI_PERSONALITY vibe block kept"
  for d in "${DROP[@]}"; do
    assert_not_contains SOUL.md "$d" "SOUL.md non-$E_AI_PERSONALITY vibe stripped ('$d')"
  done
else
  bad "unknown personality '$E_AI_PERSONALITY' — no SOUL.md branch assertion possible"
fi

# 5. heartbeat-state.json must be valid JSON.
assert_json_valid memory/heartbeat-state.json

# 6. Parity: rendered templates carry no leftover placeholders.
for f in "${ROOT_TEMPLATE_FILES[@]}"; do assert_no_unrendered "$f"; done

# ── Summary ──────────────────────────────────────────────────────────
echo ""
echo "-- Summary --"
echo "  Passed: $PASS"
echo "  Failed: $FAIL"

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAIL"
  printf '  - %s\n' "${FAILED_MSGS[@]}"
  exit 1
fi

echo ""
echo "RESULT: PASS ($PASS assertions)"
exit 0
