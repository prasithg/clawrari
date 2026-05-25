# Ecosystem Outreach List

_Last updated: 2026-05-24. Source of identity info: GitHub maintainer profiles, public X/Twitter bios, and personal websites. Login-walled or paywalled sources excluded. Where a specific maintainer could not be identified from public sources, the entry says "no public contact identified" — do not fabricate._

This is a research artifact. **No contact has been made.** Drafts only. Approval required before any outbound.

## Success metric

**≥3 named partner conversations on calendar within 60 days of first send.** A "conversation" means a scheduled call, an exchanged thread on a concrete collab proposal, or a merged cross-link/PR — not a one-shot acknowledgement. Below that bar, the outreach motion is not working and the list needs to be re-scoped before sending more.

---

## 1. Anthropic — Claude Skills program

- **Why they matter to Clawrari:** Claude Skills (launched late 2025) is now the canonical Anthropic-blessed surface for packaged behaviors. Clawrari is a skills-heavy operating system. If Skills' authoring conventions become the standard, Clawrari needs to interoperate cleanly. They are the platform; we are an opinionated configuration on top.
- **Primary maintainer / decision-maker:** No single public engineering owner for the Skills program has been identifiable from public sources. The Anthropic Applied AI / Developer Relations team owns public-facing Skills discussion (e.g., the engineering blog post that introduced the format). Public contact: **no public individual contact identified** — best route is the public `support@anthropic.com` or the Anthropic Developer Discord, both of which are non-personal channels and out of scope for a peer-maintainer intro.
- **Surface area for collab:** (a) Author skills under the Skills format directly and contribute them upstream as examples; (b) write a public post about Clawrari's experience with Skills at scale (most external authors have shipped 1–3 skills, Clawrari runs dozens); (c) offer feedback on Skills authoring ergonomics with concrete repro cases.
- **Risk:** They are a platform team at a large company; they engage with users via blog posts and Discord, not 1:1 partnerships. Direct outreach will likely route through DevRel or be ignored. Best framing is **public contribution first**, then let them notice. Do **not** position Clawrari as a competing standard — Skills is the standard, Clawrari is a setup that uses it well.

---

## 2. obra/superpowers (GitHub)

- **Why they matter to Clawrari:** Closest neighbor in the "opinionated Claude Code skill bundles" space. Same philosophy of file-first behaviors, durable conventions, and shipped-in-public iteration. Adjacent enough that users will compare us; close enough that we can credit, learn from, and complement each other.
- **Primary maintainer / decision-maker:** **Jesse Vincent** (`@obra` on GitHub, `@obra` on X). Long-time engineer (perl/Bestpractical/email infrastructure, formerly K-9 Mail). His blog historically lives at `blog.fsck.com` / `obra.com`-adjacent surfaces. Public email is listed on his GitHub profile and personal site (already public — do not duplicate it here; pull from the live profile at send time).
- **Surface area for collab:** (a) Cross-link: their README references peer setups including ours, ours references theirs; (b) shared skill-format conventions where compatible (frontmatter, naming, install patterns); (c) one PR each direction — we contribute one good skill upstream to `superpowers`, they consider one of ours.
- **Risk:** Low. Jesse is a public, collegial maintainer with a long track record of OSS collaboration. The main failure mode is sounding like a clone — must lead with what Clawrari does *differently* (full OS with memory + heartbeat + crons + identity, not just skills) and where they're stronger (skill curation depth, established mindshare).

---

## 3. basic-memory (GitHub: basicmachines-co/basic-memory)

