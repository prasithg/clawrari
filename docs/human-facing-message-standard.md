# Human-Facing Message Standard

Agents spend most of their time surrounded by machinery: state IDs, rubric names, tool calls, retry counters, trace fields, and internal notes. Humans do not. When that machinery leaks into a chat update, Slack reply, or status note, the person reading it has to decode the system before they can decide what to do.

The standard is simple: **lead with plain English and the human action, then keep the machinery in the files built for machinery.** A human-facing message should answer "what happened, what do I need to do, and where is the evidence" before it exposes any internal labels. If the person needs no action, say that clearly too.

## The rule

Every human-facing agent message follows three constraints:

1. **Start with the human-readable outcome.** Say what changed, what is blocked, or what decision is needed in plain English.
2. **Name the human action early.** If the human must review, approve, choose, retry auth, or ignore the update, put that in the first sentence or short opening paragraph.
3. **Keep internals out of the message body.** State IDs, rubric codes, private ticket labels, tool names, prompt snippets, stack traces, and retry metadata belong in logs, traces, evals, or linked files. Reference the artifact path when useful; do not make the person read the internals inline.

This applies to chat responses, Slack updates, status pings, handoff notes, morning reports, and any other message meant for a person rather than a parser.

## Why it matters

Human-facing messages are part of the interface. A clear message lowers coordination cost; a machinery-first message moves that cost onto the reader. The failure mode is especially sharp in agent systems because internal labels often sound precise while carrying no useful instruction for the human.

Bad human update:

```text
MSG_GATE_17 failed during connector_status_update. Blocking on RETRY_AUTH with rubric plain_language_first.
```

Better human update:

```text
I could not finish because the connector session expired. Please reconnect the account, then rerun the validation. Details are recorded in the run log.
```

The second message still preserves the evidence, but it does not make the human translate internal shorthand before acting.

## What stays in files

Internal details are not banned. They are just routed to the right surface.

- **Logs and traces** keep state IDs, tool calls, retries, timings, token usage, and raw errors.
- **Eval artifacts** keep rubric names, task IDs, pass/fail details, and evidence tables.
- **Issue trackers and PRs** keep implementation context, branch names, and commit references.
- **Human messages** keep the outcome, the requested action, and the path to the evidence when the reader needs it.

If an internal label is the only precise way to identify the issue, translate it first and put the label second:

```text
The draft failed the plain-language gate. The detailed eval records this as `message_leads_with_internal_code`.
```

## Enforcement

Treat violations as small defects and fix them on sight. The standard is cheap enough to enforce during normal review:

- Scan the first sentence of every human-facing message. If it starts with a code, tool name, state name, or internal label, rewrite it.
- Ask whether the reader can tell what to do without opening a log. If not, add the human action.
- Move raw machinery into the linked artifact rather than deleting it. The goal is routing, not hiding evidence.
- Add this check to message templates, Slack responders, status reporters, and completion summaries that agents reuse.

A useful review prompt:

```text
Does this message lead with plain English and the human action, while keeping internal machinery in logs or linked artifacts?
```

When the answer is no, the fix is usually one sentence: translate the internal event into the reader's next step, then link the evidence.

## See also

- [Agent Observability](observability.md) - where raw run evidence, metrics, and gaps should live.
- [The Harness](harness/README.md) - the operating layer that turns rules like this into repeatable checks.
- [Eval Scorecard](harness/eval-scorecard.md) - the honesty rule for reporting only what the system can actually ground.
