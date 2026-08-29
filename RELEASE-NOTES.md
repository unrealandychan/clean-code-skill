# Release Notes

All notable changes to the Clean Code + DDD AI Skill Kit are documented here.  
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [1.6.0] — 2026-08-29

### Feature: Uncle Bob's "Extreme Constraints" Vibe Coding & Lean Skill Pruning

Inspired by Robert C. Martin ("Uncle Bob") — author of _Clean Code_:

> _"My current strategy is to not read any of the code written by my agents. That's the only way I can take advantage of their productivity. What I do instead is to surround the agents with extreme constraints. Unit tests, gherkin tests, QA procedures, quality metrics, mutation testing, test coverage, and a plethora of others."_

#### Added

- **Uncle Bob's Extreme Constraints Canonical Rules** (`skills/shared/extreme-constraints-rules.md`):
  - `missing-gherkin-acceptance-spec` — Gherkin Given-When-Then behavioral acceptance specs required before coding.
  - `missing-test-baseline` & `unexercised-branch-coverage` — 100% green test suite baseline and $\ge 90\%$ branch coverage threshold.
  - `mutant-survival-detected` — Mutation testing gauntlet (Stryker, mutmut, Pitest, go-mutesting) with $\ge 85\%$ mutation kill score.
  - `crap-complexity-breach` & `cyclomatic-complexity-breach` — Cyclomatic complexity $M \le 10$ and CRAP score $\le 30$ ($CRAP(m) = comp(m)^2 \cdot (1 - cov(m))^3 + comp(m)$).
  - `leaky-architectural-invariant` — Enforces pure domain boundaries, immutable Value Objects, and Aggregate root isolation.
  - `unsupervised-syntax-trust` & `line-by-line-micromanagement` — Replaces line-by-line micro-reading with automated gauntlets and high-leverage constraint specification.
- **Extreme Constraints Skill & Workflows Module** (`skills/extreme-constraints/SKILL.md` & `WORKFLOWS.md`):
  - `/extreme-constraints` (full 6-pillar constraint assessment)
  - `/gherkin-spec` (Given-When-Then spec generation and validation)
  - `/mutation-audit` (mutation score inspection and test synthesis to kill surviving mutants)
  - `/crap-metric` (Cyclomatic Complexity + CRAP index evaluation)
  - `/vibe-guard` (real-time guardrails for AI coding sessions)
  - `/gauntlet-check` (one-shot automated verification across tests, coverage, mutation, and linters)
- **Migration & Adapter Integration**:
  - Added `--extreme-constraints` / `--constraints` / `--vibe-constraints` options to `scripts/migrate.sh`.
  - Updated all tool adapters (`claude/CLAUDE.md`, `copilot/`, `cursor/`, `opencode/`, `hermes/`, `codex/`, `aider/`, `generic/`).
  - Added `extreme-constraints` commitlint and husky scope.

#### Removed

- **Graph Engineering & LangGraph Module**:
  - Pruned out-of-scope Knowledge Graph & Task Graph files (`skills/graph-engineering/`, `skills/shared/graph-engineering-rules.md`, `skills/harness/graph-engineering.md`) to keep the skill kit lean, focused strictly on Clean Code, DDD, Test Harness, and AI developer velocity.

---

## [1.5.0] — 2026-08-19

### Feature: Matt Pocock Productivity Suite, 5-Axis Code Review, Graph Engineering & Modern Tooling

Inspired by Matt Pocock (`mattpocock/skills`) and Addy Osmani (`addyosmani/agent-skills`).

#### Added

- **Matt Pocock Productivity Rules** — `skills/shared/mattpocock-productivity-rules.md`:
  - `user-invoked-skill-boundary` & `unclear-cross-skill-call` — guards interactive skill execution boundaries and requires explicit `call Skill tool with "<name>"` invocation syntax.
  - `unclear-explanation-no-wait-what` — rapid plain-English clarification protocol using `CONTEXT.md` vocabulary.
  - `uncompacted-agent-handoff` & `lossy-context-transfer` — structured session handoff compaction.
  - `fictitious-time-estimates` — replaces hallucinated time estimates with automated verification commands per milestone.
  - `missing-domain-context-map` — grounds ubiquitous language dictionaries in `CONTEXT-MAP.md` linked to ADRs.
