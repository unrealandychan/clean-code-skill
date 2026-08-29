# Uncle Bob's "Extreme Constraints" Vibe Coding Protocol — Canonical Reference

> Inspired by Robert C. Martin ("Uncle Bob"), author of _Clean Code_.
>
> _"My current strategy is to **not read any of the code written by my agents**. That's the only way I can take advantage of their productivity. What I do instead is to **surround the agents with extreme constraints**. Unit tests, gherkin tests, QA procedures, quality metrics, mutation testing, test coverage, and a plethora of others."_
> — Robert C. Martin (Uncle Bob)

---

## The Paradigm Shift: Upstream Judgment over Syntax Micromanagement

In the AI era, human token reading velocity (~250 words per minute) is hopelessly outpaced by AI token generation velocity (~50–100 tokens per second). Line-by-line manual code review becomes the single greatest bottleneck to software delivery.

However, unchecked **"vibe coding"** without guardrails breeds technical debt, hallucinated dependencies, edge-case failures, and architectural rot at machine speed.

Uncle Bob's solution resolves this paradox:

1. **Stop reading the code syntax line-by-line.**
2. **Move human judgment "one floor up"** — become a **Constraint Architect and Specifier**.
3. **Surround the AI agent with a ruthless, automated verification gauntlet.**
4. **Derive trust mathematically**: If code survives the gauntlet (executable Gherkin specs, 100% test pass, mutant slaughterhouse, CRAP metrics, architectural invariants), it is accepted. If it fails any gate, it is rejected automatically.

```
┌────────────────────────────────────────────────────────────────────────┐
│               THE "EXTREME CONSTRAINTS" HARNESS GAUNTLET               │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
  [1] Executable Specs (Gherkin: Given-When-Then Acceptance Criteria)
                                    │
  [2] Test Baseline & Suite (Unit + Integration + Regression Safety Net)
                                    │
  [3] Mutation Testing (Mutant Slaughterhouse: Stryker / Mutmut / Pitest)
                                    │
  [4] Quality & Risk Metrics (Cyclomatic Complexity ≤ 10, CRAP Score ≤ 30)
                                    │
  [5] Architectural & Invariant Fences (DDD Aggregates, Immutability, ACL)
                                    │
  [6] Zero-Tolerance Linter & Static Analysis (Ruff, ESLint, golangci)
                                    │
                    ┌───────────────▼───────────────┐
                    │  ALL CONSTRAINTS PASSED?      │
                    └───────┬───────────────┬───────┘
                       YES  │               │  NO
             ┌──────────────▼──────┐ ┌──────▼──────────────┐
             │ AUTO-ACCEPT / SHIP  │ │ AUTO-REJECT / RETRY │
             └─────────────────────┘ └─────────────────────┘
```

---

## The 6 Pillars of Extreme Constraints

### Pillar 1: Executable Specifications (Gherkin Behavior Contracts)

Every agent task MUST start with an unambiguous, executable behavioral specification written in Given-When-Then format before implementation begins.

### Pillar 2: Deterministic Test-Driven Baselines

The codebase must possess a 100% green test baseline. The agent must write tests first or accompany implementation with tests covering all branches and edge cases ($>90\%$ branch coverage).

### Pillar 3: Mutation Testing (The Mutant Slaughterhouse)

Passing tests is necessary but insufficient—tests must be proven capable of detecting defects. Mutation testing tools (Stryker for TS/JS, Mutmut for Python, Pitest for Java, GoMutating for Go) inject artificial faults (mutations) into agent-generated code. Any surviving mutant indicates a gap in test rigor. **Minimum mutation score threshold: $\ge 85\%$.**

### Pillar 4: Quality & Risk Metrics (Complexity & CRAP Bounds)

- **Cyclomatic Complexity ($M$)**: Maximum $M \le 10$ per method/function.
- **CRAP Index (Change Risk Anti-Patterns)**:
  $$\text{CRAP}(m) = \text{comp}(m)^2 \times (1 - \text{cov}(m))^3 + \text{comp}(m)$$
  A CRAP score $> 30$ represents unmaintainable, risky code and triggers an immediate rejection.

