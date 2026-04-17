# Clean Code + DDD AI Skill Kit

> Plug-and-play AI review skills, linting configs, and pre-commit hooks for Clean Code and Domain-Driven Design (DDD).  
> Works with GitHub Copilot, Claude Code, Cursor, OpenCode, Windsurf, and any other AI assistant or API.

---

## What Is This?

A single set of Clean Code + DDD rules, expressed in every format your AI tools and linters can consume:

- **AI skill adapters** — one file per tool, drop into your project and start reviewing immediately
- **Shared rule definitions** — one canonical source of truth; all adapters reference the same rules
- **Linter configurations** — per-language static analysis aligned to the same rule IDs
- **Pre-commit hooks** — enforce rules before code reaches a pull request
- **Shared EditorConfig** — universal formatting baseline for all editors

**One rule set. Every tool. Every language.**

---

## How the Rules Are Organized

```
skills/
  shared/
    rules.md                          ← canonical rules (edit here first)
    lint-report-prompt.md             ← canonical lint-report prompt (edit here first)
    release-notes-prompt.md           ← canonical release notes prompt (edit here first)
    task-summary-prompt.md            ← canonical task-summary & skill-extraction prompt (edit here first)
    husky-rules.md                    ← canonical commit hygiene rules
  copilot/
    _rules.instructions.md            ← shared rules in Copilot format
    clean-code-review.instructions.md ← Copilot code review adapter
    lint-report.instructions.md       ← Copilot lint report adapter
    task-summary.instructions.md      ← Copilot task-summary adapter
    husky-enforcement.instructions.md ← Copilot commit hygiene adapter
  claude/
    CLAUDE.md                         ← thin adapter; imports @skills/shared/*.md
  cursor/
    .cursor/rules/
      clean-code-review.mdc           ← self-contained adapter with frontmatter globs
      task-summary.mdc                ← task-summary adapter with frontmatter globs
  opencode/
    AGENTS.md                         ← self-contained adapter
  windsurf/
    .windsurfrules                    ← self-contained adapter
  generic/
    system-prompt.txt                 ← raw code review prompt for any AI tool or API
    lint-report-system-prompt.txt     ← raw lint report prompt for any AI tool or API
    task-summary-system-prompt.txt    ← raw task-summary prompt for any AI tool or API
```

Each tool adapter is a **thin wrapper**: persona declaration + compact rule table + output format.  
The full annotated rules live in `skills/shared/rules.md`.  
The lint report prompt lives in `skills/shared/lint-report-prompt.md`.  
The task summary prompt lives in `skills/shared/task-summary-prompt.md`.  
To change a rule, update `shared/rules.md` and propagate to the adapters.

---

## Project Structure

