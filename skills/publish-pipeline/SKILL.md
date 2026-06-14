# publish-pipeline — Publish-Stage Gate (stub)

**Status:** stub. Documents the publish-stage contract; not a full vended skill.

The publish pipeline is the last step before reviewed content leaves the workspace for an external surface. It separates drafting from sending: draft freely, publish only with explicit approval.

## Voice authority

This skill does **not** define its own voice or anti-AI-tell rules. The single source of truth for all voice/anti-AI-tell rules is the **`avoid-ai-writing` (AWDS)** skill — see [`skills/avoid-ai-writing/SKILL.md`](../avoid-ai-writing/SKILL.md). On any conflict between this stub and AWDS, **AWDS wins.**

Earlier iterations of a publish pipeline carried their own em-dash strip and emoji cap. Those are now a subset of AWDS `patterns/v1-lexical.md` (`v1.01-em-dash`, `v1.50-emoji-cap`). Do not re-implement them here — call the AWDS gate.

## Contract

1. **Gate first.** Run the candidate through the AWDS gate. Never publish a REWRITE-verdict piece.
2. **Human approval.** Publishing to an external surface is a two-gate action (confirm before any public/external send). The pipeline posts a preview for approval; it does not auto-send.
3. **Keep the source.** Retain the source markdown after publish.
4. **Capture learnings.** Feed what performed well back into the content-engine learn stage (`docs/content-engine.md`).

## See also

- [`skills/avoid-ai-writing/SKILL.md`](../avoid-ai-writing/SKILL.md) — canonical voice/anti-AI-tell rules (this stub defers to it).
- [`docs/content-engine.md`](../../docs/content-engine.md) — the full draft → review → publish → learn loop.
