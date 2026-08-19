# Matt Pocock Productivity & Engineering Rules - Canonical Reference

> Extends `rules.md` and `agentic-engineering-rules.md` with Matt Pocock's daily engineering and productivity workflows (`mattpocock/skills`).
> Reference: [github.com/mattpocock/skills](https://github.com/mattpocock/skills)

---

## Role & Scope

- **Productivity & Engineering Workflow Assistant**
- Scope: Plan grilling, domain terminology modeling, clarification protocols, state compaction, async questionnaires, and goal-driven implementation.
- Standard: Relentless clarity, minimal footprints, verifiable milestones, zero hallucinated time estimates.

---

## Rules by Category

### 1. User-Invoked vs Model-Invoked Skill Discipline

| Rule                             | Severity | Trigger                                                                                                                                                          |
| -------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `user-invoked-skill-boundary`    | **high** | A background agent or sub-skill invokes a top-level user-interactive skill (e.g. `grill-me`, `to-questionnaire`, `wizard`) instead of keeping execution focused. |
| `unclear-cross-skill-call`       | medium   | A skill attempts to invoke another skill ambiguously instead of using explicit `call Skill tool with "<name>"` syntax.                                           |
| `missing-model-invocation-guard` | medium   | Interactive slash-command skills omit `disable-model-invocation: true` / `policy.allow_implicit_invocation: false` metadata.                                     |

### 2. Clarification & Plain-English Communication (`wait-what`)

| Rule                               | Severity | Trigger                                                                                                                                                                                            |
| ---------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `unclear-explanation-no-wait-what` | **high** | User indicates confusion ("wait what?", "I don't understand", "clarify") and the agent repeats the same technical monologue instead of re-pitching in plain English using `CONTEXT.md` vocabulary. |
| `jargon-overload`                  | medium   | Agent explains simple architectural decisions using unnecessary meta-commentary, buzzwords, or convoluted phrasing.                                                                                |
| `unanchored-vocabulary`            | medium   | Agent introduces new domain terms without checking or referencing `CONTEXT.md` / `CONTEXT-MAP.md`.                                                                                                 |

### 3. Plan Hardening & Stress-Testing (`grill-me` / `grilling`)

| Rule                       | Severity | Trigger                                                                                                                          |
| -------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `unguarded-plan-execution` | **high** | Agent begins writing code on a complex architecture without resolving branch decisions or user trade-offs.                       |
| `shallow-interview`        | medium   | Agent asks superficial questions instead of relentlessly probing edge cases, failure modes, data lifecycles, and rollback plans. |
| `unresolved-design-forks`  | **high** | Multiple competing implementation paths exist, but the agent selects one silently without grilling the user on trade-offs.       |

### 4. Domain Modeling & Context Mapping (`domain-modeling`)

| Rule                          | Severity | Trigger                                                                                                        |
| ----------------------------- | -------- | -------------------------------------------------------------------------------------------------------------- |
| `missing-domain-context-map`  | **high** | Non-trivial multi-module project lacks `CONTEXT-MAP.md` or `CONTEXT.md` defining bounded context vocabularies. |
| `adr-without-vocabulary-sync` | medium   | Architectural Decision Record (ADR) written without updating the project's ubiquitous domain dictionary.       |
| `domain-boundary-drift`       | **high** | Core entity terms are used inconsistently across different modules or adapters.                                |

### 5. State Compaction & Multi-Agent Handoff (`handoff`)

| Rule                        | Severity | Trigger                                                                                                              |
| --------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------- |
| `uncompacted-agent-handoff` | **high** | Agent session or sub-task terminates without generating a structured markdown handoff summary for subsequent agents. |
| `lossy-context-transfer`    | **high** | Handoff document omits active branch state, decisions made, pending edge cases, or verification commands.            |

### 6. Async Alignment & Questionnaire (`to-questionnaire`)

| Rule                                | Severity | Trigger                                                                                                                                            |
| ----------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `blocking-on-unstructured-question` | medium   | Agent presents a wall of unformatted questions instead of a clean, structured Markdown questionnaire with selectable options and trade-off tables. |

### 7. Goal-Driven Spec & Execution (`to-spec`, `to-tickets`, `wizard`)

| Rule                        | Severity | Trigger                                                                                                                                   |
| --------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `fictitious-time-estimates` | **high** | Agent or wizard fabricates arbitrary time estimates ("this will take 2 hours") instead of defining concrete, verifiable acceptance tests. |
| `unverifiable-ticket-step`  | **high** | Spec or ticket breakdown lacks concrete per-step automated verification checks (`Step N -> Verify: <cmd>`).                               |
| `oversized-ticket-scope`    | medium   | A ticket or task step modifies more than 2-3 logical files at once without intermediate verification.                                     |

---

## Core Interactive Workflows

### `/grill-me` - Plan Stress-Testing

- **Purpose**: Relentlessly interview the user about a proposed plan or design until every branch of the decision tree is resolved.
- **Protocol**:
  1. Identify all decision branches, edge cases, performance limits, and security constraints.
  2. Ask targeted, non-trivial questions one at a time (or in tightly coupled groups).
  3. Update the implementation plan in-place after each resolution.

### `/wait-what` - Plain-English Clarification

- **Purpose**: Instantly pivot when an explanation or proposed change fails to land.
- **Protocol**:
  1. Read `CONTEXT-MAP.md` and the appropriate `CONTEXT.md` to ground domain terms.
  2. Strip away all meta-jargon and re-pitch the core concept in 2-3 concise plain-English paragraphs.
  3. State: (a) What this actually does, (b) Why we need it, and (c) What the user needs to decide.

### `/handoff` - Session State Compaction

- **Purpose**: Compact current conversation context into a structured markdown document so any subsequent agent or engineer can pick up seamlessly.
- **Structure**:

  ```markdown
  # Session Handoff: [Feature / Task Name]

  - Date: YYYY-MM-DD
  - Current Status: [In Progress / Blocked / Ready for Review]

  ## Decisions Made

  - [Decision 1] -> Rationale: [Why]

  ## Completed Work

  - [x] [Item 1] ([file:line](file:///path))

  ## Remaining Work & Immediate Next Step

  - [ ] [Next immediate task] -> Run verification: `npm test`

  ## Gotchas & Blockers

  - [Warning or edge case discovered]
  ```

### `/to-questionnaire` - Async Decision Form

- **Purpose**: Convert an architectural or design roadblock into a structured Markdown questionnaire for async completion.
- **Structure**: Include concise context, explicit options (A, B, C), trade-offs matrix, and a recommended default.

### `/domain-modeling` - Bounded Context & Vocabulary Sync

- **Purpose**: Maintain `CONTEXT.md` files mapped by `CONTEXT-MAP.md` whenever codebase terminology, ADRs, or bounded contexts are introduced or modified.

---

## Severity Summary

- **high**: Direct risk of agent derailment, runaway loops, context loss, or broken domain boundaries. Must resolve before proceeding.
- **medium**: Workflow friction or missing documentation artifact. Address within current session.
- **low**: Stylistic or non-blocking improvement recommendation.
