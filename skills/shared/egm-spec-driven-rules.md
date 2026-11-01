# Google's Elephant-Goldfish Model (EGM) — Canonical Reference

> Inspired by Google's **Elephant-Goldfish Model** ([github.com/google/elephant-goldfish-model](https://github.com/google/elephant-goldfish-model), Apache 2.0).
> Extends `rules.md` and `agentic-engineering-rules.md` with Google's Spec-Driven Development (SDD) memory split, stateless adversarial Goldfish review swarms, versioned document standards, and AST spec-to-code drift detection.

---

## 1. The Core Paradigm: Elephant vs. Goldfish Memory Split

Unstructured AI coding suffers from **conversational confirmation bias**, **context pollution**, **premature code generation**, and **architectural drift**. When the same AI session that brainstormed a design also reviews and implements it, unstated assumptions from the chat history masquerade as documented requirements.

Google's **Elephant-Goldfish Model (EGM)** resolves this by enforcing a strict separation between two agent memory modes:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   THE ELEPHANT-GOLDFISH MODEL (EGM)                         │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
        ┌──────────────────────────────┴──────────────────────────────┐
        ▼                                                             ▼
┌───────────────────────────────────────┐     ┌───────────────────────────────┐
│   🐘 THE ELEPHANT (Deep-Context)      │     │  🐠 THE GOLDFISH (Zero-Context)│
├───────────────────────────────────────┤     ├───────────────────────────────┤
│ • Remembers full project history,     │     │ • Stateless, isolated subagent│
│   GLOSSARY.md, ADRs, & user journeys  │     │   sessions with ZERO chat     │
│ • Strict "NO-CODE" Constraint         │     │   memory of the Elephant      │
│ • Conducts interviews, challenges     │     │ • Reads ONLY the written spec │
│   assumptions, drafts & resolves      │     │   & target codebase files     │
│   specs in docs/designs/<feature>.md  │     │ • Runs adversarial multi-lens │
│ • Commands: /egm-brainstorm,          │     │   audits against 5 standards  │
│   /egm-draft, /egm-resolve            │     │ • Commands: /egm-review,      │
│                                       │     │   /egm-review-loop            │
└───────────────────┬───────────────────┘     └───────────────┬───────────────┘
                    │                                         │
                    └────────────────────┬────────────────────┘
                                         ▼
                    ┌─────────────────────────────────────────┐
                    │  🧑 HUMAN ARCHITECT APPROVAL GATE       │
                    │  • Zero-Decision Readiness Verified     │
                    │  • Extreme Constraints Gauntlet Active  │
                    │  • Post-Code Audit: /egm-drift-report   │
                    └─────────────────────────────────────────┘
