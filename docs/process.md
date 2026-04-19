# Process

How Clawrari itself gets built.

This project is not maintained with “random good ideas.” Features are extracted from real use, filtered, documented, and then packaged.

---

## The Cycle

Clawrari follows a five-step product loop:

`Discover → Define → Architect → Build → Ship`

### Discover

Find a real pattern in daily use, a failure, a repeated annoyance, or a community request.

### Define

Write the FRD. Stable requirement IDs, clear acceptance criteria, explicit scope.

### Architect

Write the blueprint or ExecPlan. Decide what gets packaged, what stays personal, and what needs templating.

### Build

Use coding agents for the implementation work. Review output against the plan.

### Ship

Update docs, release notes, the website, and the public framing. If the pattern is worth shipping, it should also be explainable.

---

## Where Features Come From

Most Clawrari features come from one of five sources:

1. Something useful we built for ourselves
2. Something that broke and forced a better guardrail
3. Something we learned from research or other builders
4. Something users asked for
5. A content gap that exposed missing packaging

The regression log is part of the backlog. So is the feedback channel.

---

## The Extraction Filter

Before a local pattern becomes a public Clawrari feature, it should pass four tests:

1. Is it generalizable?
2. Is it stable enough to teach?
3. Can we explain the why, not just the how?
4. Can it survive sanitization?

If the answer is no, it stays local.

---

## Packaging Rules

- Never copy private data into the public repo.
- File-first and local-first beats hidden automation.
- Opinionated defaults are good; invisible magic is not.
- Examples should teach the pattern, not leak the source context.
- A new feature is not finished until the docs and templates teach it.

---

## Current Shape

`v0.4.0` still ships as a single strong workspace with persona overlays and public patterns. A fuller work/personal split remains a design direction, not a claim of implementation.

That matters because Clawrari tries to document the real system, not a prettier imaginary one.
