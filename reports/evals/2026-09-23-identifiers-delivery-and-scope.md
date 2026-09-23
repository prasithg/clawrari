# Documentation Eval: Identifiers, Delivery, Backup Boundaries, and Verification Scope

## Header

- **Change under test:** Extend [Self-Improvement](../../docs/self-improvement.md) with lessons about saved identifiers, complete message delivery, generated retry inputs, quoted names, and backup boundaries. Refresh the verification-scope fields in the [agent prompt template](../../reference/agent-prompt-template.md#long-horizon-goal-spec).
- **Surface class:** Public documentation and one mapped prompt-template refresh.
- **Linked work:** [Changelog](../../CHANGELOG.md#2026-09-23). No separate implementation ticket; this change documents existing operational lessons.
- **Fault side:** Stale instruction data and missing harness checks. The documented repairs belong at the source reference, sender, backup boundary, or launcher, rather than in a generic reminder to the model.
- **Method:** Manual documentation walkthrough using the synthetic cases below. These are reasoned applications of the text, not executed service calls or runtime tests.

## Task Set and Baseline vs New

### Saved-Identifier Cases

| Task | Baseline guidance | Updated guidance | Result |
| --- | --- | --- | --- |
| A documented state ID resolves but belongs to another team | Section 17 checks the identity returned for an individual request | Audit the source document's expected type and ownership, then flag the wrong-team mapping | Pass: existence cannot establish correct routing |
| A documented ID no longer exists, or the lookup is unavailable | No source-inventory procedure distinguishes these outcomes | Report an invalid ID separately from unavailable evidence | Pass: a failed lookup does not become a false invalid-ID claim |
| A same-team project resolves but is archived | Stable identity alone cannot establish an appropriate default | Include lifecycle state and limit claims to the read-only evidence collected | Pass: no successful write is claimed |

### Delivery Cases

| Task | Baseline guidance | Updated guidance | Result |
| --- | --- | --- | --- |
| One send appears as several messages; the receipt omits a displayed part | Section 31 requires destination confirmation without describing split content | Read back complete ordered content, sender, and final instruction | Pass: receipt length alone cannot establish delivery |
| The next period changes dates inside generated identifiers | Retry guidance covers stable operation keys and interruption boundaries | Regenerate the input and retain meaningful identity, prior values, content, and source fingerprints | Pass: changing only the batch label is insufficient |
| Preview exits before reading the delivery record | Generic retry tests do not name this branch distinction | Exercise the production record-reading branch; require zero sends for an unchanged pending operation and an allowed send for a genuine change | Pass: preview evidence is not promoted to duplicate-suppression proof |

### Quoted-Content Cases

| Task | Baseline guidance | Updated guidance | Result |
| --- | --- | --- | --- |
| A saved report names a person without addressing them | No dedicated public rule distinguishes quoted names from recipients | Preserve the name as text and verify no unintended notification | Pass: quoted content stays intact |
| A quoted report also asks an owner to act | No explicit mixed-content case | Keep a verified mention token for the addressee | Pass: quoted mode does not promise zero notifications |
| Sender identity or a mention token cannot be verified | No description of the boundary for a quoted-content exception | Relax only the plain-name check; retain identity and token checks | Pass: the exception cannot disable unrelated protections |

### Backup Cases

| Task | Baseline guidance | Updated guidance | Result |
| --- | --- | --- | --- |
| An absolute link is rewritten as a relative link with the same escaping target | No specific archive-boundary procedure | Evaluate the resolved target against the archive's declared assets | Pass: a spelling change is not a boundary repair |
| A reconstructable environment moves outside the backup tree | No explicit dependency follow-through | Update callers and verify that the environment still runs | Pass: a working backup cannot hide a broken caller |
| Archive integrity passes, but restoration has not been attempted | No explicit distinction in this section | Record archive verification and restore testing separately | Pass: restoration remains untested |

### Delegation-Template Refresh

This is the only mapped artifact refreshed in this run. The source template contains a checked-scope field for verification-command paths and globs. The public version generalizes that field without requiring a workspace-specific wrapper or claiming it is installed.

| Task | Baseline guidance | Updated guidance | Result |
| --- | --- | --- | --- |
| A command passes against a similarly named, out-of-scope test directory | Commands and expected results are present, but checked paths are implicit | Compare command paths and globs with the declared verification scope | Pass: wrong-target success does not satisfy the requirement |
| A task needs a shared fixture outside the editable directory | Read scope is not distinguished from edit scope in the goal block | Declare the fixture as a required read without authorizing edits | Pass: the verification remains possible within the edit boundary |
| A launcher has no scope validator and the spec lists an external write | A written contract could be mistaken for runtime protection or authorization | Record manual review, test enforcement only where implemented, and require independent authorization for the write | Pass: neither enforcement nor authority is inferred from prose |

## Metrics

- Manual documentation cases: 15 reviewed, 15 consistent with the stated rules.
- Live external mutations executed for this evaluation: 0.
- Runtime tests added or executed for these documented patterns: 0.
- Scope: three edited public documents plus this evaluation.
- Qualitative result: the additions identify evidence that the earlier wording left implicit and preserve the limits of that evidence.

## Grader / Eval-Fault Check

These tables evaluate whether the instructions yield the intended decision in each synthetic case. They do not measure an agent's compliance or prove a production repair. A reviewer must not equate the fifteen walkthrough results with fifteen passing implementation tests.

The source work includes completed checks alongside unfinished rollout and scheduled observation. This public document does not claim that all callers changed, that a later scheduled run succeeded, or that concurrency and interrupted receipt writes are solved.

For identifier checks, false alarms cost investigation time. Keep unavailable service evidence distinct from a confirmed mapping error. For delivery checks, falsely treating partial readback as a failed send can cause duplicate publication; preserve the uncertain state.

## Publication Checks

- Added-text privacy review found no private organization names, identities, host paths, internal IDs, or private service links.
- All 14 added relative links and their heading targets resolved in a local check.
- An independent Claude reviewer found no privacy or evidence-claim blockers. Its wording finding about generated fields was corrected: normalization is limited to the separate duplicate comparison, and saved operations and authorization records stay intact.
- Writing checks evaluated body prose separately from Markdown headings, links, and template formatting. Social-message rules initially misclassified document markup; that mismatch was inspected rather than applied as a documentation-format rule. The prose check passed without blocking findings.

## Untested Surface

No live issue creation, message send, next-period scheduled run, backup restoration, or launcher rejection test was performed for this documentation change. Concurrent senders, receipt corruption, and successful delivery followed by a failed state write still need their own implementation tests.

The backup procedure depends on the archive tool's documented resolver and exclusions. This eval does not establish that every platform can use a copied interpreter or that every reconstructable environment is portable.

## Verdict

**ship** the documentation and single template refresh. This verdict covers clarity and scope of the public guidance, not adoption of any unshipped runtime fix.

## Artifact Path

The complete synthetic inputs and expected decisions are the fifteen rows in this file: `reports/evals/2026-09-23-identifiers-delivery-and-scope.md`. Public change summary: `CHANGELOG.md`, entry dated 2026-09-23. Private incident records, service identifiers, message contents, and host paths are excluded.

## Lessons Learned

Verify the evidence at the boundary where a claim can fail: ownership for a saved ID, rendered content for a send, regenerated operations for a retry, resolved targets for a backup, and checked paths for a verification command.

## Sign-off

- Run by: GPT-6 documentation agent.
- Date: 2026-09-23.
- Linked from: changelog, Self-Improvement sections, and the delegation template.
