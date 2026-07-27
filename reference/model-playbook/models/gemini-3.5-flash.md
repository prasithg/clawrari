# Gemini 3.5 Flash

**Runtime id:** `google/gemini-3.5-flash` · **alias:** `flash`

## Routing boundary

Gemini Flash is **fast/bulk only**:

- Classification and tagging.
- Structured extraction.
- OCR and quick visual passes.
- Lightweight summaries with a supplied source.
- Broad fan-out where a stronger model owns final synthesis.

Never route hard reasoning, architecture, strategy, voice-critical writing, code review, or autonomous work to Flash.

## Prompt shape

Use one structure—Markdown or XML, never both. Put source material before the final task, specify the output schema exactly, and keep temperature at the provider-recommended default unless the task has a tested reason to override it.

## Verification

For bulk jobs, sample outputs and validate schema/coverage mechanically. Flash output is an intermediate artifact when judgment matters; a stronger route performs final synthesis.

