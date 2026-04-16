# AI Skill Guide: Clean Code Review Assistant

## Overview
This guide describes how to create an AI skill that reviews source code against Clean Code principles, combining prompt design, rule definition, workflow integration, and output formatting into a practical review assistant.[cite:1][cite:5][cite:6]
A useful Clean Code checker should focus on readability, maintainability, simplicity, consistency, and actionable feedback rather than generic criticism.[cite:1][cite:2][cite:5]

## What Clean Code Means
Clean code is code that is easy to read, understand, modify, and collaborate on, which directly improves long-term maintainability and team velocity.[cite:1][cite:2]
Common themes across Clean Code guidance include meaningful naming, small focused functions, low duplication, shallow nesting, and code that explains itself with structure more than with comments.[cite:3][cite:4][cite:11]

## Core Principles To Check
The skill should evaluate code against a concise set of rules so feedback stays consistent and easy to automate.[cite:5][cite:6]

| Principle | What to check | Why it matters |
|---|---|---|
| Meaningful names | Variables, functions, classes, and files clearly express purpose | Clear names improve readability and reduce misunderstanding.[cite:1][cite:4] |
| Single responsibility | Functions and classes do one job only | Small focused units are easier to test and maintain.[cite:3][cite:5] |
| DRY | Repeated logic, repeated literals, and repeated branching | Duplication spreads bugs and increases maintenance cost.[cite:4][cite:5] |
| Simplicity | Overly clever logic, unnecessary abstractions, deep conditionals | Simple code is easier to change safely.[cite:5][cite:11] |
| Low nesting | Excessive indentation and complex control flow | Flatter logic lowers cognitive load.[cite:4][cite:11] |
| Comments quality | Comments explain intent, trade-offs, or constraints, not obvious code | Self-explanatory code reduces noisy comments.[cite:3][cite:4] |
| Function arguments | Too many parameters or unrelated parameters | Narrow interfaces are easier to use correctly.[cite:4] |
| Constants over magic numbers | Unnamed numeric or string literals with business meaning | Named constants preserve intent.[cite:4] |
| Error handling | Generic exceptions, silent failures, missing context | Clear error handling improves reliability and debugging.[cite:2][cite:12] |
| Consistency | Naming, formatting, patterns, and file organization | Predictable structure helps teams review and extend code.[cite:1][cite:5][cite:6] |

## Recommended Skill Scope
The best version of this skill should not try to judge everything at once.[cite:6][cite:9]
It should focus on changed files or pull request diffs first, because differential analysis reduces noise and keeps reviewer attention on newly introduced issues.[cite:9]

A practical scope is:
- Review only modified files or hunks by default.[cite:9]
- Flag only high-confidence Clean Code issues, not stylistic preferences with weak justification.[cite:6][cite:12]
- Return concrete rewrite suggestions when possible.[cite:5][cite:7]
- Separate maintainability findings from security or performance findings unless explicitly asked to include them.[cite:10]

## Skill Architecture
A Clean Code review skill works best as a layered system rather than a single prompt.[cite:6][cite:7][cite:10]

### Input Layer
The skill should accept:
- Source diff, file, or directory
- Programming language
- Framework or project context
- Optional team conventions
- Optional severity threshold

### Analysis Layer
The skill should perform checks in this order:
1. Detect language and structural context.[cite:10]
2. Evaluate naming, function size, nesting, duplication, comments, and error handling.[cite:3][cite:4][cite:11]
3. Suppress trivial or low-signal observations.[cite:6][cite:12]
4. Prioritize findings by maintainability impact and refactor effort.[cite:6][cite:9]

### Output Layer
The skill should return a structured report with:
- Summary
- Findings by severity
- File and line references
- Why each issue matters
- Suggested refactor
- Optional rewritten snippet

## Review Rubric
A stable rubric makes the skill predictable across languages and repositories.[cite:5][cite:6]

