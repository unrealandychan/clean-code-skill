---
name: productivity-and-engineering
description: "Provides high-leverage productivity, plan grilling, session compaction, and domain modeling workflows. Use when stress-testing implementation plans, resolving architectural ambiguity, generating questionnaires, or invoking /grill-me, /wait-what, /handoff, /to-questionnaire, or /wizard."
disable-model-invocation: true
---

# Productivity & Engineering Skills

> Inspired by Matt Pocock's daily agentic engineering patterns (`mattpocock/skills`).
> Reference: [github.com/mattpocock/skills](https://github.com/mattpocock/skills)

This skill equips agents and developers with high-leverage workflows for plan stress-testing, rapid clarification, session state compaction, async decision questionnaires, and ubiquitous domain vocabulary modeling.

---

## Skill Inventory

| Workflow                            | Command / Trigger                    | Type             | Core Outcome                                                                                           |
| ----------------------------------- | ------------------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------ |
| **Grill Me & Grill With Docs**      | `/grill-me`, `/grill-with-docs`      | User-Invoked     | Relentlessly interview about a plan, grounded in `GLOSSARY.md` and `ADR`s, until zero ambiguity remains.|
| **Loop Me (Workflow Specs)**        | `/loop-me`                           | User-Invoked     | Specify recurring loops into `workflows/*.md` using `Trigger`, `Checkpoint`, `Push Right`, and `Brief`.|
| **Improve Codebase Architecture**   | `/improve-codebase-architecture`     | Sub-Skill / Auto | Consolidate shallow agent-generated files into Ousterhout **Deep Modules** (`codebase-design`).        |
| **Wait What**                       | `/wait-what`                         | User-Invoked     | Re-pitch an explanation in plain English grounded in `CONTEXT.md` / `GLOSSARY.md` domain vocabulary.   |
| **Session Handoff**                 | `/handoff`                           | User-Invoked     | Compact multi-step conversation context into a structured, portable handoff document.                  |
| **To Questionnaire**                | `/to-questionnaire`                  | User-Invoked     | Turn an architectural deadlock into a clean Markdown questionnaire for async alignment.                |
| **Domain Modeling**                 | `/domain-modeling`                   | Sub-Skill / Auto | Ground domain concepts in `GLOSSARY.md` / `CONTEXT.md` mapped by `CONTEXT-MAP.md` alongside ADRs.      |
| **To Spec, Tickets & TDD**          | `/to-spec`, `/to-tickets`, `/tdd`    | Sub-Skill / Auto | Convert product ideas to formal specs, verifiable single-step tickets, and Red-Green-Refactor loops.   |
| **Wayfinder, Triage & Wizard**      | `/wayfinder`, `/triage`, `/wizard`   | User-Invoked     | Goal-driven exploration, bug triage, and implementation with verifiable checks and zero time guesses.  |

---

## Architectural Principles

1. **User-Invoked vs Model-Invoked Separation**:
   - Interactive conversational skills (`grill-me`, `to-questionnaire`, `wizard`) are user-invoked (`disable-model-invocation: true`).
   - Background tasks and sub-skills must never call user-interactive skills autonomously.
   - Cross-skill calls must use explicit tool syntax: `call Skill tool with "<name>"`.

2. **Grounding in Ubiquitous Language**:
   - Technical explanations must align with `CONTEXT.md` / `CONTEXT-MAP.md` domain dictionaries.
   - Keep architectural explanations jargon-free.

3. **Verifiable Milestones over Hallucinated Time**:
   - Never generate speculative time estimates ("this will take 2 hours").
   - Define concrete automated verification commands for every single step (`Step N -> Verify: <cmd>`).

4. **Surgical Footprints & Anti-Overengineering**:
   - Enforce the Ponytail Ladder: "The best code is the code you never wrote."

---

## Detailed Prompts & Workflows

- **Canonical Rules**: [`skills/shared/mattpocock-productivity-rules.md`](../shared/mattpocock-productivity-rules.md)
- **Step-by-Step Prompts**: [`WORKFLOWS.md`](WORKFLOWS.md)
- **For Multi-Agent Spec Verification (Elephant-Goldfish Model)**: Pair `/grill-me` and `/to-spec` with [`skills/elephant-goldfish/SKILL.md`](../elephant-goldfish/SKILL.md) (`/egm-brainstorm` -> `/egm-draft` -> `/egm-review-loop`).
