# Weekly Build-in-Public Post Template

Clawrari weekly update. Two variants: X (short) and LinkedIn (medium). Use one or both depending on what shipped.

---

## X Variant (Single Tweet)

**Hook formula:** Behind-the-Scenes Hook (hooks.md #6)
> `I [run/manage/build] [X]. Here's [what it actually looks like / what nobody tells you].`

```
{hook_line}

{bullet_1}
{bullet_2}
{bullet_3}

{cta_question}
```

**Constraints:** 280 chars max. One hook, three bullets, one question. No hashtags unless they earn their characters.

### X Thread Variant (when the week warrants it, max 8 posts)

```
1/ {hook_line}

2/ Shipped: {what_shipped_this_week}

3/ Learned: {one_lesson_with_specifics}

4/ Broke: {what_went_wrong_and_why}

5/ Next: {what_we_are_building_next_week}

6/ {optional_deeper_detail_on_any_of_the_above}

7/ {optional_link_to_PR_or_doc}

8/ {cta_question}
```

**Rules:**
- Skip posts 6-7 if nothing fills them. A 5-post thread that says something beats an 8-post thread that pads.
- Every post must stand alone if someone reads only that one.
- Post 1 is the hook. If it doesn't stop the scroll, the thread dies.

---

## LinkedIn Variant (~150-250 words)

**Hook formula:** Discovery Hook (hooks.md #5)
> `I just [found/discovered/realized] [thing]. [Why it matters or what changed].`

Alternative: Playbook Hook (hooks.md #1) when you have 3+ concrete takeaways.
> `Here's [N] things I learned [doing X]:`

```
{hook_line}

{one_sentence_context — what Clawrari is, for new readers who landed here}

What shipped:
- {shipped_1 — concrete artifact, link if public}
- {shipped_2}
- {shipped_3}

What we learned:
- {lesson — specific, not platitude}

What broke:
- {honest_failure — what went wrong, what we did about it}

Next week:
- {next_focus — verifiable, not vague}

{cta_question}
```

**Rules:**
- Hook is line 1, alone. LinkedIn truncates after ~2 lines. If the hook doesn't earn the "see more" click, everything below is wasted.
- "What broke" is not optional. If nothing broke, say what was harder than expected.
- CTA is always a question. Never "drop a like" or "share if you agree."
- 0-1 emoji max. If you use one, it should be functional (a bullet marker or a single visual anchor), not decoration.

---

## Placeholder Reference

| Placeholder | What goes here |
|---|---|
| `{hook_line}` | Opening line using the specified hook formula |
| `{bullet_1-3}` | Three tightest wins/changes of the week |
| `{what_shipped_this_week}` | Concrete artifacts: merged PRs, published docs, released versions |
| `{one_lesson_with_specifics}` | What surprised us, with enough detail to be useful to someone else |
| `{what_went_wrong_and_why}` | Honest failure or friction point. No euphemisms. |
| `{what_we_are_building_next_week}` | Specific focus, not "keep building" |
| `{one_sentence_context}` | For LinkedIn readers who don't know Clawrari: what it is in <15 words |
| `{cta_question}` | Question that invites real answers, not engagement bait |

---

## Voice Guardrails

This checklist is a convenience subset of the [`avoid-ai-writing` (AWDS) skill](../../../skills/avoid-ai-writing/SKILL.md), which is the single source of truth for voice and anti-AI-tell rules. Run the AWDS gate for the authoritative check; the boxes below are a quick manual pass and defer to AWDS on any conflict.

Before posting, check every line against this list:

- [ ] No hype words: "game-changing," "revolutionary," "insane," "wild," "amazing," "incredible"
- [ ] 0-1 emoji in the entire post
- [ ] None of: "thrilled," "excited," "honored," "humbled," "blown away," "AI-powered"
- [ ] Short sentences. If a sentence has a comma and a semicolon, split it.
- [ ] Action verbs. "We shipped X" not "We were able to successfully deliver X"
