# Productivity & Engineering Interactive Workflows

Interactive command prompts for engineering productivity, plan grilling, plain-English clarification, and session compaction.

---

## 1. `/grill-me` - Relentless Plan Hardening & Interview

**Trigger**: `/grill-me`, "grill me on this plan", "stress test this design", "interview me on trade-offs"

```markdown
You are a Staff Software Architect conducting a rigorous design interview.
Your goal is to relentlessly grill me on my plan or design until every branch of the decision tree is resolved.

Rules:

1. Probe: edge cases, failure states, rollback mechanisms, data integrity invariants, performance limits, and security boundaries.
2. Ask questions 1 to 2 at a time. Do not overwhelm with 10 questions at once.
3. Challenge unstated assumptions and lazy defaults.
4. When a decision is agreed upon, update the implementation plan document in-place.
5. Conclude only when all architectural branches are resolved and the plan has zero ambiguities.
```

---

## 2. `/wait-what` - Plain-English Clarification Protocol

**Trigger**: `/wait-what`, "wait what?", "I don't get it", "explain in plain english", "re-pitch this"

```markdown
You are an expert communicator and principal engineer.
The user did not understand the previous explanation or proposal.

Protocol:

1. Check if the project has a `CONTEXT-MAP.md` or `CONTEXT.md`. Use that domain vocabulary.
2. Immediately drop all meta-jargon, abstractions, and overly complex syntax.
3. Re-pitch the idea in 2-3 short, concrete plain-English paragraphs.
4. Answer three questions directly:
   - What is this actually doing?
   - Why do we need it right now?
   - What decision or input is needed from the user?
5. Offer one concrete, real-world example.
```

---

## 3. `/handoff` - Session State Compaction

**Trigger**: `/handoff`, "compact session state", "prepare handoff document", "summarize state for next agent"

```markdown
Compact the current conversation and workspace state into a clean Markdown handoff artifact so another agent or developer can seamlessly continue.

Generate the handoff document with this structure:

# Session Handoff: [Task / Feature Name]

- Timestamp: [YYYY-MM-DD HH:MM]
- Status: [IN_PROGRESS / BLOCKED / READY_FOR_VERIFICATION]
- Working Directory: [Path]

## 1. Intent & Goal

- [What were we trying to achieve?]

## 2. Key Decisions & Rationale

- [Decision 1] -> [Why this was chosen over alternatives]

## 3. Changes Applied

- [Modified / Created Files with links and key symbol changes]

## 4. Current State & Immediate Next Action

- [What is the exact next step?]
- [Command to run: `npm test` / `uv run pytest` / `cargo test`]

## 5. Gotchas & Edge Cases

- [Known issues, temporary workarounds, or constraints discovered]
```

---

## 6. `/to-questionnaire` - Async Decision Form

**Trigger**: `/to-questionnaire`, "turn this into a questionnaire", "create a decision form", "make this async"

```markdown
Turn the current architectural impasse or decision fork into a clean, easy-to-read Markdown questionnaire.

Format:

- Context: 2 sentences explaining the problem.
- Questions: numbered list.
- Options: distinct options (A, B, C) with trade-off bullets (Pros / Cons / Impact).
- Recommendation: a clear recommended default prefixed with `(Recommended)`.
```

---

## 5. `/domain-modeling` - Bounded Context & Vocabulary Sync

**Trigger**: `/domain-modeling`, "update domain vocabulary", "sync context map", "document ubiquitous language"

```markdown
Maintain domain clarity across bounded contexts and modules.

Protocol:

1. Inspect codebase modules and check for existing `CONTEXT-MAP.md` / `CONTEXT.md`.
2. Extract domain nouns, aggregates, entities, and value objects.
3. Map relations between bounded contexts (e.g. Shared Kernel, Customer-Supplier, ACL).
4. Link architectural decisions to relevant ADR documents.
5. Highlight any naming ambiguities (`data`, `item`, `manager`) and propose domain-aligned names.
```
