# Claude Opus 4.8

**Runtime id:** `amazon-bedrock/us.anthropic.claude-opus-4-8` · **alias:** `opus`

## Routing

Opus 4.8 at **medium** is the default interactive/generalist route for orchestration, planning, research synthesis, content, and voice. Its fallback chain is GPT-5.6 Sol medium, then Kimi K3 high.

Do not use another Anthropic model as an outage fallback. Fable is a role-specific hard-autonomous model, not an Opus availability substitute.

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

- `medium`: standing default.
- `high`: bounded difficult judgment or review.
- Hard autonomous work belongs on Fable xhigh rather than routine Opus escalation.
