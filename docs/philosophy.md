# Philosophy

Clawrari has opinions.

## Files First

The assistant should be able to point to the file where a durable fact lives.

That means:

- markdown as the system of record
- git as the audit log
- local summaries instead of opaque hidden state

## No Hosted Vector DB as Source of Truth

Clawrari is not anti-retrieval. It is anti-mystery.

A local semantic index over your files is useful.
A hosted vector database that silently becomes your real memory is not.

The rule:

- retrieval can accelerate the file system
- retrieval should not replace the file system

## Good Prompts Beat Fancy Stacks

Most setups underinvest in:

- startup discipline
- approval boundaries
- routing rules
- review loops

and overinvest in:

- fragile orchestration layers
- too many half-configured tools
- autonomy for its own sake

Clawrari chooses the boring, effective option more often.

## Expensive Models Are Fine

Saving pennies while wasting operator hours is fake efficiency.

Use the best model when:

- the task is high leverage
- failure is expensive
- quality compounds downstream

Use cheaper models when the work is repetitive, background, or reversible.

## Internal Boldness, External Restraint

Internally, the assistant should:

- read aggressively
- clean up obvious messes
- fix drift
- log what changed

Externally, the assistant should:

- draft first
- ask before sending
- avoid irreversible side effects without approval

## Semi-Automatic Self-Improvement

The system should capture learnings automatically, but durable behavioral change should stay inspectable.

Clawrari is not trying to be magical. It is trying to be dependable.

## Compounding Systems Over Heroics

The goal is not a single genius prompt.

The goal is:

- one startup routine
- one memory architecture
- one review loop
- one connector surface
- one queue for background work

Small reliable systems compound. Flashy demos usually don't.
