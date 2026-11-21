# Identity checks and separate completion evidence

## Scope

Documentation review of the lookup guidance and one mapped agent prompt template. The source lessons concern callers accepting the wrong record and prompts separating implementation, validation, and handoff. No private implementation, identifiers, or logs are included.

## Identity cases

These are manual instruction walkthroughs against the previous public wording.

| Input | Previous guidance | Revised instruction | Result |
| --- | --- | --- | --- |
| Correct identifier, wrong team | Ownership check conditional on uniqueness | Require independent ownership match | Pass |
| Correct identifier, missing team | Missing ownership not explicit | Keep unresolved | Pass |
| Duplicate exact matches | Reject duplicates | Retain rejection | Pass |
| One exact match, correct team and usable fields | Accept verified record | Retain acceptance | Pass |
| Repaired helper, unchecked direct caller | No explicit caller inventory | Inventory downstream callers | Pass |

## Completion cases

| Situation | Previous guidance | Revised instruction | Result |
| --- | --- | --- | --- |
| Files written, entry point untested | General acceptance checks | Keep validation separate and incomplete | Pass |
| Checks pass, required handoff absent | Handoff requested | Keep handoff separately incomplete | Pass |
| Normal output passes, empty result untested | Relevant checks requested | Check empty-result behavior where applicable | Pass |
| Excluded file changed | Scope restrictions | Explicitly confirm excluded files unchanged | Pass |
| Required validation unavailable | Keep blockers visible | Preserve blocker and name untested behavior | Pass |

## Evaluation limits

Ten of ten manual cases have explicit supporting instructions. This is documentation coverage, not an executed connector test, agent-behavior measurement, or independent review. The author checked both the baseline and revised wording; that review can miss ambiguity.

A false rejection can stop useful work when ownership evidence is missing. Obtain the required evidence rather than weakening the identity check. Runtime enforcement, live delivery, concurrent edits, and caller completeness remain untested here.

Verdict: publish the bounded documentation update. No executable behavior is changed.

Run by: Codex. Date: 2026-11-21.

Lesson learned: matching labels and passing checks each need independent evidence for the conclusion drawn from them.
