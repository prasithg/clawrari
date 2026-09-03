#!/usr/bin/env node

// Validate the zero-dependency model-routing contract and its public documentation.
//
// This intentionally parses only the small YAML subset used by
// reference/model-playbook/models.yaml. Unsupported or incomplete shapes fail closed.
//
// Usage:
//   node scripts/validate-model-playbook.mjs
//   node scripts/validate-model-playbook.mjs --selftest

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import process from "node:process";

const VALID_STATUSES = new Set(["active", "comparison-only", "experimental", "retired"]);
const VALID_EFFORTS = new Set(["low", "medium", "high", "xhigh", "max"]);

function scalar(value) {
  const trimmed = value.trim();
  if (
    trimmed.length >= 2 &&
    ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
      (trimmed.startsWith("'") && trimmed.endsWith("'")))
  ) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

function sequence(value) {
  const trimmed = value.trim();
  if (!trimmed.startsWith("[") || !trimmed.endsWith("]")) return null;
  const body = trimmed.slice(1, -1).trim();
  if (!body) return [];
  return body.split(",").map((item) => scalar(item));
}

function inlineMap(value) {
  const trimmed = value.trim();
  if (!trimmed.startsWith("{") || !trimmed.endsWith("}")) return null;
  const body = trimmed.slice(1, -1).trim();
  if (!body) return {};
  const out = {};
  for (const pair of body.split(",")) {
    const splitAt = pair.indexOf(":");
    if (splitAt < 1) return null;
    out[scalar(pair.slice(0, splitAt))] = scalar(pair.slice(splitAt + 1));
  }
  return out;
}

function parseValue(value) {
  return sequence(value) ?? inlineMap(value) ?? scalar(value);
}

