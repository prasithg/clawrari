# The Harness

A model is the engine. The harness is everything around it that turns a capable model into a reliable operator: how work gets planned and verified, how guardrails get enforced, how you measure whether a session was any good, and how two agents working together avoid getting stuck.

Most of what separates a flashy demo from a system you trust at 3am lives in the harness rather than the model. This section ports four harness patterns from a running Clawrari setup into reusable, dependency-free scaffolds.

## The four patterns

### [Night-Work Pipeline](night-work-pipeline.md)
Runs one task through four ordered stages: plan, build, test, completion sweep. The pipeline owns ordering, logging, and safety valves so an unattended run either finishes or stops loudly. Scaffold: `scripts/night-work-pipeline.sh`.

### [Regression Suite](regression-suite.md)
Turns prose guardrails ("never commit secrets", "keep the brief short") into machine-checkable assertions that pass or fail and exit non-zero on failure. A guardrail you can run is a guardrail that holds. Scaffold: `scripts/regression-check.mjs`, sample spec in `config/regression-suite.example.json`.

### [Eval Scorecard](eval-scorecard.md)
Rolls a window of agent runs into a six-axis scorecard: Output, Throughput, Intelligence, Collaboration, Autonomy, Safety. Its defining trait is honesty about measurement: it never fabricates a score it cannot ground. Scaffold: `scripts/eval-scorecard.mjs`.

### [Peer-Blocker Bridge](peer-blocker-bridge.md)
Watches a shared inbox for blocking handoffs from a peer agent, so a cross-agent question gets answered in one cron cycle instead of sitting unread for hours. Scaffold: `scripts/peer-blocker-watch.sh`.

## How they fit together

The pipeline runs the work. The regression suite is what the pipeline's test stage calls. The scorecard reads the runs the pipeline produced and reports how the session went. The bridge keeps a multi-agent setup from deadlocking while all of that happens.

For the layer that feeds the scorecard — tracing each run, capturing tokens and durable artifacts, and rendering a morning report a human reads in two minutes — see [Agent Observability](../observability.md).

Every scaffold ships with a `--selftest` so you can confirm it works before wiring it into a cron. None of them pull a dependency: the shell scripts are POSIX-ish bash, and the `.mjs` tools use Node builtins only. Copy them, adapt the paths, and keep the markdown files as the source of truth.
