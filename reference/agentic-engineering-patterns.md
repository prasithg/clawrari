# Agentic Engineering Patterns
**Source:** Simon Willison's Living Guide — https://simonwillison.net/guides/agentic-engineering-patterns/
**Extracted:** 2026-03-10
**Status:** Full extraction — all 8 sub-pages synthesized with Claw's annotations

---

## Why This Matters

> "The biggest challenge in adopting agentic engineering practices is getting comfortable with the consequences of the fact that writing code is cheap now."

Code generation is nearly free. *Good* code is not. The new job is orchestration, taste, and quality control — not typing.

---

## 1. Writing Code Is Cheap Now

**Core tension:** Writing a few hundred lines of tested, clean code used to take a developer a full day. Our entire engineering culture (planning, estimation, feature prioritization, "is this worth building?") is built around that constraint. Agents break it.

**What's now cheap:**
- Parallel implementation (one human, multiple agents working simultaneously)
- Prototyping branches you'd have deprioritized
- Adding tests, docs, debug interfaces you'd have skipped

**What's still expensive — "Good Code":**
- Code that actually works (not just looks like it does)
- Handled error cases, not just happy path
- Covered by tests that act as regression suite
- Documented and reflects current state (update docs when code changes)
- Simple and minimal — YAGNI still applies
- Accessible, testable, observable — the "ilities"
- Design that affords future changes without over-engineering

**Claw's takeaway:** When the instinct is "not worth the time" — fire off a prompt in an async agent session anyway. Worst case: check 10 minutes later, it wasn't worth the tokens. Best case: it's done.

**Our adoption:** local Claude/Codex wrappers are a clean async agent dispatch. Use them instead of over-deliberating.

---

## 2. Hoard Things You Know How To Do ⭐ TOP PRIORITY

**The pattern:** Collect working code examples for specific problems. The more answers you have to "can X be done, and how?", the more opportunities you spot. Knowing something is *theoretically possible* is not the same as *having seen it done*.

**Simon's methods:**
- Blog / TIL blog crammed with solved problems
- 1,000+ GitHub repos — many are small proof-of-concepts
- `tools.simonwillison.net` — single-file HTML tools (no build step)
- `github.com/simonw/research` — complex research reports with working code

**The recombination superpower:**
> Tell an agent to build something new by combining two or more existing working examples.

Example: "I have Tesseract.js snippets and PDF.js snippets — combine them into a browser OCR tool." One prompt, zero iteration, fully working.

**With coding agents:**
- Point agent at a repo with working examples: `git clone /tmp && use this as input`
- Agent does sub-search to find relevant patterns
- Key idea: **you only need to figure out a useful trick once.** Document it, and your agents can use it forever.

**🔧 Our `reference/` folder IS our hoard.** This file is part of it.
- Every solved problem → add to `reference/`
- Every working script → document the invocation pattern
- Every integration trick → note it in TOOLS.md

**Immediate action items for our setup:**
- [ ] Add working example prompts to `reference/prompt-patterns.md` (start with our best Claude Code prompts)
- [ ] Maintain `reference/` as the agent knowledge base — not just for Claw, but for every Codex/Claude Code sub-agent we spawn

---

## 3. Anti-Patterns: Things to Avoid

### ❌ Inflicting unreviewed code on collaborators

Don't open PRs with agent-generated code you haven't reviewed yourself. You're delegating *your* work to the reviewer.

**A good agentic PR:**
- Code works — you've confirmed it
- Small enough to review efficiently (multiple small PRs > one massive one)
- Includes higher-level context: why this change, link to relevant spec/issue
- PR description is reviewed by you too — agents write convincing but sometimes wrong descriptions
- Evidence of manual testing: notes, screenshots, video

**🔧 Our rule (already in SOUL.md):** Agent reviews agent output before presenting it to the operator. Include manual test notes whenever the work will be handed to another human.

---

## 4. Red/Green TDD ⭐

**The pattern:** Write failing tests first → confirm they fail (red) → implement until tests pass (green).

**Why it works with agents:**
- Agents risk writing code that never gets exercised
- Agents risk building code that *was already working* (tests pass vacuously)
- Test-first eliminates both risks
- Comprehensive test suite = regression protection as codebase grows

**Prompt shortcut:** Every good model understands `"use red/green TDD"` as shorthand for the full workflow.

**Example prompt:**
```
Use red/green TDD to implement [feature]. Write the tests first, run them to confirm they fail, then implement the feature until the tests pass.
```

**🔧 Adoption:** Always include "use red/green TDD" in coding agent prompts for non-trivial features.

---

## 5. First Run the Tests

**The pattern:** Every new coding agent session against an existing project should start with running the test suite.

**Why:**
- Forces the agent to discover *how* to run tests (makes it more likely to run them throughout)
- Gives a proxy for codebase size/complexity (number of tests)
- Establishes a testing mindset — agent naturally adds tests later
- Tests serve as documentation: agents find and read them to understand features

**Prompt shortcut:** `"First run the tests"` — 4 words that encode substantial software engineering discipline.

