# Commit Message Guide

Every commit in this repository must follow [Conventional Commits](https://www.conventionalcommits.org).  
The `commit-msg` hook validates this automatically. The `pre-commit` hook lints and formats staged files first.

---

## Format

```
<type>(<scope>): <subject>

[body — optional, blank line above required]

[footer — optional, blank line above required]
```

**Good commit message, annotated:**

```
feat(shared): add value-object-mutability rule to ddd checks
  ↑     ↑       ↑
  │     │       └─ subject: lowercase, ≤72 chars, no trailing period, imperative mood
  │     └───────── scope: optional, which part of the project
  └─────────────── type: what kind of change
```

---

## Types

| Type | Use when | Example |
|---|---|---|
| `feat` | Adding a new skill, rule, linting config, or tool adapter | `feat(copilot): add lint-report instructions adapter` |
| `fix` | Correcting a wrong rule, broken config, or bad prompt | `fix(python): lower ruff complexity threshold from 15 to 10` |
| `docs` | Updating README, RELEASE-NOTES, or guides | `docs(release): add v0.5.0 release notes` |
| `style` | Whitespace or formatting inside config files — no logic change | `style(shared): align rule table columns` |
| `refactor` | Restructuring without behaviour change | `refactor(shared): extract lint-report-prompt from generic adapter` |
| `perf` | Making a hook or lint step faster | `perf(hooks): skip gofmt when no .go files are staged` |
| `test` | Adding or fixing config validation tests | `test(typescript): add eslint rule for bounded-context boundary` |
| `chore` | Dependency bumps, CI, tooling | `chore(deps): bump husky from 9.1.4 to 9.1.5` |
| `revert` | Reverting a previous commit | `revert: revert "feat(shared): add new ddd rule"` |
| `release` | Version bump commit | `release: bump version to 0.5.0` |

---

## Scopes

Scopes are optional but strongly encouraged — they make the git log scannable and drive the release notes grouping.

| Scope | Covers |
|---|---|
| `shared` | `skills/shared/` — rules.md, lint-report-prompt.md, release-notes-prompt.md |
| `copilot` | `skills/copilot/` |
| `claude` | `skills/claude/` |
| `cursor` | `skills/cursor/` |
| `opencode` | `skills/opencode/` |
| `windsurf` | `skills/windsurf/` |
| `generic` | `skills/generic/` |
| `skills` | Change affects multiple adapters at once |
| `python` | `linting/python/` |
| `typescript` | `linting/typescript/` |
| `go` | `linting/go/` |
| `java` | `linting/java/` |
| `csharp` | `linting/csharp/` |
| `linting` | Change affects multiple linting configs |
| `editorconfig` | `linting/shared/.editorconfig` |
| `pre-commit` | `linting/shared/.pre-commit-config.yaml` |
| `hooks` | `.husky/` or `commitlint.config.cjs` |
| `deps` | `package.json` dependency updates |
| `release` | `RELEASE-NOTES.md`, version tags |
| `ci` | `.github/workflows/` |

---

## Subject rules

- **Lowercase** — `add rule` not `Add rule`
- **No trailing period** — `add rule` not `add rule.`
- **10–72 characters** — specific enough to be useful, short enough to scan
- **Imperative mood** — `add rule`, `fix glob`, `update readme` — not `added`, `fixes`, `updating`
- **Explains what, not how** — the body is for details

---

## Body (optional)

Add a body when the subject alone doesn't explain the *why* or *trade-offs*.  
Separate from the subject with a blank line. Wrap at 100 characters.

```
refactor(shared): extract lint-report-prompt.md from generic adapter

The generic system-prompt was growing into two distinct concerns:
code review and lint translation. Splitting them lets each prompt
evolve independently and makes the Copilot adapter thin.
```

---

## Footer (optional)

### Breaking changes

If this commit changes behaviour in a way that requires consumers to update their setup, add a `BREAKING CHANGE` footer. The release notes generator uses this to create a `#### Breaking Changes` section.

```
feat(shared): rename rule id minimize-duplication to no-duplication

BREAKING CHANGE: rule ID changed from `minimize-duplication` to
`no-duplication`. Update any custom linter configs that reference it.
```

### Closes issues

```
fix(copilot): correct applyTo glob for swift files

Closes #42
```

---

## Valid vs invalid — quick reference

| Commit message | Problem | Correct version |
|---|---|---|
| `updated readme` | No type, past tense | `docs: update readme with install steps` |
| `Fix: wrong rule` | Type not lowercase | `fix: correct wrong rule in shared/rules.md` |
| `feat(SHARED): add rule` | Scope not lowercase | `feat(shared): add rule for domain event naming` |
| `added new linting.` | No type, past tense, trailing period | `feat(linting): add golangci-lint configuration` |
| `wip` | Too short, no type | `chore: work in progress — partial typescript rule` |
| `feat: x` | Subject too short (< 10 chars) | `feat: add ruff complexity rule for python` |

---

## How the hooks work

```
git commit -m "feat(shared): add rule"
      │
      ├─ pre-commit hook fires first
      │    └─ lint-staged runs on staged files only:
      │         *.md        → markdownlint-cli2 --fix + prettier --write
      │         *.json      → prettier --write
      │         *.yml/yaml  → prettier --write
      │         *.ts/js/cjs → prettier --write
      │         *.py        → ruff check --fix + ruff format
      │         *.go        → gofmt -w
      │         *.cs        → dotnet format --include
      │         *.sh        → shfmt -w
      │    If any tool reports an unfixable error → commit is aborted
      │
      └─ commit-msg hook fires after you write the message
           └─ commitlint validates against commitlint.config.cjs
                If the message is invalid → commit is aborted with
                an explanation and the format reminder
```

Auto-fixes are **re-staged automatically** by lint-staged — you do not need to `git add` again after a format fix.

---

## Interactive commit helper

If you find it hard to remember the format, use the guided prompt:

```bash
npm run commit
```

It walks through type → scope → subject → body → breaking change interactively, then writes the correctly formatted message for you.

---

## Setup (after cloning)

```bash
npm install       # installs husky and wires the git hooks automatically
```

If the hooks are not running, fix them:

```bash
npm run prepare           # re-registers .git/hooks from .husky/
chmod +x .husky/commit-msg .husky/pre-commit   # ensure executable
```

Verify hooks are registered:

```bash
ls -la .git/hooks/commit-msg .git/hooks/pre-commit
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `commitlint: command not found` | `node_modules` not installed | `npm install` |
| Hook fires but does nothing | Hook file not executable | `chmod +x .husky/commit-msg .husky/pre-commit` |
| `pre-commit` skips some files | Files not staged | `git add <file>` before committing |
| `ruff: command not found` | Ruff not installed | `pip install ruff` |
| `gofmt: command not found` | Go not installed | Install Go from golang.org |
| `prettier` reformats an already-formatted file | EditorConfig mismatch | Ensure your editor uses `.editorconfig` |
| Commit aborted with no error shown | Hook exited non-zero silently | Run `npx lint-staged` manually to see the error |

**Never use `--no-verify` to skip hooks.** Find the root cause instead — the hooks catch real problems.
