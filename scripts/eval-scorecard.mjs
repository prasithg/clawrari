#!/usr/bin/env node

// eval-scorecard.mjs — cross-agent session eval scorecard (6 axes).
//
// Rolls up a window of agent runs into a single scorecard with six axes:
// Output, Throughput, Intelligence, Collaboration, Autonomy, Safety.
//
// The core discipline is honesty about what you can and cannot measure:
//   - Tokens and cost are summed ONLY across runs that actually carry them. Runs with
//     null metrics are counted as opaque_runs and never estimated. This matters on
//     plans where per-run token receipts are not exposed.
//   - Axes that need human or QA judgment (Output quality, Intelligence, Collaboration,
//     Autonomy) emit score:null with a "needs":"qa-judgment" marker plus the supporting
//     evidence the reviewer should look at. They never emit a fabricated 1-5.
//   - Throughput is capped at 3 and labelled "uninstrumented" until real token receipts
//     exist, so an opaque run cannot inflate the score.
//   - Safety defaults to 5 and drops to 1 if a guardrail breach is recorded. A breach
//     caps the whole session.
//
// Input: a JSONL index of runs (one JSON object per line). Each row may carry:
//   { "agent": "claude", "started_at": ISO, "ended_at": ISO, "exit_code": 0,
//     "artifacts": ["path", ...],
//     "metrics": { "tokens_in": N|null, "tokens_out": N|null, "cost_usd": N|null } }
// Missing fields degrade gracefully; the roll-up keeps whatever is present.
//
// Node builtins only. No dependencies. Sanitized and generic.
//
// Usage:
//   node scripts/eval-scorecard.mjs --index runs.jsonl \
//       [--since ISO] [--until ISO] [--session-name "..."] \
//       [--mode solo|orchestrated|peer] [--guardrail-breach] [--print]
//   node scripts/eval-scorecard.mjs --selftest
//
// Default window: last 18h if --since omitted; --until defaults to now.

import fs from "node:fs";
import process from "node:process";

const DEFAULT_WINDOW_HOURS = 18;
const VALID_MODES = new Set(["solo", "orchestrated", "peer"]);
const ARTIFACT_TOOL_RE = /write|edit|create|patch|multiedit|notebook/i;
const BOOL_FLAGS = new Set(["print", "selftest", "guardrail-breach"]);

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i += 1) {
    const key = argv[i];
    if (!key.startsWith("--")) throw new Error(`Unexpected argument: ${key}`);
    const name = key.slice(2);
    if (BOOL_FLAGS.has(name)) {
      args[name] = true;
      continue;
    }
    const value = argv[i + 1];
    if (value === undefined || value.startsWith("--")) throw new Error(`Missing value for ${key}`);
    args[name] = value;
    i += 1;
  }
  return args;
}

function isoOrThrow(value, label) {
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) throw new Error(`Invalid ${label}: ${value}`);
  return d;
}

function wallSeconds(startedAt, endedAt) {
  const s = new Date(startedAt).getTime();
  const e = new Date(endedAt).getTime();
  if (Number.isNaN(s) || Number.isNaN(e)) return 0;
  const sec = (e - s) / 1000;
  return sec > 0 ? sec : 0;
}

function round(n, places = 2) {
  const f = 10 ** places;
  return Math.round(n * f) / f;
}

function loadIndexRows(indexPath) {
  if (!fs.existsSync(indexPath)) return [];
  const rows = [];
  for (const line of fs.readFileSync(indexPath, "utf8").split(/\r?\n/)) {
    if (!line.trim()) continue;
    try {
      rows.push(JSON.parse(line));
    } catch {
      // skip malformed rows rather than aborting the whole roll-up
    }
  }
  return rows;
}

function filterWindow(rows, since, until) {
  const sinceMs = since.getTime();
  const untilMs = until.getTime();
  return rows.filter((row) => {
    const t = new Date(row.started_at).getTime();
    return !Number.isNaN(t) && t >= sinceMs && t <= untilMs;
  });
}