```
.
├── skills/
│   ├── shared/
│   │   ├── rules.md                            ← single source of truth for all rules
│   │   ├── lint-report-prompt.md               ← canonical prompt: lint output → AI report
│   │   ├── release-notes-prompt.md             ← canonical prompt: commits → release notes entry
│   │   ├── task-summary-prompt.md              ← canonical prompt: session → task summary + skill recipe
│   │   └── husky-rules.md                      ← canonical commit hygiene rules
│   ├── copilot/
│   │   ├── _rules.instructions.md              ← shared rules (Copilot picks up both files)
│   │   ├── clean-code-review.instructions.md   ← persona adapter
│   │   ├── lint-report.instructions.md         ← lint report adapter
│   │   ├── task-summary.instructions.md        ← task-summary & skill-extraction adapter
│   │   └── husky-enforcement.instructions.md   ← commit hygiene adapter
│   ├── claude/
│   │   └── CLAUDE.md                           ← thin adapter (@file imports)
│   ├── cursor/
│   │   └── .cursor/rules/
│   │       ├── clean-code-review.mdc           ← self-contained adapter
│   │       └── task-summary.mdc                ← task-summary & skill-extraction adapter
│   ├── opencode/
│   │   └── AGENTS.md                           ← self-contained adapter
│   ├── windsurf/
│   │   └── .windsurfrules                      ← self-contained adapter
│   └── generic/
│       ├── system-prompt.txt                   ← raw code review prompt for any tool or API
│       ├── lint-report-system-prompt.txt       ← raw lint report prompt for any tool or API
│       └── task-summary-system-prompt.txt      ← raw task-summary prompt for any tool or API
│
├── scripts/
│   ├── lint-and-report.sh                      ← run linting + print LLM feed instructions
│   ├── generate-release-notes.sh               ← call LLM to generate a RELEASE-NOTES entry
│   └── migrate.sh                              ← interactive wizard to copy kit files into a project
│
├── bin/
│   └── clean-code-skill.js                     ← npx entry point (calls migrate.sh)
│
├── src/
│   └── clean_code_skill_kit/                   ← uvx / pip Python package
│       ├── __init__.py
│       └── cli.py                              ← Python entry point (calls migrate.sh)
│
├── pyproject.toml                              ← Python package metadata (for uvx / pip publish)
│
├── .github/
│   └── workflows/
│       ├── release-notes.yml                   ← auto-generate release notes on tag push
│       ├── publish-npm.yml                     ← publish to npm on tag push
│       └── publish-pypi.yml                    ← publish to PyPI on tag push
│
├── linting/
│   ├── python/
│   │   └── pyproject.toml                      ← Ruff + Mypy + Bandit
│   ├── typescript/
│   │   ├── .eslintrc.json                      ← ESLint + TypeScript + SonarJS + DDD layer rules
│   │   └── .prettierrc.json                    ← Prettier
│   ├── go/
│   │   └── .golangci.yml                       ← golangci-lint with DDD depguard rules
│   ├── java/
│   │   ├── checkstyle.xml                      ← Checkstyle
│   │   └── pmd-ruleset.xml                     ← PMD
│   ├── csharp/
│   │   └── .editorconfig                       ← EditorConfig + Roslyn analyser overrides
│   └── shared/
│       ├── .editorconfig                       ← Universal EditorConfig for all languages
│       └── .pre-commit-config.yaml             ← pre-commit hooks for all languages
│
├── ai-clean-code-skill-guide.md                ← background reading and design rationale
├── COMMIT-GUIDE.md                             ← commit message format, hooks, troubleshooting
├── LICENSE
└── README.md
```

---

## Install (one-liner, no clone needed)

If you don't want to clone the repo, run the migration wizard directly via npm or uv:

```bash
# via npm / npx  (requires Node ≥ 20)
npx clean-code-skill-kit

# via uv / uvx  (requires Python ≥ 3.9 and uv installed)
uvx clean-code-skill-kit
```

Both commands download the kit, launch the interactive wizard, copy the files you choose into your project, and then exit — nothing is permanently installed in your global environment.

Pass any flag the wizard accepts:

```bash
npx clean-code-skill-kit --tool copilot --lang typescript ../my-project --yes
uvx clean-code-skill-kit --tool claude --lang python --dry-run .
```

> **Publishing the package yourself?**  
> See `.github/workflows/publish-npm.yml` and `.github/workflows/publish-pypi.yml` for the automated release workflows and the one-time setup steps documented inside each file.

---

## Quick Start — Migration Wizard

The fastest way to adopt the kit in a new project is the interactive migration wizard.  
It asks which AI tool(s), language(s), and optional extras you want — then shows a dry-run preview before writing anything.

```bash
# Run the wizard (interactive — asks questions, previews changes, confirms before writing)
./scripts/migrate.sh

# Or via npm
npm run migrate
```

**What the wizard asks**

| Step | Question | Default |
|---|---|---|
| 1 | Target project directory | `.` (current directory) |
| 2 | Which AI tool(s)? copilot / claude / cursor / opencode / windsurf / generic / all | all |
| 3 | Copy linting configs? | yes |
| 4 | Which language(s)? python / typescript / go / java / csharp / all | all |
| 5 | Copy pre-commit hook config? | yes |
| 6 | Do a dry run first? | yes |

After the dry run it prints the exact command to re-run with `--yes` to apply the changes.

```
# Non-interactive (CI / scripting) — skip all questions
./scripts/migrate.sh --tool copilot --lang typescript ../my-project --yes

# Dry run only (no writes)
./scripts/migrate.sh --dry-run
npm run migrate:dry
```

---

## Quick Start — AI Skills (manual copy)

If you prefer copying files directly without the wizard:

### GitHub Copilot (VS Code)

```bash
cp skills/copilot/_rules.instructions.md skills/copilot/clean-code-review.instructions.md \
   skills/copilot/lint-report.instructions.md .github/
cp -r skills/shared .
```

