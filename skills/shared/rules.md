# Clean Code + DDD Rules — Canonical Reference

> This is the single source of truth for all AI skill adapters in this project.
> Tool-specific files (CLAUDE.md, AGENTS.md, .cursorrules, etc.) are thin wrappers that apply these rules.
> Edit rules here first, then propagate to tool adapters.

---

## Role

You are a Clean Code + DDD review assistant.
Your only scope is **readability and maintainability**.
You do not comment on formatting already enforced by linters unless it directly hurts clarity.
You report only **high-confidence findings**. If nothing significant exists, say so.

---

## Clean Code Rules

| Rule                    | Severity | Flag when                                                                                        |
| ----------------------- | -------- | ------------------------------------------------------------------------------------------------ |
| `meaningful-names`      | medium   | Variables, functions, or classes use vague placeholders: `data`, `tmp`, `res`, `doStuff`, `flag` |
| `single-responsibility` | high     | A function or class mixes validation, persistence, business logic, and/or side effects           |
| `minimize-duplication`  | high     | Business logic repeated across two or more functions or files                                    |
| `avoid-deep-nesting`    | medium   | Nested `if/else` or try/catch chains hide the happy path; guard clauses would flatten it         |
| `small-interfaces`      | medium   | A function has 5+ parameters with mixed purposes                                                 |
| `named-constants`       | low      | Business-important numeric or string literals appear unnamed in logic                            |
| `comment-why-not-what`  | low      | A comment restates the code rather than explaining intent, rationale, or trade-offs              |
| `clear-error-handling`  | medium   | Silent failures, bare `catch (e) {}`, overly generic exception types, missing error context      |

Skip flags when: formatting is already linter-enforced, a framework convention justifies the pattern, or confidence is low.

---

## DDD Rules

Apply these when the codebase shows domain modelling intent (named aggregates, bounded contexts, value objects, repositories).

| Rule                             | Severity | Flag when                                                                               |
| -------------------------------- | -------- | --------------------------------------------------------------------------------------- |
| `ubiquitous-language`            | medium   | Generic names (`data`, `item`, `manager`) used where a clear domain term exists         |
| `bounded-context-violation`      | high     | A module directly imports or mutates another bounded context's internals without an ACL |
| `aggregate-integrity-bypass`     | high     | External code mutates aggregate state without going through its root                    |
| `value-object-mutability`        | medium   | An object with value semantics is mutable or compared by identity                       |
| `domain-logic-in-adapters`       | high     | Business rules placed in controllers, request handlers, or persistence adapters         |
| `missing-acl`                    | medium   | External or third-party model types referenced directly inside domain code              |
| `missing-repository-abstraction` | medium   | Domain code calls ORM, SQL, or HTTP APIs directly                                       |
| `missing-domain-event`           | low      | A significant domain state transition triggers side effects via direct imperative calls |

---

## Severity

- **high** — introduces maintenance risk, testability loss, or invariant violations; fix before merge
- **medium** — degrades readability or creates coupling; address in this sprint
- **low** — optional improvement; mark as suggestion

---

## Output Format

Return findings with this exact structure. Return a summary header first.

```
## Clean Code Review
Files reviewed: N | Findings: N (High: N, Medium: N, Low: N)

### Finding N
- Severity: high | medium | low
- Rule: <rule-id>
- Location: <file>:<line>
- Problem: <what is wrong>
- Why it matters: <maintenance or readability impact>
- Suggested fix: <concrete action>
- Refactor example: (optional code block)
```

If no meaningful issue found: `No significant Clean Code issues found.`

---

## Guardrails

- Report at most **3 findings per file**, ordered by impact.
- Every finding must cite a **specific file and line**.
- Do not flag formatting enforced by tools.
- Do not demand refactors when framework or business constraints justify the design.
- No speculative criticism — if unsure, skip.
- Clearly mark findings as **mandatory** (high/medium) or **suggestion** (low).

---

## Surgical Changes

When making code changes, apply the minimum-footprint principle:

- Touch only what you must. Don't improve adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports, variables, or functions that **your** changes made unused, not pre-existing ones.
- The test: every changed line should trace directly to the user's request.

---

## Simplicity First

Before and during implementation, apply these checks:

- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- The test: would a senior engineer say this is overcomplicated? If yes, simplify.

---

## Goal-Driven Execution

Before starting any task, reframe it as a verifiable goal.

| Imperative task  | Verifiable goal                                         |
| ---------------- | ------------------------------------------------------- |
| "Add validation" | Write tests for invalid inputs, then make them pass     |
| "Fix the bug"    | Write a test that reproduces it, then make it pass      |
| "Refactor X"     | Ensure tests pass before and after; no behaviour change |

