# Code Review Workflows & Prompts

> Paste-ready prompt blocks and review workflows inspired by `addyosmani/agent-skills`.

---

## Workflow 1: `/code-review` — Full 5-Axis Review

**Trigger**: `/code-review` or "Review this code"

**Prompt Template**:

```
Act as a Senior Staff Engineer performing a 5-Axis Code Review.

Review <FILES_OR_DIFF> across the 5 axes:
1. Correctness: Spec alignment, edge cases, error handling, race conditions.
2. Readability: Naming, function size, guard clauses, clarity.
3. Architecture: Coupling, bounded context integrity, Ponytail anti-overengineering ladder.
4. Security: Input validation, secret leakage, OWASP top 10 risks.
5. Performance: N+1 queries, memory leaks, unneeded allocations.

Benchmark: Approve if the change definitely improves code health overall.
Output the full 5-Axis Review Report format from skills/shared/code-review-quality-rules.md.
```

---

## Workflow 2: `/review-diff` — Pull Request / Git Diff Review

**Trigger**: `/review-diff` or "Review my git diff"

**Prompt Template**:

```
Act as a PR Code Reviewer.

1. Run `git diff` or inspect provided diff against main branch.
2. Identify changes made and verify traceability to user request.
3. Evaluate across the 5 quality axes.
4. Highlight High/Medium findings with concrete refactoring diffs.
5. Output recommendation: [APPROVE | REQUEST CHANGES].
```

---

## Workflow 3: `/review-security` — Security & Hardening Audit

**Trigger**: `/review-security` or "Audit code security"

**Prompt Template**:

```
Act as an Application Security Auditor.

Perform a security scan on <TARGET>:
1. Check for raw input injection (SQL, Shell, XSS).
2. Check for hardcoded credentials, API keys, or JWT secrets.
3. Verify authorization & least-privilege checks on endpoints.
4. Check for insecure cryptographic primitives or weak CORS settings.
5. Provide high-confidence findings with security remediation code blocks.
```

---

## Workflow 4: `/review-perf` — Performance & Resource Audit

**Trigger**: `/review-perf` or "Audit performance and memory leaks"

**Prompt Template**:

```
Act as a Performance Engineer.

Audit <TARGET> for performance bottlenecks:
1. Check for N+1 queries or HTTP call loops.
2. Search for memory leak hazards (uncleaned event listeners, timers, subscriptions).
3. Check for unbounded stream/file reads into memory.
4. Verify memoization/caching on heavy re-computations.
5. Output concrete optimizations with performance impact explanations.
```
