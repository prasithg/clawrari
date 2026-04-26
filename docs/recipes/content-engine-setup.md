# Content Engine Setup Recipe

How to configure a structured content engine in Clawrari so your AI can turn your daily work, reading, and opinions into consistent LinkedIn, X/Twitter, and blog drafts.

## The Problem

Content is easy to want and hard to ship consistently. Without structure, your AI either writes generic thought-leadership sludge or asks you for direction every time.

A good content engine gives the agent durable answers to the recurring questions:

- What topics are actually yours?
- Which platforms matter most?
- What should it read, ignore, and save?
- What does a good daily or weekly deliverable look like?
- What does your voice sound like when you are sharp, skeptical, excited, or teaching?

This recipe creates that structure as an OpenClaw skill graph.

## What You Need Before Starting

1. **OpenClaw workspace** at `~/.openclaw/workspace/`
2. **A working Clawrari-style layout** with `skills/`, `memory/`, `tasks/`, and optional `crons/`
3. **At least one research source** your agent can use: web search, RSS/blogwatcher, Reddit, X/Twitter via browser, or curated links
4. **A clear primary platform** — usually LinkedIn for founders/operators, X/Twitter for builders, or a blog/newsletter for long-form thinkers

## Setup Steps

### Step 1: Create the Skill Graph Structure

Create a new skill directory:

```bash
mkdir -p ~/.openclaw/workspace/skills/content-engine
cd ~/.openclaw/workspace/skills/content-engine

touch SKILL.md \
  platform-configs.md \
  content-strategy.md \
  curation-rules.md \
  deliverable-specs.md \
  writing-style.md \
  hooks.md
```

The files divide responsibilities cleanly:

| File | Purpose |
|------|---------|
| `SKILL.md` | Index and routing instructions for the skill graph |
| `platform-configs.md` | Platform roles, constraints, formats, and optimization notes |
| `content-strategy.md` | Your content buckets and rotation strategy |
| `curation-rules.md` | What to read, save, reject, and cite |
| `deliverable-specs.md` | Daily and weekly output formats |
| `writing-style.md` | Your voice, structure, tone, and anti-patterns |
| `hooks.md` | Reusable hook patterns and post openers |

Start with this `~/.openclaw/workspace/skills/content-engine/SKILL.md`:

```markdown
---
name: content-engine
description: Content creation preferences, platform configs, deliverable specs, and curation rules for my content pipeline.
---

# Content Engine

A skill graph for producing consistent content drafts from my work, reading, and opinions.

## Quick Start

For daily or weekly content work, start with [[deliverable-specs]], then reference [[content-strategy]], [[curation-rules]], [[platform-configs]], [[writing-style]], and [[hooks]].

## Components

- **[[platform-configs]]** — Platform roles, constraints, and optimization notes
- **[[content-strategy]]** — Content buckets, rotation patterns, and strategic focus
- **[[curation-rules]]** — Source selection, filters, exclusions, and quality bar
- **[[deliverable-specs]]** — Daily and weekly output templates
- **[[writing-style]]** — Voice, tone, structure, authenticity markers, and banned patterns
- **[[hooks]]** — Reusable hooks for posts, threads, and long-form pieces

## Operating Principle

The content engine should draft, not publish. External posts require explicit approval.
```

### Step 2: Define Your Content Buckets

Do not copy someone else's buckets. Pick 3–5 topics that sit at the intersection of:

- What you are actively doing
- What you have earned opinions about
- What your target audience cares about
- What you can sustain for 6–12 months

Create `~/.openclaw/workspace/skills/content-engine/content-strategy.md`:

