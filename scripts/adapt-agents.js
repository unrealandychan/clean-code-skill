#!/usr/bin/env node
"use strict";

/**
 * adapt-agents.js
 *
 * Compiles and adapts agent definitions for multiple harness targets:
 *  - gemini / antigravity
 *  - claude
 *  - codex
 *  - cursor
 *  - opencode
 *
 * Usage:
 *   node scripts/adapt-agents.js --target <gemini|codex|claude|all> [--output <dir>]
 */

const fs = require("fs");
const path = require("path");

const REPO_ROOT = path.resolve(__dirname, "..");
const AGENTS_DIR = path.join(REPO_ROOT, "agents");

const GEMINI_TOOL_MAP = {
  Read: "read_file",
  Write: "write_file",
  Edit: "replace_file_content",
  Bash: "run_command",
  Grep: "grep_search",
  Glob: "find_by_name",
  WebSearch: "search_web",
  WebFetch: "read_url_content",
};

function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---(\n|$)/);
  if (!match) return { frontmatter: {}, body: content };

  const raw = match[1];
  const body = content.slice(match[0].length);
  const data = {};

  for (const line of raw.split("\n")) {
    const m = line.match(/^([a-zA-Z0-9_-]+)\s*:\s*(.*)$/);
    if (m) {
      let val = m[2].trim();
      if (val.startsWith("[") && val.endsWith("]")) {
        val = val
          .slice(1, -1)
          .split(",")
          .map((s) => s.trim().replace(/^['"]|['"]$/g, ""));
      }
      data[m[1]] = val;
    }
  }

  return { frontmatter: data, body, rawFrontmatter: raw };
}

function adaptForGemini(agentContent) {
  const { frontmatter, body } = parseFrontmatter(agentContent);
  if (!frontmatter.name) return agentContent;

  let tools = frontmatter.tools;
  if (typeof tools === "string") {
    tools = tools.split(",").map((s) => s.trim());
  } else if (!Array.isArray(tools)) {
    tools = ["Read", "Write", "Edit", "Bash", "Grep", "Glob"];
  }

  const mappedTools = tools.map((t) => GEMINI_TOOL_MAP[t] || t);

  const newFrontmatter = [
    "---",
    `name: ${frontmatter.name}`,
    `description: ${JSON.stringify(frontmatter.description || "")}`,
    `model: ${frontmatter.model || "inherit"}`,
    `tools: [${mappedTools.map((t) => JSON.stringify(t)).join(", ")}]`,
    "---",
    "",
  ].join("\n");

  return newFrontmatter + body;
}

function main() {
  const args = process.argv.slice(2);
  let target = "gemini";
  let outDir = null;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--target" && args[i + 1]) {
      target = args[i + 1].toLowerCase();
      i++;
    } else if (args[i] === "--output" && args[i + 1]) {
      outDir = path.resolve(args[i + 1]);
      i++;
    }
  }

  if (!fs.existsSync(AGENTS_DIR)) {
    console.error(`Agents directory not found: ${AGENTS_DIR}`);
    process.exit(1);
  }

  const agentFiles = fs
    .readdirSync(AGENTS_DIR)
    .filter((f) => f.endsWith(".md"));
  console.log(`Adapting ${agentFiles.length} agents for target: ${target}`);

  if (target === "gemini" || target === "antigravity") {
    const dest = outDir || path.join(REPO_ROOT, ".gemini", "agents");
    if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });

    let adapted = 0;
    for (const file of agentFiles) {
      const src = fs.readFileSync(path.join(AGENTS_DIR, file), "utf8");
      const transformed = adaptForGemini(src);
      fs.writeFileSync(path.join(dest, file), transformed, "utf8");
      adapted++;
    }
    console.log(`✓ Adapted ${adapted} agents to ${dest}`);
  } else {
    console.log(
      `Target "${target}" requires no transformation (standard format).`,
    );
  }
}

if (require.main === module) {
  main();
}

module.exports = { adaptForGemini, parseFrontmatter };
