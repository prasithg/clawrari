# Regressions

A lightweight log of cadence misses, broken workflows, and guardrail trips. Each entry should answer: what happened, why it matters, how it was fixed, and what guardrail caught (or should have caught) it.

## REG-001: 2026-05-17 cadence miss (1 day)

**What:** First cadence miss since the charter went live (2026-05-14). Last commit was 2026-05-03; the cadence pulse caught the 14-day gap on 2026-05-17.

**Why it matters:** The charter requires a commit at minimum every two days. This was one missed pulse cycle (one day late on the 2026-05-17 pulse). Regressions like this are the canary for the discipline layer working — or not.

**Fix:** Recovery commit (this PR) shipping README polish, CONTRIBUTING expansion, and this regressions log so the next pulse goes green.

**Guardrail:** Cadence pulse cron working as designed — miss surfaced within four hours of the midnight slip. No code change needed; the cron plus escalation already cover this class of miss.