| Category | Strong signal | Weak signal |
|---|---|---|
| Naming | Ambiguous names like `data`, `tmp`, `doStuff` | Personal preference over equivalent clear names.[cite:4][cite:5] |
| Functions | Function mixes validation, transformation, persistence, and logging | Function is slightly long but still coherent.[cite:3][cite:4] |
| Branching | Nested `if/else` chains that hide the happy path | One extra guard that does not hurt readability.[cite:4][cite:11] |
| Duplication | Repeated business logic across files | Repeated trivial glue code with no practical abstraction.[cite:5] |
| Comments | Comments restate code line by line | Brief obvious comments with low maintenance cost.[cite:3][cite:4] |
| Parameters | 5+ mixed-purpose parameters | 3 parameters that are tightly related.[cite:4] |
| Constants | Repeated unexplained literals in business rules | One-off literal that is already self-evident.[cite:4] |

## Prompt Design
The prompt should be explicit, narrow, and output-constrained so the model behaves like a reviewer instead of a lecturer.[cite:7][cite:10]
GitHub guidance on instruction files emphasizes preserving intent, removing vague directives, organizing rules with headings, and adding concrete examples where needed.[cite:7]

A strong system prompt can look like this:

```md
You are a Clean Code review assistant.
Review only for maintainability and readability.
Do not comment on formatting already enforced by linters unless it affects clarity.
Prefer high-confidence findings only.
For each finding, return:
- severity: low | medium | high
- rule: short rule name
- file
- line
- problem
- why_it_matters
- suggested_fix
- optional_refactor_example
If no meaningful Clean Code issue exists, say: "No significant Clean Code issues found."
```

## Rule Set Template
Store rules in a markdown or YAML file so they are easy to update as team standards evolve.[cite:6][cite:7]
Static analysis best practices recommend regularly reviewing and tuning rule sets instead of treating configuration as fixed forever.[cite:6]

Example rule set:

```yaml
rules:
  - id: meaningful-names
    description: Names must reveal intent and avoid vague placeholders
    severity: medium
  - id: single-responsibility
    description: Functions and classes should have one clear responsibility
    severity: high
  - id: avoid-deep-nesting
    description: Prefer guard clauses and early returns over nested conditionals
    severity: medium
  - id: avoid-magic-numbers
    description: Business-important literals should be named constants
    severity: low
  - id: comment-why-not-what
    description: Comments should explain intent, rationale, or trade-offs
    severity: low
  - id: minimize-duplication
    description: Avoid repeated business logic across functions or files
    severity: high
```

## Suggested Output Format
Structured output makes the skill easier to integrate into CI, PR comments, or editor extensions.[cite:6][cite:10][cite:12]
Markdown is usually the most readable default, while JSON is useful for machine consumption.[cite:10]

Example markdown output:

```md
## Clean Code Review Summary
- Files reviewed: 3
- Findings: 4
- High: 1, Medium: 2, Low: 1

### Finding 1
- Severity: High
- Rule: single-responsibility
- File: src/order_service.py:87
- Problem: `process_order` validates input, calculates totals, persists data, and sends notifications.
- Why it matters: Mixing responsibilities makes testing and change impact harder.
- Suggested fix: Split validation, pricing, persistence, and notification into separate functions.
```

Example JSON output:

```json
{
  "summary": {
    "files_reviewed": 3,
    "findings": 4,
    "high": 1,
    "medium": 2,
    "low": 1
  },
  "findings": [
    {
      "severity": "high",
      "rule": "single-responsibility",
      "file": "src/order_service.py",
      "line": 87,
      "problem": "Function mixes validation, pricing, persistence, and notification.",
      "why_it_matters": "Harder to test and maintain.",
      "suggested_fix": "Split into smaller functions."
    }
  ]
}
```

## Workflow Integration
Static analysis guidance consistently recommends integrating checks into CI/CD, configuring rules clearly, and updating them over time to reduce false positives and developer frustration.[cite:6][cite:12]
The Clean Code skill should therefore run in several places, with different strictness levels per stage.[cite:6][cite:9]

Recommended workflow:
1. IDE or pre-commit: quick local check for obvious readability issues.[cite:12]
2. Pull request: differential review on changed code only.[cite:9]
3. CI pipeline: full repository scan on main branches or nightly jobs.[cite:6][cite:15]
4. Rule tuning review: regular calibration to remove noisy findings and add project-specific rules.[cite:6][cite:12]