function extractArtifacts(row) {
  if (Array.isArray(row.artifacts) && row.artifacts.length) {
    return [...new Set(row.artifacts.map(String))];
  }
  const found = new Set();
  for (const call of row.tool_calls || []) {
    if (!call || !ARTIFACT_TOOL_RE.test(call.name || "")) continue;
    for (const t of call.targets || []) found.add(String(t));
  }
  return [...found];
}

function rollup(rows) {
  const agents = {};
  for (const row of rows) {
    const agent = row.agent || "unknown";
    if (!agents[agent]) {
      agents[agent] = {
        agent,
        run_count: 0,
        total_wall_clock_seconds: 0,
        mean_wall_clock_seconds: 0,
        exit_code_histogram: {},
        artifacts: [],
        measured_runs: 0,
        opaque_runs: 0,
        tokens_in: 0,
        tokens_out: 0,
        cost_usd: 0,
        token_visibility: "measured",
      };
    }
    const a = agents[agent];
    a.run_count += 1;
    a.total_wall_clock_seconds += wallSeconds(row.started_at, row.ended_at);

    const exit = row.exit_code;
    const exitKey = exit === null || exit === undefined ? "null" : String(exit);
    a.exit_code_histogram[exitKey] = (a.exit_code_histogram[exitKey] || 0) + 1;

    for (const art of extractArtifacts(row)) {
      if (!a.artifacts.includes(art)) a.artifacts.push(art);
    }

    const m = row.metrics || {};
    const hasIn = m.tokens_in !== null && m.tokens_in !== undefined;
    const hasOut = m.tokens_out !== null && m.tokens_out !== undefined;
    const hasCost = m.cost_usd !== null && m.cost_usd !== undefined;
    if (hasIn || hasOut || hasCost) {
      a.measured_runs += 1;
      if (hasIn) a.tokens_in += Number(m.tokens_in);
      if (hasOut) a.tokens_out += Number(m.tokens_out);
      if (hasCost) a.cost_usd += Number(m.cost_usd);
    } else {
      a.opaque_runs += 1;
    }
  }

  for (const a of Object.values(agents)) {
    a.mean_wall_clock_seconds = a.run_count ? round(a.total_wall_clock_seconds / a.run_count) : 0;
    a.total_wall_clock_seconds = round(a.total_wall_clock_seconds);
    a.cost_usd = round(a.cost_usd, 4);
    if (a.measured_runs === 0 && a.opaque_runs > 0) {
      a.token_visibility = "opaque";
      a.tokens_in = null;
      a.tokens_out = null;
      a.cost_usd = null;
    } else if (a.opaque_runs > 0) {
      a.token_visibility = "partial";
    }
  }
  return agents;
}

function sessionWallClock(rows) {
  let min = Infinity;
  let max = -Infinity;
  for (const row of rows) {
    const s = new Date(row.started_at).getTime();
    const e = new Date(row.ended_at).getTime();
    if (!Number.isNaN(s)) min = Math.min(min, s);
    if (!Number.isNaN(e)) max = Math.max(max, e);
  }
  if (!Number.isFinite(min) || !Number.isFinite(max)) return 0;
  return round((max - min) / 3600000, 2);
}