VS Code automatically merges all `.instructions.md` files in `.github/` matching the `applyTo` glob.  
Ask Copilot: *"Review this file for Clean Code and DDD issues."*

### Claude Code

```bash
cp skills/claude/CLAUDE.md .
cp -r skills/shared .          # so the @file references resolve
```

Claude Code reads `CLAUDE.md` on startup and follows the `@skills/shared/rules.md` and `@skills/shared/lint-report-prompt.md` imports automatically.

### Cursor

```bash
cp -r skills/cursor/.cursor .
```

The `.mdc` rule activates automatically for code files matching the declared globs.

### OpenCode

```bash
cp skills/opencode/AGENTS.md .
```

OpenCode reads `AGENTS.md` from the project root as agent context.

### Windsurf (Cascade)

```bash
cp skills/windsurf/.windsurfrules .
```

Cascade reads `.windsurfrules` as persistent workspace-level rules.

### Any other tool (ChatGPT, API, custom agent)

Copy the content of `skills/generic/system-prompt.txt` into the **system prompt** field of your AI tool, API call, or agent definition.

---

## Quick Start — Linting

```bash
cp linting/python/pyproject.toml .
pip install ruff mypy bandit
ruff check . && ruff format . && mypy src/ && bandit -r src/
```

### TypeScript / JavaScript

```bash
cp linting/typescript/.eslintrc.json linting/typescript/.prettierrc.json .
npm install -D eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin \
  eslint-plugin-import eslint-plugin-unicorn eslint-plugin-sonarjs
npx eslint . --fix && npx prettier --write .
```

### Go

```bash
cp linting/go/.golangci.yml .
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
golangci-lint run ./...
```

### Java

**Maven** — add to `pom.xml`:

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-checkstyle-plugin</artifactId>
  <version>3.3.1</version>
  <configuration>
    <configLocation>checkstyle.xml</configLocation>
    <failsOnError>true</failsOnError>
  </configuration>
</plugin>
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-pmd-plugin</artifactId>
  <version>3.22.0</version>
  <configuration>
    <rulesets><ruleset>pmd-ruleset.xml</ruleset></rulesets>
    <failOnViolation>true</failOnViolation>
  </configuration>
</plugin>
```

```bash
cp linting/java/checkstyle.xml linting/java/pmd-ruleset.xml .
mvn checkstyle:check pmd:check
```

### C# / .NET

```bash
cp linting/csharp/.editorconfig .
dotnet format --verify-no-changes
```

### Shared EditorConfig

```bash
cp linting/shared/.editorconfig .
```

Every modern editor (VS Code, JetBrains, Vim, Emacs) picks this up automatically.

### Pre-commit hooks (all languages)

```bash
cp linting/shared/.pre-commit-config.yaml .
pip install pre-commit
pre-commit install
pre-commit run --all-files   # first-time check
```

Hooks run automatically on every `git commit` after installation.

---

## Lint → AI Report

After running a linter you can pipe its raw output to any LLM and receive a prioritised, human-readable improvement report — no linter-code jargon, plain English explanations, and a numbered action plan.

### One-step script (auto-detects language)

```bash
# make executable once
chmod +x scripts/lint-and-report.sh

# run — detects python/typescript/go/java/csharp automatically
./scripts/lint-and-report.sh

# or pass language and path explicitly
./scripts/lint-and-report.sh python src/
./scripts/lint-and-report.sh typescript packages/api
./scripts/lint-and-report.sh go ./...
```

The script runs the linter, saves raw output to `lint-output.txt`, then prints copy-paste commands for feeding it to each LLM.

### Claude Code

```bash
# copy the CLAUDE.md adapter so Claude knows about the lint report skill
cp skills/claude/CLAUDE.md .
cp -r skills/shared .

# run linting, then ask Claude to analyse the output
./scripts/lint-and-report.sh
claude "Analyze the linting output in lint-output.txt and generate a human-readable report"
```

### GitHub Copilot (VS Code)

```bash
# copy lint-report instructions so Copilot picks them up automatically
cp skills/copilot/lint-report.instructions.md .github/

# run linting
./scripts/lint-and-report.sh

# open lint-output.txt in the editor, then in Copilot Chat:
# "Analyze this lint output and generate a human-readable improvement report"
```

### OpenAI Codex or any LLM API

```bash
# option A — CLI pipe (replace `your-llm-cli` with your tool)
cat skills/generic/lint-report-system-prompt.txt lint-output.txt | your-llm-cli