```

1. **The Elephant (Long-Horizon Designer)**:
   - Holds the entire architectural vision, repository history, domain glossary (`GLOSSARY.md` / `CONTEXT-MAP.md`), and micro-decisions.
   - **Strict "No-Code" Policy**: The Elephant never writes production implementation code during ideation or specification drafting.
2. **The Goldfish (Stateless Adversarial Critics)**:
   - Fresh, zero-context subagents spawned without any access to the Elephant's conversation history.
   - Because they cannot rely on "what the human meant in chat," they evaluate the written specification literally against objective rubrics and live source code.
3. **The Human (Decision Authority)**:
   - Arbitrates trade-offs during `/egm-resolve`, approves the final specification when it reaches **Zero-Decision Readiness**, and gates implementation.

---

## 2. How EGM Connects with Clean Code Skill Modules

EGM serves as the **upstream architectural verification engine** that bridges existing modules in `clean-code-ddd-harness`:

| Lifecycle Phase | Clean Code Skill Module | EGM Integration Role |
| :--- | :--- | :--- |
| **0. Legacy Onboarding** | Domain Modeling (`/domain-modeling`) | **`/egm-bootstrap`** crawls leaf-to-root directories, upserting sentinel-bounded READMEs and extracting module contracts (`Interface`, `Invariants`, `Seam`) for the Elephant. |
| **1. Ideation & Grilling** | Matt Pocock (`/grill-me`, `/wait-what`) | **`/egm-brainstorm`** pairs Elephant interviewing with a Goldfish "shootdown swarm" to stress-test raw ideas and emit `concepts_brief.md`. |
| **2. Spec Compilation** | DDD Rules & Codebase Design (`deep modules`) | **`/egm-draft`** compiles `concepts_brief.md` into `docs/designs/<feature>.md`, enforcing DDD bounded contexts and deep module interfaces. |
| **3. Adversarial Spec Audit** | Ponytail Ladder (`YAGNI`, anti-overengineering) | **`/egm-review` & `/egm-review-loop`** dispatch zero-context Goldfish personas (`egm-zoom-out`, `egm-comprehension`, `egm-design`, `egm-implementation-readiness`) to prune overengineering and verify the **Zero-Decision Rule**. |
| **4. Spec Triage** | Async Questionnaires (`/to-questionnaire`) | **`/egm-resolve`** triages `Blockers`, `Major`, and `Nits` interactively with the human and patches the spec in place. |
| **5. Constrained Execution** | Uncle Bob's Extreme Constraints (`/vibe-guard`, `/gherkin-spec`, `/gauntlet-check`) | Once the spec passes `implementation-readiness-standard.md`, Gherkin specs and the 6-pillar automated gauntlet validate implementation. |
| **6. Code Review & Drift** | Addy Osmani 5-Axis Review (`/code-review`) | **`/egm-drift-report`** scans AST and live code against `docs/designs/<feature>.md` to catch post-implementation divergence or undocumented shortcuts. |

---

## 3. The 5 Evaluation Rubrics (`resources/document_standards/`)

Goldfish reviewers never grade on subjective "vibes." Every review pass scores the specification against five explicit document standards:

| Standard ID | Rubric Name | Core Evaluation Criteria |
| :--- | :--- | :--- |
| `heilmeier-standard` | **Heilmeier Catechism Standard** | Evaluates problem clarity: What is the problem in plain English? Why does it matter now? What is the core hypothesis and measurable value proposition? What are the risks of doing nothing? |
| `zoom-out-standard` | **Zoom-Out & Altitude Standard** | Audits for simplicity and **YAGNI** (Ponytail alignment): Can existing codebase modules be reused instead of inventing new infrastructure? Prunes speculative abstractions and premature configurability. |
| `feature-spec-standard` | **Feature Architecture Standard** | Measures architectural completeness: Are bounded contexts, data contracts, scale limits, single points of failure (SPOFs), security boundaries, and rollback/degradation paths explicitly defined? |
| `implementation-readiness-standard` | **Zero-Decision Readiness Standard** | Enforces the **Zero-Decision Rule**: Could a fresh engineer or stateless coding agent implement this on the first pass without guessing, asking clarifying questions, or making unapproved design choices? Requires exact file paths (create/modify), real API signatures, and a concrete test plan. |
| `re-implementation-standard` | **Codebase Re-Implementation Standard** | Governs how existing code state, shared utilities, and module seams are documented so new changes integrate natively without duplicating existing patterns. |

---

## 4. The Stateless Goldfish Personas (`agents/`)

During `/egm-review` and `/egm-review-loop`, the orchestrator dispatches isolated subagents using strict persona definitions:

| Persona ID | Archetype | Primary Lens & Responsibility |
| :--- | :--- | :--- |
| `egm-synthesizer` | **Fan-Out / Fan-In Orchestrator** | Used in **Hierarchical Dispatch**. Spawns parallel Goldfish reviewers, collects raw findings, deduplicates overlapping critiques, formats file/line citations, and returns a single consolidated report to keep the Elephant's context window clean. |
| `egm-zoom-out` | **Skeptical Zoom-Out Architect** | Grades against `zoom-out-standard.md` and `heilmeier-standard.md`. Challenges problem framing, flags YAGNI violations, and identifies existing codebase utilities that should be reused. |
| `egm-comprehension` | **Naive Reader Auditor** | Audits the spec with zero background knowledge. Flags undefined acronyms, missing domain glossary terms (`GLOSSARY.md`), unstated prerequisites, and logical leaps that only make sense if you read the chat history. |
| `egm-design` | **Antagonistic Design Critic** | Grades against `feature-spec-standard.md`. Probes concurrency hazards, SPOFs, bounded-context leaks, error recovery, state mutations, and scale bottlenecks. |
| `egm-structural` | **Structural Validator** | Verifies document layout, markdown heading hierarchy, required spec sections, and table completeness. |
| `egm-style` | **Technical Copy Editor** | Strips conversational filler, hedging language ("maybe", "probably", "we could"), and vague prose, enforcing crisp, objective engineering specifications. |
| `egm-implementation-readiness` | **Pragmatic Tech Lead** | Grades against `implementation-readiness-standard.md`. Rejects hand-wavy steps, parked open questions, or missing verification commands. Enforces the **Zero-Decision Rule**. |
| `egm-codebase-details` | **Live Codebase Auditor** | Grades against `re-implementation-standard.md`. Cross-checks every file path, class/function name, type signature, and import in the spec against the live repository to catch hallucinated APIs before coding starts. |

---

## 5. Multi-Stage Verification Pipeline (`/egm-review`)

When `/egm-review` runs on `docs/designs/<feature>.md`, it executes five sequential gates after intake:

1. **Stage 1 (Step 5) — Initial Zoom-Out Review (`egm-zoom-out`)**:
   - Checks `heilmeier-standard` and `zoom-out-standard`. Rejects overengineered plans before wasting tokens polishing details.
2. **Stage 2 (Step 6) — Comprehension Test (`egm-comprehension`)**:
   - Verifies the document is 100% self-contained for a zero-context reader and aligned with `GLOSSARY.md` / `CONTEXT.md`.
3. **Stage 3 (Step 7) — Adversarial Critic Swarm (`egm-design`, `egm-structural`, `egm-style`)**:
   - Parallel stress-test of architecture, failure modes, structural completeness, and technical clarity.
4. **Stage 4 (Step 8) — Intermediate Zoom-Out Review (`egm-zoom-out`)**:
   - Second altitude pass to prune defensive bloat or speculative complexity accidentally introduced while addressing Stage 3 critiques.
5. **Stage 5 (Step 9) — Implementation Readiness Audit (`egm-implementation-readiness`, `egm-codebase-details`)**:
   - Final pre-code gate verifying exact file paths, live API signatures, test seams, and the **Zero-Decision Rule**.

---

## 6. Canonical EGM Rules

| Rule ID | Severity | Flag When |
| :--- | :--- | :--- |
| `elephant-premature-coding` | **high** | The deep-context planning session ("Elephant") begins writing production code before the design spec in `docs/designs/` is drafted and reviewed. |
| `goldfish-context-contamination` | **high** | Reviewer subagents ("Goldfish") are passed the full brainstorming chat transcript instead of receiving only the isolated spec document and target source files. |
| `missing-heilmeier-clarity` | **high** | A design spec or `concepts_brief.md` fails to state the concrete problem, core hypothesis, measurable value proposition, or out-of-scope boundaries (`heilmeier-standard`). |
| `zoom-out-yagni-breach` | **high** | Spec proposes new infrastructure, custom frameworks, or speculative abstractions when existing codebase modules or standard library features suffice (`zoom-out-standard`). |
| `unverified-comprehension-gap` | medium | Design spec relies on conversational context, undefined domain terms, or implicit assumptions that a zero-context reader (`egm-comprehension`) cannot understand. |
| `unresolved-spec-blocker` | **high** | Implementation proceeds while `BLOCKER` or `MAJOR` findings from `/egm-review` remain unresolved or parked as "TODOs" in the spec. |
| `zero-decision-readiness-failure` | **high** | Spec lacks exact target file paths, verified API signatures, or concrete per-step test plans, forcing the implementer agent to guess (`implementation-readiness-standard`). |
| `unbootstrapped-legacy-context` | medium | Elephant attempts architectural planning on an undocumented legacy codebase without running `/egm-bootstrap` or mapping directory-level contracts. |
| `unmonitored-spec-code-drift` | **high** | Post-implementation code diverges from `docs/designs/<feature>.md` (altered signatures, skipped edge cases, undocumented shortcuts) without running `/egm-drift-report` and syncing. |
| `unbounded-review-fanout` | medium | Multi-lens Goldfish reviews are dumped raw into the main session context instead of using `egm-synthesizer` (Hierarchical Dispatch) to deduplicate and summarize findings. |

---

## 7. EGM Review & Triage Output Format

When reporting findings from `/egm-review`, `/egm-review-loop`, or `/egm-drift-report`, use this exact structure:

```markdown
## EGM Specification & Architecture Audit

