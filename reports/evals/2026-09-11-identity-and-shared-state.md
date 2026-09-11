# Record identity and shared-state documentation evaluation

## Change under test

The [self-improvement guide](../../docs/self-improvement.md#17-verify-the-identity-returned-by-a-lookup) adds response-identity checks and version-aware handling of shared settings. Surface: operating guidance. This is a scheduled public distillation of observed work; no new feature ticket or deployed wrapper is claimed.

Faults addressed: a tool resolving a locally unique number across namespaces, and callers attributing another writer's settings change to their own command. Identity validation belongs at the tool boundary. Write coordination belongs in the caller or service.

## Task set and baseline comparison

These are **manual, simulated procedure cases**, applied to the written instructions. They are not live service calls or evidence that an agent always follows the text. All identifiers below are synthetic.

| Case | Prior public guidance | Result with the added guidance | Result |
| --- | --- | --- | --- |
| Request `OPS-42`; receive `WEB-42` first and `OPS-42` second. | No explicit response-identity check. | Select the exact `OPS-42` record, then use its stable ID. | Pass |
| Request `OPS-42`; receive only `WEB-42`. | No explicit no-match stop. | Keep the lookup unresolved; perform no downstream write. | Pass |
| Receive two records both claiming `OPS-42`. | No explicit duplicate-identity stop. | Require one exact match; investigate the ambiguity. | Pass |
| A record identifier is unique only inside one project. | Namespace scope was unspecified. | Check project or tenant as well as the identifier. | Pass |
| A settings revision moves between snapshot and pre-write check. | Public guidance covers isolated working trees, but not shared remote settings. | Stop and reconcile; do not restore the older snapshot. | Pass |
| The service omits the revision. | Missing-version behavior was unspecified. | Treat ownership as unproven; do not overwrite shared state from that snapshot. | Pass |
| A competing write occurs after the client-side check. | No stated check/write race limit. | Recognize the gap; require atomic conditional writes or serialized ownership for exclusion. | Pass |

## Observed regression evidence

The existing local concurrency helper was also exercised on 2026-09-11. Its six automated tests passed with zero failures. They cover extracting the revision, detecting changed or missing targets, an unchanged snapshot, rejecting a moved revision, applying an uncontested change and refreshing the snapshot, and a missing snapshot file.

That run supports the pre-write conflict-detection pattern. The source-specific helper is not ported in this change. The public instructions explicitly state that a separate read and write are not atomic. The identity lesson comes from an observed multi-namespace lookup response; an earlier wrong-record lookup did not reproduce on its later check, so the text makes no claim that the fault occurs on every call.

## Metrics

- Procedure coverage: 7/7 simulated cases have an explicit safe outcome in the changed text.
- Existing local concurrency regression suite: 6 passed, 0 failed.
- Added live API calls for this evaluation: 0.
- Additional work when adopted: identity comparisons and a revision read; callers bear this cost. Conflicts require reconciliation but do not automatically notify a person.

## Grader and evaluation-fault check

A correct lookup on one attempt cannot disprove an intermittent resolver fault. A green revision-check test cannot prove atomicity. Success here means the documentation describes the right boundary and its limits, not that every client or service enforces them. No performance or reliability threshold was weakened.

## Untested surface

No live record writes, concurrent production updates, service-specific conditional-write APIs, tenant migrations, or model adherence trials were run. The document introduces guidance, not a deployed identity-checking wrapper or a portable concurrency implementation.

## Verdict

**Ship as documentation.** Both lessons add missing failure handling, retain the uncertainty in the observations, and separate written instructions from mechanical enforcement.

## Evidence and sign-off

The seven-case comparison and regression-run summary above are the public evaluation artifact. Private source records and raw service output are deliberately excluded.

- Run by: documentation maintainer, GPT-6 Astra.
- Date: 2026-09-11.
- Linked from: [Changelog](../../CHANGELOG.md#2026-09-11).
