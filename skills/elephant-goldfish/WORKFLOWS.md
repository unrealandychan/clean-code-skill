# Elephant-Goldfish Model (EGM) Execution Workflows

Actionable step-by-step workflows, subagent dispatch templates, and document standard checklists for executing Google's Elephant-Goldfish Model (`google/elephant-goldfish-model`) across Antigravity, Claude Code, Codex, and Herdr.

---

## 1. `/egm-brainstorm` (Elephant Interview + Goldfish Shootdown)

**Goal**: Stress-test a raw idea, prevent premature coding, and produce an approved `concepts_brief.md`.

### Execution Steps
1. **Activate Elephant Mode (Strict No-Code Policy)**:
   - Refuse to write or edit production source code during this phase.
   - Explore the repository read-only to identify existing bounded contexts, modules, and conventions.
2. **Conduct the Heilmeier Catechism Interview**:
   - Ask 1 to 3 targeted questions per turn until every question in the **Heilmeier Standard** is answered:
     1. *What are you trying to do?* Articulate objectives using zero jargon and DDD Ubiquitous Language (`GLOSSARY.md`).
     2. *How is it done today, and what are the limits of current practice?*
     3. *What is new in your approach, and why do you think it will be successful?*
     4. *Who cares? If you are successful, what difference will it make?*
     5. *What are the risks and payoffs?*
     6. *How much will it cost (complexity, latency, maintenance, blast radius)?*
     7. *What are the midterm and final "exams" to check for success (observable verification gates)?*
3. **Dispatch Goldfish Shootdown Critics**:
   - Propose 2 to 3 distinct candidate approaches (including a minimal YAGNI baseline).
   - Spawn fresh, zero-context Goldfish subagents (`egm-zoom-out` and `egm-design`) passing *only* the candidate summaries and relevant codebase file paths.
   - Instruct Goldfish critics to attempt to **shoot down** each candidate on complexity, hidden coupling, codebase duplication, or failure modes.
4. **Emit `concepts_brief.md`**:
   - Synthesize the surviving approach, rejected alternatives (with shootdown rationale), Heilmeier answers, and scope boundaries into `concepts_brief.md`.

---

## 2. `/egm-draft` (Iterative Section-by-Section Spec Compiler)

**Goal**: Transform an approved `concepts_brief.md` into a rigorous, self-contained specification at `docs/designs/<feature>.md`.

### Execution Steps
1. **Verify Prerequisite**: Confirm `concepts_brief.md` exists or that the Heilmeier Catechism is answered. Maintain the Elephant **No-Code Policy**.
2. **Draft Section-by-Section**: Draft `docs/designs/<feature>.md` following `feature-spec-standard.md`, pausing after each major group for user confirmation before locking:
   - **Section 1: Overview & Heilmeier Summary** (Problem Statement, Ubiquitous Language terms, Goals, Non-Goals).
   - **Section 2: System Architecture & Bounded Context Impact** (Component diagram, data flow, `CONTEXT-MAP.md` alignment, deep module boundaries).
   - **Section 3: Exact Interfaces, Data Models & File Manifest** (Exact file paths to create/modify, concrete type/interface definitions, function signatures, state transitions).
   - **Section 4: Failure Modes, Security & Invariants** (Error taxonomy, timeouts, idempotency, concurrency, rollback/migration strategy if re-implementing).
   - **Section 5: Verification & Test Strategy** (Gherkin acceptance scenarios, unit/integration test matrix, observability signals).
   - **Section 6: Alternatives Considered** (Summary of approaches rejected during `/egm-brainstorm`).

### `docs/designs/<feature>.md` Template
```markdown
# Design Spec: <Feature Name>

- **Status**: Draft | In Review | Approved | Implemented
- **Bounded Context**: <Context Name>
- **Related Glossary / ADRs**: <Links to GLOSSARY.md / ADR-xxx>

## 1. Overview & Heilmeier Summary
### 1.1 Problem Statement
### 1.2 Goals
### 1.3 Non-Goals (Explicit Out-of-Scope)

## 2. System Architecture & Context Integration
### 2.1 High-Level Design & Data Flow
### 2.2 Existing Codebase Reuse (Ponytail Check)

## 3. Exact Interfaces, Data Models & File Manifest
### 3.1 File Manifest (Create / Modify / Delete)
### 3.2 Public Interfaces & Type Signatures
### 3.3 Data Models & Schema Changes

## 4. Failure Modes, Edge Cases & Operational Invariants
### 4.1 Error Handling & Recovery
### 4.2 Concurrency, Performance & Security Constraints
### 4.3 Migration & Rollback Plan (If Re-Implementation)

## 5. Verification & Test Plan
### 5.1 Gherkin Acceptance Criteria
### 5.2 Unit, Property-Based & Integration Test Matrix

## 6. Alternatives Considered
```

