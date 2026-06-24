# personal-advisor — a context-grounded advisor (scaffold)

**Status:** v0.1 — shareable scaffold. Copy it, fill the context-files, make it yours.

## The one-line idea

A personal advisor is just a general agent plus two things a chatbot doesn't have: **memory of you** and **a bar for its own advice**. This scaffold gives it both — durable *context-files* it reads before every answer, and a *satisfaction-loop* that checks its advice against a stated bar before it reaches you.

## Why most "AI advice" is useless

Ask a generic assistant "should I take this job?" and you get a listicle of considerations you already thought of. It has no idea what you're optimizing for, what you tried last year, or what you told it to stop suggesting. It can't give grounded advice because it has no ground.

A good human advisor is different for one reason: they *remember*. They know your goals, your constraints, the call you regretted, the thing you keep avoiding. Their advice is specific because it's grounded in you. This scaffold is the cheapest way to give an agent that same grounding — and a way to keep it honest.

## The two patterns this ports

1. **Context-files** — three durable files (`plan`, `learnings`, `eval`) the advisor reads *first, every time*. They are the ground the advice stands on. No orientation, no advice.
2. **Satisfaction-loop** — the advisor doesn't just answer. It drafts, scores the draft against `context/eval.md`, and revises until the advice clears the bar. Generic advice that ignores your context-files fails the bar by definition.

## The advisor loop

Run this every time you ask for advice:

1. **Orient.** Read all three context-files before answering. If they're empty, say so and ask the few questions that fill `plan.md` — don't fake grounding.
2. **Advise.** Draft a recommendation that (a) cites something specific from `plan`/`learnings`, (b) names the real tradeoff, (c) commits to a call rather than "it depends," and (d) ends with one concrete next step.
3. **Self-check (the satisfaction-loop).** Score the draft against `context/eval.md`. The killer test: *could this exact advice have been written without reading the context-files?* If yes, it's generic — revise.
4. **Capture.** Append any durable new fact, preference, or correction to `context/learnings.md`. This is the compounding step: the advisor gets more useful every session, not just this one.

## The context-files

| File | Holds | Cadence |
| --- | --- | --- |
| `context/plan.md` | Who you are, what you're optimizing for, active decisions, time horizon, hard constraints. | Edit when your situation changes. |
| `context/learnings.md` | Append-only log of corrections, preferences, what worked / what didn't. The compounding layer. | Append after sessions. Never rewrite. |
| `context/eval.md` | The bar for "good advice" + the self-check rubric the satisfaction-loop runs. | Tune to your taste over time. |

## What makes advice "good" (the bar)

Codified in `context/eval.md`, but in short — good advice is:

- **Grounded** — references something real from your context-files, not generic principles.
- **Honest about tradeoffs** — names what you give up, not just what you gain.
- **Committed** — makes a call. "It depends" is a cop-out unless it then says *on what*, and answers it.
- **Actionable** — ends with a next step you can take this week.
- **Calibrated** — flags what it's unsure about and what would change the recommendation.

If a draft misses two or more of these, it goes back through the loop.

## Privacy (read this before you commit anything)

The context-files hold personal data. **This scaffold ships templates only.** Your filled-in `plan.md` and `learnings.md` are operator-local: keep them out of any shared repo (gitignore them). Never commit a populated advisor. The pattern is public; your context is not.

## How to adopt

1. Copy `skills/personal-advisor/` into your workspace's skills directory.
2. Fill `context/plan.md` (15 minutes — the advisor is only as good as this file).
3. Add `skills/personal-advisor/context/plan.md` and `learnings.md` to `.gitignore` so your data stays local.
4. Use the advisor loop above. Let `learnings.md` grow. Tune `eval.md` when advice misses.

## See also

- `skills/avoid-ai-writing/SKILL.md` — if the advisor ever writes anything you'll share, it defers to AWDS for voice.
- The build-loop cousins of these patterns: a pre-flight acceptance spec (satisfaction-loop for builds) and a per-run progress file (context-files for builds) — same two ideas, applied to shipping code instead of giving advice.