function parsePlaybook(raw) {
  const document = { version: null, models: {}, intents: {} };
  let section = null;
  let current = null;

  for (const [index, line] of raw.split(/\r?\n/).entries()) {
    if (/^\s*$/.test(line) || /^\s*#/.test(line)) continue;

    const version = line.match(/^version:\s*(\d+)\s*$/);
    if (version) {
      document.version = Number(version[1]);
      continue;
    }
    if (/^models:\s*$/.test(line)) {
      section = "models";
      current = null;
      continue;
    }
    if (/^intents:\s*$/.test(line)) {
      section = "intents";
      current = null;
      continue;
    }

    const entry = line.match(/^  ([A-Za-z0-9_-]+):\s*$/);
    if (entry && section) {
      current = entry[1];
      document[section][current] = {};
      continue;
    }

    const field = line.match(/^    ([A-Za-z0-9_-]+):\s*(.*?)\s*$/);
    if (field && section && current) {
      document[section][current][field[1]] = parseValue(field[2]);
      continue;
    }

    throw new Error(`unsupported YAML shape at line ${index + 1}: ${line}`);
  }

  return document;
}

function readRequired(file, errors) {
  try {
    return fs.readFileSync(file, "utf8");
  } catch (error) {
    errors.push(`missing or unreadable file: ${file} (${error.code ?? error.message})`);
    return "";
  }
}

function validate(root) {
  const errors = [];
  const playbookDir = path.join(root, "reference", "model-playbook");
  const yamlPath = path.join(playbookDir, "models.yaml");
  const raw = readRequired(yamlPath, errors);
  if (!raw) return errors;

  let doc;
  try {
    doc = parsePlaybook(raw);
  } catch (error) {
    return [`models.yaml parse failed: ${error.message}`];
  }

  if (!Number.isInteger(doc.version) || doc.version < 1) {
    errors.push("models.yaml needs a positive integer version");
  }
  if (Object.keys(doc.models).length === 0) errors.push("models.yaml declares no models");
  if (Object.keys(doc.intents).length === 0) errors.push("models.yaml declares no intents");

  const aliasOwners = new Map();
  for (const [modelId, model] of Object.entries(doc.models)) {
    for (const field of ["display_name", "full_id", "status", "prompt_file"]) {
      if (typeof model[field] !== "string" || !model[field]) {
        errors.push(`model ${modelId} is missing ${field}`);
      }
    }
    if (!VALID_STATUSES.has(model.status)) {
      errors.push(`model ${modelId} has invalid status: ${model.status ?? "(missing)"}`);
    }
    const promptFile = typeof model.prompt_file === "string" ? path.join(playbookDir, model.prompt_file) : "";
    if (promptFile && !fs.existsSync(promptFile)) {
      errors.push(`model ${modelId} points to missing prompt file: ${model.prompt_file}`);
    }

    if (!Array.isArray(model.aliases)) errors.push(`model ${modelId} needs an aliases list`);
    const aliases = Array.isArray(model.aliases) ? model.aliases : [];
    for (const alias of [modelId, ...aliases]) {
      const owner = aliasOwners.get(alias);
      if (owner && owner !== modelId) errors.push(`alias ${alias} belongs to both ${owner} and ${modelId}`);
      aliasOwners.set(alias, modelId);
    }
  }

  for (const [intentId, intent] of Object.entries(doc.intents)) {
    if (typeof intent.primary !== "string" || !intent.primary) {
      errors.push(`intent ${intentId} is missing primary`);
      continue;
    }
    if (!VALID_EFFORTS.has(intent.effort)) {
      errors.push(`intent ${intentId} has invalid effort: ${intent.effort ?? "(missing)"}`);
    }

    const fallbacks = Array.isArray(intent.fallbacks) ? intent.fallbacks : [];
    const references = [intent.primary, ...(intent.secondary ? [intent.secondary] : []), ...fallbacks];
    if (new Set(references).size !== references.length) {
      errors.push(`intent ${intentId} repeats a model across primary, secondary, or fallbacks`);
    }

    for (const modelId of references) {
      const model = doc.models[modelId];
      if (!model) {
        errors.push(`intent ${intentId} references missing model: ${modelId}`);
        continue;
      }
      if (model.status === "retired") {
        errors.push(`intent ${intentId} references retired model: ${modelId}`);
      }
      if (model.status === "comparison-only" && !/(comparison|experimental|ab_testing)/.test(intentId)) {
        errors.push(`intent ${intentId} routes production work to comparison-only model: ${modelId}`);
      }
      if (model.status === "experimental" && !/(comparison|experimental|ab_testing)/.test(intentId)) {
        errors.push(`intent ${intentId} routes production work to experimental model: ${modelId}`);
      }
    }

    const fallbackEffort = intent.fallback_effort && typeof intent.fallback_effort === "object"
      ? intent.fallback_effort
      : {};
    const effortKeys = Object.keys(fallbackEffort).sort();
    const fallbackKeys = [...fallbacks].sort();
    if (JSON.stringify(effortKeys) !== JSON.stringify(fallbackKeys)) {
      errors.push(`intent ${intentId} fallback_effort keys do not match fallbacks`);
    }
    for (const [modelId, effort] of Object.entries(fallbackEffort)) {
      if (!VALID_EFFORTS.has(effort)) errors.push(`intent ${intentId} has invalid fallback effort for ${modelId}: ${effort}`);
    }
    if (intent.secondary && !VALID_EFFORTS.has(intent.secondary_effort)) {
      errors.push(`intent ${intentId} needs a valid secondary_effort`);
    }
  }

  const mainModel = doc.models[doc.intents.main_session?.primary];
  if (!mainModel) {
    errors.push("main_session must reference a declared primary model");
  } else {
    const docs = ["README.md", "effort-ladder.md", "orchestration-strategy.md"];
    for (const relative of docs) {
      const body = readRequired(path.join(playbookDir, relative), errors);
      if (body && !body.includes(mainModel.display_name)) {
        errors.push(`${relative} does not name the main-session primary: ${mainModel.display_name}`);
      }
    }

    const guide = readRequired(path.join(playbookDir, mainModel.prompt_file), errors).split(/\r?\n/).slice(0, 16).join("\n");
    if (guide && (!guide.includes(mainModel.display_name) || !guide.includes(mainModel.full_id))) {
      errors.push(`${mainModel.prompt_file} does not identify the active main model and runtime id near the top`);
    }
  }

  const routeDocs = [
    "README.md",
    "effort-ladder.md",
    "orchestration-strategy.md",
  ];
  for (const [modelId, model] of Object.entries(doc.models)) {
    if (model.status !== "retired" || !model.display_name) continue;
    const optionalOverlay = path.join(playbookDir, "overlays", "main-opus.md");
    const retiredDocs = [
      ...routeDocs,
      model.prompt_file,
      ...(fs.existsSync(optionalOverlay) && /opus/i.test(modelId) ? ["overlays/main-opus.md"] : []),
    ];
    for (const relative of new Set(retiredDocs)) {
      const body = readRequired(path.join(playbookDir, relative), errors);
      for (const [index, line] of body.split(/\r?\n/).entries()) {
        if (!line.includes(model.display_name)) continue;
        if (!/\b(default|primary|secondary|fallback|active route)\b/i.test(line)) continue;
        if (/\b(retir|histor|legacy|previous|former|no active|never an active|was the)\w*/i.test(line)) continue;
        errors.push(`${relative}:${index + 1} may present retired ${modelId} as an active route`);
      }
    }
  }

  return [...new Set(errors)];
}

function writeFixture(root, yaml, label = "Alpha 1") {
  const playbookDir = path.join(root, "reference", "model-playbook");
  fs.mkdirSync(path.join(playbookDir, "models"), { recursive: true });
  fs.mkdirSync(path.join(playbookDir, "overlays"), { recursive: true });
  fs.writeFileSync(path.join(playbookDir, "models.yaml"), yaml);
  fs.writeFileSync(path.join(playbookDir, "README.md"), `Default: ${label}\n`);
  fs.writeFileSync(path.join(playbookDir, "effort-ladder.md"), `Default: ${label}\n`);
  fs.writeFileSync(path.join(playbookDir, "orchestration-strategy.md"), `Primary: ${label}\n`);
  fs.writeFileSync(path.join(playbookDir, "models", "alpha.md"), `# ${label}\nmodel/alpha-1\n`);
  fs.writeFileSync(path.join(playbookDir, "models", "old.md"), "# Old 1 — Retired reference\n");
  fs.writeFileSync(path.join(playbookDir, "models", "beta.md"), "# Beta 1\nmodel/beta-1\n");
  fs.writeFileSync(path.join(playbookDir, "overlays", "main-opus.md"), "Retired reference. No active route.\n");
}

function selftest() {
  const base = `version: 1
models:
  alpha-1:
    display_name: Alpha 1
    aliases: [alpha]
    full_id: model/alpha-1
    status: active
    prompt_file: models/alpha.md
  old-1:
    display_name: Old 1
    aliases: [old]
    full_id: model/old-1
    status: retired
    prompt_file: models/old.md
intents:
  main_session:
    primary: alpha-1
    effort: medium
    fallbacks: []
    rationale: "fixture"
`;
  const temp = fs.mkdtempSync(path.join(os.tmpdir(), "model-playbook-test-"));
  try {
    const validRoot = path.join(temp, "valid");
    writeFixture(validRoot, base);
    if (validate(validRoot).length !== 0) throw new Error(`valid fixture failed: ${validate(validRoot).join("; ")}`);

    const retiredRoot = path.join(temp, "retired-route");
    writeFixture(retiredRoot, base.replace("primary: alpha-1", "primary: old-1"), "Old 1");
    if (!validate(retiredRoot).some((error) => error.includes("references retired model"))) {
      throw new Error("retired-route fixture was accepted");
    }

    const missingRoot = path.join(temp, "missing-prompt");
    writeFixture(missingRoot, base.replace("models/alpha.md", "models/missing.md"));
    if (!validate(missingRoot).some((error) => error.includes("missing prompt file"))) {
      throw new Error("missing-prompt fixture was accepted");
    }

    const aliasRoot = path.join(temp, "duplicate-alias");
    const duplicateAlias = base.replace(
      "intents:\n",
      `  beta-1:\n    display_name: Beta 1\n    aliases: [alpha]\n    full_id: model/beta-1\n    status: active\n    prompt_file: models/beta.md\nintents:\n`,
    );
    writeFixture(aliasRoot, duplicateAlias);
    if (!validate(aliasRoot).some((error) => error.includes("belongs to both"))) {
      throw new Error("duplicate-alias fixture was accepted");
    }

    console.log("PASS model-playbook validator selftest (4 fixtures)");
  } finally {
    fs.rmSync(temp, { recursive: true, force: true });
  }
}

function main() {
  const args = process.argv.slice(2);
  if (args.length > 1 || (args.length === 1 && args[0] !== "--selftest")) {
    console.error("usage: node scripts/validate-model-playbook.mjs [--selftest]");
    process.exit(2);
  }
  if (args[0] === "--selftest") {
    try {
      selftest();
      return;
    } catch (error) {
      console.error(`FAIL selftest: ${error.message}`);
      process.exit(1);
    }
  }

  const errors = validate(process.cwd());
  if (errors.length > 0) {
    for (const error of errors) console.error(`FAIL ${error}`);
    console.error(`\n${errors.length} model-playbook check(s) failed.`);
    process.exit(1);
  }

  const parsed = parsePlaybook(
    fs.readFileSync(path.join(process.cwd(), "reference", "model-playbook", "models.yaml"), "utf8"),
  );
  console.log(
    `PASS model playbook: ${Object.keys(parsed.models).length} models, ` +
      `${Object.keys(parsed.intents).length} intents, routing docs aligned.`,
  );
}

main();