---

## 3. `/egm-review` (5-Stage Stateless Goldfish Verification Pipeline)

**Goal**: Audit `docs/designs/<feature>.md` using fresh, zero-context Goldfish subagents that have **no access** to the Elephant's conversation history.

### Critical Isolation Rule
When invoking any Goldfish subagent, **never** pass conversation history, chat summaries, or unwritten intent. Pass **only**:
1. The path to `docs/designs/<feature>.md`
2. The path to `GLOSSARY.md` / `CONTEXT-MAP.md` (if present)
3. Read access to the repository source tree

### The 5 Sequential/Parallel Stages

#### Stage 1: Initial Zoom-Out (`egm-zoom-out` + `zoom-out-standard.md`)
- **Prompt Focus**: "Read `docs/designs/<feature>.md` and inspect the repository. Without any conversational context, evaluate: (1) Is this problem solvable by extending an existing module? (2) Does the complexity match the problem value (YAGNI)? (3) Can the design be cut in half while delivering 90% of the value?"
- **Gate**: If `egm-zoom-out` raises an architectural **Blocker**, halt the pipeline and surface it immediately.

#### Stage 2: Comprehension Pass (`egm-comprehension`)
- **Prompt Focus**: "Act as a Naive Reader who just joined the team and has zero chat context. Read `docs/designs/<feature>.md`. List every undefined term, unstated assumption, ambiguous control flow, or contradiction with `GLOSSARY.md`."

#### Stage 3: Parallel Critic Swarm (`egm-design`, `egm-structural`, `egm-style`, `egm-codebase-details`)
- Dispatch in parallel:
  - **`egm-design`**: Check deep module boundaries (Ousterhout), DDD aggregate invariants, failure handling, security, and concurrency.
  - **`egm-structural`**: Check compliance with `feature-spec-standard.md` (or `re-implementation-standard.md` for rewrites) and internal consistency across sections.
  - **`egm-style`**: Flag vague qualifiers ("fast", "should probably", "appropriately", "etc.") and passive voice where actor responsibility is unclear.
  - **`egm-codebase-details`**: Verify that every file path, class, function signature, and package referenced in `docs/designs/<feature>.md` actually exists in the repository (unless explicitly marked `[NEW]`).

#### Stage 4: Intermediate Zoom-Out (`egm-zoom-out` Post-Critic Pass)
- **Prompt Focus**: "Review the combined findings from Stage 3 alongside `docs/designs/<feature>.md`. Identify and reject any critic recommendations that introduce scope creep, speculative abstractions, or unnecessary layers."

#### Stage 5: Implementation Readiness (`egm-implementation-readiness` + `implementation-readiness-standard.md`)
- **Prompt Focus**: "Apply the **Zero-Decision Rule** to `docs/designs/<feature>.md`. Could a stateless coding agent implement this spec from top to bottom without making a single architectural, API, naming, or error-handling guess? List every remaining decision gap as a `Blocker`."

---

## 4. `/egm-review-loop` (Hierarchical vs. Direct Dispatch)

**Goal**: Automate multi-pass Goldfish verification until `docs/designs/<feature>.md` reaches zero `Blockers`.

### Mode A: Hierarchical Dispatch (Default — Recommended for Context Hygiene)
1. The Elephant spawns a single **`egm-synthesizer`** orchestrator subagent.
2. `egm-synthesizer` runs the Stage 1–5 Goldfish subagents, collects their raw critiques, removes duplicate points, resolves conflicting suggestions using the Stage 4 Intermediate Zoom-Out filter, and returns a single structured report to the Elephant:
   - **`[BLOCKER]`**: Must be resolved before implementation (missing interface contract, hallucinated file path, unhandled failure mode, YAGNI violation).
   - **`[MAJOR]`**: Significant clarity or design weakness that risks agent misinterpretation.
   - **`[NIT]`**: Style, wording, or minor formatting improvement.

### Mode B: Direct Dispatch (Fallback when nested subagents are restricted)
1. The Elephant dispatches each Goldfish critic directly (`invoke_subagent` with `research` or `self` in Antigravity, or `herdr agent start` in Herdr).
2. The Elephant aggregates and deduplicates the findings using the `egm-synthesizer` rubric before presenting them to the user via `/egm-resolve`.