function buildScorecard({ rows, agentRollup, since, until, sessionName, mode, guardrailBreach }) {
  const agentNames = Object.keys(agentRollup).sort();
  const wallClockH = sessionWallClock(rows);
  const allArtifacts = [...new Set(agentNames.flatMap((n) => agentRollup[n].artifacts))];
  const totalRuns = agentNames.reduce((s, n) => s + agentRollup[n].run_count, 0);
  const exitNonZero = agentNames.reduce((s, n) => {
    const h = agentRollup[n].exit_code_histogram;
    return s + Object.entries(h).reduce((acc, [k, v]) => (k === "0" ? acc : acc + v), 0);
  }, 0);
  const measuredRuns = agentNames.reduce((s, n) => s + agentRollup[n].measured_runs, 0);
  const opaqueRuns = agentNames.reduce((s, n) => s + agentRollup[n].opaque_runs, 0);
  const tokenVisibility = measuredRuns === 0 ? "opaque" : opaqueRuns > 0 ? "partial" : "measured";
  const isCollabMode = mode === "orchestrated" || mode === "peer";
  const guardrailHeld = !guardrailBreach;

  return {
    schemaVersion: "cross-agent-eval-scorecard/v0.1",
    generated_at: new Date().toISOString(),
    generator: "scripts/eval-scorecard.mjs",
    session: {
      name: sessionName,
      mode,
      window: { since: since.toISOString(), until: until.toISOString() },
      wall_clock_hours: wallClockH,
      total_runs: totalRuns,
      agents_observed: agentNames,
    },
    rollup: agentRollup,
    axes: {
      output: {
        name: "Output",
        score: null,
        needs: "qa-judgment",
        evidence: {
          durable_artifacts_count: allArtifacts.length,
          artifacts: allArtifacts,
          runs_total: totalRuns,
          runs_nonzero_exit: exitNonZero,
        },
      },
      throughput: {
        name: "Throughput",
        score: measuredRuns > 0 ? null : 3,
        capped: measuredRuns === 0,
        cap_reason: measuredRuns === 0 ? "uninstrumented: token/cost receipts unavailable (opaque)" : null,
        needs: measuredRuns > 0 ? "qa-judgment" : null,
        evidence: {
          wall_clock_hours: wallClockH,
          per_agent_run_counts: Object.fromEntries(agentNames.map((n) => [n, agentRollup[n].run_count])),
          durable_artifacts_count: allArtifacts.length,
          measured_runs: measuredRuns,
          opaque_runs: opaqueRuns,
          token_visibility: tokenVisibility,
        },
      },
      intelligence: {
        name: "Intelligence / Quality",
        score: null,
        needs: "qa-judgment",
        evidence: {
          agents_observed: agentNames,
          note: "model tier and reasoning effort are not recorded in the run schema; independent QA verdict required",
        },
      },
      collaboration: {
        name: "Collaboration Health",
        score: null,
        needs: isCollabMode ? "qa-judgment" : "n/a-solo-mode",
        evidence: {
          applicable: isCollabMode,
          agents_involved: agentNames,
          note: "blocking-question latency, redundancy, and symmetry require a human read of the session",
        },
      },
      autonomy: {
        name: "Autonomy",
        execution: { score: null, needs: "qa-judgment" },
        direction: { score: null, needs: "qa-judgment" },
        evidence: {
          note: "report execution autonomy and direction autonomy as separate ratios; never blend them",
        },
      },
      safety: {
        name: "Safety",
        score: guardrailHeld ? 5 : 1,
        guardrail_held: guardrailHeld,
        evidence: {
          source: "default held; pass --guardrail-breach to record a breach (caps the session at 1)",
        },
      },
    },
  };
}

function fmtScore(axis) {
  if (axis.score === null || axis.score === undefined) return `null (${axis.needs})`;
  return `${axis.score}/5${axis.capped ? " (capped)" : ""}`;
}

function renderMarkdown(sc) {
  const s = sc.session;
  const a = sc.axes;
  const agentLines = s.agents_observed.map((n) => {
    const r = sc.rollup[n];
    return `  - ${n}: ${r.run_count} run(s), wall-clock ${r.total_wall_clock_seconds}s (mean ${r.mean_wall_clock_seconds}s), exits ${JSON.stringify(r.exit_code_histogram)}, tokens ${r.token_visibility}, artifacts ${r.artifacts.length}`;
  });
  return [
    `## Cross-Agent Session Eval — ${s.window.since.slice(0, 10)} — Mode: ${s.mode}`,
    `Session: ${s.name || "(unnamed)"}`,
    `Agents: ${s.agents_observed.join(", ") || "(none in window)"}`,
    `Window: ${s.window.since} to ${s.window.until}, wall-clock ${s.wall_clock_hours}h`,
    `Total runs: ${s.total_runs}`,
    ``,
    `### Per-agent roll-up`,
    agentLines.join("\n") || "  - (no runs in window)",
    ``,
    `| Axis | Score/5 | Note |`,
    `|------|---------|------|`,
    `| Output | ${fmtScore(a.output)} | ${a.output.evidence.durable_artifacts_count} durable artifacts |`,
    `| Throughput | ${fmtScore(a.throughput)} | ${a.throughput.cap_reason || "instrumented"} |`,
    `| Intelligence | ${fmtScore(a.intelligence)} | needs QA |`,
    `| Collaboration | ${fmtScore(a.collaboration)} | ${a.collaboration.evidence.applicable ? "needs QA" : "solo, n/a"} |`,
    `| Autonomy (exec/dir) | null / null (qa-judgment) | report separately |`,
    `| Safety | ${a.safety.score}/5 | guardrail ${a.safety.guardrail_held ? "held" : "BREACHED"} |`,
  ].join("\n");
}

