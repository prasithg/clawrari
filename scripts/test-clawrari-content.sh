#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

work_dir="$tmp/work"
mock_run="$tmp/mock-content-engine-run.sh"
mock_args="$tmp/mock-args.txt"

cat > "$mock_run" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" > "$MOCK_ARGS"
out_dir="$(dirname "$MOCK_ARGS")/generated"
mkdir -p "$out_dir"
draft="$out_dir/mock-weekly.md"
printf '# Mock draft\n' > "$draft"
printf '{"verdict":"PATCH","flags":[],"categories_touched":[]}\n' > "${draft%.md}.awds.json"
echo "$draft"
MOCK
chmod +x "$mock_run"

export CLAWRARI_CONTENT_WORK_DIR="$work_dir"
export CLAWRARI_CONTENT_RUN_SCRIPT="$mock_run"
export MOCK_ARGS="$mock_args"

new_output="$("$REPO_ROOT/scripts/clawrari-content.sh" new test-piece)"
new_file="$(printf '%s\n' "$new_output" | tail -n1)"

[ -f "$new_file" ] || { echo "FAIL: new did not create a file: $new_file"; exit 1; }
grep -q '^## Hook$' "$new_file" || { echo "FAIL: scaffold missing Hook section"; exit 1; }
grep -q '^## Bullets$' "$new_file" || { echo "FAIL: scaffold missing Bullets section"; exit 1; }
grep -q '^## CTA$' "$new_file" || { echo "FAIL: scaffold missing CTA section"; exit 1; }
grep -q 'slug: test-piece' "$new_file" || { echo "FAIL: scaffold missing slug metadata"; exit 1; }

run_output="$("$REPO_ROOT/scripts/clawrari-content.sh" run test-piece --as-of 2026-07-01)"
printf '%s\n' "$run_output" | grep -q 'VERDICT: PATCH' || {
  echo "FAIL: run did not print mocked verdict"
  printf '%s\n' "$run_output"
  exit 1
}
grep -q -- '--weekly' "$mock_args" || { echo "FAIL: run did not invoke weekly recipe"; exit 1; }
grep -q -- '--no-notify' "$mock_args" || { echo "FAIL: run did not suppress notification"; exit 1; }
grep -q -- '--as-of' "$mock_args" || { echo "FAIL: run did not pass --as-of"; exit 1; }

echo "clawrari-content test OK"