- **Productivity & Engineering Skill Module** — `skills/productivity/SKILL.md` & `WORKFLOWS.md`:
  - `/grill-me` (relentless plan stress-testing)
  - `/wait-what` (plain-English clarification)
  - `/handoff` (session state compaction)
  - `/to-questionnaire` (async decision form)
  - `/domain-modeling` (context map and vocabulary synchronization)
  - `/to-spec` & `/to-tickets` (RFC to formal spec and discrete tickets)
  - `/wayfinder` & `/wizard` (goal-driven exploration and implementation)
- **5-Axis Code Review & Quality Protocol** (`skills/code-review/` & `skills/shared/code-review-quality-rules.md`): Correctness, Readability, Architecture, Security, and Performance.
- **Graph Engineering Skill Module** (`skills/graph-engineering/` & `skills/shared/graph-engineering-rules.md`): Knowledge Graphs (typed ontology, ER, GraphRAG) and Task Graphs (typed state, deterministic routing, HITL safety).
- **Default Package Managers**: `uv` for Python and `pnpm` for JavaScript/TypeScript.
- **Ponytail Anti-Overengineering Philosophy**: 5-step evaluation ladder ("the best code is the code you never wrote").
- **LLM Agent Framework Standard**: Google Cloud ADK (`google-adk`) as default, with interactive query for alternatives.
- **Pre-commit Linter Resilience**: Defensive wrappers (`command -v`) in `package.json` and updated Prettier / markdownlint configurations.

#### Removed

- **Windsurf Adapter & Support**: Removed deprecated `skills/windsurf/.windsurfrules` and references across CLI migration wizard, package metadata, and guides.

---

## [1.2.0] — 2026-05-23

### Feature: Agentic Engineering — Spec Hygiene, Guardrails, AI Output Evaluation & Multi-Agent Coordination

Inspired by Google for Developers — _"Build core skills to thrive as an AI-era developer"_.

#### Added

**Agentic Engineering rules** — new canonical rule set in `skills/shared/agentic-engineering-rules.md`:

- 6 **Intent & Specification** rules — catch missing specs, vague intent, and undocumented decisions before implementation starts
- 5 **Guardrail & Environment** rules — enforce agent persona files, green test baselines, and linter configs
- 5 **AI Output Evaluation** rules — prevent accepting AI code that isn't understood, tested, or validated
- 4 **Multi-Agent Coordination** rules — detect single-agent overload, missing context handoffs, and parallel conflicts
- 3 **Agent Journaling** rules — surface recurring friction and unpatched skill gaps

**Agentic Engineering workflow guide** — `skills/harness/agentic-engineering.md`:

- Spec-driven development template (Goal → Acceptance Criteria → Constraints → Edge Cases)
- Guardrail setup checklist
- Anti-vibe-coding: AI output evaluation techniques (reimplementation, walkthrough, coverage check)
- Multi-agent role split (Planner / Researcher / Implementer / Reviewer / Orchestrator)
- Context handoff contract template
- Agent journaling format and usage guide
- T-Shaped Developer quality gates checklist

#### Updated

- `skills/claude/CLAUDE.md` — added Agentic Engineering Review section with 4 trigger patterns
- `skills/opencode/AGENTS.md` — added Agentic Engineering section with anti-pattern table
- `skills/generic/system-prompt.txt` — added full Agentic Engineering rules in compact format
- `README.md` — added Agentic Engineering to rule categories and file structure

---

## [1.1.0] — 2026-05-02

### Feature: Harness Engineering — Testability, Observability & Progressive Delivery

#### Added

**Harness Engineering rules** — new canonical rule set in `skills/shared/harness-rules.md`:

