# Code Review & Quality Protocol — Canonical Reference

> Comprehensive 5-Axis Code Review & Quality Protocol inspired by Addy Osmani's `agent-skills` (`addyosmani/agent-skills/skills/code-review-and-quality/SKILL.md`).
> Enforces rigorous senior-engineering standards across Correctness, Readability, Architecture, Security, and Performance.

---

## The Code Review Philosophy

> **Approval Benchmark**: Approve a change when it **definitely improves overall code health**, even if it isn't perfect. Perfect code doesn't exist — the goal is continuous, verifiable code health improvement.

- **High Signal, Low Noise**: Focus exclusively on high-confidence findings that impact correctness, maintainability, security, or performance. Skip linter-enforced formatting.
- **Delta Improvement**: Evaluate changes relative to the existing baseline, not against unattainable perfection.
- **Explain Why & Show Fixes**: Every finding must explain _why_ it matters and provide a concrete refactoring solution.

---

## The 5 Axes of Code Quality

```
                   ┌─────────────────────────────────────────┐
                   │    5-AXIS CODE REVIEW PROTOCOL          │
                   └────────────────────┬────────────────────┘
                                        │
      ┌─────────────────┬───────────────┼───────────────┬─────────────────┐
      │                 │               │               │                 │
┌─────▼───────┐   ┌─────▼──────┐  ┌─────▼───────┐ ┌─────▼──────┐   ┌──────▼──────┐
│ CORRECTNESS │   │ READABILITY│  │ARCHITECTURE │ │  SECURITY  │   │ PERFORMANCE │
└─────────────┘   └────────────┘  └─────────────┘ └────────────┘   └─────────────┘
```

---

### Axis 1: Correctness (Spec Alignment & Execution Integrity)

| Rule ID                   | Severity | Flag when                                                                               |
| ------------------------- | -------- | --------------------------------------------------------------------------------------- |
| `spec-mismatch`           | **high** | Code deviates from stated acceptance criteria or requirements                           |
| `unhandled-edge-case`     | **high** | Missing handling for null/undefined, empty inputs, network timeouts, or boundary values |
| `silent-error-swallowing` | **high** | Bare `catch (e) {}`, suppressed promises, or missing error context                      |
| `off-by-one-logic`        | medium   | Loop or indexing boundary condition errors                                              |
| `race-condition-risk`     | **high** | Unsynchronized shared state mutations across async/concurrent executions                |

---

### Axis 2: Readability & Maintainability

| Rule ID                 | Severity | Flag when                                                                       |
| ----------------------- | -------- | ------------------------------------------------------------------------------- |
| `vague-naming`          | medium   | Names like `data`, `info`, `tmp`, `res`, `doStuff` hide intent                  |
| `bloated-function`      | medium   | Function exceeds ~30 lines or mixes multiple levels of abstraction              |
| `comment-restates-code` | low      | Comment restates _what_ the code does instead of explaining _why_ or trade-offs |
| `deep-nesting-chain`    | medium   | Guard clauses could flatten 3+ levels of nested `if/else` or try-catch          |
| `unnamed-literals`      | low      | Magic numbers or hardcoded domain strings without named constants               |

---

### Axis 3: Architecture & Design

| Rule ID                      | Severity | Flag when                                                                                                |
| ---------------------------- | -------- | -------------------------------------------------------------------------------------------------------- |
| `bounded-context-leak`       | **high** | Module directly mutates another domain context's internal state without an Anti-Corruption Layer         |
| `overengineered-abstraction` | **high** | Single-use wrapper classes, generic factories, or speculative configurability (violates Ponytail ladder) |
| `tight-coupling`             | **high** | High-level business logic directly imports low-level database or HTTP drivers                            |
| `god-object-anti-pattern`    | **high** | A single class or module attempts to manage all business logic, validation, and persistence              |

---

### Axis 4: Security & Hardening (OWASP Guardrails)

| Rule ID                       | Severity | Flag when                                                                        |
| ----------------------------- | -------- | -------------------------------------------------------------------------------- |
| `unvalidated-input-injection` | **high** | Raw user input passed directly to SQL queries, shell commands, or HTML templates |
| `exposed-credentials-secrets` | **high** | API keys, tokens, or passwords hardcoded in source code or commit history        |
| `insecure-defaults`           | medium   | Weak encryption defaults, missing CORS origins, or permissive IAM permissions    |
| `missing-rate-limiting`       | medium   | Public endpoints exposed without rate limiting or payload size caps              |

---

### Axis 5: Performance & Resource Efficiency

| Rule ID                       | Severity | Flag when                                                                            |
| ----------------------------- | -------- | ------------------------------------------------------------------------------------ |
| `n-plus-one-query`            | **high** | Executing DB queries or HTTP requests inside loops instead of batching               |
| `memory-leak-hazard`          | **high** | Event listeners, timers, or stream subscriptions attached without cleanup            |
| `unnecessary-recomputation`   | medium   | Heavy computations or re-renders performed synchronously without memoization/caching |
| `unbounded-memory-allocation` | **high** | Reading entire large files/streams into memory at once without chunking              |

---

## Review Output Format

````markdown
## Code Review & Quality Report

Files reviewed: N | Findings: N (High: N, Medium: N, Low: N)

### 📊 Quality Axis Summary

- Correctness: [Pass | Issues Found]
- Readability: [Pass | Issues Found]
- Architecture: [Pass | Issues Found]
- Security: [Pass | Issues Found]
- Performance: [Pass | Issues Found]

### Finding 1

- Severity: high | medium | low
- Axis: Correctness | Readability | Architecture | Security | Performance
- Rule: <rule-id>
- Location: <file>:<line>
- Problem: <what is wrong>
- Why it matters: <impact on reliability, security, or maintainability>
- Suggested fix: <concrete action>
- Refactor Example:

```code

// before -> after

```
````

### Recommendation

[APPROVE WITH SUGGESTIONS | REQUEST CHANGES]

```

*If clean:* `No significant Code Review issues found across all 5 quality axes.`
```
