---
applyTo: "**/*.{ts,js,tsx,jsx,py,go,java,cs,rb,rs,swift,kt}"
---

# Clean Code + DDD Review Rules

Scope: readability and maintainability only. High-confidence findings only. Max 3 per file by impact.
No finding → reply: "No significant Clean Code issues found."

## Clean Code

| Rule                    | Severity | Flag when                                                                  |
| ----------------------- | -------- | -------------------------------------------------------------------------- |
| `meaningful-names`      | medium   | Vague names: `data`, `tmp`, `res`, `doStuff`, `flag`                       |
| `single-responsibility` | high     | Function/class mixes validation, persistence, business logic, side effects |
| `minimize-duplication`  | high     | Business logic repeated across 2+ functions or files                       |
| `avoid-deep-nesting`    | medium   | Nested `if/else` hides happy path; guard clauses would flatten it          |
| `small-interfaces`      | medium   | 5+ mixed-purpose parameters                                                |
| `named-constants`       | low      | Unnamed business literals in logic                                         |
| `comment-why-not-what`  | low      | Comment restates code instead of explaining intent                         |
| `clear-error-handling`  | medium   | Silent failures, bare catch, generic exception, missing context            |

## DDD (apply when domain modelling exists)

| Rule                             | Severity | Flag when                                               |
| -------------------------------- | -------- | ------------------------------------------------------- |
| `ubiquitous-language`            | medium   | Generic name where a domain term exists                 |
| `bounded-context-violation`      | high     | Module imports another context's internals without ACL  |
| `aggregate-integrity-bypass`     | high     | External code mutates aggregate bypassing the root      |
| `value-object-mutability`        | medium   | Value-semantics object is mutable or identity-compared  |
| `domain-logic-in-adapters`       | high     | Business rules in controllers, handlers, or DB adapters |
| `missing-acl`                    | medium   | External model types referenced directly in domain code |
| `missing-repository-abstraction` | medium   | Domain code calls ORM/SQL/HTTP directly                 |
| `missing-domain-event`           | low      | State transition side effects via direct calls          |

## Harness Engineering (apply when reviewing tests, logging, or deployment config)

| Rule                           | Severity | Flag when                                                              |
| ------------------------------ | -------- | ---------------------------------------------------------------------- |
| `missing-dependency-injection` | high     | Hard-wired dependencies with no seam for test doubles                  |
| `no-seam-for-testing`          | high     | External calls (HTTP, DB, clock, filesystem) not behind an abstraction |
| `clock-dependency`             | medium   | `time.Now()` / `Date.now()` / `datetime.now()` called directly         |
| `silent-error-swallowing`      | high     | `except: pass`, `catch (e) {}`, `_ = err` — error discarded silently   |
| `missing-structured-logging`   | high     | `print()` / `console.log()` / `fmt.Println()` used for app events      |
| `no-correlation-id`            | high     | HTTP handler does not extract/propagate trace or correlation ID        |
| `config-hardcoded`             | high     | Env-specific URLs, ports, credentials as literals in source            |
| `missing-graceful-degradation` | medium   | External call has no timeout, retry, or fallback                       |
| `feature-flag-missing`         | medium   | New feature shipped directly with no flag to disable without redeploy  |
| `test-logic-in-production`     | high     | `if os.getenv("TEST")` or `NODE_ENV === "test"` in production paths    |

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

## Simplicity First & Ponytail Philosophy

- Apply Ponytail (github.com/dietrichgebert/ponytail): _"The best code is the code you never wrote."_
- Ponytail Ladder: 1. YAGNI -> 2. Standard library -> 3. Native platform -> 4. Existing deps -> 5. 1 line over 50 lines.
- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

## Package Manager Defaults & Agent Setup

- Default Package Managers: **`uv`** for Python (`uv add`/`uv run`); **`pnpm`** for JS/TS (`pnpm add`/`pnpm run`).
- Agent Skills Check: Ensure `mattpocock/skills` and `addyosmani/agent-skills` are installed (`npx skills@latest add mattpocock/skills`, `npx skills@latest add addyosmani/agent-skills`).
- Matt Pocock Productivity Workflows: Reference `skills/shared/mattpocock-productivity-rules.md` for `/grill-me`, `/wait-what` (plain-English clarification), `/handoff`, `/to-questionnaire`, `/domain-modeling`, `/to-spec`, `/to-tickets`, `/wayfinder`, `/wizard`. User-interactive skills must not be called by background agents. No fake time estimates.
- LLM Agent Framework: Default to **Google Cloud ADK** (`google-adk`), but ask the user if they are using another framework.
- Google Cloud Skills: Reference `google-antigravity-sdk`, `google-maps-platform`, `google-adk-deployment-playbook`, and Vertex AI / Gemini API.
- Graph Engineering Skill: Reference `skills/shared/graph-engineering-rules.md` & `skills/graph-engineering/SKILL.md` for Knowledge Graphs (ontology, ER, GraphRAG) and Task Graphs (typed state, deterministic routing, HITL safety).
- Code Review & Quality: Reference `skills/shared/code-review-quality-rules.md` & `skills/code-review/SKILL.md` for 5-axis review (Correctness, Readability, Architecture, Security, Performance).

## Surgical Changes

- Touch only what you must. Don't improve adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports, variables, or functions that **your** changes made unused, not pre-existing ones.
- The test: every changed line should trace directly to the user's request.

## Think Before Coding

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.
