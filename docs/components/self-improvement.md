# Self-Improvement

How your AI gets permanently better without you doing anything.

This isn't "prompt engineering." It's a closed-loop system where every interaction feeds back into the AI's operating rules, memory, and behavior. The AI debugs itself.

---

## Recursive Self-Improvement Cycle

The core loop:

```
Generate → Evaluate → Diagnose → Improve → Repeat
```

1. **Generate** — AI produces output (content, analysis, task execution)
2. **Evaluate** — Output is scored against criteria (accuracy, tone, usefulness, human feedback)
3. **Diagnose** — If score is low, identify root cause. Was it missing context? Wrong tone? Bad assumption?
4. **Improve** — Update the relevant file: `operating-rules.md` for behavior, `preferences.md` for style, `SOUL.md` for personality drift
5. **Repeat** — Run the improved version

**Hard stop:** After 3 iterations with <5% improvement, stop. Diminishing returns are real, and infinite self-improvement loops are a waste of compute. Ship it.

This applies to content drafts, code generation, research summaries — anything where the AI can evaluate its own output.

---

## Failure-to-Guardrail Pipeline

Every mistake becomes a permanent fix. Here's how:

```
Failure occurs
    → Log to regressions.md (what happened, when, impact)
    → Root cause analysis (missing rule? stale context? wrong model?)
    → Generate candidate guardrail
    → Human reviews (approve/modify/reject)
    → Approved guardrail → operating-rules.md
    → Regression test: re-run the original scenario
```

### regressions.md Format

```markdown
## YYYY-MM-DD — [Brief description]

**What happened:** Sent a Slack message to the wrong channel.
**Root cause:** Channel name ambiguity — #general vs #general-eng.
**Impact:** Low (caught quickly), but trust-damaging.
**Guardrail:** Always confirm channel by ID, not name. Added to operating-rules.md.
**Status:** ✅ Resolved
```

The key insight: regressions are not shame. They're the raw material for guardrails. A system that never fails is a system that never learns.

---

## Prediction-Outcome Calibration

Your AI should know how confident it is — and be right about that confidence.

### How It Works

1. AI makes a prediction with a confidence level:
   ```
   Prediction: The PR will be approved without changes
   Confidence: 70%
   Date: 2026-02-25
   ```

2. When the outcome arrives, score it:
   ```
   Outcome: PR needed 2 revisions
   Score: Miss
   Calibration note: Overconfident on code review predictions. Reduce by ~15%.
   ```

3. Over time, the AI builds a calibration curve. If it says "80% confident," that should mean it's right ~80% of the time.

### Why This Matters

Uncalibrated AI is dangerous. It sounds equally confident saying "the sky is blue" and "this startup will succeed." Calibration forces honesty about uncertainty.

The `predictions.md` file is the training set for this calibration. Review it monthly.

---

## Epistemic Tagging

Every claim the AI makes should carry a tag indicating its epistemic status:

| Tag | Meaning | Example |
|-----|---------|---------|
| `[consensus]` | Widely accepted, well-sourced | "Transformers use self-attention" |
| `[observed]` | Directly witnessed or measured | "Your last 3 posts got >1k impressions" |
| `[inferred]` | Logical conclusion from evidence | "Your audience engages more on Tuesdays" |
| `[speculative]` | Hypothesis, limited evidence | "This trend might peak in Q3" |
| `[contrarian]` | Against mainstream, deliberately provocative | "RAG is mostly unnecessary for personal AI" |

### Usage

- **Content engine:** All thought leadership posts get tagged. `[speculative]` claims need a hedge. `[contrarian]` claims need extra evidence or an explicit "I think."
- **Research:** Sources are tagged by reliability. Primary > secondary > LLM-generated.
- **Memory:** Facts stored with their epistemic status. Stale `[observed]` data gets flagged for refresh.

This prevents the most common AI failure mode: stating uncertain things with supreme confidence.

---

## Active Context Holds

Sometimes you need the AI to temporarily prioritize something — a project sprint, a job search, a health goal. Context holds handle this.

### context-holds.md Format

```markdown
## Active Holds

### Job search — Expires 2026-03-15
- Prioritize career-related content in daily digest
- Flag relevant job postings from network
- Bias morning briefing toward interview prep

### Product launch — Expires 2026-03-01
- All content drafts should reference the launch
- Monitor competitor announcements
- Daily check on launch metrics
```

### Rules

- Every hold has an **expiry date**. No permanent holds — that's what `operating-rules.md` is for.
- Expired holds get auto-archived (moved to the bottom with `[EXPIRED]` tag).
- Maximum 5 active holds. More than that means you're not prioritizing.
- Holds override default behavior but never override safety rules.

This is inspired by the vasocomputation concept from [@johnsonmxe](https://x.com/johnsonmxe) — the idea that context should actively shape processing, not just passively exist.

---

## Friction Detection

Most AI assistants silently comply with everything. That's a bug, not a feature.

When the AI detects a contradiction — between a request and known preferences, between current instructions and past feedback, between what's asked and what's wise — it logs it.

### How It Works

1. AI detects friction (e.g., "post this tweet" but the content contradicts established voice guidelines)
2. Instead of silently complying or refusing, it **flags the friction:**
   ```
   ⚠️ Friction: This draft uses a tone you've explicitly asked me to avoid (see operating-rules.md #14).
   I can post as-is, adjust the tone, or skip. Your call.
   ```
3. The human's response becomes training data:
   - "Good catch, fix it" → reinforces the rule
   - "Override, post anyway" → logs an exception
   - "Update the rule" → operating-rules.md gets modified

Friction detection prevents two failure modes:
- **Sycophancy** — blindly agreeing with everything
- **Refusal** — blocking legitimate requests because of rigid rules

The middle path is flagging and letting the human decide.

---

## Nightly Extraction

Every night (or whenever the daily cron runs), the AI reviews the day's interactions and extracts:

1. **New facts** → Update relevant memory files
2. **Behavior corrections** → Update operating-rules.md
3. **Pattern observations** → Note in preferences.md
4. **Open loops** → Add to tasks/queue.md
5. **Relationship updates** → Update people.md

This is the janitor loop. It prevents memory drift and ensures nothing falls through the cracks.

### What Gets Extracted

- Explicit corrections: "Don't do X" → operating rule
- Implicit preferences: Human always edits the opening line → note the pattern
- New contacts: Mentioned a new person → add to people.md
- Project updates: Milestone hit, blocker found → update projects.md
- Ideas captured: Offhand mention of an idea → add to ideas/inbox.md

The nightly extraction is what turns raw daily logs into structured, searchable memory.

---

## Credits

The meta-learning loop framework is inspired by [@AtlasForgeAI](https://x.com/AtlasForgeAI/status/2026380335249002843) and their work on recursive self-improvement for AI agents. The active context holds concept draws from [@johnsonmxe](https://x.com/johnsonmxe)'s vasocomputation model.