### Pillar 5: Architectural & Invariant Fences

Enforce Clean Architecture and DDD boundaries mechanically:

- Pure domain logic isolated from frameworks, databases, and network I/O.
- Value Objects must be immutable.
- External dependencies must be accessed through Anti-Corruption Layers (ACL) or repository abstractions.
- Aggregate state can only be mutated through the aggregate root.

### Pillar 6: Automated Static QA & Zero-Tolerance Linting

Linter, type checker (`mypy`, `tsc`, `golangci-lint`), and security analyzers (`bandit`, `eslint-plugin-security`) must return **zero errors and zero warnings**.

---

## Canonical Rule Definitions

| Rule ID                           | Severity | Trigger & Condition                                                                                                  |
| --------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------- |
| `unconstrained-vibe-prompt`       | **high** | AI coding task launched with raw conversational prompt lacking formal specifications or explicit constraints.        |
| `missing-gherkin-acceptance-spec` | **high** | Task implementation attempted without Given-When-Then behavioral acceptance criteria.                                |
| `missing-test-baseline`           | **high** | AI agent launched against broken, failing, or missing test suites — no green validation baseline.                    |
| `unexercised-branch-coverage`     | **high** | Agent-generated logic has $<90\%$ branch/line test coverage or skips critical error paths.                           |
| `mutant-survival-detected`        | **high** | Mutation testing reveals surviving mutants ($\ge 15\%$ failure to detect injected faults); test suite lacks rigor.   |
| `cyclomatic-complexity-breach`    | medium   | Agent generates functions with Cyclomatic Complexity $M > 10$.                                                       |
| `crap-complexity-breach`          | **high** | Agent generates code with a CRAP Index $> 30$ (high complexity + low test coverage).                                 |
| `leaky-architectural-invariant`   | **high** | Domain logic leaks into controllers/adapters, aggregates are bypassed, or mutable value objects are introduced.      |
| `unsupervised-syntax-trust`       | **high** | AI code accepted/merged without passing the full automated verification gauntlet.                                    |
| `line-by-line-micromanagement`    | medium   | Reviewer spends time debating token-level syntax instead of codifying automated constraints and upstream invariants. |

---

## Review & Audit Output Format

When auditing an AI agent workflow or evaluating generated code against Extreme Constraints:

```markdown
## Extreme Constraints & Vibe Coding Audit

**Status**: [PASSED GAUNTLET | CONSTRAINTS FAILED]
**Mutation Score**: X% (Threshold: ≥85%) | **Max CRAP Index**: X (Limit: ≤30) | **Coverage**: X% (Limit: ≥90%)

### 🛡️ Constraint Gauntlet Checklist

- [x] Executable Gherkin Specification: [Pass | Missing]
- [x] Deterministic Test Suite Baseline: [Pass | Failing]
- [x] Mutation Testing Resilience (Mutants Killed): [Pass | Mutants Survived]
- [x] Cyclomatic Complexity & CRAP Metrics: [Pass | Breached]
- [x] Architectural & Domain Invariants: [Pass | Violations Found]
- [x] Zero-Tolerance Static Analysis / Linter: [Pass | Errors Found]

### 🚨 Constraint Violations (if any)

#### Finding 1

- **Severity**: high | medium
- **Rule**: `<rule-id>`
- **Location**: `<file>:<line>` or `<workflow step>`
- **Violation**: <what constraint failed>
- **Impact**: <why this violates software craftsmanship>
- **Required Automated Gate**: <exact test, mutation check, or metric to enforce>

### ⚖️ Verdict

[AUTO-ACCEPT & SHIP | REJECT & ENFORCE CONSTRAINTS]
```

_If all constraints pass:_ `All Extreme Constraints satisfied. Code is mathematically verified for merge readiness.`
