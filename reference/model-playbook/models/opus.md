# Claude Opus 4.8 — Retired reference

**Runtime id:** `amazon-bedrock/us.anthropic.claude-opus-4-8` · **legacy alias:** `opus-legacy`

## Routing

Opus 4.8 is retired from active routing. Keep this file only as a historical prompting reference for old transcripts and deliberate migration comparisons. No active intent in `models.yaml` may use it as a primary, secondary, or fallback.

Current work should follow `models.yaml` instead of silently reviving this route.

## Prompt shape

Opus accepts Markdown or XML. Use the smallest structure that makes scope and completion unambiguous:

```xml
<goal>Concrete outcome.</goal>
<context>Relevant facts and sources.</context>
<constraints>Hard boundaries only.</constraints>
<acceptance_criteria>Observable proof of completion.</acceptance_criteria>
```

State scope explicitly. “Apply this to every matching file” is better than implying broad application from one example. Name required tools when the task depends on them.

## Model behavior

- Direct, literal, and strong at sustained judgment.
- Can under-use tools unless current-state verification is explicit.
- Can overfit a correction to the one section mentioned; say whether the fix is local or global.
- Responds better to positive task framing plus explicit permission to disagree than hostile correction loops.

## Review prompts

Ask for every finding with confidence and severity, then rank/filter separately. Avoid “be conservative,” which can suppress useful findings.

## Design prompts

Specify palette, typography, structure, density, and product context. For technical and enterprise product contexts, default to blues, greens, and whites rather than the generic cream/serif/terracotta pattern.

## Effort

- Historical runs used `medium` for routine work and `high` for bounded difficult judgment.
- New work belongs on an active route; retirement is incomplete while any intent still references Opus 4.8.
