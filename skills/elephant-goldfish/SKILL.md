---
name: elephant-goldfish-model
description: "Google's Elephant-Goldfish Model (EGM) for Spec-Driven AI Development. Separates deep-context brainstorming and spec drafting (The Elephant, with a strict No-Code Policy) from stateless, zero-context multi-agent verification critics (The Goldfish). Includes the 5-stage verification pipeline, 5 document standards, and 7 workflows (/egm-brainstorm, /egm-draft, /egm-review, /egm-review-loop, /egm-resolve, /egm-bootstrap, /egm-drift-report)."
---

# Elephant-Goldfish Model (EGM) Spec-Driven Module

This module integrates Google's **Elephant-Goldfish Model** (`google/elephant-goldfish-model`, Apache 2.0) into the Clean Code, DDD, and Agentic Harness Engineering ecosystem. It eliminates single-session conversational sycophancy and AI specification drift by enforcing a hard architectural boundary between **Deep Context (The Elephant)** and **Zero Context (The Goldfish)**.

---

## Plugin Installation (Recommended Companion)

Install the official Google EGM plugin alongside this skill for native slash commands and subagent personas:

- **Google Antigravity (`agy`)**:
  ```bash
  agy plugin install https://github.com/google/elephant-goldfish-model
  ```
- **Claude Code (`claude`)**:
  ```bash
  claude plugin marketplace add google/elephant-goldfish-model
  claude plugin install egm@egm
  ```
- **Codex CLI (`codex`)**:
  ```bash
  codex plugin marketplace add google/elephant-goldfish-model
  codex plugin add egm@egm
  ```

---

## Core Architecture: The Memory Split