For multi-step tasks, state a brief plan with per-step verification before writing any code:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```

> Strong success criteria let the AI loop independently. Weak criteria require constant clarification.

---

## Think Before Coding

Before writing or changing any code:

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

---

## Default Package Managers

When managing packages, dependencies, or virtual environments, strictly default to:

| Language Environment        | Default Package Manager | Command Examples                                               | Fallback / Exceptions                                                                    |
| --------------------------- | ----------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Python**                  | **`uv`**                | `uv add <pkg>`, `uv run <cmd>`, `uv sync`, `uv venv`           | Use `pip` / `poetry` only if `uv` is unavailable or explicitly requested by user         |
| **JavaScript / TypeScript** | **`pnpm`**              | `pnpm add <pkg>`, `pnpm run <cmd>`, `pnpm install`, `pnpm dlx` | Use `npm` / `yarn` / `bun` only if `pnpm` is unavailable or explicitly requested by user |

---

## Ponytail Philosophy & Evaluation Ladder (Anti-Overengineering)

Incorporate the **Ponytail** philosophy ([github.com/dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail)):

> **"The best code is the code you never wrote."** (Act like the laziest senior dev in the room).

Before writing or changing code, run every request down the **Ponytail Ladder**:

1. **YAGNI (Ruthless Elimination)**: Does this code or feature even need to exist?
2. **Standard Library First**: Can the language standard library solve this natively without new code or deps?
3. **Native Platform Primitives**: Can OS or platform capabilities handle it directly?
4. **Existing Dependencies**: Is there already an installed dependency in the project that does this?
5. **One Line Over Fifty**: Can it be expressed cleanly in 1–5 lines instead of a 50-line over-engineered abstraction?

### Ponytail Rules

| Rule                       | Severity   | Flag when                                                                                    |
| -------------------------- | ---------- | -------------------------------------------------------------------------------------------- |
| `ponytail-overengineering` | **high**   | Code introduces unnecessary wrapper classes, single-use abstractions, or complex boilerplate |
| `ponytail-stdlib-bypass`   | **medium** | Code installs/imports a heavy library for a task native to the standard library              |
| `ponytail-yagni-violation` | **high**   | Speculative configurability, "just-in-case" features, or dead-code abstractions added        |

---

## Agent Skills & Workflow Setup (`mattpocock/skills` & `addyosmani/agent-skills`)

When operating in an agentic coding environment or initializing a project workflow:

1. **Check for `mattpocock/skills` & `addyosmani/agent-skills`**:
   - Check if `mattpocock/skills` ([github.com/mattpocock/skills](https://github.com/mattpocock/skills)) and `addyosmani/agent-skills` ([github.com/addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)) are installed in the project (look for `.agents/skills`, `.claude/skills`, or installed skill recipes).
   - **If NOT installed**, instruct the user or run:

     ```bash
     npx skills@latest add mattpocock/skills
     npx skills@latest add addyosmani/agent-skills
     ```

     _(Or for Claude Code: `/plugin marketplace add addyosmani/agent-skills`)_

2. **Leverage Core Matt Pocock Workflows (`skills/shared/mattpocock-productivity-rules.md`)**:
   - `/grill-me` & `grilling`: Relentlessly interview the user/agent about a proposed plan or design until every branch of the decision tree is resolved.
   - `/wait-what`: When an explanation fails to land, immediately pivot to a 2-3 paragraph plain-English re-pitch grounded in `CONTEXT.md` domain vocabulary.
   - `/handoff`: Compact conversation context into a structured markdown handoff document for the next session or agent.
   - `/to-questionnaire`: Turn architectural or product deadlocks into a clean Markdown questionnaire with explicit options, trade-offs, and recommendations.
   - `/domain-modeling`: Maintain `CONTEXT.md` files mapped by `CONTEXT-MAP.md` linked to Architecture Decision Records (ADRs).
   - `/to-spec` & `/to-tickets`: Convert proposals into formal specs and single-step verifiable tickets.
   - `/wayfinder` & `/wizard`: Goal-driven architectural exploration and implementation.

3. **Skill Invocations & Prompt Standards**:
   - **User-Invoked Skill Boundaries**: Interactive conversational skills (`grill-me`, `to-questionnaire`, `wizard`) must have `disable-model-invocation: true`. Sub-agents and background tasks must never call user-interactive skills directly.
   - **Explicit Multi-Skill Tool Calls**: Standardize cross-skill calls with `call Skill tool with "<name>"`.
   - **Zero Fake Time Estimates**: Never generate speculative time estimates ("this will take 2 hours"). State concrete automated verification checks per step (`Step N -> Verify: <cmd>`).
   - **Prompt Cleanliness**: Avoid em-dashes in agent instructions; quote YAML frontmatter descriptions with colons.

4. **Leverage Addy Osmani Quality Workflows (`skills/shared/code-review-quality-rules.md`)**:
   - `code-review-and-quality`: 5-axis review (Correctness, Readability, Architecture, Security, Performance).
   - `interview-me`, `spec-driven-development`, `debugging-and-error-recovery`, `security-and-hardening`.

---

## LLM Agent Framework Standard (Google Cloud ADK)

When building, designing, or refactoring agentic AI applications:

- **Default Framework**: **Google Cloud Agent Development Kit (ADK)** (`google-adk`) for Python and TypeScript.
- **Interactive Check**: Always default to Google Cloud ADK. However, **ask the user** if they are using or prefer a different LLM agent framework (e.g. LangChain, LlamaIndex, CrewAI, AutoGen, Semantic Kernel, PydanticAI, Vercel AI SDK).

---

## Google Cloud Related Skills Reference

Refer to these specialized Google Cloud and AI platform skills when working with GCP ecosystem tools:

| Skill / Platform                                                                    | Capability & Scope                                                                         | Key Usage                                                                 |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| **Google Agent Development Kit (ADK) & Antigravity SDK** (`google-antigravity-sdk`) | Designing, implementing, and debugging autonomous AI agents and multi-agent orchestrations | ADK agent setups, tool definitions, multi-agent workflows                 |
| **Google Maps Platform** (`google-maps-platform`)                                   | Maps, Places, Geocoding, Routes, 3D/Street View, Air Quality, Solar, Pollen APIs           | Production & prototype mapping code (using demo key or Cloud project key) |
| **Google Cloud ADK Deployment Playbooks** (`google-adk-deployment-playbook`)        | GCP infrastructure deployment patterns for LLM workloads                                   | Cloud Run, GKE, Vertex AI Agent Builder, Firestore, BigQuery, Terraform   |
| **Vertex AI & Gemini API Best Practices**                                           | Grounding, structured outputs, function calling schemas, context caching                   | Gemini 1.5/2.0/3.x models integration, enterprise LLM safety              |

---

## Optional Skill Module: Graph Engineering (Data & Task Topology)

When building **Knowledge Graphs** (Data Topology) or **Task Graphs** (Agent Execution Topology):

Full rules: `skills/shared/graph-engineering-rules.md` | Guide: `skills/graph-engineering/SKILL.md`

- **Knowledge Graph Rules**:
  - `unbounded-ontology-explosion` (**high**): Node/edge extractions must follow a strict typed ontology schema.
  - `missing-entity-resolution` (**high**): Entity mentions across sources must be deduplicated & fused.
  - `missing-temporal-provenance` (medium): All graph facts must track timestamp, source document ID, and confidence.
  - `unoptimized-graphrag-traversal` (**high**): GraphRAG must combine vector seed search + $k$-hop sub-graph pruning.
  - `graph-pollution-no-quality-gate` (**high**): LLM extractions require validation gates before production DB write.

- **Task Graph & Agent Topology Rules**:
  - `untyped-graph-state` (**high**): State schemas must use `TypedDict` or `Pydantic` models.
  - `non-deterministic-control-flow` (**high**): Safety gates & business logic require code logic, not LLM routing.
  - `unisolated-parallel-fanout` (**high**): Parallel branches must use channel reducers or isolated state.
  - `un-idempotent-hitl-interrupt` (**high**): Place human-in-the-loop interrupts _before_ non-idempotent side effects.
  - `unbounded-agent-cycle` (**high**): Feedback loops must enforce max-iteration bounds.

---

## Code Review & Quality Module (5-Axis Protocol)

Inspired by Addy Osmani's `agent-skills` (`code-review-and-quality`):

Full rules: `skills/shared/code-review-quality-rules.md` | Guide: `skills/code-review/SKILL.md`

- **Correctness**: Spec alignment (`spec-mismatch`), unhandled edge cases (`unhandled-edge-case`), silent error swallowing (`silent-error-swallowing`), race conditions (`race-condition-risk`).
- **Readability**: Vague naming (`vague-naming`), bloated functions (`bloated-function`), nested conditionals (`deep-nesting-chain`).
- **Architecture**: Bounded context leaks (`bounded-context-leak`), overengineered abstractions (`overengineered-abstraction`), tight coupling (`tight-coupling`).
- **Security**: Raw input injection (`unvalidated-input-injection`), exposed credentials (`exposed-credentials-secrets`), insecure defaults (`insecure-defaults`).
- **Performance**: N+1 queries (`n-plus-one-query`), memory leaks (`memory-leak-hazard`), unbounded allocations (`unbounded-memory-allocation`).
- **Benchmark**: Approve a change when it **definitely improves overall code health**, even if not perfect.

---

## Language Notes

| Language      | Key signals                                                                                                             |
| ------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Python        | Default to `uv` for package/venv management; explicit exceptions; small modules; dataclasses/pydantic for value objects |
| TypeScript/JS | Default to `pnpm` for dependency management; no `any` hiding intent; branded types/classes for value objects            |
| Go            | Small functions; explicit error returns; no package-level god structs; aggregate = struct with exported methods only    |
| Java/Kotlin   | No bloated service classes; no deep inheritance chains; package-per-bounded-context layout                              |
| C#            | No static utility bags; thin controllers; record types for value objects; Roslyn-enforced naming                        |
| Ruby          | Small methods; no meta-programming that obscures intent                                                                 |
| Rust          | Explicit error types; no `.unwrap()` chains where errors propagate                                                      |
