#!/usr/bin/env node

// regression-check.mjs — turn guardrails into machine-checkable assertions.
//
// A regression log written in prose ("never commit secrets", "the brief must stay
// under 50 lines") is only as good as someone remembering to read it. This runner
// makes a subset of those guardrails executable: each one becomes an assertion that
// passes or fails, and the suite exits non-zero on any failure so a cron or pre-commit
// hook can enforce it.
//
// Node builtins only. No dependencies. Sanitized and generic.
//
// Spec format (JSON): an array of checks, or { "checks": [ ... ] }.
//   {
//     "id": "REG-001",
//     "description": "secrets file is never committed",
//     "type": "file_absent",
//     "target": ".env",
//     "severity": "P0"            // optional, defaults to "P0"
//   }
//
// Supported check types:
//   file_exists          target = path
//   file_absent          target = path
//   file_contains        target = path, pattern = regex (string)
//   file_not_contains    target = path, pattern = regex (string)
//   max_lines            target = path, max = number
//   command_succeeds     command = shell string (exit 0 = pass)
//   command_output_matches  command = shell string, pattern = regex on stdout
//
// Usage:
//   node scripts/regression-check.mjs --spec regressions.json [--root .] [--json]
//   node scripts/regression-check.mjs --selftest
//
// Exit codes: 0 = all passed, 1 = at least one failure, 2 = usage/spec error.

import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { execSync } from "node:child_process";

function parseArgs(argv) {
  const args = { root: process.cwd(), json: false, selftest: false };
  for (let i = 0; i < argv.length; i += 1) {
    const a = argv[i];
    if (a === "--json") args.json = true;
    else if (a === "--selftest") args.selftest = true;
    else if (a === "--spec") args.spec = argv[++i];
    else if (a === "--root") args.root = argv[++i];
    else throw new Error(`Unknown argument: ${a}`);
  }
  return args;
}

function resolve(root, target) {
  return path.isAbsolute(target) ? target : path.join(root, target);
}

function readFileOrNull(p) {
  try {
    return fs.readFileSync(p, "utf8");
  } catch {
    return null;
  }
}

// Each runner returns { ok: boolean, detail: string }.
const RUNNERS = {
  file_exists(check, root) {
    const p = resolve(root, check.target);
    const ok = fs.existsSync(p);
    return { ok, detail: ok ? `exists: ${check.target}` : `missing: ${check.target}` };
  },
  file_absent(check, root) {
    const p = resolve(root, check.target);
    const ok = !fs.existsSync(p);
    return { ok, detail: ok ? `absent: ${check.target}` : `present (should be absent): ${check.target}` };
  },
  file_contains(check, root) {
    const body = readFileOrNull(resolve(root, check.target));
    if (body === null) return { ok: false, detail: `unreadable: ${check.target}` };
    const ok = new RegExp(check.pattern).test(body);
    return { ok, detail: ok ? `matched /${check.pattern}/` : `no match for /${check.pattern}/ in ${check.target}` };
  },
  file_not_contains(check, root) {
    const body = readFileOrNull(resolve(root, check.target));
    if (body === null) return { ok: true, detail: `unreadable (treated as clean): ${check.target}` };
    const ok = !new RegExp(check.pattern).test(body);
    return { ok, detail: ok ? `clean of /${check.pattern}/` : `found banned /${check.pattern}/ in ${check.target}` };
  },
  max_lines(check, root) {
    const body = readFileOrNull(resolve(root, check.target));
    if (body === null) return { ok: false, detail: `unreadable: ${check.target}` };
    const lines = body.split(/\r?\n/).length;
    const ok = lines <= check.max;
    return { ok, detail: `${lines} lines (max ${check.max}) in ${check.target}` };
  },
  command_succeeds(check, root) {
    try {
      execSync(check.command, { cwd: root, stdio: "pipe" });
      return { ok: true, detail: `exit 0: ${check.command}` };
    } catch (err) {
      return { ok: false, detail: `non-zero exit: ${check.command} (${err.status ?? "?"})` };
    }
  },
  command_output_matches(check, root) {
    let out = "";
    try {
      out = execSync(check.command, { cwd: root, stdio: "pipe" }).toString();
    } catch (err) {
      out = (err.stdout || "").toString();
    }
    const ok = new RegExp(check.pattern).test(out);
    return { ok, detail: ok ? `output matched /${check.pattern}/` : `output missing /${check.pattern}/` };
  },
};

function runChecks(checks, root) {
  const results = [];
  for (const check of checks) {
    if (!check.id || !check.type) {
      results.push({ id: check.id || "(no id)", ok: false, severity: "P0", detail: "invalid check: needs id and type" });
      continue;
    }
    const runner = RUNNERS[check.type];
    if (!runner) {
      results.push({ id: check.id, ok: false, severity: check.severity || "P0", detail: `unknown type: ${check.type}` });
      continue;
    }
    let r;
    try {
      r = runner(check, root);
    } catch (err) {
      r = { ok: false, detail: `runner error: ${err.message}` };
    }
    results.push({
      id: check.id,
      description: check.description || "",
      severity: check.severity || "P0",
      ok: r.ok,
      detail: r.detail,
    });
  }
  return results;
}

function loadSpec(specPath) {
  const raw = fs.readFileSync(specPath, "utf8");
  const doc = JSON.parse(raw);
  const checks = Array.isArray(doc) ? doc : doc.checks;
  if (!Array.isArray(checks)) throw new Error("spec must be an array or { checks: [...] }");
  return checks;
}

function render(results) {
  const failed = results.filter((r) => !r.ok);
  for (const r of results) {
    const mark = r.ok ? "PASS" : "FAIL";
    console.log(`[${mark}] ${r.id} (${r.severity}) — ${r.detail}`);
  }
  console.log(`\n${results.length - failed.length}/${results.length} checks passed.`);
  return failed.length === 0;
}

function selftest() {
  const tmp = fs.mkdtempSync(path.join(process.cwd(), ".regtest-"));
  try {
    fs.writeFileSync(path.join(tmp, "present.txt"), "hello world\nsecond line\n");
    const checks = [
      { id: "T1", type: "file_exists", target: "present.txt" },
      { id: "T2", type: "file_absent", target: "nope.txt" },
      { id: "T3", type: "file_contains", target: "present.txt", pattern: "hello" },
      { id: "T4", type: "file_not_contains", target: "present.txt", pattern: "SECRET" },
      { id: "T5", type: "max_lines", target: "present.txt", max: 10 },
      { id: "T6", type: "command_succeeds", command: "true" },
    ];
    const results = runChecks(checks, tmp);
    const allPass = results.every((r) => r.ok);
    if (!allPass) {
      console.error("selftest FAIL: expected all green", results);
      process.exit(1);
    }
    // a deliberately failing check must report fail
    const failResults = runChecks([{ id: "T7", type: "file_exists", target: "nope.txt" }], tmp);
    if (failResults[0].ok) {
      console.error("selftest FAIL: missing file reported as present");
      process.exit(1);
    }
    console.log("selftest OK");
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }
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
  if (!args.spec) {
    console.error("--spec <path> is required (or use --selftest)");
    process.exit(2);
  }
  let checks;
  try {
    checks = loadSpec(args.spec);
  } catch (err) {
    console.error(`spec error: ${err.message}`);
    process.exit(2);
  }
  const results = runChecks(checks, args.root);
  if (args.json) {
    console.log(JSON.stringify({ results, passed: results.every((r) => r.ok) }, null, 2));
  } else {
    render(results);
  }
  process.exit(results.every((r) => r.ok) ? 0 : 1);
}

main();
