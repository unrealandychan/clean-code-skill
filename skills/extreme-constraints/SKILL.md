---
name: extreme-constraints-and-vibe-coding
description: "Uncle Bob's Extreme Constraints framework for AI vibe coding: shifting human judgment upstream, replacing line-by-line code review with executable Gherkin specs, mutation testing, test baselines, CRAP metrics, and automated gauntlets."
version: 1.0.0
---

# Uncle Bob's "Extreme Constraints" Vibe Coding Skill

> Inspired by Robert C. Martin ("Uncle Bob"), author of _Clean Code_.
>
> _"My current strategy is to **not read any of the code written by my agents**. That's the only way I can take advantage of their productivity. What I do instead is to **surround the agents with extreme constraints**. Unit tests, gherkin tests, QA procedures, quality metrics, mutation testing, test coverage, and a plethora of others."_
> — Robert C. Martin (Uncle Bob)

---

## Purpose

Empower developers and AI agents to practice high-velocity **Vibe Coding** with zero compromise on software craftsmanship. Instead of wasting cognitive bandwidth reading machine-generated token syntax, human developers operate "one floor up" as **Constraint Architects**, surrounding AI agents with an uncompromising automated verification gauntlet.

---

## When to Invoke This Skill

Trigger this skill when:

- Starting an agentic or vibe coding task (`/extreme-constraints`, `/vibe-guard`).
- Writing executable Given-When-Then specifications prior to code generation (`/gherkin-spec`).
- Running mutation testing to audit test suite fault detection (`/mutation-audit`).
- Calculating Cyclomatic Complexity ($M \le 10$) and CRAP scores ($CRAP \le 30$) (`/crap-metric`).
- Verifying whether AI-generated code survives the full automated gauntlet before merging (`/gauntlet-check`).
- Refactoring legacy code with agent assistance while preserving zero-defect guarantees.

---

## The 6 Constraint Pillars

```
 ┌──────────────────────────────────────────────────────────────┐
 │             THE 6 EXTREME CONSTRAINT PILLARS                 │
 └──────────────────────────────┬───────────────────────────────┘
                                │
   1. Executable Specifications ── Gherkin (Given-When-Then) acceptance criteria
   2. Deterministic Test Baselines ── 100% green test suite, >90% branch coverage
   3. Mutation Testing ──────────── Mutant slaughterhouse (Stryker/Mutmut/Pitest)
   4. Complexity & CRAP Gates ───── Cyclomatic Complexity ≤ 10, CRAP index ≤ 30
   5. Architectural Invariants ──── Domain isolation, immutable VOs, Aggregate boundaries
   6. Automated Static QA ───────── Zero-tolerance linter, type checker, security scan
```

---

## Quick Command Reference

| Command                | Description                                                                                     |
| ---------------------- | ----------------------------------------------------------------------------------------------- |
| `/extreme-constraints` | Run full Uncle Bob Extreme Constraints audit on the current task or codebase                    |
| `/gherkin-spec`        | Generate or validate executable Gherkin behavioral specifications (`Given-When-Then`)           |
| `/mutation-audit`      | Execute mutation testing (Stryker, Mutmut, Pitest) and verify killed mutants score ($\ge 85\%$) |
| `/crap-metric`         | Compute Cyclomatic Complexity and CRAP score to ensure risk containment                         |
| `/vibe-guard`          | Set up the complete constraint gauntlet before unleashing AI agents on implementation           |
| `/gauntlet-check`      | Run all 6 gates sequentially; auto-accept if green, auto-reject with violations if red          |

---

## Canonical Rules & Workflows

- **Canonical Rules**: [`skills/shared/extreme-constraints-rules.md`](file:///Users/eddiechan/clean-code-skills/skills/shared/extreme-constraints-rules.md)
- **Executable Workflows & Commands**: [`skills/extreme-constraints/WORKFLOWS.md`](file:///Users/eddiechan/clean-code-skills/skills/extreme-constraints/WORKFLOWS.md)