---

## 5. `/egm-resolve` (Interactive Feedback Triage & Spec Patching)

**Goal**: Collaboratively resolve Goldfish findings and update `docs/designs/<feature>.md` in place.

### Execution Steps
1. Present the synthesized findings grouped by severity (`[BLOCKER]`, `[MAJOR]`, `[NIT]`).
2. For each `[BLOCKER]` and `[MAJOR]` item, offer concrete resolution options (with a recommended default aligned with Clean Code and DDD).
3. Apply the approved edits directly to `docs/designs/<feature>.md`.
4. Re-run `/egm-review` (or targeted Goldfish personas) until `[BLOCKER]` count is `0` and `egm-implementation-readiness` signs off.
5. **Transition to Implementation**: Once `docs/designs/<feature>.md` is marked `Status: Approved`, hand off to `/gherkin-spec` and `/gauntlet-check` (`skills/extreme-constraints/WORKFLOWS.md`) for TDD implementation.

---

## 6. `/egm-bootstrap` (Bottom-Up Spec & Sentinel-Bounded README Generator)

**Goal**: Reverse-engineer accurate specifications and module contracts from an undocumented or legacy codebase.

### Execution Steps
1. **Map Dependency Graph (Leaf-to-Root)**:
   - Traverse directories from the lowest-level leaf modules (zero internal dependencies) up to root application entrypoints.
2. **Generate Sentinel-Bounded Module Summaries**:
   - In each module's `README.md`, inject or update a machine-managed block wrapped in EGM sentinel comments so human-written documentation outside the block is never overwritten:
     ```markdown
     <!-- EGM:START -->
     ## Module Contract (Auto-Generated by /egm-bootstrap)
     - **Bounded Context**: <Context>
     - **Public Surface**: <Exported classes/functions>
     - **Invariants & Dependencies**: <Key constraints and internal imports>
     <!-- EGM:END -->
     ```
3. **Synthesize Feature Specs**:
   - Aggregate leaf module contracts upward into `docs/designs/<domain-or-feature>.md` baseline specifications.

---

## 7. `/egm-drift-report` (Sequential Spec-to-Code Drift Scanner)

**Goal**: Detect architectural drift between `docs/designs/*.md` (and `<!-- EGM:START -->` blocks) and the live codebase after implementation or across PRs.

### Execution Steps
1. Enumerate all specifications in `docs/designs/*.md` and sentinel blocks in `**/README.md`.
2. Sequentially dispatch a stateless Goldfish verifier (`egm-codebase-details` + `egm-design`) for each spec against its target source files.
3. Classify every specified interface, invariant, and file path into one of three buckets:
   - **`[ALIGNED]`**: Implementation matches `docs/designs/<feature>.md`.
   - **`[UNDOCUMENTED_CODE]`**: Code added public APIs, dependencies, or side effects not present in the spec.
   - **`[VIOLATED_SPEC]`**: Code contradicts or omits a behavior, invariant, or test required by the spec.
4. Output a consolidated Drift Report and recommend either updating the spec (`/egm-resolve`) or fixing the code (`/gauntlet-check`).

---

## 8. Reference Checklists for the 5 EGM Document Standards

| Standard | Mandatory Verification Questions |
| :--- | :--- |
| **`heilmeier-standard.md`** | 1. Objective stated without jargon? 2. Current limits identified? 3. Novelty explained? 4. Stakeholders/impact clear? 5. Risks & payoffs listed? 6. Cost/blast radius quantified? 7. Midterm & final verification exams defined? |
| **`zoom-out-standard.md`** | 1. Does a simpler solution already exist in the repo? 2. Are we solving a hypothetical future problem (YAGNI)? 3. Did critic feedback bloat the design with unnecessary layers? |
| **`feature-spec-standard.md`** | 1. Goals & explicit Non-Goals present? 2. Deep module interfaces defined? 3. Failure modes & invariants documented? 4. Alternatives considered recorded? 5. Test strategy specified? |
| **`implementation-readiness-standard.md`** | 1. **Zero-Decision Rule**: Are all file paths, type definitions, function signatures, and error types explicit? 2. Are all cited codebase symbols verified by `egm-codebase-details`? |
| **`re-implementation-standard.md`** | 1. Behavioral parity matrix defined? 2. Feature flag / dual-write / shadow-read strategy specified? 3. Rollback trigger metrics documented? 4. Legacy deprecation/deletion steps included? |
