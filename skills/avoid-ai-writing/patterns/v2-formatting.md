# patterns/v2-formatting.md — Mechanical Formatting Tells (v2 layer)

LLMs format consistently in ways humans don't. These rules catch mechanical formatting fingerprints.

## Spacing

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.01-double-space | P0 | `\.  ` (period followed by 2 spaces) | single space after period |
| v2.02-double-space-comma | P1 | `,  ` | single space after comma |
| v2.03-trailing-space | P1 | ` $` (trailing whitespace at end of line) | strip |
| v2.04-no-space-after-punct | P1 | `\.\w` (period directly followed by letter, no space) | add space |

**Rationale:** Double-space-after-period is a typewriter convention. Most humans on social platforms type single-space. LLMs trained on long-form prose default to double-space. This is one of the strongest non-lexical fingerprints.

## Punctuation

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.10-trailing-period-before-link | P1 | `\.\s+(https?://)` | drop the period before the link OR move it after |
| v2.11-exclamation-marks | P1 | `!` (any) | period unless genuinely exclamatory; cap at 1 per piece |
| v2.12-multiple-exclamations | P0 | `!!+` | single exclamation max |
| v2.13-ellipsis-as-trail | P1 | `\.\.\.\s*$` (line ending in ellipsis as a trail-off) | drop or commit to a sentence |
| v2.14-curly-quotes-mix | P1 | mixing `'` and `'` or `"` and `"` in same piece | normalize to one style |

## Capitalization

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.20-title-case-headings | P1 | `^[A-Z][a-z]+ [A-Z][a-z]+` heading-like line in body | lowercase or sentence case |
| v2.21-all-caps-emphasis | P1 | `\b[A-Z]{3,}\b` (3+ caps mid-sentence as emphasis) | use italics or just the word |
| v2.22-camelcase-leak | P1 | CamelCase product names invented (e.g. `WorkflowMiner`) when not actually a product | lowercase noun phrase |

## List shape

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.30-numbered-list-when-prose | P1 | numbered list 1. 2. 3. for non-sequential items | convert to bullets or prose |
| v2.31-three-bullet-default | P1 | exactly 3 bullets in a row, parallel structure | vary count or convert to prose |
| v2.32-bullet-period-default | P1 | every bullet ends with a period | drop terminal periods on noun-phrase bullets |
| v2.33-bullet-leading-bold | P1 | `\* \*\*[A-Z][a-z]+\*\*:` (bold lead-in pattern repeated 3+ times) | mix structures |

## Markdown leakage (chat-platform mrkdwn rules)

For surfaces that use a restricted markdown dialect (e.g. Slack mrkdwn), full markdown leaks as a tell.

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.40-md-headings | P0 | `^#+\s` headings in restricted-mrkdwn output | use `*bold*` instead |
| v2.41-double-asterisk-bold | P0 | `\*\*[^*]+\*\*` in restricted-mrkdwn output | single-asterisk `*bold*` |
| v2.42-pipe-tables | P0 | `\|.+\|` table rows in restricted-mrkdwn output | convert to bullets or prose |
| v2.43-md-link-format | P0 | `\[.+\]\(.+\)` in restricted-mrkdwn output | use the platform's native link syntax |

## Numbered-receipt cadence

| id | severity | pattern | rewrite |
|---|---|---|---|
| v2.50-round-number-receipts | P1 | every original opens with a specific count ("3 nights", "30 days", "12 times in 30 days", "50 entries in 60 days") | vary — sometimes lead with the observation, not the count |

This is structural-adjacent but lives here because it's a cadence pattern across pieces, not a per-piece tell. Detector: scan a batch of N pieces, flag if N>=3 of them open with a specific number-+-time-unit construction.

## Carve-outs

- Code blocks are exempt from spacing rules (preserve as-typed).
- Quoted source content is exempt — never edit the operator's own words.
- Receipts ARE part of the voice; the cadence rule is about variance across a batch, not individual pieces.

## How to use

The detector applies these regexes after v1. Same scoring math.
