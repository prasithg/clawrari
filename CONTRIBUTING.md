# Contributing

Clawrari is an opinionated reference config. Contributions should make the operating model sharper, not broader for its own sake.

Before opening a PR, skim [MISSION.md](MISSION.md), [ROADMAP.md](ROADMAP.md), and the [build playbook](docs/playbook.md) so the change lands inside the system's grain.

## Dev Setup

```bash
git clone https://github.com/prasithg/clawrari.git
cd clawrari
./bootstrap/init.sh
```

`bootstrap/init.sh` is idempotent and writes the memory skeleton plus core behavioral files. Run it once on a fresh clone to verify nothing in your change broke bootstrap parity.

If your change touches docs only, no setup is required — just edit the markdown.

## What Belongs Here

- workflows that have been used repeatedly in a real setup
- documentation that makes the system easier to adopt
- safer defaults
- clearer startup, memory, or review patterns
- connector guidance that improves reliability

## What Does Not Belong Here

- personal secrets, tokens, account IDs, or hostnames
- employer or customer-specific workflows
- purely theoretical prompts or configs
- giant kitchen-sink additions with no documentation

## Contribution Rules

1. Keep public-facing examples sanitized.
2. Explain the operational problem being solved.
3. Prefer one focused improvement per pull request.
4. Update docs when behavior changes.
5. If a pattern has not been used in practice, mark it clearly as experimental or keep it out.

## Pull Request Checklist

- documentation updated
- placeholders used instead of real identifiers
- no secrets or private customer references
- examples are copyable
- behavior is consistent with the Clawrari philosophy

## Issue Triage

Open an issue when you want to discuss a change before writing code, report a regression, or propose a workflow that needs design.

Useful issue shape:

- **Title:** short, problem-first (`bootstrap leaks raw conditional on macOS`, not `fix bug`)
- **Body:** what you ran, what you expected, what happened, environment context
- **Scope hint:** mention the affected area (`memory`, `bootstrap`, `crons`, `model-playbook`, etc.)

Small fixes — typos, dead links, doc clarifications — do not need an issue. Open a PR directly.

Larger or opinionated changes — new skills, restructures, behavior shifts — should start as an issue so the design conversation happens before the diff.

## Review Expectations

- Reviews come from a maintainer; turnaround is best-effort, not guaranteed.
- Expect questions about scope, defaults, and whether the pattern has been used in practice.
- A `changes-requested` review is not a rejection — it is the contract working.
- If a PR sits for more than a week with no movement, ping the issue (or open one) rather than rewriting silently.

Reviewers check:

- does the change satisfy the stated problem
- are docs updated alongside behavior
- are placeholders used instead of real identifiers
- is the change consistent with Clawrari's philosophy and the current roadmap

## Style Guide

- be direct
- prefer practical guidance over hype
- keep docs modular and linkable
- write for operators, not for marketing pages

## Suggested PR Shapes

- add one new documented workflow
- improve one existing playbook or architecture doc
- harden one config area and document the reason
- clarify one connector or safety pattern

If the change needs a long defense, it is probably too broad for one PR.
