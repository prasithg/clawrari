# Support

Clawrari is an opinionated reference config for running OpenClaw well. This page is the map for getting help, reporting problems, and asking the right question in the right place.

Before anything else: Clawrari is configuration and documentation, not a hosted service. There is no support inbox and no SLA. What you get is a clear set of channels and a few habits that make help fast to give.

## Start Here

Most questions are already answered. Check these first, in order:

1. [`README.md`](README.md) — what Clawrari is and is not.
2. [`docs/playbook.md`](docs/playbook.md) — the canonical install-and-adopt guide.
3. [`docs/index.md`](docs/index.md) — the documentation map.
4. [`docs/architecture.md`](docs/architecture.md) — how the pieces fit together.
5. The [OpenClaw docs](https://docs.openclaw.ai) — for anything about the underlying runtime rather than Clawrari's opinions on top of it.

If your question is "how do I make OpenClaw do X," it usually belongs in the OpenClaw docs. If it is "how does Clawrari approach X," it belongs here.

## Where to Ask

| You want to... | Use |
| --- | --- |
| Report a bug or broken example | [GitHub Issues](https://github.com/prasithg/clawrari/issues) — bug report template |
| Request a pattern or doc | [GitHub Issues](https://github.com/prasithg/clawrari/issues) — feature request template |
| Ask an open-ended question | [GitHub Discussions](https://github.com/prasithg/clawrari/discussions) (if enabled) or an issue labeled `question` |
| Propose a change | A pull request — read [`CONTRIBUTING.md`](CONTRIBUTING.md) first |
| Report a security or secret-leak concern | See [Security](#security) below — do **not** open a public issue |

## Filing a Good Issue

The fastest way to get unblocked is to make the problem reproducible. A good report includes:

- **What you did** — the command, config change, or doc step you followed.
- **What you expected** — the behavior the docs implied.
- **What happened** — the actual result, with exact error text (redact secrets).
- **Environment** — OpenClaw version, OS, and which Clawrari version/commit you are on.
- **Scope** — is this a Clawrari opinion that is wrong/unclear, or an OpenClaw runtime issue?

One problem per issue. Bundled reports are slow to triage and slow to close.

## What Is In Scope

Clawrari support covers:

- the documented patterns, workflows, and defaults in this repo
- the reference configs, templates, and skills shipped here
- guidance that makes adopting the operating model easier

It does **not** cover:

- debugging your private, employer-specific, or customer-specific workflows
- the OpenClaw runtime itself (route those upstream)
- one-off configs that have never been used in a real setup

This mirrors [`CONTRIBUTING.md`](CONTRIBUTING.md): Clawrari stays a sharp, opinionated reference, not a catch-all.

## Response Expectations

This is a maintainer-driven open-source project. Triage target is best-effort acknowledgement within a few days, not a guaranteed turnaround. Clear, reproducible reports get answered first. "It doesn't work" with no detail will get a request for detail before anything else.

## Security

Do not report secrets, tokens, or vulnerabilities in a public issue. If you find a leaked credential in the repo or a security concern with a documented pattern, contact the maintainer privately through GitHub rather than opening a public issue. Then we coordinate a fix and, if needed, a credential rotation. Sanitization rules live in [`CONTRIBUTING.md`](CONTRIBUTING.md) — placeholders only, never real identifiers.

## Contributing Back

The best support outcome is a fix that helps the next person. If you solved your own problem, consider sending a PR that clarifies the doc or hardens the default that tripped you up. See [`CONTRIBUTING.md`](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).
