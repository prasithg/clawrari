# GPT-5.6 Sol

**Runtime id:** `openai/gpt-5.6-sol` · **alias:** `sol`

## Routing

- **Sol, medium:** conversational/light GPT work and first cross-provider fallback for the default Opus route.
- **Sol, high:** normal reviewer, code-review, eval, and difficult coding model.
- **Sol, xhigh:** backup for Fable on hard autonomous work.

One model, three explicit effort tiers. Do not create another OpenAI-family alternate ladder.

## Prompt shape

GPT-5.6 responds well to compact XML control blocks. Use only the blocks the task needs:

```xml
<goal>Concrete outcome.</goal>
<scope>Files, systems, or evidence in bounds.</scope>
<acceptance_criteria>Observable completion checks.</acceptance_criteria>
<verification_loop>Run the checks before reporting done.</verification_loop>
```

For long coding work, include a scope fence, exact gates, invariants, and stop conditions. Use `scripts/run-codex.sh` for substantial repository work rather than large inline shell prompts.

## New/validated (official GPT-5.6 doc + community thread, cross-checked 2026-07-15)

Official doc: <https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6>. The thread's advice mostly matched the docs; the docs added the headline.

- **⭐ Simplify prompts first — leaner measurably wins on Sol.** OpenAI's internal coding-agent evals: trimming repeated rules/examples/redundant tool descriptions gave **+10–15% eval scores while cutting tokens 41–66% and cost 33–67%**. Remove one group at a time and re-run evals. Trim: repeated statements of the same rule, style/process instructions for behavior it already does reliably, examples that don't change behavior, unrelated tools. Keep: the outcome, success criteria + stopping conditions, safety/permission/evidence constraints, context-dependent tool-routing, required output shape. **Most skills/overlays are over-stuffed for Sol — this is the biggest lever.**
- **Check for contradictions.** GPT-5-class follows the prompt contract closely, so conflicting rules cause more instability than missing detail. Audit for contradictions after trimming.
- **Reserve absolutes for true invariants.** Use ALWAYS/NEVER/must/only only for real invariants (safety, required fields). For judgment calls (when to search/ask/use a tool/iterate), give decision rules, not absolutes.
- **Don't over-repeat approval rules.** A compact one-place autonomy policy stated once beats scattered "ask first"/"don't mutate" reminders — repetition triggers unnecessary approval pauses.
- **Detail level = `text.verbosity` param** (low/med/high default) + task-specific length in the prompt; don't lean on "be concise" spam. Set high on architecture, low on routine refactors.
- **Retrieval budget.** One broad search first; search again only when a required fact/owner/date/ID/source is missing or exhaustive coverage was asked — not to improve phrasing.
- **PTC is for record-reduction, not just many calls.** Use Programmatic Tool Calling only for bounded filter/join/sort/dedupe/aggregate/batch stages; state the bounded stage, eligible tools, output schema, retry limit, stop condition, and handoff back to direct calls. Multiple/parallel/dependent calls alone don't justify it. Test both the `program_output` and the final message.
- **Effort tier, not incantations.** Raise the tier for hard work; "think harder"/"pro mode" spam is noise (also in Failure modes).

## Failure modes

- Do not let polished structure substitute for completing the requested work.
- Do not leave Sol at medium where independent review or difficult coding is required; raise it to high.
- Do not claim tests passed without command evidence.
- Keep tool persistence explicit on multi-step research and build tasks.
- Do not over-stack "think hard"/"step by step" directives at high effort — set the effort tier and give clear constraints instead.