# option B — API call
# system prompt : contents of skills/generic/lint-report-system-prompt.txt
# user message  : contents of lint-output.txt
```

### Report format

Every LLM returns a structured Markdown document:

```
## Lint Analysis Report
Language: Python | Tool: Ruff | Files scanned: 8 | Total issues: 14 (Errors: 2, Warnings: 9, Style: 3)

### Executive Summary
Two import-order errors will break CI. Nine functions have complexity scores above
the configured threshold, making them hard to test and reason about in isolation.

### Findings by Priority
#### Must Fix — Errors (2)       ← translated to plain English, mapped to Clean Code rules
#### Should Address — Warnings (9)
#### Consider — Style / Info (3)

### Top Recurring Violations     ← deduplicated, counted
### Prioritised Action Plan      ← numbered, ordered by impact
### Clean Code Rule Mapping      ← links lint codes to project rule IDs
```

See [skills/shared/lint-report-prompt.md](skills/shared/lint-report-prompt.md) for the full prompt specification.

---

## What the Skills Check

See [skills/shared/rules.md](skills/shared/rules.md) for the full annotated rule set.

**Clean Code rules** — `meaningful-names`, `single-responsibility`, `minimize-duplication`, `avoid-deep-nesting`, `small-interfaces`, `named-constants`, `comment-why-not-what`, `clear-error-handling`

**DDD rules** — `ubiquitous-language`, `bounded-context-violation`, `aggregate-integrity-bypass`, `value-object-mutability`, `domain-logic-in-adapters`, `missing-acl`, `missing-repository-abstraction`, `missing-domain-event`

Severity: **high** = fix before merge · **medium** = fix this sprint · **low** = suggestion

---

## How AI and Linting Work Together

| Tool | Handles |
|---|---|
| **EditorConfig** | Indentation, line endings, encoding |
| **Prettier / gofmt / dotnet format** | Code formatting |
| **Ruff / ESLint / golangci-lint / Checkstyle + PMD** | Style, naming, complexity, magic numbers, unused code, security |
| **pre-commit** | Runs all of the above before every commit |
| **AI skill (code review)** | Readability, naming clarity, responsibility boundaries, DDD alignment, refactor suggestions |
| **AI skill (lint report)** | Translates raw linter output into plain English, groups by severity, maps to Clean Code rules, produces a prioritised action plan |
| **AI skill (release notes)** | Reads conventional commits since last tag, generates a Keep a Changelog entry, opens a PR for human review |
| **AI skill (task summary)** | After any AI session, produces a plain-English recap and a reusable fill-in-the-blanks prompt recipe |

---

## Task → Skill Summarizer

After an AI coding session finishes a task, trigger this skill to capture **what was done** and produce a **reusable prompt recipe** your team can use to repeat the same type of work on any project — without rediscovering the process.

### Trigger phrases

Say any of the following to your AI tool after completing a task:

- `"summarize this session as a skill"`
- `"capture this task as a recipe"`
- `"make this reusable"`
- `"extract a skill from this session"`
- `"document what we just did"`
- `"turn this into a prompt"`

### What you get

The skill always produces **two sections** in a single Markdown document:

**1 — Task Summary** (≤ 1 page)

| Field | Content |
|---|---|
| **Problem** | One sentence: what was broken, missing, or needed |
| **Approach** | 3–5 bullets — key decisions and the reasoning behind them |
| **Outcome** | What was delivered, specific and measurable |
| **Gotchas / Lessons** | Edge cases hit or surprises worth noting (omitted if none) |

**2 — Reusable Skill Recipe**

A self-contained, fill-in-the-blanks prompt template. Every project-specific name is replaced with a `<PLACEHOLDER>` variable so anyone on any project can use it immediately.

```
## Reusable Skill Recipe: <TITLE>

> Copy this prompt into your AI tool to repeat this process on any similar project.

### Context
You are working on a project where: <DESCRIBE_PROJECT>

### Task
<DESCRIBE_TASK>

### Steps
1. …

### Output
<What the AI should produce>

