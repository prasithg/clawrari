# Gemini 3.7 Flash

**Runtime id:** `google/gemini-3.7-flash` · **alias:** `flash`

## Routing boundary

Gemini Flash is **fast/bulk only**:

- Classification and tagging.
- Structured extraction.
- OCR.

Only these bounded utility tasks qualify; Fable 5.1 or GPT-6 Astra owns summaries, synthesis, and judgment. A task merely mentioning bulk or speed does not qualify.

Never route hard reasoning, architecture, strategy, voice-critical writing, code review, or autonomous work to Flash. Utility-lane recovery is Astra low, then Fable 5.1 low.

## Prompt shape

Use one structure—Markdown or XML, never both. Put source material before the final task, specify the output schema exactly, and keep temperature at the provider-recommended default unless the task has a tested reason to override it.

## Verification

For bulk jobs, sample outputs and validate schema/coverage mechanically. Flash output is an intermediate artifact when judgment matters; a stronger route performs final synthesis.
