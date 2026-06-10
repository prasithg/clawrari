# Monthly Retrospective Template

Clawrari monthly retro. Three variants: X thread (8-12 posts), LinkedIn long-form (600-900 words), and a short-form summary paragraph for newsletters/digests.

---

## X Thread Variant (8-12 posts)

**Hook formula:** Proof Hook (hooks.md #2)
> `[Metric] went from [Before] to [After] in [Timeframe]. Here's [what changed / how].`

Alternative: Behind-the-Scenes Hook (hooks.md #6) if the month's story is more qualitative than metric-driven.

```
1/ {hook_line — lead metric or strongest proof point from the month}

2/ Clawrari {month} retro. What shipped, what we learned, what's still broken. Thread.

3/ SHIPPED:
{shipped_1 — artifact + link}
{shipped_2}
{shipped_3}

4/ {shipped_4-7 if applicable, or deeper detail on a key ship}

5/ LEARNED:
{lesson_1 — specific, <=2 sentences}

6/ {lesson_2}

7/ {lesson_3}

8/ BROKEN:
{broken_1 — what's still wrong, no sugarcoating}
{broken_2 — if applicable}

9/ NEXT MONTH'S BETS:
{bet_1 — with verifiable end-state}
{bet_2}
{bet_3}

10/ {optional: metric snapshot — stars, contributors, commits, users}

11/ {optional: callout to a contributor or community member}

12/ {cta_question — what should we prioritize? what's missing?}
```

**Rules:**
- Posts 10-12 are optional. Use them only if they add signal.
- "BROKEN" section is mandatory. If you can't name something broken, you aren't looking hard enough.
- Each bet in post 9 must have a verifiable end-state. "Improve docs" is not a bet. "Ship the quickstart guide with <5 min bootstrap time" is.

---

## LinkedIn Long-Form Variant (~600-900 words)

**Hook formula:** Playbook Hook (hooks.md #1)
> `Here's [N] things I learned [doing X]:`

Alternative: Contrarian Hook (hooks.md #3) if the month's biggest lesson challenged a common assumption.

```
{hook_line}

{1-2 sentence context: what Clawrari is, what month this covers, what the thesis was going in}

---

## Shipped

- {shipped_1 — what it is, link, why it matters in 1 sentence}
- {shipped_2}
- {shipped_3}
- {shipped_4}
- {shipped_5}
- {shipped_6-7 if applicable}

## Learned

**{lesson_1_title}**
{lesson_1_body — <=2 sentences. Specific. In Prasith's "honest take" voice: what happened, what it taught us.}

**{lesson_2_title}**
{lesson_2_body}

**{lesson_3_title}**
{lesson_3_body}

## Broken

{No header dressing. Just say what's wrong.}

- {broken_1 — what's still not working and why}
- {broken_2}
- {broken_3 if applicable}

## Next Month's Bets

We're making 3 bets for {next_month}:

1. **{bet_1_name}** — {verifiable_end_state}
2. **{bet_2_name}** — {verifiable_end_state}
3. **{bet_3_name}** — {verifiable_end_state}

---

{cta_question}
```

**Rules:**
- "Shipped" section: concrete artifacts only. If you can't link to it or name the file/PR/release, it didn't ship.
- "Learned" section: 3 lessons, each <=2 sentences. No platitudes. "Communication is important" is not a lesson. "We lost 2 days because the session brief didn't include the schema change from Tuesday" is.
- "Broken" section: no euphemisms. "Area for improvement" is banned. Say what's broken.
- "Bets" section: 3 max. Each must have a verifiable end-state that someone can check next month and say yes/no.
- Total length 600-900 words. If you're over 900, cut the weakest shipped items first.

---

## Short-Form Summary (1 paragraph, for newsletters/digests)

```
Clawrari {month} {year}: {one_sentence_thesis — the single most important thing that happened}. Shipped {count} artifacts including {top_1-2_highlights}. Key lesson: {strongest_lesson_in_one_sentence}. Still working on: {biggest_open_problem}. Next month: {top_bet_with_end_state}.
```

**Constraints:** 3-5 sentences. No line breaks. This is meant to be dropped into a digest, newsletter, or status update without reformatting.

---

## Placeholder Reference

| Placeholder | What goes here |
|---|---|
| `{hook_line}` | Opening line using specified hook formula |
| `{month}` / `{year}` / `{next_month}` | Calendar references |
| `{shipped_1-7}` | Concrete artifacts with links: PRs, releases, docs, tools |
| `{lesson_1-3_title}` | Short title for each lesson (3-5 words) |
| `{lesson_1-3_body}` | The lesson itself, <=2 sentences, specific |
| `{broken_1-3}` | What's still wrong. Honest. |
| `{bet_1-3_name}` | Short name for each bet |
| `{verifiable_end_state}` | What "done" looks like, checkable by anyone |
| `{count}` | Number of shipped artifacts |
| `{top_1-2_highlights}` | Best 1-2 ships for the summary |
| `{strongest_lesson_in_one_sentence}` | Single most useful lesson |
| `{biggest_open_problem}` | Top unresolved issue |
| `{cta_question}` | Question inviting real input |

---

## Voice Guardrails

Before posting, check every line against this list:

- [ ] No hype words: "game-changing," "revolutionary," "insane," "wild," "amazing," "incredible"
- [ ] 0-1 emoji in the entire post
- [ ] None of: "thrilled," "excited," "honored," "humbled," "blown away," "AI-powered"
- [ ] Short sentences. If a sentence has a comma and a semicolon, split it.
- [ ] Action verbs. "We shipped X" not "We were able to successfully deliver X"