## Combining AI With Static Analysis
AI review is strongest when paired with deterministic linters and static analyzers instead of replacing them.[cite:6][cite:9][cite:12]
Static tools catch syntax, style, and well-defined anti-patterns reliably, while AI is more useful for judging naming clarity, responsibility boundaries, comment quality, and refactoring suggestions.[cite:6][cite:12]

A recommended split is:
- Linters/formatters: style, formatting, imports, syntax
- Static analyzers: dead code, complexity, code smells, unsafe patterns
- AI Clean Code skill: readability, maintainability, naming, design cohesion, refactor advice

## Guardrails
Without guardrails, an AI review skill can become noisy, subjective, or inconsistent.[cite:6][cite:7][cite:12]
The skill should therefore include explicit limits.

Guardrails to add:
- Do not report formatting issues already enforced by tools.
- Do not demand refactors when business constraints or framework conventions justify the current design.
- Avoid speculative criticism without a concrete code example.
- Prefer no finding over low-confidence feedback.[cite:6][cite:12]
- Limit the number of findings per file, for example top 3 by impact.[cite:9]
- Distinguish mandatory issues from optional suggestions.

## Language-Specific Extensions
General Clean Code rules should stay language-agnostic, but the skill should allow language-specific add-ons because naming, file structure, and idioms differ across ecosystems.[cite:7][cite:10]
Instruction-file guidance recommends separating language-specific rules into targeted files when needed.[cite:7]

Examples:
- Python: prefer clear function names, small modules, explicit exceptions, avoid giant utility files.
- TypeScript: prefer precise types, avoid `any` when it hides intent, separate domain logic from UI effects.
- Go: keep functions small, favor explicit error handling, avoid package-level god objects.
- Java: avoid bloated service classes, overuse of inheritance, and methods with too many responsibilities.

## Evaluation Criteria
The skill is successful only if developers find the feedback useful enough to act on.[cite:5][cite:6]
Measure quality with a lightweight scorecard.

Suggested scorecard:
- Precision: percent of findings developers agree are valid
- Actionability: percent of findings with a clear next step
- Noise rate: percent marked as false positive or not useful
- Coverage: percent of meaningful Clean Code issues caught in reviewed samples
- Adoption: percent of pull requests where reviewers keep the assistant enabled

## Starter Skill File
Below is a practical markdown-based skill definition you can adapt for an AI agent platform.

```md
# Skill: clean-code-review

## Purpose
Review changed code for Clean Code problems that hurt readability and maintainability.

## Review focus
- Meaningful naming
- Single responsibility
- Low duplication
- Shallow nesting
- Clear error handling
- Minimal unnecessary comments
- Named constants instead of magic literals
- Small, cohesive interfaces

## Rules
1. Report only high-confidence issues.
2. Ignore formatting already handled by linters unless it hurts readability.
3. Prefer findings on changed lines or directly impacted code.
4. Explain why each issue matters in maintenance terms.
5. Suggest a concrete refactor.
6. If no important issue exists, return no finding.

## Output format
For each finding include:
- Severity
- Rule
- File
- Line
- Problem
- Why it matters
- Suggested fix
- Optional refactor example

## Reviewer behavior
- Be concise.
- Be specific.
- Avoid subjective style debates.
- Prefer practical recommendations over theory.
```

## Implementation Plan
A strong first version can be built in five steps.[cite:6][cite:7][cite:10]

1. Define 8 to 12 Clean Code rules with examples.[cite:4][cite:5]
2. Write a strict system prompt and structured output schema.[cite:7]
3. Feed the skill diffs instead of the whole repository by default.[cite:9]
4. Integrate it into pull requests and CI with separate thresholds.[cite:6][cite:12]
5. Review false positives monthly and tune rules continuously.[cite:6]

## Practical Advice
Start narrow and optimize for signal, because developers will stop trusting the skill if it comments on every file with low-value advice.[cite:6][cite:9][cite:12]
The most effective Clean Code assistant behaves like a senior reviewer who highlights the few issues that truly affect readability and maintainability, then explains them clearly and suggests a better structure.[cite:1][cite:5][cite:10]