**Python shortcut (Simon's setup):**
```
uv run pytest
```

**🔧 Our wrapper scripts should include:** "First, run the existing tests to understand the codebase, then use red/green TDD for any new features."

---

## 6. Agentic Manual Testing

**Core principle:** Never assume agent-generated code works until it's been *executed.* Tests passing ≠ code working.

**Mechanisms by context:**

| Code type | Testing approach |
|-----------|-----------------|
| Python library | `python -c "import module; module.function()"` |
| CLI tool | Direct execution, vary inputs |
| JSON API | `curl` — tell agent to "explore" the API (covers lots of ground fast) |
| Web UI | Browser automation: **Playwright** or **agent-browser CLI** |

**Browser automation:** `agent-browser` (Vercel, already installed globally) is the right tool for our web UIs.
```
# After building component:
agent-browser open http://localhost:3000
agent-browser snapshot  # accessibility tree view
```

**The pattern for bugs found via manual testing:**
> Fix it with red/green TDD → ensures the case gets permanently covered by automated tests.

**🔧 Our agent prompts should include:**
- For APIs: `"After implementing, test all endpoints with curl. Fix any issues found with red/green TDD."`
- For web UI: `"Use agent-browser to verify the UI renders correctly. Screenshot and snapshot each main view."`

---

## 7. Linear Walkthroughs

**The pattern:** Ask a coding agent to produce a structured, documented walkthrough of a codebase — especially code you vibe-coded and don't fully understand.

**Why it matters:** Vibe coding creates cognitive debt. Linear walkthroughs pay it down.

**Simon's tool: Showboat** (`showboat note` + `showboat exec` to build a self-documenting walkthrough)
- Forces agent to use `sed/grep/cat` to embed real code snippets (no hallucination risk)
- Output: a markdown file with code + explanation walking through each file

**Prompt pattern:**
```
Create a detailed walkthrough of this codebase using showboat. For each key file, use sed/grep/cat to include actual code snippets rather than retyping them. Explain what each part does and how the pieces fit together.
```

**🔧 Apply this to:** Any feature-rich repo you have not reviewed in a while.

---

## 8. Interactive Explanations

**The pattern:** When a linear walkthrough isn't enough (you understand the structure but not the algorithm), ask the agent to build an **animated or interactive explanation**.

**Example:** Simon didn't understand "Archimedean spiral placement" in a word cloud algorithm. Linear walkthrough helped with structure. Animated HTML explanation made the algorithm *click*.

**The prompt pattern:**
```
I understand the structure from the walkthrough but don't have an intuitive feel for [specific algorithm/behavior]. Build an animated HTML explanation that shows visually how [X] works step by step.
```

**Why it works:** Claude Opus has good taste for explanatory animations. Single-file HTML = easy to share, no build step.

**🔧 Apply to:** Complex matching algorithms, state machines, or any algorithm you need to present clearly but did not write yourself.

---

## Prompts Reference (Simon's Patterns)

### No-React Artifacts
Prevents agent from using React (requires build step) when prototyping HTML tools:
```
Build this as a single HTML file with vanilla JavaScript and CSS. No React, no build step — I want to be able to copy the file to static hosting directly.
```

### Proofreader
Simon's rule: LLMs can proofread but not ghost-write. His voice = his words.
*(Same rule for personal content: drafts yes, publishing without review never.)*

### Agent Manual Testing (API)
```
After implementing, test all the API endpoints using curl. Explore different inputs and edge cases. If you find anything that doesn't work, fix it with red/green TDD.
```

### Agent Manual Testing (Web UI with agent-browser)
```
Test the UI with: agent-browser open http://localhost:PORT && agent-browser snapshot. Take screenshots of each main view and look at them to verify the visual appearance is correct.
```

---

## Top 3 Patterns for Immediate Adoption

1. **Hoard working examples** — Start `reference/prompt-patterns.md` today. Every solved problem gets documented with a working example. This is how we compound capability across sessions and agents.

2. **Red/Green TDD in every coding prompt** — Add `"use red/green TDD"` to our standard coding agent wrapper scripts (or at minimum, every manually crafted prompt for non-trivial features).

3. **First Run the Tests** — Add to our coding agent task templates: "First, run the existing tests to get a sense of the codebase. Then use red/green TDD for new work."

---

## Claw's Annotations

**[observed]** The "hoard" pattern explains why our `reference/` folder has been underutilized. We've been solving the same kinds of problems repeatedly without capturing the solutions for future agents.

**[contrarian]** "Good code still has a cost" is often ignored in the AI hype. The *generation* is cheap; the *judgment* isn't. This means the bottleneck shifts from typing to taste — which is actually hard to automate.

**[inferred]** Simon's guide is implicitly about building a second brain for your agents, not just yourself. The TIL blogs and GitHub repos are as much for future Claude Code sessions as they are for Simon's own memory.

**[speculative]** The "interactive explanations" pattern is powerful for content too — turn complex AI or agent concepts into animated HTML explainers as reusable assets.
