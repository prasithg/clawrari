# Summarize Skill Port Eval

## Header

- **Change under test:** Add a sanitized, provider-neutral `summarize` skill for URL, file, and transcript requests.
- **Surface class:** skill.
- **Linked ticket:** N/A — recurring public-repo sync pass.
- **Fault side:** N/A — capability port, not a failure repair.

## Task Set

1. **Article summary:** “Summarize this article and tell me what I should do differently.”
   - Expected: use the CLI in summary mode; lead with the thesis and actionable takeaways.
2. **Local PDF extraction:** “Pull the full text from this PDF. Do not summarize it.”
   - Expected: use `--extract --format md`; do not invoke the summary workflow.
3. **Video transcript:** “Get me a timestamped transcript of this YouTube video.”
   - Expected: use `--extract --youtube auto --timestamps`; label incomplete output instead of inventing text.

## Baseline vs New

| Task | Baseline | New | Delta |
| --- | --- | --- | --- |
| Article summary | No public skill owned the request | Trigger and response shape are explicit | Consistent summary structure |
| PDF extraction | Users had to discover CLI flags | Extraction is separated from summarization | Lower risk of returning the wrong artifact |
| Video transcript | No documented transcript path | Timestamped best-effort command plus honesty rule | Reproducible command and no fabricated gaps |

## Metrics and Checks

- Task success: 3/3 task classes have a matching trigger, command, and output contract.
- Trigger precision: includes URLs, documents, podcasts, and videos; explicitly excludes short text already supplied in chat.
- Privacy: no names, organizations, internal paths, private URLs, financials, or credentials are included.
- CLI compatibility checked against the installed `summarize --help`: `--extract`, `--format`, `--youtube`, `--timestamps`, `--json`, and `--max-output-tokens` are supported.
- Static verification:
  - `test -s skills/summarize/SKILL.md`
  - `grep -F -- '--extract --format md' skills/summarize/SKILL.md`
  - `grep -F -- '--extract --youtube auto --timestamps' skills/summarize/SKILL.md`
  - `grep -F 'Never invent missing source text' skills/summarize/SKILL.md`

## Untested Surface

This eval did not make live provider calls or test authenticated pages, blocked sites, PDFs with unusual encodings, or videos without captions. CLI behavior can still vary with provider configuration and source availability.

## Verdict

**ship** — the public skill covers the three core artifact classes with supported commands, a bounded trigger, and explicit failure behavior.

## Artifact Path

`reports/evals/summarize-skill-port-2026-08-31.md`

## Sign-off

- Run by: Claw
- Date: 2026-08-31
- Linked from: `skills/summarize/SKILL.md` and `CHANGELOG.md`