| Role | Memory Horizon | Responsibilities | Hard Guardrails |
| :--- | :--- | :--- | :--- |
| **The Elephant** | **Deep Context** (Full conversation history, architectural nuances, domain trade-offs) | Executes `/egm-brainstorm`, `/egm-draft`, and `/egm-resolve`. Compiles messy exploratory conversations into structured specs (`concepts_brief.md` and `docs/designs/<feature>.md`). | **Strict No-Code Policy**: The Elephant is forbidden from writing production application code during brainstorming or drafting. |
| **The Goldfish** | **Zero Context** (Stateless subagents with **no access** to the Elephant's chat history) | Executes `/egm-review`, `/egm-review-loop`, `/egm-bootstrap`, and `/egm-drift-report`. Reads *only* the markdown spec on disk and target codebase files. | **Strict Isolation**: Goldfish critics never receive conversational justifications; if a design decision is not explicitly documented in `docs/designs/<feature>.md`, it fails review. |

---

## The 8 Goldfish Subagent Personas

1. **`egm-synthesizer` (Orchestrator)**: Manages the review loop in **Hierarchical Dispatch Mode**, batches multi-agent feedback, deduplicates overlapping complaints, and writes a consolidated review report (`Blockers`, `Major`, `Nits`).
2. **`egm-zoom-out` (High-Level Strategist)**: Evaluates YAGNI, proportional complexity, over-engineering, and alignment with existing codebase patterns (operationalizes the Ponytail Philosophy).
3. **`egm-comprehension` (Naive Reader)**: Evaluates whether an engineer or AI agent with zero conversation history can understand the spec without guessing. Enforces DDD Ubiquitous Language (`GLOSSARY.md`).
4. **`egm-design` (Architecture Critic)**: Audits interface depth (`codebase-design`), DDD bounded context boundaries (`CONTEXT-MAP.md`), failure modes, security, and concurrency.
5. **`egm-structural` (Structural & Flow Critic)**: Audits document structure, section completeness, logical ordering, and absence of contradictions against `feature-spec-standard.md`.
6. **`egm-style` (Clarity & Tone Critic)**: Enforces crisp, unambiguous technical prose. Flags vague qualifiers ("should probably", "fast", "handle appropriately").
7. **`egm-implementation-readiness` (Execution Gatekeeper)**: Applies the **Zero-Decision Rule**: verifies that every file path, function signature, data type, edge case, and test plan is explicit enough for mechanical coding.
8. **`egm-codebase-details` (Codebase Fact-Checker)**: Verifies every file path, symbol, import, and API signature cited in the spec against the live repository to prevent hallucinated references.

---

## The 5-Stage Verification Pipeline (`/egm-review`)

```
[1. Initial Zoom-Out]       -> egm-zoom-out (Ponytail Altitude Pass: YAGNI & Reuse)
         |
         v
[2. Comprehension Pass]     -> egm-comprehension (Naive Reader & DDD Glossary Check)
         |
         v
[3. Critic Swarm (Parallel)]-> egm-design + egm-structural + egm-style + egm-codebase-details
         |
         v
[4. Intermediate Zoom-Out]  -> egm-zoom-out (Prevents Critic-Induced Scope Creep)
         |
         v
[5. Implementation Readiness]-> egm-implementation-readiness (Zero-Decision Gate)
```

---

## The 5 Document Standards

1. **`heilmeier-standard.md`**: Catechism gate for `/egm-brainstorm` (What are you trying to do? How is it done today? What is new? Who cares? What are the risks, costs, and midterm/final "exams"?).
2. **`zoom-out-standard.md`**: Altitude check enforcing proportional complexity, reuse of existing abstractions, and scope pruning before and after detailed critic passes.
3. **`feature-spec-standard.md`**: Structural contract for `docs/designs/<feature>.md` (Summary, Goals/Non-Goals, System Architecture, Interfaces & Data Models, Failure Modes, Alternatives Considered, Test Strategy).
4. **`implementation-readiness-standard.md`**: The **Zero-Decision Rule** checklist required before unlocking implementation or `/gauntlet-check`.
5. **`re-implementation-standard.md`**: Parity, migration, shadow-read/dual-write, rollback, and behavioral equivalence checklist for refactors and rewrites.

---

## Quick Command & Workflow Reference

| Command | Mode | Artifact Produced / Updated | Purpose |
| :--- | :--- | :--- | :--- |
| **`/egm-brainstorm`** | Elephant + Goldfish Shootdown | `concepts_brief.md` | High-rigor interview using Heilmeier Catechism + parallel Goldfish feasibility shootdown. |
| **`/egm-draft`** | Elephant (Section-by-Section) | `docs/designs/<feature>.md` | Compiles `concepts_brief.md` into a formal design spec with explicit user sign-off per section. |
| **`/egm-review`** | Goldfish 5-Stage Pipeline | Consolidated Review Report | Runs the 5-stage stateless critic pipeline against `docs/designs/<feature>.md`. |
| **`/egm-review-loop`** | Hierarchical (`egm-synthesizer`) or Direct | Iteratively refined `docs/designs/<feature>.md` | Loops Goldfish critics and Elephant resolution until zero Blockers remain. |
| **`/egm-resolve`** | Elephant Interactive Triage | Patched `docs/designs/<feature>.md` | Walks through `Blockers`, `Major`, and `Nits` with the user and patches the spec in place. |
| **`/egm-bootstrap`** | Bottom-Up Reverse Engineering | `docs/designs/` + `README.md` (`<!-- EGM:START -->`) | Generates specs from existing undocumented codebases leaf-to-root using sentinel tags. |
| **`/egm-drift-report`** | Sequential AST / Spec Audit | Drift Report (`Aligned`, `Undocumented`, `Violated`) | Compares `docs/designs/` against live code to catch post-implementation architectural drift. |

---

## Detailed Rules & Step-by-Step Workflows

- **Canonical Rules & Violation Catalog**: See [egm-spec-driven-rules.md](../shared/egm-spec-driven-rules.md)
- **Step-by-Step Execution Prompts & Templates**: See [WORKFLOWS.md](WORKFLOWS.md)