function selftest() {
  const rows = [
    { agent: "claude", started_at: "2026-06-15T01:00:00Z", ended_at: "2026-06-15T01:30:00Z", exit_code: 0, artifacts: ["docs/a.md"], metrics: { tokens_in: null, tokens_out: null, cost_usd: null } },
    { agent: "claude", started_at: "2026-06-15T02:00:00Z", ended_at: "2026-06-15T02:10:00Z", exit_code: 1, artifacts: ["docs/b.md"] },
    { agent: "codex", started_at: "2026-06-15T03:00:00Z", ended_at: "2026-06-15T03:20:00Z", exit_code: 0, artifacts: ["docs/a.md"], metrics: { tokens_in: 1000, tokens_out: 500, cost_usd: 0.02 } },
  ];
  const r = rollup(rows);
  const assert = (cond, msg) => { if (!cond) { console.error("selftest FAIL:", msg); process.exit(1); } };

  assert(r.claude.run_count === 2, "claude run_count");
  assert(r.claude.opaque_runs === 2 && r.claude.measured_runs === 0, "claude opaque accounting");
  assert(r.claude.tokens_in === null, "opaque-only agent tokens must be null, never estimated");
  assert(r.codex.measured_runs === 1 && r.codex.tokens_in === 1000, "codex measured accounting");
  assert([...new Set(rows.flatMap((x) => x.artifacts))].length === 2, "dedup artifacts");

  const sc = buildScorecard({
    rows, agentRollup: r,
    since: new Date("2026-06-15T00:00:00Z"), until: new Date("2026-06-15T23:59:59Z"),
    sessionName: "selftest", mode: "orchestrated", guardrailBreach: false,
  });
  assert(sc.axes.output.score === null && sc.axes.output.needs === "qa-judgment", "output stays qa-judgment");
  assert(sc.axes.safety.score === 5, "safety defaults to 5 when held");

  const breached = buildScorecard({
    rows, agentRollup: r,
    since: new Date("2026-06-15T00:00:00Z"), until: new Date("2026-06-15T23:59:59Z"),
    sessionName: "selftest", mode: "solo", guardrailBreach: true,
  });
  assert(breached.axes.safety.score === 1, "guardrail breach caps safety at 1");
  assert(breached.axes.collaboration.needs === "n/a-solo-mode", "solo mode marks collaboration n/a");

  console.log("selftest OK");
}

function main() {
  let args;
  try {
    args = parseArgs(process.argv.slice(2));
  } catch (err) {
    console.error(err.message);
    process.exit(2);
  }
  if (args.selftest) return selftest();
  if (!args.index) {
    console.error("--index <runs.jsonl> is required (or use --selftest)");
    process.exit(2);
  }
  const mode = args.mode || "solo";
  if (!VALID_MODES.has(mode)) {
    console.error(`--mode must be one of: ${[...VALID_MODES].join(", ")}`);
    process.exit(2);
  }
  const until = args.until ? isoOrThrow(args.until, "until") : new Date();
  const since = args.since
    ? isoOrThrow(args.since, "since")
    : new Date(until.getTime() - DEFAULT_WINDOW_HOURS * 3600000);

  const rows = filterWindow(loadIndexRows(args.index), since, until);
  const agentRollup = rollup(rows);
  const sc = buildScorecard({
    rows, agentRollup, since, until,
    sessionName: args["session-name"] || "", mode,
    guardrailBreach: Boolean(args["guardrail-breach"]),
  });

  if (args.print) {
    console.log(renderMarkdown(sc));
  } else {
    console.log(JSON.stringify(sc, null, 2));
  }
}

main();
