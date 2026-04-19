# Prompt Patterns — Our Hoard
**Purpose:** Working prompts and prompt fragments we know how to use. This is the "hoard" described in Agentic Engineering Patterns. Every solved problem gets a snippet here. Agents can read this file directly.
**Last updated:** 2026-03-10

---

## Coding Agent Kickoff (Universal)

Use at the START of any coding agent session against an existing project:

```
First run the tests to understand the codebase and get a baseline.
Then use red/green TDD for any new features — write failing tests first, confirm they fail, then implement until green.
```

**Why:** Forces test discovery, establishes testing mindset, protects against regressions.

---

## Coding Agent Kickoff (New Feature)

```
Use red/green TDD. Write the tests for [feature] first. Run them to confirm they fail (red phase). Then implement until all tests pass (green phase). Do not implement anything without a failing test that requires it.
```

---

## API Manual Testing

```
After implementing, test all API endpoints with curl. Try different inputs and edge cases. If anything fails, fix it using red/green TDD so the case ends up in the permanent test suite.
```

---

## Web UI Manual Testing (with agent-browser)

```
After building, test the UI:
  agent-browser open http://localhost:PORT
  agent-browser snapshot
Take screenshots of each main view. Look at them and verify the visual appearance is correct. Note any rendering issues.
```

---

## Single-File HTML Tool (No React)

Prevents agent from using React when you want a portable, copy-pasteable single file:

```
Build this as a single HTML file with vanilla JavaScript and CSS inline. No React, no npm, no build step. I want to be able to drag the file into a browser and have it work immediately.
```

---

## Linear Walkthrough (Understand Vibe-Coded Code)

```
Create a structured walkthrough of this codebase. Use sed/grep/cat to include actual code snippets — don't retype code manually. Explain what each key file does and how the pieces connect. Save to walkthrough.md.
```

**Use when:** You vibe-coded something and don't understand how it works. Or returning to a module after weeks away.

---

## Recombination (Combine Two Working Examples)

```
I have two working examples:
1. [Example A — describe or link]
2. [Example B — describe or link]

Build [new thing] by combining them. Use Example A for [part] and Example B for [part].
```

**Why:** Most powerful prompting pattern. Only need to solve each piece once.

---

## Repo Pattern Lookup

```
Search [path/to/reference/folder] for examples of [pattern/technology]. Use those examples as the basis for implementing [new thing].
```

---

## Debug Mode

```
Before fixing anything: read the error, form a hypothesis, then test the hypothesis. Do not change unrelated code. If the fix doesn't work, say so and form a new hypothesis.
```

---

## Claude Code Wrapper — Standard Invocation

```bash
# Example with a local wrapper:
echo "your task prompt here" | ./scripts/run-claude-code.sh /path/to/project

# Or with heredoc (preferred for multi-line):
cat <<'EOF' | ./scripts/run-claude-code.sh /path/to/project
First run the tests.
Then [task description].
Use red/green TDD.
Test with curl / agent-browser.
EOF
```

**NEVER** inline prompts as `codex exec "..."` or `claude -p "..."` — shell quoting breaks.

---

## Codex Wrapper — Standard Invocation

```bash
echo "your task prompt here" | ./scripts/run-codex.sh /path/to/project
```

Same rules apply — pipe prompt, don't inline.

---

## Interactive Algorithm Explanation

When a linear walkthrough isn't enough (structure is clear but algorithm isn't intuitive):

```
I understand the structure of the code but not how [specific algorithm] works intuitively. Build an animated HTML explanation that shows step-by-step how [X] works visually. Single HTML file, vanilla JS, no build step.
```

---

## PR Prep

Before submitting a PR with agent-generated code:

```
Review the diff. For each change:
1. Does it work? Have you run it?
2. Is it covered by tests?
3. Could it break anything existing?
4. Is the PR description accurate?

Write a short testing note I can include in the PR description describing how you verified this works.
```

---

## Codebase Documentation (per Feature)

Based on the "Documentation Handbook" pattern from r/ClaudeCode:

```
Create a documentation file for [feature] at documentation/[feature-name].md.

Include:
- Data model (fields, types, relationships)
- API endpoints (method, path, params, response)
- Business rules and validation logic
- Edge cases and error states
- State machine (if applicable)

Quality bar: a fresh Claude instance reading ONLY this file should be able to implement the feature correctly without touching source code.
```

---

*Add new patterns here as you discover them. This file is the agent knowledge base.*
