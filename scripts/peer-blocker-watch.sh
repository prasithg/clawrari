#!/usr/bin/env bash
# peer-blocker-watch.sh — surface NEW blocking handoffs from a peer agent's inbox.
#
# When two agents collaborate through a shared file drop, a blocking question can sit
# unread for hours because nobody is watching the drop. That is a deadlock: agent A is
# waiting on a decision agent B never saw. This watcher closes that gap. Point it at the
# inbox directory, run it on a cron, and every cycle it prints any new handoff that is
# actually blocking, so it gets answered within one cycle instead of rotting.
#
# Convention this assumes: a notification channel (chat, etc.) is the doorbell, and the
# shared directory is the source of truth. This makes the doorbell monitored.
#
# A handoff (a .md file in the inbox) counts as BLOCKING if either:
#   - its `**Priority:**` line contains high / blocking / urgent, OR
#   - it has a `## Decisions needed` section whose body is non-empty and not "none".
#
# Dedup is by filename + mtime, stored in a small JSON state file, so a handoff is
# flagged once and not re-flagged on every cron tick (unless it changes).
#
# Usage:
#   peer-blocker-watch.sh           # print NEW blocking handoffs (or NO_NEW_BLOCKERS)
#   peer-blocker-watch.sh --mark    # same, then record them as seen
#   peer-blocker-watch.sh --selftest
#
# Env overrides:
#   PEER_INBOX            directory of incoming handoff .md files (required for real runs)
#   PEER_STATE           JSON state file for dedup (default: <inbox>/.peer-blocker-seen.json)
#   PEER_LOOKBACK_HOURS  how far back to consider files (default: 48)
set -euo pipefail

if [ "${1:-}" = "--selftest" ]; then
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  inbox="$tmp/inbox"; mkdir -p "$inbox"
  state="$tmp/seen.json"

  # blocking by priority
  cat > "$inbox/a.md" <<'EOF'
**Topic:** schema choice
**Priority:** high
## Decisions needed
Pick UUID vs bigint for the id column.
EOF
  # not blocking
  cat > "$inbox/b.md" <<'EOF'
**Topic:** fyi
**Priority:** low
## Decisions needed
none
EOF
  out="$(PEER_INBOX="$inbox" PEER_STATE="$state" PEER_LOOKBACK_HOURS=48 bash "$0")"
  echo "$out" | grep -q "NEW_BLOCKERS=1" || { echo "selftest FAIL: expected 1 blocker, got: $out"; exit 1; }
  echo "$out" | grep -q "a.md" || { echo "selftest FAIL: a.md not flagged"; exit 1; }
  echo "$out" | grep -q "b.md" && { echo "selftest FAIL: b.md should not be flagged"; exit 1; }

  # --mark then re-run should report none
  PEER_INBOX="$inbox" PEER_STATE="$state" bash "$0" --mark >/dev/null
  out2="$(PEER_INBOX="$inbox" PEER_STATE="$state" bash "$0")"
  echo "$out2" | grep -q "NO_NEW_BLOCKERS" || { echo "selftest FAIL: marked blocker re-flagged: $out2"; exit 1; }

  echo "selftest OK"
  exit 0
fi

INBOX="${PEER_INBOX:-}"
[ -n "$INBOX" ] || { echo "PEER_INBOX is required" >&2; exit 2; }
STATE="${PEER_STATE:-$INBOX/.peer-blocker-seen.json}"
LOOKBACK_HOURS="${PEER_LOOKBACK_HOURS:-48}"
MARK=0
[ "${1:-}" = "--mark" ] && MARK=1

[ -d "$INBOX" ] || { echo "NO_NEW_BLOCKERS"; exit 0; }
mkdir -p "$(dirname "$STATE")"
[ -f "$STATE" ] || echo '{}' > "$STATE"

now_epoch=$(date +%s)
cutoff=$(( now_epoch - LOOKBACK_HOURS * 3600 ))

found=0
new_keys=""
out=""

while IFS= read -r f; do
  [ -n "$f" ] || continue
  mt=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null || echo 0)
  [ "$mt" -ge "$cutoff" ] || continue

  prio_line=$(grep -iE '\*\*Priority:\*\*' "$f" 2>/dev/null | head -1 || true)
  is_blocking=0
  echo "$prio_line" | grep -iqE 'high|blocking|urgent' && is_blocking=1
  dec=$(awk '/^## Decisions needed/{flag=1;next}/^## /{flag=0}flag' "$f" 2>/dev/null | tr -d '[:space:]' || true)
  if [ -n "$dec" ] && ! echo "$dec" | grep -iqE '^none'; then is_blocking=1; fi
  [ "$is_blocking" -eq 1 ] || continue

  base=$(basename "$f")
  key="${base}::${mt}"
  grep -q "\"$key\"" "$STATE" 2>/dev/null && continue

  found=$((found + 1))
  new_keys="$new_keys $key"
  topic=$(grep -iE '\*\*Topic:\*\*' "$f" | head -1 | sed -E 's/.*Topic:\*\* *//' || echo "(no topic)")
  ask=$(awk '/^## (Decisions needed|Suggested next action)/{flag=1}/^## (Sensitive|Files)/{flag=0}flag' "$f" 2>/dev/null | head -12 || true)
  out="${out}
=== BLOCKING HANDOFF: $base ===
Topic: $topic
$ask
"
done < <(find "$INBOX" -maxdepth 1 -name '*.md' -type f 2>/dev/null)

if [ "$found" -eq 0 ]; then
  echo "NO_NEW_BLOCKERS"
  exit 0
fi

echo "NEW_BLOCKERS=$found"
echo "$out"

if [ "$MARK" -eq 1 ]; then
  tmp=$(mktemp)
  python3 - "$STATE" "$tmp" $new_keys <<'PY'
import json, sys
state_path, tmp_path = sys.argv[1], sys.argv[2]
keys = sys.argv[3:]
try:
    d = json.load(open(state_path))
except Exception:
    d = {}
for k in keys:
    d[k] = 1
json.dump(d, open(tmp_path, "w"))
PY
  mv "$tmp" "$STATE"
fi
