# Persona Patterns

Clawrari is opinionated about personality and overlays, but careful about persona sprawl.

`v0.4.0` ships a single strong base workspace first. Persona patterns sit on top of that base through `SOUL.md`, model overlays, connector choices, and channel behaviors.

---

## The Current Pattern

One shared operating system:

- memory
- task workflow
- self-improvement loops
- connector rules
- model routing

Then lightweight persona shaping on top:

- `SOUL.md` for temperament and directives
- `IDENTITY.md` for the stable assistant identity
- `reference/model-playbook/overlays/` for model-specific behavior
- connector/channel rules for where the assistant speaks and how

This keeps one durable brain instead of fragmenting everything too early.

---

## Why Not Full Persona Splits Yet

A fully separate work persona and personal persona is a valid direction, but it adds real cost:

- duplicated config
- duplicated maintenance
- duplicated memory boundaries

The public repo should only claim what it can teach cleanly today. Right now that is:

- one shared base
- strong overlay patterns
- a path toward persona separation if your life genuinely needs it

---

## Useful Persona Axes

The ones that matter most in practice:

- tone and directness
- approval posture
- connector access
- what counts as “important enough to interrupt”
- content vs execution bias

Do not build five personas because you can. Build one base and one or two overlays because the workflows are actually different.

---

## Personal Pattern Examples

Patterns that fit well as persona overlays or optional channels:

- voice journal
- habit tracker
- personal morning brief
- listen mode
- content optimization
- cross-platform repurposing

These are better thought of as optional playbooks than as entirely separate brains.