### Guardrails
- …
```

### Setup

**Claude Code**

```bash
cp skills/claude/CLAUDE.md .
cp -r skills/shared .
```

**GitHub Copilot**

```bash
cp skills/copilot/task-summary.instructions.md .github/
```

**Any other tool (ChatGPT, API, custom agent)**

Copy the content of `skills/generic/task-summary-system-prompt.txt` into the **system prompt** field of your AI tool.

### Output location

Saved to `skills/extracted/<YYYY-MM-DD>-<kebab-title>.md` by default.  
Pass a custom path in your trigger message to override, e.g. `"summarize this session as a skill and save to docs/recipes/add-adapter.md"`.

### Customising the prompt

The prompt that defines the output format and guardrails lives in [skills/shared/task-summary-prompt.md](skills/shared/task-summary-prompt.md).  
Edit it to change the recipe structure, writing style, or placeholder naming convention.  
All tool adapters reference this file — no other files need updating.

---

## Automated Release Notes

After pushing a version tag, the `Generate Release Notes` GitHub Actions workflow collects all conventional commits since the previous tag, sends them to an LLM, and opens a **PR** with the generated RELEASE-NOTES.md entry — ready for human review before merging.

### How it works

```
git tag v0.5.0 && git push origin v0.5.0
        ↓
GitHub Actions: collect commits since v0.4.0
        ↓
LLM (Claude or GitHub Models): group by type, write human-readable bullets
        ↓
Insert entry into RELEASE-NOTES.md after the header
        ↓
Open PR: "docs(release): release notes for v0.5.0"
        ↓
Human reviews → merge
```

### Setup

**Option A — Claude (recommended, higher quality)**

1. Add `ANTHROPIC_API_KEY` as a repository secret:  
   Settings → Secrets and variables → Actions → New repository secret
2. Push a tag — the workflow fires automatically.

**Option B — GitHub Models (zero extra secrets)**

The workflow auto-falls back to `gpt-4o` via GitHub Models when `ANTHROPIC_API_KEY` is not set.  
No extra configuration needed — GitHub Actions has `GITHUB_TOKEN` built in.

### Trigger manually

Useful for testing or regenerating notes for a past tag:

```
GitHub UI → Actions → "Generate Release Notes" → Run workflow
  version: 0.5.0     (optional — defaults to latest tag)
  llm: claude         (or github-models)
  dry run: true       (prints entry without opening a PR)
```

### Run locally

```bash
# Dry run — preview without modifying RELEASE-NOTES.md
ANTHROPIC_API_KEY=sk-ant-... ./scripts/generate-release-notes.sh --dry-run

# Write the entry for the latest tag
ANTHROPIC_API_KEY=sk-ant-... ./scripts/generate-release-notes.sh

# Specific version, GitHub Models backend (uses GITHUB_TOKEN)
GITHUB_TOKEN=ghp_... ./scripts/generate-release-notes.sh \
  --version 0.5.0 --llm github-models
```

### Customising the LLM prompt

The prompt that instructs the LLM lives in [skills/shared/release-notes-prompt.md](skills/shared/release-notes-prompt.md).  
Edit it to change section headings, writing style, bullet length, or the commit-type → section mapping.  
The workflow and the local script both read this file at runtime — no other files need updating.

---

## Customising the Rules

| What to change | Where |
|---|---|
| Rules content or DDD checks | `skills/shared/rules.md` → propagate to tool adapters |
| AI output format or persona | Tool adapter in `skills/<tool>/` |
| Lint report format or severity mapping | `skills/shared/lint-report-prompt.md` → propagate to tool adapters |
| Release notes writing style or sections | `skills/shared/release-notes-prompt.md` |
| Task summary structure or recipe format | `skills/shared/task-summary-prompt.md` → propagate to tool adapters |
| Python linting | `linting/python/pyproject.toml` |
| TypeScript rules or DDD import boundaries | `linting/typescript/.eslintrc.json` |
| Go lint rules | `linting/go/.golangci.yml` |
| Java complexity thresholds | `linting/java/checkstyle.xml` and `pmd-ruleset.xml` |
| C# naming and Roslyn severities | `linting/csharp/.editorconfig` |
| Pre-commit hook versions | `linting/shared/.pre-commit-config.yaml` → run `pre-commit autoupdate` |

---

## Contributing

1. Fork the repository.
2. Create a branch: `git checkout -b feature/your-change`
3. Edit `skills/shared/rules.md` first, then update the affected tool adapters.
4. Open a pull request with a clear description of what changed and why.

Contributions welcome — new language linting configs, additional DDD checks, new AI tool adapters, or rule refinements.

---

## License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
