# Contributing to Clawrari

First off — thanks for being here. Clawrari is one person's production setup, open sourced so others can build on it. Contributions should enhance, not dilute.

## Ground Rules

This is an opinionated project. That's the point. PRs that add 47 configuration options where there's currently one good default will be respectfully declined.

**Good contributions:**
- Bug fixes
- Documentation improvements
- New component docs with real substance
- Bootstrap improvements
- New skill recommendations (battle-tested, not theoretical)
- Security hardening

**Not what we're looking for:**
- "Make it configurable" PRs that add complexity without clear value
- Generic templates that water down the opinionated voice
- AI-generated docs that read like AI-generated docs

## How to Report Issues

1. Open a [GitHub issue](https://github.com/prasithg/clawrari/issues)
2. Describe what's broken and what you expected
3. Include your environment (OS, OpenClaw version) if relevant
4. If it's a bootstrap issue, include the error output

## How to Suggest Features

1. Open an issue with the `enhancement` label
2. Explain the use case — not just "add X" but "I need X because..."
3. Bonus: explain how it fits the existing architecture

## How to Submit PRs

1. Fork the repo
2. Create a branch (`feature/your-thing` or `fix/the-bug`)
3. Make your changes
4. Write a clear commit message (what and why, not just what)
5. Open a PR against `main`
6. Describe what changed and why

## Code Style

- **Keep it simple.** Bash for scripts, Markdown for docs. No build tools, no frameworks.
- **Be substantive.** No "coming soon" stubs. If you write a doc, make it real.
- **Match the voice.** Sharp, direct, opinionated. Read the README to calibrate.
- **Test the bootstrap.** If you change `init.sh`, run it on a clean workspace.

## Questions?

Open an issue or reach out to [@prasithg](https://x.com/prasithg).