- **Testability Rules** (8 rules): `missing-dependency-injection`, `no-seam-for-testing`, `clock-dependency`, `random-dependency`, `test-pyramid-violation`, `missing-test-data-builder`, `assertion-roulette`, `test-logic-in-production`
- **Observability Rules** (6 rules): `missing-structured-logging`, `no-correlation-id`, `missing-metrics-instrumentation`, `silent-error-swallowing`, `log-without-context`, `missing-health-endpoint`
- **Progressive Delivery Rules** (5 rules): `feature-flag-missing`, `config-hardcoded`, `missing-graceful-degradation`, `missing-circuit-breaker`, `deploy-coupled-to-release`
- Per-language seam patterns and recommended libraries for each category

**New analyst prompts:**

- `skills/shared/test-review-prompt.md` — 6-step test quality review: classify type (unit/integration/e2e), assess pyramid health, apply testability rules, check test quality patterns (over-mocking, assertion roulette, flaky time dependency, naming), summarise coverage gaps
- `skills/shared/observability-report-prompt.md` — 7-step observability review: logging structure, metrics coverage, correlation ID propagation, error handling, incident readiness score

**Harness Engineering adapter files** (`skills/harness/`):

- `testability.md` — when to activate, DI patterns by language, seam references
- `observability.md` — when to activate, structured logging recommendations per language
- `progressive-delivery.md` — feature flag + circuit breaker library table by language; Harness.io pipeline integration notes

**Harness.io pipeline templates** (`pipelines/`):

- `harness-ci.yaml` — CI pipeline: Install → Lint → Unit Tests → Integration Tests → Build & Push Docker; JUnit report collection; DORA metrics tracking
- `harness-canary.yaml` — Canary deployment: 10% → verify 5m → 50% → verify 5m → 100% promote; auto-rollback on verify failure with `K8sCanaryDelete` + `K8sRollingRollback`
- `harness-feature-flag-gate.yaml` — Dark launch pipeline: deploy (flag OFF) → park up to 7 days → enable flag → verify 10m → promote; auto-disables flag on rollback

#### Changed

- `scripts/migrate.sh` — added `--harness` flag and wizard question 6: copies `harness-rules.md`, `test-review-prompt.md`, `observability-report-prompt.md`, `skills/harness/`, `pipelines/` to target project
- `scripts/migrate.sh` — wizard upgraded from 6 questions to 7; `--help` text updated
- `skills/shared/rules.md` — `copy_shared_skills()` function in migrate.sh now always copies the 3 new shared harness prompts alongside the existing files
- `skills/claude/CLAUDE.md` — added `## Harness Engineering Review` section with testability, observability, and progressive delivery trigger phrases and steps
- `skills/copilot/_rules.instructions.md` — added Harness Engineering rules table (10 rules) inline
- `skills/cursor/.cursor/rules/clean-code-review.mdc` — added `## Harness Engineering` section
- `skills/opencode/AGENTS.md` — added `## Harness Engineering` section
- `skills/windsurf/.windsurfrules` — added `## Harness Engineering` section
- `skills/generic/system-prompt.txt` — added `HARNESS ENGINEERING RULES` block (10 rules in plain text)
- `README.md` — updated title, header badge, What Is This, How Rules Are Organized, Project Structure tree, What the Skills Check (added 3 Harness rule groups), How AI and Linting Work Together (added 3 Harness AI skill rows)

---

## [1.0.0] — 2026-04-17

### Release: first stable release — complete AI-assisted development workflow

#### Added

