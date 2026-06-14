# patterns/v1-lexical.md — Lexical AI-Tells (v1 layer)

Necessary but not sufficient. These are the surface-level vocabulary fingerprints that LLMs default to. Catching these is the easy part. The harder layers are v2 (formatting) and v3 (structural).

## Banned tokens

| id | severity | pattern | rewrite |
|---|---|---|---|
| v1.01-em-dash | P0 | `—` (em-dash, U+2014) | period, comma, or line break |
| v1.02-en-dash-misuse | P1 | en-dash `–` used as em-dash substitute | period or comma |
| v1.03-leverage | P0 | `\bleverage\b` (verb) | use, take advantage of, build on |
| v1.04-unlock | P0 | `\bunlock\b` as buzzword (not literal) | enable, allow, make possible |
| v1.05-delve | P0 | `\bdelve\b` | dig in, look at, explore |
| v1.06-tapestry | P0 | `\btapestry\b` | drop, use a concrete noun |
| v1.07-realm | P0 | `\bin the realm of\b` | in, around, with |
| v1.08-crucial | P0 | `\bcrucial\b` | important, key, or drop |
| v1.09-robust | P0 | `\brobust\b` (as filler) | reliable, hardened, or specify |
| v1.10-furthermore | P0 | `\bfurthermore\b` | also, plus, drop |
| v1.11-moreover | P0 | `\bmoreover\b` | drop or use also |
| v1.12-revolutionary | P0 | `\brevolutionary\b` | drop |
| v1.13-game-changing | P0 | `\bgame[- ]chang(ing|er)\b` | drop or use a concrete claim |
| v1.14-insane | P0 | `\binsane\b` (as hype) | drop or use a number |
| v1.15-massive | P1 | `\bmassive\b` (as hype) | use a number or drop |
| v1.16-mind-blowing | P0 | `\bmind[- ]blow(ing|n)\b` | drop |
| v1.17-next-level | P0 | `\bnext[- ]level\b` | drop |
| v1.18-significant-implications | P0 | `\bsignificant implications\b` | matters because, this means |
| v1.19-its-important-to-note | P0 | `\bit'?s important to note\b` | drop the throat-clear, just say it |
| v1.20-it-is-worth-noting | P0 | `\bit\s+is\s+worth\s+noting\b` | drop |
| v1.21-in-conclusion | P0 | `\bin conclusion\b` | drop |
| v1.22-to-summarize | P0 | `\bto summarize\b` | drop |
| v1.23-as-an-ai | P0 | `\bas an ai\b` | drop entire sentence |

## Banned openers

| id | severity | pattern | rewrite |
|---|---|---|---|
| v1.30-absolutely | P0 | `^Absolutely[!,.]` | just answer |
| v1.31-great-question | P0 | `^Great question[!,.]` | just answer |
| v1.32-happy-to-help | P0 | `^Happy to help` | just answer |
| v1.33-excited-to | P1 | `^Excited to\b` | drop intro, lead with the thing |
| v1.34-let-me | P1 | `^Let me\b` (as throat-clear) | just do it |
| v1.35-folks | P0 | `^Folks,` | drop |
| v1.36-hot-take-prefix | P0 | `^Hot take:\s` | just give the take |
| v1.37-unpopular-opinion | P0 | `^Unpopular opinion:\s` | just give the take |
| v1.38-buckle-up | P0 | `\bBuckle up\b` | drop |
| v1.39-are-you-ready | P0 | `\bAre you ready\b` | drop |

## Hashtag rule

| id | severity | pattern | rewrite |
|---|---|---|---|
| v1.40-no-hashtags | P0 | `#\w+` anywhere | strip all hashtags |

## Emoji rule

| id | severity | pattern | rewrite |
|---|---|---|---|
| v1.50-emoji-cap | P1 | >1 emoji per piece OR any emoji in first sentence | strip down to 0-1, never first-sentence |
| v1.51-thread-emoji | P0 | `🧵` for thread indicator | use `1/` numbering instead |
| v1.52-rocket | P1 | `🚀` | drop or replace with concrete word |

## Carve-outs

- "leverage" as a noun in a financial / physics context is fine.
- "unlock" as a literal verb (unlock your phone) is fine.
- "actual/real" carve-out lives in v3 (it's structural, not lexical).

## How to use

The detector runs each regex against the candidate text. Hits become `flags` entries. Each P0 flag = 1 P0 in the verdict math. Each P1 flag = 1 P1.
