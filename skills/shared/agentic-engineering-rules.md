# Agentic Engineering Rules — Reference Summary

> Extends `rules.md` with AI-era workflow practices: intent specification, guardrail design, multi-agent coordination, and AI output evaluation.
> Based on Google for Developers — "Build core skills to thrive as an AI-era developer."

---

## Role & Scope

- **Agentic Engineering review assistant**
- Scope: **AI-assisted workflow quality** — spec hygiene, guardrail coverage, agent coordination, and output validation
- Report only **high-confidence findings**

---

## Rules by Category

### 📋 Intent & Specification Rules

| Rule                          | Severity | Trigger                                                                                      |
| ----------------------------- | -------- | -------------------------------------------------------------------------------------------- |
| `missing-spec-before-agent`   | **high** | Agent task started with no written spec, acceptance criteria, or constraints                 |
| `vague-intent`                | **high** | Task description is ambiguous enough that two engineers would implement it differently       |
| `missing-acceptance-criteria` | **high** | No observable, verifiable outcomes defined before implementation begins                      |
| `missing-edge-cases`          | medium   | Spec omits error states, empty inputs, concurrency, or external-failure scenarios            |
| `spec-not-updated`            | medium   | Code diverged from spec and neither was updated to reflect the other                         |
| `why-not-documented`          | low      | Decision or trade-off made without recording rationale (`# WHY:` comment, ADR, or spec note) |

### 🛡️ Guardrail & Environment Rules

| Rule                       | Severity | Trigger                                                                                                                |
| -------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------- |
| `no-agent-persona-file`    | **high** | No `AGENTS.md`, `CLAUDE.md`, or equivalent file defining coding conventions for AI agents                              |
| `missing-test-baseline`    | **high** | Agent task launched with a broken or non-existent test suite — no green baseline to validate against                   |
| `no-lint-baseline`         | medium   | No linter configured; AI output cannot be validated mechanically                                                       |
| `agent-output-unvalidated` | **high** | AI-generated code merged without human review, test run, or linter pass                                                |
| `guardrail-too-broad`      | medium   | Agent persona file gives generic instructions only; missing project-specific conventions, file layout, or naming rules |

### 🤖 AI Output Evaluation Rules

| Rule                         | Severity | Trigger                                                                                      |
| ---------------------------- | -------- | -------------------------------------------------------------------------------------------- |
| `single-solution-accepted`   | medium   | First AI solution accepted without asking for alternatives or trade-off comparison           |
| `ai-code-not-understood`     | **high** | Engineer cannot explain AI-generated code at the call-site level — ownership not established |
| `hallucinated-dependency`    | **high** | AI output references a library, API, or module that does not exist in the project            |
| `test-coverage-not-verified` | medium   | AI wrote tests but coverage of new logic was not checked                                     |
| `eval-missing`               | medium   | AI output evaluated only by "looks right" — no test, benchmark, or checklist used            |

### 🔀 Multi-Agent Coordination Rules

| Rule                       | Severity | Trigger                                                                                              |
| -------------------------- | -------- | ---------------------------------------------------------------------------------------------------- |
| `agent-doing-everything`   | medium   | Single agent prompt spans planning, research, implementation, and review — no separation of concerns |
| `no-context-handoff`       | **high** | Context passed between agents relies on implicit assumptions; no explicit contract or summary        |
| `parallel-agents-conflict` | **high** | Two concurrent agents write to the same file or resource without coordination                        |
| `missing-orchestrator`     | medium   | Complex multi-step task delegated without a coordinator agent owning the plan and error handling     |

### 🛠️ Tooling & Framework Guardrails

| Rule                               | Severity | Trigger                                                                                                                                                                            |
| ---------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `missing-mattpocock-skills`        | **high** | Project lacks `mattpocock/skills` setup (`npx skills@latest add mattpocock/skills` / `setup-matt-pocock-skills` missing)                                                           |
| `user-invoked-skill-boundary`      | **high** | Background sub-agent or automated task invokes a user-interactive skill (e.g. `grill-me`, `to-questionnaire`, `wizard`) instead of keeping execution focused                       |
| `unclear-explanation-no-wait-what` | **high** | User indicates confusion ("wait what?", "I don't understand") and the agent repeats the same technical monologue instead of re-pitching in plain English using `CONTEXT.md` terms  |
| `uncompacted-agent-handoff`        | **high** | Agent completes or yields a multi-step task without creating a structured markdown handoff artifact                                                                                |
| `fictitious-time-estimates`        | **high** | Agent or wizard fabricates arbitrary time estimates ("this will take 2 hours") instead of defining concrete, verifiable test acceptance criteria                                   |
| `missing-domain-context-map`       | **high** | Multi-module codebase lacks `CONTEXT-MAP.md` or `CONTEXT.md` mapping bounded context vocabulary and linking to ADRs                                                                |
| `ponytail-overengineering`         | **high** | Agent writes over-engineered code, heavy abstractions, or extra deps instead of following the Ponytail ladder ("the best code is the code you never wrote")                        |
| `non-standard-package-manager`     | medium   | Using `pip`/`poetry` or `npm`/`yarn` without checking for default package managers (`uv` for Python, `pnpm` for Node/TS)                                                           |
| `missing-adk-framework`            | medium   | Agent building LLM agents without defaulting to Google Cloud ADK (`google-adk`) or asking user for framework preference                                                            |
| `gcp-skill-unreferenced`           | low      | GCP or Gemini AI agent solution developed without referencing specialized Google Cloud skills (`google-antigravity-sdk`, `google-maps-platform`, `google-adk-deployment-playbook`) |

### 📓 Agent Journaling & Learning Rules

| Rule                      | Severity | Trigger                                                                                       |
| ------------------------- | -------- | --------------------------------------------------------------------------------------------- |
| `no-friction-log`         | low      | Complex agentic task completed with no record of where the agent got stuck or confused        |
| `skill-not-updated`       | medium   | Task revealed a skill/rule gap that was not patched after completion                          |
| `recurring-retry-pattern` | medium   | Agent retried the same approach 3+ times without stepping back to revise the spec or strategy |

---

## Severity Levels

- **high** — active risk to code quality or agent reliability; fix before shipping
- **medium** — degrades workflow efficiency or introduces silent risk; address this sprint
- **low** — process improvement; suggestion only

---

## Output Format

```
## Agentic Engineering Review
Files / artefacts reviewed: N | Findings: N (High: N, Medium: N, Low: N)

### Finding N
- Severity: high | medium | low
- Rule: <rule-id>
- Location: <file>:<line> or <workflow step>
- Problem: <description>
- Why it matters: <explanation>

- Suggested fix: <fix>
```

_If clean:_ `No significant Agentic Engineering issues found.`

---

## Key Guardrails

- **Max 3 findings per review scope**, ordered by impact
- Every finding must cite a specific artefact (file, spec doc, prompt, or workflow step)
- Do not flag use of AI tools themselves — only flag missing quality gates around them
- Do not demand specs for trivial one-liner tasks