**Target Document**: `docs/designs/<feature>.md`
**Pipeline Stage**: [Zoom-Out | Comprehension | Critic Swarm | Readiness | Drift Report]
**Dispatch Mode**: [Hierarchical via `egm-synthesizer` | Direct Goldfish Swarm]
**Findings Summary**: Total: N (Blockers: N, Major: N, Nits: N)
**Readiness Verdict**: [READY FOR IMPLEMENTATION | BLOCKED — RUN /egm-resolve]

---

### 🚨 Blockers (Must resolve before implementation)

#### [B-1] <Short Title>
- **Lens / Standard**: `egm-design` / `feature-spec-standard`
- **Rule**: `<rule-id>`
- **Location**: `<spec-file>:<section-or-line>` (Code ref: `<source-file>:<line>`)
- **Problem**: <Specific ambiguity, architectural flaw, or hallucinated API>
- **Why It Matters**: <What breaks or what the implementer agent would have to guess>
- **Proposed Resolution**: <Concrete spec amendment or architectural choice>

---

### ⚠️ Major Issues (Significant edge cases, YAGNI bloat, or codebase mismatch)

#### [M-1] <Short Title>
- **Lens / Standard**: `egm-zoom-out` / `zoom-out-standard`
- **Rule**: `<rule-id>`
- **Location**: `<spec-file>:<section-or-line>`
- **Problem**: <Description>
- **Proposed Resolution**: <Concrete action>

---

### 💡 Nits (Style, structural hierarchy, or wording polish)

- **[N-1]** (`<spec-file>:<line>`, `egm-style`): <One-sentence fix>
```

_If all stages pass with zero Blockers or Major issues:_
`EGM Verification Complete: Specification satisfies Zero-Decision Implementation Readiness.`