```markdown
# Content Strategy

## Audience

Primary audience: <founders / engineers / operators / candidates / investors / customers>

What they want:
- <pain or aspiration 1>
- <pain or aspiration 2>
- <pain or aspiration 3>

What I want to be known for:
- <reputation goal 1>
- <reputation goal 2>

## Content Buckets

### 1. <Bucket Name>

**Angle:** <your specific point of view>

Good topics:
- <topic>
- <topic>
- <topic>

Avoid:
- <generic version of this topic>
- <topics you cannot speak about credibly>

### 2. <Bucket Name>

**Angle:** <your specific point of view>

Good topics:
- <topic>
- <topic>
- <topic>

### 3. <Bucket Name>

**Angle:** <your specific point of view>

Good topics:
- <topic>
- <topic>
- <topic>

## Rotation Strategy

Daily drafts should rotate buckets instead of clustering around the same theme.

Suggested weekly mix:
- 2x practical lessons from current work
- 1x architecture / systems breakdown
- 1x founder/operator reflection
- 1x curated insight from external reading
- 1x contrarian or unresolved question

## Content Inputs

Use these as raw material:
- Daily work logs in `memory/YYYY-MM-DD.md`
- Project notes in `projects/*/`
- Meeting notes and debriefs
- Bookmarks / saved links
- Interesting errors, regressions, decisions, and tradeoffs
```

Good bucket examples:

| Role | Better buckets |
|------|----------------|
| AI founder | AI product lessons, evals in practice, founder ops, go-to-market experiments |
| Devtools builder | Developer workflows, architecture tradeoffs, shipping notes, open-source maintenance |
| Engineering leader | Team systems, technical strategy, hiring, incident lessons |
| Career coach | Job search strategy, interview prep, salary negotiation, career transitions |

Weak buckets are broad nouns: `AI`, `startups`, `leadership`. Strong buckets contain a point of view: `AI product lessons from shipping real workflows`.

### Step 3: Configure Platform Roles

Every platform needs a job. Otherwise the agent will flatten everything into the same post with different line breaks.

Create `~/.openclaw/workspace/skills/content-engine/platform-configs.md`:

```markdown
# Platform Configs

## Platform Priority

1. **Primary:** <LinkedIn / X / blog / newsletter>
2. **Secondary:** <platform>
3. **Mining sources:** <Reddit / Hacker News / X lists / RSS / YouTube / podcasts>
4. **Occasional:** <long-form blog / YouTube / podcast / talks>

## LinkedIn

Role: high-signal professional distribution.

Best for:
- Lessons from building
- Founder/operator reflections
- Clear frameworks
- Hiring/career insights

Format:
- Strong hook in first 1–2 lines
- Short paragraphs or bullets
- One concrete example
- Simple closing question or takeaway

Avoid:
- Engagement bait
- Fake vulnerability
- Corporate jargon
- Overlong threads disguised as posts

## X / Twitter

Role: fast idea testing and builder notes.

Best for:
- Sharp observations
- Mini-frameworks
- Build-in-public notes
- One-liners that may become LinkedIn posts later

Format:
- 1–2 sentence standalone tweets
- Short threads only when sequence matters
- Strong nouns and verbs; no filler

Avoid:
- Context-heavy posts that require backstory
- Vague inspiration
- Overexplaining

## Blog / Newsletter

Role: durable thinking and canonical explanations.

Best for:
- Architecture breakdowns
- Deep lessons from projects
- Opinionated guides
- Case studies

Format:
- Clear thesis
- Sectioned argument
- Specific examples
- Practical conclusion

## Mining Sources

Use mining platforms to find questions, objections, language, and pain — not to copy takes.

Good mining targets:
- Reddit threads where people describe real problems
- Hacker News comments with objections and edge cases
- X posts with strong claims worth responding to
- YouTube/podcast transcripts from credible practitioners
```

### Step 4: Set Deliverable Specs

The agent needs to know what “done” means. Define daily and weekly deliverables explicitly.

Create `~/.openclaw/workspace/skills/content-engine/deliverable-specs.md`:

````markdown
# Deliverable Specs

## Daily Content Brief

Frequency: weekdays, or whenever requested.

Output path:
`reports/content-drafts/daily-content-YYYY-MM-DD.md`

Required sections:

```markdown
# Daily Content Brief — YYYY-MM-DD

## 5 Reads Worth Considering

1. **<Title>** — <source/link>
   - Why it matters: <1 sentence>
   - Useful angle: <how I could respond or use it>
   - Bucket: <bucket name>

<!-- repeat 5 times -->

## LinkedIn Draft

**Bucket:** <bucket>
**Source/trigger:** <work log, article, meeting, idea>

<draft>

## X / Twitter Draft

<tweet or short thread>

## Notes

- Claims that need verification:
- Follow-up ideas:
```

## Weekly Content Pack

Frequency: once per week.

Output path:
`reports/content-drafts/weekly-content-pack-YYYY-MM-DD.md`

Required sections:

```markdown
# Weekly Content Pack — Week of YYYY-MM-DD

## Weekly Thesis

<What theme connected this week's work and reading?>

## 3 LinkedIn Drafts

### Draft 1 — <title>
**Bucket:** <bucket>
<draft>

### Draft 2 — <title>
**Bucket:** <bucket>
<draft>

### Draft 3 — <title>
**Bucket:** <bucket>
<draft>

## 10 X / Twitter Drafts

1. <tweet>
2. <tweet>
...
10. <tweet>

## Blog / Long-Form Candidates

- <title> — <why it deserves long-form treatment>
- <title> — <why it deserves long-form treatment>

## Build / Content Ideas

- <idea inspired by this week's work>
- <idea inspired by external reading>

## Quality Review

- Strongest draft:
- Weakest draft:
- Claims to verify:
- Suggested next experiment:
```

## Quality Bar

A deliverable is not done unless it includes:
- At least one specific example from my work or reading
- No generic “AI will change everything” language
- Clear platform fit
- Claims marked if they need verification
- Drafts only — no external publishing without approval
````

### Step 5: Write Your Voice and Style Guide

This is the most important file. Generic voice instructions create generic writing. Be blunt.

Create `~/.openclaw/workspace/skills/content-engine/writing-style.md`:

```markdown
# Writing Style

## Voice Principles

- Direct, practical, and specific
- Strong opinions are welcome when earned
- Prefer concrete examples over abstractions
- Explain tradeoffs, not just conclusions
- Sound like a practitioner, not a pundit

## Tone

Default tone: <practical / skeptical / warm / technical / candid>

Allowed:
- <e.g., dry humor>
- <e.g., sharp disagreement>
- <e.g., personal lessons when grounded in facts>

Avoid:
- Hype
- Motivational fluff
- Fake certainty
- Corporate filler
- “In today's fast-paced world…” openings

## Structure Patterns

### Practical Lesson

1. Hook: what I learned or changed my mind about
2. Context: where the lesson came from
3. Breakdown: 3–5 bullets
4. Takeaway: what I would do differently next time

### Architecture Breakdown

1. Problem
2. Constraint
3. Design choice
4. Tradeoff
5. What I would watch next

### Founder / Operator Reflection

1. Tension or decision
2. What made it hard
3. What we chose
4. What I learned
5. Question for others

## Language Rules

Use:
- Short sentences
- Active voice
- Specific nouns
- Real examples
- Measured confidence

Avoid:
- “Leverage” as a verb
- “Game-changer”
- “Revolutionize”
- “Unlock” unless literally unlocking something
- “Delve”
- “Supercharge”
- “Seamless”

## Authenticity Markers

Good drafts should include at least one:
- A real decision I made
- A mistake or correction
- A tradeoff I accepted
- A number or concrete constraint
- A question I am still wrestling with

## Editing Pass

Before finalizing any draft, tighten it:
- Delete the weakest 20%
- Replace abstractions with examples
- Cut throat-clearing
- Make the hook less generic
- Mark unverifiable claims
```

### Step 6: Wire Curation Rules

Curation rules prevent the engine from becoming a content landfill.

Create `~/.openclaw/workspace/skills/content-engine/curation-rules.md`:

````markdown
# Curation Rules

## What to Consume

Prioritize:
- Practitioner-written posts with real examples
- Technical breakdowns with architecture or process detail
- Founder/operator retrospectives with numbers or constraints
- Customer language from forums, comments, support threads, and reviews
- Research or benchmarks with methodology attached

Use cautiously:
- Viral threads
- Vendor reports
- Hot takes without evidence
- News that everyone is already posting about

Avoid:
- Generic AI trend pieces
- Content farms
- Engagement bait
- Uncited claims presented as fact
- Anything outside my content buckets unless unusually relevant

## Quality Filters

A source is worth saving if it has at least two:
- Specific example
- Novel framing
- Useful data
- Strong counterargument
- Customer/user language
- Direct relevance to a content bucket
- A practical lesson I can apply

## Exclusion Criteria

Do not draft from:
- Private/confidential work details
- Customer names unless already public and approved
- Internal financials or strategy unless explicitly cleared
- Personal information about employees, candidates, or customers
- Medical/legal/financial advice unless framed carefully and verified

## Source Notes Format

When saving a source, use:

```markdown
## <Title>
- Link:
- Source:
- Date found:
- Bucket:
- Why it matters:
- Possible angle:
- Claims to verify:
```
````

### Step 7: Add a Hook System

Hooks are not clickbait. They are compression: the first line tells the reader why this matters.

Create `~/.openclaw/workspace/skills/content-engine/hooks.md`:

```markdown
# Hooks

## Hook Principles

Good hooks are:
- Specific
- Slightly opinionated
- Grounded in a real problem
- Short enough to read instantly

Bad hooks are:
- Generic
- Overpromising
- Fake controversial
- Detached from the post body

## Reusable Patterns

### Lesson Learned

- I changed my mind about <topic> after <specific event>.
- The hardest part of <thing> wasn't <obvious problem>. It was <less obvious problem>.
- We tried <approach>. The surprising part was <lesson>.

### Tradeoff

- The tradeoff nobody mentions in <topic>: <tradeoff>.
- <Popular approach> works until <constraint>.
- I like <tool/pattern>, but I would not use it for <case>.

### Architecture / Systems

- A simple architecture rule that saved us from <failure mode>:
- The best system design decision we made was boring: <decision>.
- Before adding <feature>, ask this first: <question>.

### Founder / Operator

- Founder lesson I keep relearning: <lesson>.
- The uncomfortable part of <decision>: <truth>.
- A small operating habit that changed <outcome>:

## Hook Review

For every draft, ask:
- Would the target reader know this is for them?
- Is there a concrete noun in the first line?
- Does the body actually pay off the hook?
```

### Step 8: Invoke the Content Engine

Once the skill exists, you can invoke it directly in chat:

```text
Use the content-engine skill to create today's daily content brief from today's memory log and recent project work.
```

Or:

```text
Use content-engine to turn this week's project notes into a weekly content pack. Draft only. Do not publish.
```

Good invocation prompts include:

- Time range: today, this week, last 30 days
- Source files: `memory/YYYY-MM-DD.md`, `projects/my-project/notes.md`, meeting notes, links
- Desired output path
- Platform priority
- Any topics to avoid

Example:

```text
Use content-engine. Create `reports/content-drafts/daily-content-2026-05-04.md` from `memory/2026-05-04.md`, `projects/acme/repo/ARCHITECTURE.md`, and the last 5 saved links. Primary platform LinkedIn. Draft only. Avoid confidential customer details.
```

### Step 9: Integrate with Clawrari Workflows

The content engine gets stronger when it is connected to the rest of the workspace.

#### Morning Briefing

Add a content section to your morning briefing prompt or cron:

```markdown
## Content Opportunity Scan

Use `skills/content-engine/` to identify:
- 1 idea from yesterday's work log
- 1 external read worth saving
- 1 draft-worthy lesson or tradeoff
- Any claims that need verification before posting
```

#### Night Work

Add an autonomous content slot to `tasks/queue.md`:

```markdown
### Content Engine Standing Task
- Goal: Produce one daily content brief or improve one existing draft.
- Inputs: `memory/YYYY-MM-DD.md`, recent project notes, saved links.
- Output: `reports/content-drafts/daily-content-YYYY-MM-DD.md`
- Constraints: Draft only. Do not post externally. Do not expose private customer or employee details.
- Verification: File exists, includes 5 reads, 1 LinkedIn draft, 1 X draft, and claims-to-verify notes.
```

#### Weekly Review

Add a weekly cron or manual task:

```json
{
  "schedule": "0 9 * * 5",
  "task": "Use the content-engine skill to create a weekly content pack from this week's memory logs, project notes, and saved links. Draft only. Save under reports/content-drafts/.",
  "label": "weekly-content-pack"
}
```

#### Self-Improvement Loop

After each content pack, run a lightweight review:

```markdown
## Content Retrospective

- Which draft was strongest and why?
- Which hook felt generic?
- Which bucket is underfed?
- What source produced the best insight?
- What rule should be added to `writing-style.md`, `curation-rules.md`, or `hooks.md`?
```

If the agent repeatedly makes the same mistake, update the skill files. Do not rely on chat memory.

## Troubleshooting

**Drafts sound generic:** Your `writing-style.md` is too vague. Add banned phrases, concrete examples, and 2–3 posts that sound like you.

**The agent keeps choosing the same topic:** Tighten `content-strategy.md` with a weekly rotation and mark underused buckets.

**Too much content, not enough signal:** Make `curation-rules.md` stricter. Require sources to pass at least two quality filters.

**LinkedIn and X drafts sound identical:** Strengthen `platform-configs.md`. LinkedIn should carry context and reflection; X should test sharper ideas faster.

**The agent asks what to produce every time:** Your `deliverable-specs.md` does not define output paths, required sections, or cadence clearly enough.

**Drafts include private details:** Add explicit exclusions to `curation-rules.md` and invocation prompts. Content work should default to draft-only and redact confidential names, numbers, and internal strategy.

**Weekly packs are repetitive:** Feed the engine more diverse inputs: meeting notes, project diffs, saved links, customer language, error logs, and decisions made during the week.

## Verification Checklist

After setup, verify:

- [ ] `~/.openclaw/workspace/skills/content-engine/SKILL.md` exists and links every component
- [ ] `content-strategy.md` defines 3–5 specific content buckets
- [ ] `platform-configs.md` identifies primary, secondary, mining, and occasional platforms
- [ ] `deliverable-specs.md` defines daily and weekly output paths and templates
- [ ] `writing-style.md` includes voice principles, structure patterns, banned language, and authenticity markers
- [ ] `curation-rules.md` defines what to consume, quality filters, and exclusion criteria
- [ ] `hooks.md` contains reusable hook patterns
- [ ] A test daily brief can be generated from one memory file
- [ ] The output is saved under `reports/content-drafts/`
- [ ] No external publishing happens without explicit approval

Run a first test:

```text
Use content-engine to create a test daily content brief from `memory/YYYY-MM-DD.md`. Save it to `reports/content-drafts/test-daily-content.md`. Draft only.
```

Then inspect the result. If it is generic, do not just edit the draft — update the skill graph so the next draft is better.