- **Why they matter to Clawrari:** Their entire thesis — "your AI's memory should be markdown files in a folder you own, not a hidden vector DB" — is identical to Clawrari's. Different scope (they're a memory tool; we're a full OS), same conviction. Strongest doctrinal alignment of anyone on this list.
- **Primary maintainer / decision-maker:** Listed maintainer on the project is **Phil Hernandez / Basic Machines** (`@phernandez` historically; verify the active GitHub handle at send time via the repo's commit history). Public site: `basicmachines.co`. Public email is listed on the GitHub org page and personal site — do not duplicate here; pull live at send time.
- **Surface area for collab:** (a) **Integration:** Clawrari's memory layer is already markdown files — basic-memory could be a drop-in semantic index over the same files without violating either project's principles; (b) shared blog post: "files-first memory: two takes"; (c) explicit cross-promo — they recommend Clawrari for users who want a full OS, we recommend basic-memory for users who only want memory.
- **Risk:** Low. Aligned philosophy means low chance of being seen as a competitor. The main risk is moving too fast on integration before either side wants the support burden — start with a public conversation, not a PR.

---

## 4. Letta (formerly MemGPT)

- **Why they matter to Clawrari:** They are the most academically respected agent-memory project (MemGPT paper, UC Berkeley origin). Clawrari is the opposite end of the philosophy spectrum — markdown files and grep, not a research-grade hierarchical memory system. Talking to them sharpens *our* positioning and surfaces real differences worth writing about.
- **Primary maintainer / decision-maker:** Co-founders **Charles Packer** (`@cpacker` on GitHub, also on X) and **Sarah Wooders** (publicly listed Letta co-founder, on X). Both UC Berkeley. Letta is a YC-backed company; public email contact is via `letta.com`. Best peer-maintainer contact is Charles via his GitHub-listed channels.
- **Surface area for collab:** (a) Joint thought piece: "two philosophies of agent memory — hosted systems vs. files-first" framed as honest comparison, not zero-sum; (b) Clawrari user could optionally back its memory with a Letta server if they want the hosted experience — explicit "we don't ship this, but if you want it, here's how"; (c) we cite their research, they note our setup as a practical files-first alternative.
- **Risk:** Medium. Letta is a funded company building a product; they have business reasons to position their memory system as the standard. Clawrari publicly arguing "no hosted vector DB as source of truth" can read as a critique of their core thesis. **Framing must be respectful — different philosophies for different users, not us-vs-them.** Pre-read our `philosophy.md` page before any outreach and consider whether to soften that section before reaching out.

---

## 5. Agent OS

- **Why they matter to Clawrari:** Name overlap and conceptual overlap — both projects use "operating system for AI agents" framing. Adjacent positioning means users may discover one and ask "how does this differ from the other?" Worth a relationship to keep the narrative clear.
- **Primary maintainer / decision-maker:** The most prominent public "Agent OS" project at the time of this writing is the one by **Brian Casel** (Builder Methods — `buildermethods.com`, public on X), a methodology / spec for AI-coding workflows in Cursor/Claude Code. Brian is publicly accessible via his site and X. **Caveat:** "Agent OS" is a generic name and there are multiple unrelated projects using it (academic systems, commercial products, hobby repos). Before any outreach, **re-verify which Agent OS we mean** — confirm against the live project repo and recent posts. If the intended target turns out to be a different Agent OS, this entry must be redone.
- **Surface area for collab:** (a) Clear differentiation post: Agent OS is a workflow methodology for AI coding; Clawrari is a personal-assistant OS for one operator's life. Both can coexist; users may run both. (b) Cross-link with explicit "what each is for" clarification so readers don't conflate them.
- **Risk:** Low-to-medium. Risk is *narrative confusion*, not conflict — two projects with similar names will get confused in discussions regardless of how we feel about it, so a clear public statement of difference benefits both sides.

---

## Targets researched but not surfaced

- **Hosted agent-memory platforms (Zep, Mem0, etc.):** Doctrinal opposite of Clawrari (hosted vector DB as source of truth). Worth tracking; not a near-term partnership target.
- **Claude Code core team at Anthropic:** Same as Skills entry above — no individual public maintainer for peer outreach. Best signal: ship good work, contribute upstream, get noticed.

## Next steps (no sends until Prasith approves)

1. Prasith reviews this list and flags any wrong/missing targets.
2. Re-verify each maintainer's current public handle and contact surface against the live repo on send day — handles and channels rotate.
3. Pick one target to start with (recommend obra/superpowers — lowest risk, highest alignment, easiest first conversation).
4. Draft outreach using the templates in `intro-templates.md`. Send only after Prasith reviews the personalized draft.
