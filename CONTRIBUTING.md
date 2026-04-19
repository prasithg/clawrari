# Contributing

Clawrari is an opinionated reference config. Contributions should make the operating model sharper, not broader for its own sake.

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
