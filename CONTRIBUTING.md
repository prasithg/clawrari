# Contributing

Clawrari is an opinionated reference config. Contributions should make the operating model sharper, not broader for its own sake.

## Before You Start

Clawrari isn't a typical OSS repo. It has an opinionated governance and cadence layer on top of the code — roles, decision protocols, and a commit-every-2-days mandate. **Read [`CHARTER.md`](CHARTER.md) first** so a contribution lands inside the operating model rather than against it.

A canonical "Linear-style workflow" doc (how tickets, decisions, and releases flow through the project) is planned for v0.5.x and will be linked here once it lands. Until then, the charter + this file are the authority.

## Filing Issues

- File bugs, feature requests, and feedback at **<https://github.com/prasithg/clawrari/issues>**.
- For bugs: include what you ran, what you expected, what happened, and your Clawrari version.
- For ideas: explain the operational problem first; the design proposal second.
- Triage SLA: 48h acknowledgement (per charter).

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
