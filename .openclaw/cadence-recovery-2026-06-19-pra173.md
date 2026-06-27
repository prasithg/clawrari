# Clawrari cadence recovery - 2026-06-19 miss (PRA-173)

The repo missed its every-two-days publishing cadence after the 2026-06-19 window. This recovery slice restores the pulse with one public, reusable operating-rule packet instead of a cosmetic heartbeat commit.

## Slice shipped

- `docs/stacking-loops.md` - documents nested feedback loops where each loop emits a measurable signal the next loop consumes.
- `docs/human-facing-message-standard.md` - documents the plain-English-first rule for chat, Slack, status updates, handoffs, and morning reports.
- `.github/workflows/ci.yml` - runs the documented harness selftests and shell syntax checks on push and pull request.
- `.github/ISSUE_TEMPLATE/` - adds structured bug and pattern-request intake templates with redaction guardrails.
- `reports/evals/2026-06-21-pra173-clawrari-cadence.md` - records the eval evidence for the human-facing message standard.

## Verification target

Run the narrow repo gate before handoff:

```sh
bash scripts/night-work-pipeline.sh --selftest
bash scripts/peer-blocker-watch.sh --selftest
node scripts/regression-check.mjs --selftest
node scripts/eval-scorecard.mjs --selftest
```
