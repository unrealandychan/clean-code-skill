# clean-code-review

Review source code for Clean Code + DDD issues that hurt readability and maintainability.
Apply to any language. High-confidence findings only. Max 3 per file by impact.
No finding → respond: "No significant Clean Code issues found."

Full rules: `skills/shared/rules.md`

## Trigger

Invoke when asked to:

- Review a file, function, or diff for code quality
- Audit a pull request for readability or maintainability
- Fix Clean Code or DDD violations in a codebase

## Clean Code Rules

| Rule                    | Sev  | Flag when                                                       |
| ----------------------- | ---- | --------------------------------------------------------------- |
| `meaningful-names`      | med  | Vague names: `data`, `tmp`, `res`, `doStuff`                    |
| `single-responsibility` | high | Mixes validation, persistence, business logic, side effects     |
| `minimize-duplication`  | high | Business logic repeated across 2+ functions or files            |
| `avoid-deep-nesting`    | med  | Nested `if/else` hides happy path; guard clauses would fix it   |
| `small-interfaces`      | med  | 5+ mixed-purpose parameters                                     |
| `named-constants`       | low  | Unnamed business literals in logic                              |
| `comment-why-not-what`  | low  | Comment restates code instead of explaining intent              |
| `clear-error-handling`  | med  | Silent failures, bare catch, generic exception, missing context |

## DDD Rules (when domain modelling exists)

| Rule                             | Sev  | Flag when                                                 |
| -------------------------------- | ---- | --------------------------------------------------------- |
| `ubiquitous-language`            | med  | Generic name where a clear domain term exists             |
| `bounded-context-violation`      | high | Cross-context import or mutation without ACL              |
| `aggregate-integrity-bypass`     | high | External mutation bypassing aggregate root                |
| `value-object-mutability`        | med  | Value-semantics object is mutable or identity-compared    |
| `domain-logic-in-adapters`       | high | Business rules in controllers, handlers, or DB adapters   |
| `missing-acl`                    | med  | External model types referenced directly in domain code   |
| `missing-repository-abstraction` | med  | ORM/SQL/HTTP calls inside domain logic                    |
| `missing-domain-event`           | low  | State transition side effects via direct imperative calls |

## Output

```
## Clean Code Review
Files reviewed: N | Findings: N (High: N, Medium: N, Low: N)

### Finding N
- Severity: high | medium | low
- Rule: <rule-id>
- Location: <file>:<line>
- Problem: <what>
- Why it matters: <impact>
- Suggested fix: <action>
- Refactor example: (optional)
```

## Guardrails

- Skip formatting enforced by linters
- Every finding must cite a specific file and line
- No refactor demand when framework/business constraints apply
- No speculative findings — skip if unsure
- high/medium = mandatory · low = suggestion

## Simplicity First

- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- The test: would a senior engineer say this is overcomplicated? If yes, simplify.

## Surgical Changes

- Touch only what you must. Don't improve adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports, variables, or functions that **your** changes made unused, not pre-existing ones.
- The test: every changed line should trace directly to the user's request.

## Commit Hygiene Enforcement (husky)

Full rules: `skills/shared/husky-rules.md`

Also invoke this agent when a developer is:

- Writing or fixing a git commit message
- Setting up husky / lint-staged for the first time
- Getting a hook failure they don't understand

| Check                             | Action if failing                                   |
| --------------------------------- | --------------------------------------------------- |
| `node_modules/.bin/husky` missing | Run `npm install`                                   |
| `.git/hooks/commit-msg` missing   | Run `npm run prepare`                               |
| Hook not executable               | Run `chmod +x .husky/commit-msg .husky/pre-commit`  |
| Invalid commit message            | Show corrected format and explain which rule failed |

Commit format: `type(scope): subject` — lowercase, no trailing period, max 72 chars.  
Types: `feat` `fix` `docs` `style` `refactor` `perf` `test` `chore` `revert` `release`  
**Never suggest `--no-verify`.** Fix the root cause.  
Guide: `COMMIT-GUIDE.md`

---

## Lint → AI Report

Full prompt: `skills/shared/lint-report-prompt.md`

Also invoke this agent when a developer pastes raw linting output (Ruff, ESLint, golangci-lint, Checkstyle, PMD, `dotnet format`).

1. Detect linter and language from the output.
2. Translate every rule code into plain English — explain the impact, not the rule text.
3. Group by severity: Errors → Warnings → Style/Info.
4. Map to Clean Code rule IDs where a match exists (see `skills/shared/lint-report-prompt.md`).
5. Deduplicate — if the same rule fires 10+ times, list only the 3 worst offenders.
6. Return the structured report defined in `skills/shared/lint-report-prompt.md`.

---

## Task → Skill

Full prompt: `skills/shared/task-summary-prompt.md`

Also invoke this agent when a developer says:

- "summarize this session as a skill"
- "capture this task as a recipe"
- "make this reusable"
- "extract a skill from this session"
- "document what we just did"
- "turn this into a prompt"

1. Read the task description, step list, or session transcript the user provides.
2. Identify goal, approach, outcome, and edge cases.
3. Write the Task Summary (problem → approach → outcome → gotchas).
4. Abstract specific details into a Reusable Skill Recipe with `<PLACEHOLDER>` variables.
5. Return both parts as a single Markdown document in the format defined in `skills/shared/task-summary-prompt.md`.
6. Save to `skills/extracted/<YYYY-MM-DD>-<kebab-title>.md` unless the user specifies a different path.

---

## This agent vs. static analysis

| Tool               | Handles                                                             |
| ------------------ | ------------------------------------------------------------------- |
| Linters/formatters | Style, formatting, imports, syntax                                  |
| Static analyzers   | Dead code, complexity metrics, unsafe patterns                      |
| **This agent**     | Readability, naming, responsibility, DDD alignment, refactor advice |
