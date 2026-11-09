# Memory changes, event delivery, and background work

## Header

- **Change under test:** four additions to the [self-improvement guide](../../docs/self-improvement.md) and a targeted refresh of the [generic-opener rule](../../skills/avoid-ai-writing/patterns/v1-lexical.md#generic-reaction-openers).
- **Surface class:** documentation and skill rule data.
- **Linked work:** the [November 9 change record](../../CHANGELOG.md#2026-11-09). No separate issue is required for this documentation update.
- **Fault side:** writing-process observability, event delivery, process launch, and saved-data replacement. These are implementation boundaries; prose alone does not enforce them.

## Task Set and Method

Review sixteen synthetic scenarios against the previous and revised instructions. Run the published opener expression against eighteen synthetic strings. The scenario review is a manual documentation check by the author, not an executed production test or independent review. Baseline findings come from reading the previous documents, not running an old implementation.

The earlier guide already distinguishes failed requests from empty results, discusses waiting limits, and requires exact historical exceptions. This update adds the missing consequences for saved-data replacement, process-group survival, and exception identity after a subsequent write. The prior lexical table has no generic-reaction rule.

## Memory Cases

| Case | Earlier guidance | Revised guidance | Review result |
| --- | --- | --- | --- |
| Consecutive write hashes agree and the file matches | General preservation and exception advice | Compare both record continuity and current content | No unexplained difference; pass |
| File changes without a recorded write | No specific current-file comparison | Compare current hash with the last completed result | Report a difference; pass |
| Reviewed file difference becomes historical after a normal write | Exact exceptions required, but observation changes unspecified | Keep file, preceding write, and hash pair stable | Preserve the existing exception; pass |
| A different unrecorded edit follows that write | No explicit next-operation control | Require a new finding for a different hash or later gap | Do not exempt the file; pass |
| First measurement exists for an unrecorded file | No size-baseline procedure | First measurement establishes comparison data only | No claim about earlier preservation; pass |

## Event Cases

| Case | Earlier guidance | Revised guidance | Review result |
| --- | --- | --- | --- |
| Author and recipient are the same runtime session | No specific self-event filter | Skip before delivery and record processing | Avoid a repeated notification; pass |
| A human or another session writes an update | No specific filter boundary | Preserve updates that are not confirmed self-events | Deliver normally; pass |
| One event has its author and another subscriber as recipients | No recipient-specific instruction | Decide separately for each recipient | Skip only the author; pass |
| A job label resembles the owner's identity | No explicit identity distinction | A label or shared account is insufficient | Keep uncertain events eligible; pass |

## Background Cases

| Case | Earlier guidance | Revised guidance | Review result |
| --- | --- | --- | --- |
| Child changes parent but keeps the caller's process group | Waiting guidance asks whether work survives | Verify group separation and caller-group termination | Parent change alone is insufficient; pass |
| Launcher returns success but no matching start record exists | No bounded start-confirmation procedure | Require liveness and the matching record | Do not claim confirmed startup; pass |
| A simulated worker survives termination | Simulated and real completion already distinguished | Preserve that distinction in the launch procedure | Real workload completion remains unverified; pass |

## Collection Cases

| Case | Earlier guidance | Revised guidance | Review result |
| --- | --- | --- | --- |
| Failed request yields no usable records | Report the request as unavailable | Also preserve saved data | No empty overwrite; pass |
| Partial collection contains some records | Validate scope and pagination | Require a defined partial-result replacement policy | Nonempty alone is insufficient; pass |
| Successful collection is empty without a clearing policy | Report zero only after successful collection | Empty collection alone does not authorize clearing | Preserve the prior list; pass |
| A validated empty collection has explicit clearing authority | No explicit replacement policy | Apply the authorized empty-replacement rule | Clearing is permitted under that policy; pass |

## Writing Cases

Run this command from the repository root. It extracts the expression from the published table, removes Markdown table escaping, and tests the expression itself.

```sh
node --input-type=module <<'JS'
import { readFileSync } from 'node:fs';
const file = 'skills/avoid-ai-writing/patterns/v1-lexical.md';
const row = readFileSync(file, 'utf8').split('\n').find(x => x.startsWith('| v1.41-'));
const pattern = row.split(String.fromCharCode(96))[1].replaceAll('\\|', '|');
const rule = new RegExp(pattern, 'i');
const cases = [
  ['Great to see this.', true],
  ['Love this!', true],
  ['Love it.', true],
  ['Great post.', true],
  ['Great share.', true],
  ['Great insight.', true],
  ['Great insights.', true],
  ['Thanks for sharing,', true],
  ['Well said.', true],
  ['Spot on.', true],
  ["Couldn't agree more.", true],
  ['So true.', true],
  ['This is so true.', true],
  ['great post.', true],
  ['The retry diagram explains the timeout.', false],
  ['The sample says Love this! near its end.', false],
  ['Great posting guidance needs examples.', false],
  ['Love this project because its logs are readable.', false],
];
for (const [text, expected] of cases) {
  if (rule.test(text) !== expected) throw new Error('Unexpected match: ' + text);
}
console.log('18/18 expression cases passed');
JS
```

The final case demonstrates the punctuation boundary; extending the phrase is outside this expression. The rule does not identify all generic praise. No author-specific exemption or preference data is included.

## Metrics and Evaluation-Fault Check

- Manual documentation review: 16 of 16 scenarios have the required outcome.
- Expression checks: 18 of 18 passed. Observed output: `18/18 expression cases passed`. Command exit: 0.
- Production code changed: none.
- Mapped artifacts refreshed: one skill directory. Other source differences remain for later review.
- False-alarm cost: a legitimate generic compliment can require an editorial rewrite. The rule describes a writing preference, not proof of automated authorship.
- Negative cases preserve other recipients, valid clearing authority, specific observations, and quotes away from the opener. The review does not equate silence with success or a historical exception with repaired data.

## Untested Surface

No live file writer, event poller, detached production job, collector, or operator-supplied writing detector ran for this update. Manual scenarios show that the instructions contain the intended decisions; they do not prove implementation behavior. The expression checks prove only the documented match boundary. Human writing preference and production false-positive rates remain unmeasured.

## Verdict

**Ship as documentation and tested expression data.** Operational verification remains the responsibility of each implementation. No live reliability or writing-quality improvement is claimed.

## Artifact Path and Sign-off

The synthetic inputs, expected results, runnable command, and observed output are retained in this report. The change record links here.

- Run by: the documentation author using GPT-6.
- Date: 2026-11-09.
- Lessons learned: test the next normal operation after accepting historical state; check event identity per recipient; distinguish process survival from completion.
