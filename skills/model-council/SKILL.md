# model-council — multi-model judgment with visible disagreement

**Status:** v0.1 — vended in full. Wire it to whatever model families you have and make it yours.

Use this when one polished answer is not enough. The goal is **not** to average models. The goal is to expose disagreement, identify the crux, and make a defensible call.

## When to use

Use for:
- High-stakes product / strategy / architecture decisions
- PRDs, specs, roadmap commitments, launch or demo go/no-go
- Model quality comparisons or evaluation design
- Positioning / narrative decisions
- Ambiguous questions where model blind spots matter

Do **not** use for:
- Simple facts or web lookups
- Routine summaries
- Low-stakes drafts
- Premortems — if the question is "what could go wrong / imagine this already failed," use a premortem instead.

## Modes

### Quick Council — ~5-minute answer

Use when the question matters but is narrow.

Time budget / fallback:
- Target: ~5 minutes.
- 3 lanes max by default.
- If a lane times out, synthesize from the completed lanes and mark the timeout as a signal — never block indefinitely on perfect coverage.

Run one perspective per model family, then synthesize:
1. **Judgment / adversarial family** — critique, strategy, spotting the weak assumption.
2. **Research / broad-context family** — grounding, breadth, multimodal if relevant.
3. **Implementation-realism family** — operational edge cases, "what breaks in practice."
4. **Optional third-party family** — an independent training prior as a tiebreaker.

The point of using different *families* (not three prompts to the same model) is that different training priors catch different blind spots. Same-family lanes tend to agree with each other for the wrong reason.

### Canvas Council — deep thinking-team pattern

Use when the question is deep enough that a normal answer would hide the important reasoning.

Time budget / fallback:
- Target: 30–60 minutes depending on stakes.
- Default to 3 expert roles; use 4–5 only when each role tests a distinct blind spot.
- If a role times out, continue if ≥3 useful perspectives completed; record the missing lane as a quality signal.
- If completed experts contradict each other, run the mandatory adversary even if a non-essential lane timed out.

Before spawning models, write 3–5 expert briefs:
- **Job title** — Strategy Lead, Skeptical CTO, Customer Researcher, Finance/Risk Analyst, Implementation Owner, etc.
- **Mandate** — the angle this expert owns.
- **Blind-spot target** — the failure mode this expert is meant to catch.
- **Evidence rule** — the files, sources, metrics, or constraints they must inspect before opining.
- **Model fit** — which model gets the brief and why.

If experts contradict each other, assign a **mandatory adversary**. The adversary must resolve the contradiction by naming the crux and the evidence that decides it — not merely summarize both sides.

Pause for steering only when the work forks into materially different directions. Ask one short choiceful question ("optimize for speed, reliability, or narrative?"). Otherwise proceed with labeled assumptions.

## Output contract

Return:
- **Verdict** — one recommended path. Commit to it.
- **Consensus** — what all models/experts independently support.
- **Disagreements** — explicit differences, not blended away.
- **Cruxes** — the 1–3 facts/assumptions that decide the disagreement.
- **Signals** — green/yellow/red on each major claim.
  - **Green:** strong evidence, unlikely to flip.
  - **Yellow:** plausible but assumption-sensitive; name the assumption.
  - **Red:** weak, contradicted, missing evidence, or risky.
- **Flip conditions** — what evidence would change each yellow/red signal.
- **Dissent** — the best rejected argument, preserved for auditability.
- **Action items** — concrete next steps.

## Operating rules

- Prefer expert-role diversity over model-count inflation.
- Give each model a role-specific brief, not the same generic prompt.
- Hide private chain-of-thought. Show evidence, frames, cruxes, signals, and decisions.
- Add a fact-check lane for factual/market claims: claim, source, verdict, confidence.
- If an artifact was requested, save the council brief to your reports/ or repo path.
- For code/architecture work, use at least one reviewer family different from the writer (see the cross-review skill).

## Source pattern

This skill combines two public patterns:
- **Perplexity-style Model Council** — parallel frontier models + a disagreement map + synthesis.
- **Serno-style Canvas/Council** — a custom expert team, mandatory adversarial debate, green/yellow/red signals, human steering, and exportable thinking frames.
