# Agentic Engineering — Workflow Guide

> Detailed practices for AI-era software engineering.
> Rule definitions live in `skills/shared/agentic-engineering-rules.md`.

---

## 1. Spec-Driven Development (Shift Left on Intent)

Write intent **before** handing off to an agent. A vague prompt produces vague code.

**Minimal spec template:**

```markdown
## Goal

One sentence: what business problem does this solve?

## Acceptance Criteria

- [ ] Observable outcome 1
- [ ] Observable outcome 2

## Constraints & Trade-offs

- Must not break X
- Prefer approach A over B because...
- Out of scope: ...

## Edge Cases

- What happens when input is empty / malformed?
- What if the external service is down?
```

**When to write a spec:**

- Task involves 3+ implementation steps
- Two engineers could reasonably disagree on the approach
- The change touches a shared interface or data contract

---

## 2. Guardrail Setup Checklist

Before delegating any non-trivial task to an agent:

- [ ] `AGENTS.md` / `CLAUDE.md` exists with project-specific conventions
- [ ] Relevant skill / rule file loaded (e.g. `@skills/shared/rules.md`)
- [ ] Test suite is **green** — you have a known-good baseline
- [ ] Linter is configured — mechanical validation is available
- [ ] Acceptance criteria are written (see spec template above)

> "The best engineers spend time designing the system environment and setting up guardrails, not just prompting." — Google for Developers

---

## 3. Anti-Vibe-Coding: AI Output Evaluation

Don't accept the first solution. Apply at least one of:

| Technique            | How                                                                     |
| -------------------- | ----------------------------------------------------------------------- |
| **Reimplementation** | Ask agent for a second approach; compare trade-offs explicitly          |
| **Walkthrough**      | Explain the AI-generated code at the call-site level — in plain English |
| **Test validation**  | Run the test suite; check coverage on new logic specifically            |
| **Linter pass**      | Confirm no new lint violations introduced                               |
| **Checklist**        | Use acceptance criteria from spec to verify each outcome                |

**Ownership rule:** If you cannot explain the AI-generated code on a whiteboard, you do not own it — it is a liability.

---

## 4. Multi-Agent Coordination

Split large tasks by responsibility:

| Role             | Responsibility                                               |
| ---------------- | ------------------------------------------------------------ |
| **Planner**      | Writes spec, decomposes into tasks, owns acceptance criteria |
| **Researcher**   | Reads codebase, docs, existing tests — builds context        |
| **Implementer**  | Writes code and tests based on spec + context                |
| **Reviewer**     | Validates against acceptance criteria, runs linter and tests |
| **Orchestrator** | Coordinates parallel workers, handles errors, owns the plan  |

**Context handoff contract** (pass between agents explicitly):

```markdown
## Handoff: <from-role> → <to-role>

### Completed

- ...

### Inputs for next step

- <file>: <what was changed / discovered>

### Open questions

- ...

### Constraints to preserve

- ...
```

---

## 5. Agent Journaling

After any complex agentic task, log friction to a journal:

```markdown
## Agent Journal — <YYYY-MM-DD> — <task-slug>

### Where I got stuck

### What context was missing from the spec

### What I had to look up mid-task (signals for missing skills)

### Recurring retry patterns (same approach attempted 3+ times)

### Skill / rule gaps found — patched? (yes/no + what changed)
```

Save to: `skills/extracted/<YYYY-MM-DD>-<slug>-journal.md`

**Use journals to:**

- Patch skills/rules that were incomplete
- Identify missing guardrails for future tasks
- Surface spec patterns that repeatedly produce ambiguity

---

## 6. T-Shaped Developer Quality Gates

Before shipping any AI-assisted feature:

**Core — AI use:**

- [ ] Evaluated AI output (not just accepted it)
- [ ] Can explain _why_ the solution works

**Vertical — engineering depth:**

- [ ] Tests cover new logic and edge cases
- [ ] A colleague can understand the code without your explanation

**Left wing — adjacent engineering:**

- [ ] Security implications checked (auth, injection, data exposure)
- [ ] No unintentional tech debt introduced

**Right wing — non-engineering:**

- [ ] Solves the actual user/business problem (not just the stated spec)
- [ ] Compliance / privacy implications considered

---

## Anti-Patterns to Flag

| Anti-pattern                               | Rule                        |
| ------------------------------------------ | --------------------------- |
| Start coding before spec is written        | `missing-spec-before-agent` |
| No `AGENTS.md` in repo                     | `no-agent-persona-file`     |
| AI code merged without review              | `agent-output-unvalidated`  |
| One prompt does planning + coding + review | `agent-doing-everything`    |
| Agent retried same approach 3+ times       | `recurring-retry-pattern`   |
| No record of friction after complex task   | `no-friction-log`           |