- **`skills/shared/lint-report-prompt.md`** — canonical lint analyst prompt: role, 7-step analysis process, structured output format (summary table, top issues, code-snippet examples, Clean Code mapping, action plan), lint-code → rule mapping table, and guardrails.
- **`skills/shared/release-notes-prompt.md`** — canonical release notes prompt: commit-type → section mapping, writing rules, exact Keep-a-Changelog output format, and guardrails.
- **`skills/copilot/lint-report.instructions.md`** — Copilot adapter for lint report; trigger phrases, Copilot-specific output notes.
- **`skills/generic/lint-report-system-prompt.txt`** — raw lint report prompt for direct API or non-IDE use.
- **`scripts/lint-and-report.sh`** — runs the correct linter for the detected language, saves `lint-output.txt`, and prints ready-to-paste Claude/Copilot/API commands.
- **`scripts/generate-release-notes.sh`** — calls Claude (`ANTHROPIC_API_KEY`) or GitHub Models GPT-4o (`GITHUB_TOKEN`) with the canonical prompt; guards against duplicate version insertion; inserts the new entry after the first `---` separator in `RELEASE-NOTES.md`; `--dry-run` flag for preview.
- **`.github/workflows/release-notes.yml`** — triggers on `v*` tag push and `workflow_dispatch`; resolves version and LLM automatically (Claude → GitHub Models fallback); opens a PR with generated entry and a review checklist.
- **`COMMIT-GUIDE.md`** — comprehensive commit message reference: types table with examples, scopes table, subject rules, body/footer format, valid vs. invalid quick-reference card, hook flow diagram, `npm run commit` interactive helper docs, setup instructions, and troubleshooting table.
- **`.gitignore`** — covers `node_modules/`, Python caches (`.ruff_cache`, `.mypy_cache`, `__pycache__/`), Go `vendor/`, OS files (`.DS_Store`), editor files (`.idea/`), `*.bak.*` migration backups, and `lint-output.txt`.
- **`npm run commit`** — interactive conventional commit helper via `@commitlint/prompt-cli`.
- **`npm run release:notes`** / **`npm run release:notes:dry`** — wrappers around `generate-release-notes.sh`.
- **`npm run migrate:yes`** — non-interactive migration for CI via `scripts/migrate.sh --yes`.

#### Changed

- **`scripts/migrate.sh`** — fully rewritten as an interactive 6-question wizard (target dir, tool(s), linting, language(s), hooks, dry-run). Defaults to dry-run first. `--yes` flag skips all prompts for CI. Post-dry-run prints the exact apply command.
- **`.husky/pre-commit`** — adds a spinner-style header; captures exit code; prints fix hint and `COMMIT-GUIDE.md` path on failure.
- **`.husky/commit-msg`** — captures exit code; prints guide path and `npm run commit` hint on rejection.
- **`package.json`** — version `1.0.0`; added `commit`, `release:notes`, `release:notes:dry`, `migrate:yes` scripts; fixed `*.{cs}` glob to `*.cs`; added `"*.sh": ["shfmt -w"]` to lint-staged.
- **`skills/claude/CLAUDE.md`** — extended with lint-report and release-notes sections (imports `@skills/shared/lint-report-prompt.md` and `@skills/shared/release-notes-prompt.md`).
- **`skills/cursor/.cursor/rules/clean-code-review.mdc`** — extended with lint-report section and `COMMIT-GUIDE.md` reference.
- **`skills/windsurf/.windsurfrules`** — extended with lint-report section and `COMMIT-GUIDE.md` reference.
- **`skills/opencode/AGENTS.md`** — extended with lint-report section.
- **`skills/shared/husky-rules.md`** — updated lint-staged table to include `*.sh` → `shfmt -w`; added `COMMIT-GUIDE.md` reference.

#### Removed

- Stale `skills/shared/rules.md.bak.*` backup file left by an earlier migration run.

---

## [0.4.0] — 2026-04-10

### Added: Conventional Commit enforcement and Husky enforcement skill

#### Added

- `commitlint.config.cjs` — validates every commit message against Conventional Commits; custom `type-enum` (10 types), `scope-enum` (20 project scopes, severity=warning), `subject-max-length: 72`, `subject-min-length: 10`, `subject-case: lower-case`, full `prompt.questions` for interactive use.
- `package.json` — Node manifest wiring husky v9, lint-staged v15, markdownlint-cli2, prettier; `"prepare": "husky"` script installs hooks automatically on `npm install`.
- `.husky/commit-msg` — git hook that runs `npx commitlint --edit "$1"` on every commit; file is executable.
- `.husky/pre-commit` — git hook that runs `npx lint-staged` on staged files before every commit; file is executable.
- `skills/shared/husky-rules.md` — canonical husky enforcement rules: setup checks table, commit message type/scope/subject rules with valid/invalid examples, lint-staged per-file-type mapping, bypass policy, guardrails.
- `skills/copilot/husky-enforcement.instructions.md` — thin Copilot adapter (applies to `package.json`, `commitlint.config.cjs`, `.husky/**`, `linting/shared/.pre-commit-config.yaml`).
- Husky enforcement injected into all remaining tool adapters: `skills/claude/CLAUDE.md`, `skills/cursor/.cursor/rules/clean-code-review.mdc`, `skills/opencode/AGENTS.md`, `skills/windsurf/.windsurfrules`, `skills/generic/system-prompt.txt`.

