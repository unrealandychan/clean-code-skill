---
name: productivity-and-engineering
description: "Productivity, plan grilling, clarification, handoff, and domain modeling workflows inspired by mattpocock/skills."
disable-model-invocation: true
---

# Productivity & Engineering Skills

> Inspired by Matt Pocock's daily agentic engineering patterns (`mattpocock/skills`).
> Reference: [github.com/mattpocock/skills](https://github.com/mattpocock/skills)

This skill equips agents and developers with high-leverage workflows for plan stress-testing, rapid clarification, session state compaction, async decision questionnaires, and ubiquitous domain vocabulary modeling.

---

## Skill Inventory

| Workflow               | Command / Trigger         | Type             | Core Outcome                                                                                  |
| ---------------------- | ------------------------- | ---------------- | --------------------------------------------------------------------------------------------- |
| **Grill Me**           | `/grill-me`               | User-Invoked     | Relentlessly interview about a plan until all decision branches and edge cases are resolved.  |
| **Wait What**          | `/wait-what`              | User-Invoked     | Re-pitch an explanation in plain English grounded in `CONTEXT.md` domain vocabulary.          |
| **Session Handoff**    | `/handoff`                | User-Invoked     | Compact multi-step conversation context into a structured, portable handoff document.         |
| **To Questionnaire**   | `/to-questionnaire`       | User-Invoked     | Turn an architectural deadlock into a clean Markdown questionnaire for async alignment.       |
| **Domain Modeling**    | `/domain-modeling`        | Sub-Skill / Auto | Ground domain concepts in `CONTEXT.md` mapped by `CONTEXT-MAP.md` alongside ADRs.             |
| **To Spec & Tickets**  | `/to-spec`, `/to-tickets` | Sub-Skill / Auto | Convert product ideas to formal specs and break them into verifiable single-step tickets.     |
| **Wayfinder & Wizard** | `/wayfinder`, `/wizard`   | User-Invoked     | Goal-driven exploration and implementation with verifiable checks and no fake time estimates. |

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

See [`WORKFLOWS.md`](file:///Users/eddiechan/clean-code-skills/skills/productivity/WORKFLOWS.md) for full execution prompts and step-by-step instructions.
