# Release Notes

All notable changes to the Clean Code + DDD AI Skill Kit are documented here.  
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