#### Policy

- `--no-verify` is banned in all skill adapters — fix the root cause instead.
- Adding a new file type to the project requires a corresponding lint-staged entry in `package.json`.

---

## [0.3.0] — 2026-04-10

### Refactor: Shared rule definitions and thin tool adapters

**Breaking change for contributors:** rules no longer live inside each tool adapter file. Edit `skills/shared/rules.md` first, then propagate to adapters.

#### Added

- `skills/shared/rules.md` — single canonical source of truth for all 8 Clean Code rules and 8 DDD rules with severity, trigger conditions, output format, and guardrails. All tool adapters reference this file.
- `skills/copilot/_rules.instructions.md` — shared rule table in Copilot `.instructions.md` format; VS Code merges it with the persona adapter automatically.

#### Changed

- `skills/copilot/clean-code-review.instructions.md` — reduced to a persona adapter (~15 lines). Full rules moved to `_rules.instructions.md`.
- `skills/claude/CLAUDE.md` — reduced to a thin adapter with `@skills/shared/rules.md` import. Removed ~80 lines of duplicated rule prose.
- `skills/cursor/.cursor/rules/clean-code-review.mdc` — rewritten as compact self-contained adapter (~55 lines, down from ~110).
- `skills/opencode/AGENTS.md` — rewritten as compact self-contained adapter. Removed YAML rule-reference block and repeated prose. Added "Trigger" section for when to invoke the agent.
- `skills/windsurf/.windsurfrules` — rewritten as compact self-contained adapter (~55 lines, down from ~110).
- `skills/generic/system-prompt.txt` — rewritten in plain-text rule table format with no markdown headings. Reduced from 56 to 37 lines.
- `README.md` — updated project structure diagram, Quick Start commands (Claude now includes `cp -r skills/shared .`), "What the Skills Check" section replaced with a pointer to `shared/rules.md` plus inline rule-ID lists. Customisation table updated to direct rule edits at `shared/rules.md`.

#### Why

Every tool adapter previously repeated the same ~100 lines with minor wording variations. A one-rule change required editing 6 files with no guarantee of consistency. The shared source + thin adapter pattern reduces total skill content by ~50%, makes rule propagation explicit, and gives a single place to audit or tighten rules over time.

---

## [0.2.0] — 2026-04-10

### Feature: DDD checks, linting configurations, and pre-commit hooks

#### Added

**DDD principles** — injected into all 5 tool skill files and the generic system prompt:

- `ubiquitous-language` — flag generic names where a domain term exists (medium)
- `bounded-context-violation` — flag cross-context imports without ACL (high)
- `aggregate-integrity-bypass` — flag external mutation bypassing aggregate root (high)
- `value-object-mutability` — flag mutable or identity-compared value-semantics objects (medium)
- `domain-logic-in-adapters` — flag business rules in controllers, handlers, or DB adapters (high)
- `missing-acl` — flag external model types referenced directly in domain code (medium)
- `missing-repository-abstraction` — flag ORM/SQL/HTTP calls inside domain logic (medium)
- `missing-domain-event` — flag direct imperative side-effects where a domain event would be clearer (low)

**Python** — `linting/python/pyproject.toml`

- Ruff: lint + format, McCabe complexity max 10, pep8-naming, pyflakes, bugbear, simplify, pyupgrade
- Mypy: strict mode, `disallow_untyped_defs`, `warn_return_any`, `no_implicit_optional`
- Bandit: security scanning

**TypeScript / JavaScript** — `linting/typescript/.eslintrc.json` + `.prettierrc.json`

- ESLint with `@typescript-eslint/recommended-type-checked`
- `import/no-restricted-paths` — DDD layer boundary rules (domain must not import infrastructure or application)
- `import/no-cycle` — circular dependency detection
- SonarJS cognitive complexity max 12, duplicate string detection
- Unicorn: abbreviation prevention, nested ternary, array forEach
- `@typescript-eslint/no-explicit-any` as error
- `eslint-plugin-sonarjs`, `eslint-plugin-unicorn`, `eslint-plugin-import`

