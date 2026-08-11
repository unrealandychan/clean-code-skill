# Code Review & Quality Skill

> Inspired by Addy Osmani's `agent-skills` (`addyosmani/agent-skills/skills/code-review-and-quality/SKILL.md`).

## Purpose

Perform rigorous, multi-dimensional code reviews across **Correctness**, **Readability**, **Architecture**, **Security**, and **Performance**.

---

## When to Invoke This Skill

Trigger this skill when:

- The user requests a code review, pull request review, or quality check (`/code-review`, `/review-diff`, `/review-security`, `/review-perf`).
- Reviewing new code or refactoring changes before merging.
- Evaluating code health across the 5 axes of quality.

---

## The 5-Axis Quality Framework

1. **Correctness**: Spec/acceptance criteria alignment, edge cases, error handling, race conditions.
2. **Readability**: Clear naming, small functions, self-documenting structure, _why_-focused comments.
3. **Architecture**: Separation of concerns, bounded context boundaries, Ponytail anti-overengineering ladder.
4. **Security**: OWASP top risks, input sanitization, secret protection, least privilege.
5. **Performance**: Query batching, memory leak prevention, async efficiency, resource bounding.

>

---

## Review Benchmark

> Approve a change when it **definitely improves overall code health**, even if it isn't perfect. Perfect code doesn't exist — continuous improvement is the goal.

---

## Quick Shortcuts

| Command            | Action                                                |
| ------------------ | ----------------------------------------------------- |
| `/code-review`     | Full 5-axis code review on target files or git diff   |
| `/review-diff`     | Review git diff against HEAD / main branch            |
| `/review-security` | Focused security audit (injection, secrets, OWASP)    |
| `/review-perf`     | Focused performance & memory leak audit               |
| `/quality-gate`    | Evaluate whether code passes merge readiness criteria |

---

## Reference

- Canonical Rules: `skills/shared/code-review-quality-rules.md`
- Workflows & Prompts: `skills/code-review/WORKFLOWS.md`
