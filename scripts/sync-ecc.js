#!/usr/bin/env node
"use strict";

/**
 * sync-ecc.js
 *
 * Imports and synchronizes ECC (Everything Claude Code / Agent Harness OS)
 * assets into clean-code-skills.
 *
 * Copies:
 *  - agents/                -> agents/
 *  - rules/                 -> rules/
 *  - skills/                -> skills/ecc/
 *  - hooks/                 -> hooks/
 *  - contexts/              -> contexts/
 *  - manifests/             -> manifests/
 *  - scripts/lib/           -> scripts/lib/
 *  - scripts/hooks/         -> scripts/hooks/
 *
 * Usage:
 *   node scripts/sync-ecc.js [--source <path-to-ECC>] [--dry-run]
 */

const fs = require("fs");
const path = require("path");

const REPO_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SOURCE = path.resolve(
  process.env.ECC_SOURCE ||
    "/Users/eddiechan/.gemini/antigravity/brain/ec9febcb-33b1-4523-a4ed-dfda5551c64b/scratch/ECC",
);

function parseArgs() {
  const args = process.argv.slice(2);
  let source = DEFAULT_SOURCE;
  let dryRun = false;
  let verifyOnly = false;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--source" && args[i + 1]) {
      source = path.resolve(args[i + 1]);
      i++;
    } else if (args[i] === "--dry-run") {
      dryRun = true;
    } else if (args[i] === "--verify") {
      verifyOnly = true;
    }
  }

  return { source, dryRun, verifyOnly };
}

function copyRecursive(src, dst, dryRun, stats) {
  if (!fs.existsSync(src)) {
    return;
  }

  const stat = fs.statSync(src);
  if (stat.isDirectory()) {
    if (!fs.existsSync(dst) && !dryRun) {
      fs.mkdirSync(dst, { recursive: true });
    }
    const entries = fs.readdirSync(src);
    for (const entry of entries) {
      if (entry === ".git" || entry === "node_modules") continue;
      copyRecursive(
        path.join(src, entry),
        path.join(dst, entry),
        dryRun,
        stats,
      );
    }
  } else if (stat.isFile()) {
    stats.files++;
    stats.bytes += stat.size;
    if (!dryRun) {
      const parent = path.dirname(dst);
      if (!fs.existsSync(parent)) {
        fs.mkdirSync(parent, { recursive: true });
      }
      fs.copyFileSync(src, dst);
    }
  }
}

function countFiles(dir) {
  if (!fs.existsSync(dir)) return 0;
  let count = 0;
  function walk(d) {
    const list = fs.readdirSync(d, { withFileTypes: true });
    for (const item of list) {
      if (item.name === ".git" || item.name === "node_modules") continue;
      if (item.isDirectory()) walk(path.join(d, item.name));
      else if (item.isFile()) count++;
    }
  }
  walk(dir);
  return count;
}

function main() {
  const { source, dryRun, verifyOnly } = parseArgs();

  console.log(
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  );
  console.log(" Clean Code + DDD Skill Kit — ECC Importer & Synchronizer");
  console.log(
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  );
  console.log(`Source ECC:  ${source}`);
  console.log(`Target Repo: ${REPO_ROOT}`);
  console.log(
    `Mode:        ${dryRun ? "DRY-RUN" : verifyOnly ? "VERIFY-ONLY" : "SYNC"}\n`,
  );

  if (!fs.existsSync(source)) {
    console.error(`Error: Source directory not found: ${source}`);
    process.exit(1);
  }

  if (verifyOnly) {
    console.log("Verifying imported assets in target repo:");
    const agentCount = countFiles(path.join(REPO_ROOT, "agents"));
    const ruleCount = countFiles(path.join(REPO_ROOT, "rules"));
    const eccSkillCount = countFiles(path.join(REPO_ROOT, "skills", "ecc"));
    const hookCount = countFiles(path.join(REPO_ROOT, "hooks"));
    const contextCount = countFiles(path.join(REPO_ROOT, "contexts"));

    console.log(` - agents/:     ${agentCount} files`);
    console.log(` - rules/:      ${ruleCount} files`);
    console.log(` - skills/ecc/: ${eccSkillCount} files`);
    console.log(` - hooks/:      ${hookCount} files`);
    console.log(` - contexts/:   ${contextCount} files`);

    if (agentCount >= 60 && eccSkillCount >= 200 && ruleCount >= 50) {
      console.log("\n[PASS] ECC assets are verified and healthy.");
      process.exit(0);
    } else {
      console.error(
        "\n[FAIL] ECC assets are missing or incomplete. Run sync-ecc.js without --verify.",
      );
      process.exit(1);
    }
  }

  const syncPlan = [
    {
      name: "Agents",
      src: path.join(source, "agents"),
      dst: path.join(REPO_ROOT, "agents"),
    },
    {
      name: "Rules",
      src: path.join(source, "rules"),
      dst: path.join(REPO_ROOT, "rules"),
    },
    {
      name: "Skills (ECC library)",
      src: path.join(source, "skills"),
      dst: path.join(REPO_ROOT, "skills", "ecc"),
    },
    {
      name: "Hooks config",
      src: path.join(source, "hooks"),
      dst: path.join(REPO_ROOT, "hooks"),
    },
    {
      name: "Contexts",
      src: path.join(source, "contexts"),
      dst: path.join(REPO_ROOT, "contexts"),
    },
    {
      name: "Manifests",
      src: path.join(source, "manifests"),
      dst: path.join(REPO_ROOT, "manifests"),
    },
    {
      name: "Lib (Scripts)",
      src: path.join(source, "scripts", "lib"),
      dst: path.join(REPO_ROOT, "scripts", "lib"),
    },
    {
      name: "Hooks runtime (Scripts)",
      src: path.join(source, "scripts", "hooks"),
      dst: path.join(REPO_ROOT, "scripts", "hooks"),
    },
  ];

  const totalStats = { files: 0, bytes: 0 };

  for (const item of syncPlan) {
    const stats = { files: 0, bytes: 0 };
    if (!fs.existsSync(item.src)) {
      console.warn(
        `[WARN] Skipping ${item.name}: Source directory missing (${item.src})`,
      );
      continue;
    }
    copyRecursive(item.src, item.dst, dryRun, stats);
    totalStats.files += stats.files;
    totalStats.bytes += stats.bytes;
    const mb = (stats.bytes / (1024 * 1024)).toFixed(2);
    console.log(
      `✓ ${item.name.padEnd(26)} -> ${stats.files.toString().padStart(4)} files (${mb} MB)`,
    );
  }

  const totalMb = (totalStats.bytes / (1024 * 1024)).toFixed(2);
  console.log(
    "──────────────────────────────────────────────────────────────────────",
  );
  console.log(`Total synchronized: ${totalStats.files} files, ${totalMb} MB`);
  console.log("Synchronization complete!\n");
}

if (require.main === module) {
  main();
}

module.exports = { main, copyRecursive };