**Go** — `linting/go/.golangci.yml`

- golangci-lint: `errcheck`, `staticcheck`, `gocognit` (max 10), `cyclop` (max 10), `funlen` (60 lines / 40 statements), `gomnd`, `revive`, `dupl`, `gosec`, `bodyclose`, `noctx`
- `depguard` — DDD layer rules: domain packages may not import infrastructure or adapter packages

**Java** — `linting/java/checkstyle.xml` + `pmd-ruleset.xml`

- Checkstyle: `MethodLength` (max 40), `CyclomaticComplexity` (max 10), `NestedIfDepth` (max 3), `ParameterNumber` (max 5), `MagicNumber`, `AbbreviationAsWordInName`, `IllegalCatch`, `EmptyCatchBlock`, `ClassFanOutComplexity` (max 20)
- PMD: `GodClass`, `TooManyMethods` (max 15), `TooManyFields` (max 10), `CouplingBetweenObjects` (max 15), `AvoidCatchingGenericException`, `AvoidDuplicateLiterals`, `UnusedLocalVariable`, `CollapsibleIfStatements`, `SimplifyBooleanReturns`

**C#** — `linting/csharp/.editorconfig`

- Roslyn: `CA1822`, `CA1062`, `CA2000`, `MA0051` (method too long), `MA0016`, `S1135`
- EditorConfig naming rules: interfaces `I`-prefix, types PascalCase, private fields `_camelCase`
- Pattern matching, throw expressions, null checks, primary constructors enabled as suggestions

**Shared tooling:**

- `linting/shared/.editorconfig` — universal per-language EditorConfig for all editors
- `linting/shared/.pre-commit-config.yaml` — multi-language pre-commit config covering Ruff, Mypy, Bandit, ESLint, Prettier, golangci-lint, Go vet, Checkstyle (Maven), dotnet format, detect-secrets

**Project structure:**

- `LICENSE` — MIT
- `README.md` — full plug-and-play guide with per-tool install commands, per-language linting quick-starts, rules reference tables, how AI and linting complement each other, customisation guide, contributing guide, and MIT license block

---

## [0.1.0] — 2026-04-10

### Initial release: AI skill adapters for 5 tools

#### Added

**AI skill files** — derived from `ai-clean-code-skill-guide.md`:

- `skills/copilot/clean-code-review.instructions.md` — GitHub Copilot (VS Code). Uses `applyTo` frontmatter glob. Covers 8 Clean Code review rules, severity rubric, structured output format, and guardrails.
- `skills/claude/CLAUDE.md` — Claude Code. Auto-loaded from project root on startup. Full inline rule set with rule YAML reference block.
- `skills/cursor/.cursor/rules/clean-code-review.mdc` — Cursor. Uses `description` and `globs` frontmatter for automatic activation on code files.
- `skills/opencode/AGENTS.md` — OpenCode and any AGENTS.md-compatible runner. Includes "When to Invoke" section and AI vs. static analysis split table.
- `skills/windsurf/.windsurfrules` — Windsurf (Cascade). Auto-loaded as workspace-level rules.
- `skills/generic/system-prompt.txt` — plain-text system prompt for any AI tool, API, or custom agent.

**Clean Code rules covered in all adapters:**

- `meaningful-names` (medium)
- `single-responsibility` (high)
- `minimize-duplication` (high)
- `avoid-deep-nesting` (medium)
- `small-interfaces` (medium)
- `named-constants` (low)
- `comment-why-not-what` (low)
- `clear-error-handling` (medium)

**Consistent output format** across all tools:

- Summary header (files reviewed, finding counts by severity)
- Per-finding: severity, rule ID, location, problem, why it matters, suggested fix, optional refactor example
- Max 3 findings per file ordered by impact

**Guardrails** applied in all adapters:

- Skip findings when formatting is linter-enforced
- Every finding must cite a specific file and line
- No speculative or low-confidence findings
- Mandatory (high/medium) vs. suggestion (low) clearly separated
