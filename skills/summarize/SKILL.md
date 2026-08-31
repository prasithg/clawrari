---
name: summarize
description: "Summarize or extract text and transcripts from URLs, videos, and local files with the summarize CLI."
homepage: https://summarize.sh
metadata:
  {
    "openclaw":
      {
        "emoji": "🧾",
        "requires": { "bins": ["summarize"] },
        "install":
          [
            {
              "id": "brew",
              "kind": "brew",
              "formula": "steipete/tap/summarize",
              "bins": ["summarize"],
              "label": "Install summarize (Homebrew)"
            }
          ]
      }
  }
---

# Summarize

Use the `summarize` CLI to understand a web page, document, podcast, or video without manually copying its contents into the conversation.

## Use when

- The user asks for a summary of a URL, article, PDF, document, podcast, or video.
- The user asks what a linked item is about.
- The user asks to extract text or a transcript from supported media.

Do not use this skill when the user has already supplied a short passage in the conversation; summarize that text directly.

## Workflow

1. Identify whether the user wants a summary, full extraction, or transcript.
2. Run the narrowest command that produces that artifact.
3. Return the core thesis first, then actionable takeaways, tradeoffs, and intended audience when those sections add value.
4. For long source material, give a tight overview and section outline before expanding individual sections.
5. State extraction or transcription gaps. Never invent missing source text.

## Commands

Summarize a web page or local document:

```bash
summarize "https://example.com" --length short --plain
summarize "/path/to/file.pdf" --length short --plain
```

Extract source text without asking a model to summarize it:

```bash
summarize "https://example.com" --extract --format md
summarize "/path/to/file.pdf" --extract --format md
```

Extract a best-effort YouTube transcript:

```bash
summarize "https://www.youtube.com/watch?v=VIDEO_ID" --extract --youtube auto --timestamps
```

Use `--json` for machine-readable output and `--max-output-tokens <count>` when a downstream process requires a hard output cap.

## Model configuration

Let the CLI use its configured default unless the operator names a provider or model. A specific model can be selected with `--model <provider/model>`.

Provider credentials are supplied through the provider's documented environment variables. Do not print, copy, or persist credentials in output or repository files.

Optional extraction services:

- `FIRECRAWL_API_KEY` enables a fallback for blocked web pages.
- `APIFY_API_TOKEN` enables an additional YouTube transcript fallback.

## Failure handling

- If extraction fails, report the failing source and the next viable input form, such as an uploaded file or pasted text.
- If a transcript is incomplete, label it partial and name the missing range when known.
- If the requested source requires authentication, ask the user to provide an accessible export or use an authorized browser workflow; do not bypass access controls.

## Verification evidence

See `reports/evals/summarize-skill-port-2026-08-31.md`.
