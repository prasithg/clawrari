# Contributor Highlight Template

Format for spotlighting Clawrari contributors. X + LinkedIn variants.

---

## Required Fields

Every contributor highlight must include all of these before drafting:

| Field | Description |
|---|---|
| `{contributor_name}` | Their name as they prefer it |
| `{github_handle}` | GitHub username |
| `{what_they_shipped}` | Specific artifact: PR, feature, doc, fix |
| `{why_it_matters}` | 1-2 sentences on the impact — why this contribution moved the needle |
| `{quote_or_paraphrase}` | One quote from them (preferred) or a paraphrase with `[paraphrased]` label |
| `{link_to_work}` | URL to PR, commit, doc, or issue |

---

## X Variant (Single Tweet)

**Hook formula:** Discovery Hook (hooks.md #5)
> `I just [found/discovered/realized] [thing]. [Why it matters or what changed].`

```
{contributor_name} just shipped {what_they_shipped} for Clawrari.

{why_it_matters_in_one_sentence}

"{quote_or_paraphrase}" — @{github_handle}

{link_to_work}
```

**Constraints:** 280 chars max. If it doesn't fit, cut the quote and keep the link. The work speaks louder than the words about the work.

### X Thread Variant (when the contribution is substantial, 3-5 posts)

```
1/ {contributor_name} just shipped {what_they_shipped} for Clawrari. Here's why it matters.

2/ The problem: {what_was_broken_or_missing_before}

3/ What they built: {concrete_description_of_the_contribution}

4/ "{quote_or_paraphrase}" — @{github_handle}

{link_to_work}

5/ {cta_question — what would you build on top of this?}
```

---

## LinkedIn Variant (~150-250 words)

**Hook formula:** Behind-the-Scenes Hook (hooks.md #6)
> `I [run/manage/build] [X]. Here's [what it actually looks like / what nobody tells you].`

```
{hook_line — frame around the contribution, not around yourself}

{1-2 sentences of context: what Clawrari is, what problem existed before this contribution}

What {contributor_name} shipped:
- {what_they_shipped — specific artifact}
- {technical_detail_1 — what it does, concretely}
- {technical_detail_2 — if applicable}

Why it matters:
{why_it_matters — 2-3 sentences. Connect the contribution to a real user benefit or project milestone.}

In their words:
"{quote_or_paraphrase}" — {contributor_name} (@{github_handle})

{link_to_work}

{cta_question}
```

**Rules:**
- Lead with the contributor and their work, not with yourself.
- "Why it matters" connects to users, not to your roadmap. "This makes bootstrap 40% faster" beats "This helps us hit our Q3 OKR."
- The quote should be real. If they didn't say anything quotable, use a paraphrase and label it.
- Tone: warmth without sycophancy. Real credit, not corporate "shoutout." No "huge props to" or "big shoutout to our amazing contributor." Just say what they did and why it was good.

---

## Placeholder Reference

| Placeholder | What goes here |
|---|---|
| `{contributor_name}` | Name as they prefer it |
| `{github_handle}` | GitHub username (no @) |
| `{what_they_shipped}` | Specific PR, feature, doc, or fix |
| `{why_it_matters}` | Impact in 1-2 sentences |
| `{why_it_matters_in_one_sentence}` | Compressed version for X single tweet |
| `{quote_or_paraphrase}` | Their words or `[paraphrased]` version |
| `{link_to_work}` | URL to PR/commit/doc |
| `{what_was_broken_or_missing_before}` | The problem state before the contribution |
| `{concrete_description_of_the_contribution}` | What they actually built |
| `{technical_detail_1-2}` | Concrete implementation details |
| `{hook_line}` | Opening line using specified hook formula |
| `{cta_question}` | Question inviting engagement |

---

## Privacy and Consent

**Do not publish a contributor highlight without the contributor's explicit acknowledgment.**

Before publishing:
- [ ] Contributor has been contacted and agreed to be featured
- [ ] Their preferred name and handle are confirmed
- [ ] Any direct quote has been approved by them
- [ ] The link to their work is public (not to a private branch or internal doc)
- [ ] No private information is included (email, location, employer unless they've shared it publicly)

If a contributor declines or doesn't respond within 7 days, do not publish. Move on.

---

## Voice Guardrails

This checklist is a convenience subset of the [`avoid-ai-writing` (AWDS) skill](../../../skills/avoid-ai-writing/SKILL.md), which is the single source of truth for voice and anti-AI-tell rules. Run the AWDS gate for the authoritative check; the boxes below are a quick manual pass and defer to AWDS on any conflict.

Before posting, check every line against this list:

- [ ] No hype words: "game-changing," "revolutionary," "insane," "wild," "amazing," "incredible"
- [ ] 0-1 emoji in the entire post
- [ ] None of: "thrilled," "excited," "honored," "humbled," "blown away," "AI-powered"
- [ ] Short sentences. If a sentence has a comma and a semicolon, split it.
- [ ] Action verbs. "We shipped X" not "We were able to successfully deliver X"
- [ ] No sycophancy: "huge props," "massive shoutout," "amazing contributor" — just say what they did
