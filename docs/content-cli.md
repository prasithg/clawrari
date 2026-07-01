# Clawrari Content CLI

`scripts/clawrari-content.sh` is the operator-facing wrapper for the content
engine. It gives the workflow one clean entrypoint while keeping the existing
recipe in charge of generation and AWDS scoring.

There is no top-level `clawrari` dispatcher in this repo yet. Until one exists,
run the script directly or add a local shell shim:

```bash
clawrari() {
  case "$1" in
    content) shift; "$PWD/scripts/clawrari-content.sh" "$@" ;;
    *) echo "unknown clawrari command: $1" >&2; return 2 ;;
  esac
}
```

## Usage

```bash
scripts/clawrari-content.sh new <slug>
scripts/clawrari-content.sh run <slug> [--weekly|--monthly] [--as-of YYYY-MM-DD] [--force]
scripts/clawrari-content.sh --help
```

The script also accepts the future dispatcher shape:

```bash
scripts/clawrari-content.sh content new launch-notes
scripts/clawrari-content.sh content run launch-notes --weekly
```

## Create a Piece

```bash
scripts/clawrari-content.sh new launch-notes
```

This creates a timestamped markdown scaffold under:

```text
docs/content-engine/work/<slug>/<timestamp>-<slug>.md
```

The scaffold includes:

- front matter with the slug and creation timestamp
- `Hook`
- `Bullets`
- `CTA`

## Run the Recipe

```bash
scripts/clawrari-content.sh run launch-notes --weekly --as-of 2026-07-01
```

`run` delegates to `scripts/content-engine-run.sh`, which runs the existing
content-engine recipe:

```text
generate draft -> AWDS voice gate -> verdict artifact
```

The wrapper always passes `--no-notify`. It does not send Slack messages, post to
external platforms, or publish content.

After the run, it prints:

```text
VERDICT: CLEAN|PATCH|REWRITE
Draft: docs/content-engine/drafts/<generated>.md
AWDS: docs/content-engine/drafts/<generated>.awds.json
Run log: docs/content-engine/work/<slug>/run-<timestamp>.log
```

Use `--monthly` for the monthly rollup path. Use `--force` only when you need to
regenerate an existing period draft and rerun the AWDS gate.

## Test

```bash
bash scripts/test-clawrari-content.sh
```

The test uses a mocked content-engine runner so it stays offline and
deterministic while still proving that `run` invokes the recipe and reports the
AWDS verdict.
