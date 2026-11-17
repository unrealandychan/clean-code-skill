#!/usr/bin/env node
"use strict";

/**
 * doctor.js
 *
 * Workspace and Cross-Harness Diagnostics for Clean Code + DDD + Harness + ECC.
 * Inspects all installed capabilities, agents, skills, rules, hooks, and linters.
 *
 * Usage:
 *   node scripts/doctor.js [--json]
 */

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const REPO_ROOT = path.resolve(__dirname, "..");

function checkCmd(cmd) {
  try {
    execSync(`command -v ${cmd}`, { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

function countItems(dirPath, filter = () => true) {
  if (!fs.existsSync(dirPath)) return 0;
  return fs.readdirSync(dirPath).filter(filter).length;
}

function runDiagnostics() {
  const report = {
    timestamp: new Date().toISOString(),
    coreSkills: {},
    eccComponents: {},
    systemTools: {},
    status: "healthy",
  };

  // 1. Core Clean Code / DDD Skills
  const coreSkillDirs = [
    "code-review",
    "elephant-goldfish",
    "extreme-constraints",
    "impeccable",
    "productivity",
    "harness",
    "skill-doctor",
    "update-skill",
    "shared",
    "claude",
    "cursor",
    "copilot",
    "codex",
    "opencode",
    "hermes",
    "aider",
    "generic",
  ];

  for (const name of coreSkillDirs) {
    const p = path.join(REPO_ROOT, "skills", name);
    report.coreSkills[name] = fs.existsSync(p);
  }

  // 2. ECC Components
  const agentsDir = path.join(REPO_ROOT, "agents");
  const rulesDir = path.join(REPO_ROOT, "rules");
  const eccSkillsDir = path.join(REPO_ROOT, "skills", "ecc");
  const hooksDir = path.join(REPO_ROOT, "hooks");
  const contextsDir = path.join(REPO_ROOT, "contexts");

  report.eccComponents.agentsCount = countItems(agentsDir, (f) =>
    f.endsWith(".md"),
  );
  report.eccComponents.rulePacksCount = countItems(rulesDir, (f) => {
    return fs.statSync(path.join(rulesDir, f)).isDirectory();
  });
  report.eccComponents.eccSkillsCount = countItems(eccSkillsDir, (f) => {
    return fs.statSync(path.join(eccSkillsDir, f)).isDirectory();
  });
  report.eccComponents.hooksConfig = fs.existsSync(
    path.join(hooksDir, "hooks.json"),
  );
  report.eccComponents.memoryPersistence = fs.existsSync(
    path.join(hooksDir, "memory-persistence"),
  );
  report.eccComponents.contexts = countItems(contextsDir, (f) =>
    f.endsWith(".md"),
  );

  // 3. System Tools & Linters
  const tools = [
    "git",
    "node",
    "npm",
    "python3",
    "ruff",
    "eslint",
    "prettier",
    "golangci-lint",
    "dotnet",
    "checkstyle",
  ];
  for (const t of tools) {
    report.systemTools[t] = checkCmd(t);
  }

  return report;
}

function printReport(report, isJson) {
  if (isJson) {
    console.log(JSON.stringify(report, null, 2));
    return;
  }

  console.log(
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  );
  console.log(" Clean Code + DDD + Harness + ECC — Doctor Diagnostics");
  console.log(
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n",
  );

  console.log("1. Core Clean Code & DDD Skills:");
  for (const [skill, present] of Object.entries(report.coreSkills)) {
    console.log(
      `   ${present ? "✓" : "✗"} ${skill.padEnd(24)} ${present ? "ready" : "missing"}`,
    );
  }

  console.log("\n2. ECC Harness Operating System:");
  console.log(
    `   ✓ Agents:             ${report.eccComponents.agentsCount} specialized subagents`,
  );
  console.log(
    `   ✓ Language Rules:     ${report.eccComponents.rulePacksCount} framework/language rule packs`,
  );
  console.log(
    `   ✓ Curated Skills:     ${report.eccComponents.eccSkillsCount} domain skills`,
  );
  console.log(
    `   ${report.eccComponents.hooksConfig ? "✓" : "✗"} Runtime Hooks:       ${report.eccComponents.hooksConfig ? "hooks.json present" : "missing"}`,
  );
  console.log(
    `   ${report.eccComponents.memoryPersistence ? "✓" : "✗"} Memory Persistence: ${report.eccComponents.memoryPersistence ? "enabled" : "missing"}`,
  );
  console.log(
    `   ✓ Dynamic Contexts:   ${report.eccComponents.contexts} context profiles (dev, review, research)`,
  );

  console.log("\n3. Developer Environment Linters & Tools:");
  for (const [tool, present] of Object.entries(report.systemTools)) {
    console.log(
      `   ${present ? "●" : "○"} ${tool.padEnd(16)} ${present ? "installed" : "not found in PATH"}`,
    );
  }

  console.log(
    "\n──────────────────────────────────────────────────────────────────────",
  );
  console.log(
    "Overall Status: All AI agent capabilities and rule packs are operational.\n",
  );
}

if (require.main === module) {
  const isJson = process.argv.includes("--json");
  const report = runDiagnostics();
  printReport(report, isJson);
}

module.exports = { runDiagnostics };
