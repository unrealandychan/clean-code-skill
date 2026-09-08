#!/usr/bin/env node
"use strict";

/**
 * Entry point for `npx clean-code-skill-kit`.
 *
 * Locates migrate.sh relative to this file (which is at <pkg-root>/bin/),
 * then forwards all CLI arguments to the bash script unchanged.
 *
 * The script's own SCRIPT_DIR / KIT_ROOT detection still works correctly
 * because migrate.sh is executed from its real on-disk location inside
 * the npm package tree.
 */

const { spawnSync } = require("child_process");
const path = require("path");

const args = process.argv.slice(2);
const first = args[0];

let targetScript;
let cmdArgs;
let isNode = false;
let runner;

if (first === "doctor") {
  targetScript = path.join(__dirname, "..", "scripts", "doctor.js");
  cmdArgs = args.slice(1);
  isNode = true;
} else if (first === "sync" || first === "sync:ecc") {
  targetScript = path.join(__dirname, "..", "scripts", "sync-ecc.js");
  cmdArgs = args.slice(1);
  isNode = true;
} else if (first === "catalog") {
  targetScript = path.join(__dirname, "..", "scripts", "catalog.js");
  cmdArgs = args.slice(1);
  isNode = true;
} else if (first === "health" || first === "skills:health") {
  targetScript = path.join(__dirname, "..", "scripts", "skills-health.js");
  cmdArgs = args.slice(1);
  isNode = true;
} else if (first === "adapt" || first === "adapt:agents") {
  targetScript = path.join(__dirname, "..", "scripts", "adapt-agents.js");
  cmdArgs = args.slice(1);
  isNode = true;
} else if (first === "skill-doctor" || first === "audit") {
  targetScript = path.join(
    __dirname,
    "..",
    "skills",
    "skill-doctor",
    "scripts",
    "collect_sessions.py",
  );
  cmdArgs = args.slice(1);
  runner = "python3";
} else if (first === "migrate") {
  targetScript = path.join(__dirname, "..", "scripts", "migrate.sh");
  cmdArgs = args.slice(1);
} else {
  targetScript = path.join(__dirname, "..", "scripts", "migrate.sh");
  cmdArgs = args;
}

if (!runner) {
  runner = isNode ? process.execPath : "bash";
}
const result = spawnSync(runner, [targetScript, ...cmdArgs], {
  stdio: "inherit",
  shell: false,
});

process.exit(result.status ?? 1);
