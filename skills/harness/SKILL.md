---
name: harness-engineering
description: Implements Harness Engineering practices including testability, observability, progressive delivery, and AI agent guardrails. Use when designing CI/CD pipelines, configuring feature flags, setting up health checks, instrumenting telemetry, or running /harness-audit.
---

# Harness Engineering Skill

> Inspired by modern continuous delivery and autonomous agent harness architectures.

## Overview

Equips developers and AI agents with battle-tested patterns for **Testability**, **Observability**, **Progressive Delivery**, and **Agentic Engineering**, ensuring software is resilient and safe to deploy autonomously.

## When to Invoke This Skill

Use this skill when:

- Designing or reviewing CI/CD pipelines and deployment safety mechanisms.
- Setting up observability, structured logging, OpenTelemetry tracing, or metrics.
- Configuring feature flags, canary releases, or automated rollback criteria.
- Hardening AI agent environments with determinism and automated guardrails.
- Running `/harness-audit`, `/canary-setup`, or `/pipeline-review`.

## The 4 Harness Pillars

1. **Testability**: Fast, deterministic test suites, strict mutation testing baselines, and decoupled mocks. See [testability.md](testability.md).
2. **Observability**: Standardized structured JSON logging, distributed tracing, and health check endpoints (`/healthz`, `/livez`). See [observability.md](observability.md).
3. **Progressive Delivery**: Canary analysis, blue/green rollouts, feature flags, and automatic blast-radius containment. See [progressive-delivery.md](progressive-delivery.md).
4. **Agentic Engineering**: Controlled tool access, reproducible execution environments, and automated gauntlets. See [agentic-engineering.md](agentic-engineering.md).

## Quick Shortcuts

| Command             | Action                                                               |
| ------------------- | -------------------------------------------------------------------- |
| `/harness-audit`    | Audit pipeline safety, observability, and test baselines             |
| `/canary-setup`     | Configure progressive canary delivery with rollback triggers         |
| `/telemetry-check`  | Verify OpenTelemetry traces, structured metrics, and health probes   |
| `/agent-guardrails` | Set up automated execution sandboxes and safety checks for AI agents |

## References

- Testability Architecture: [skills/harness/testability.md](testability.md)
- Observability Architecture: [skills/harness/observability.md](observability.md)
- Progressive Delivery: [skills/harness/progressive-delivery.md](progressive-delivery.md)
- Agentic Engineering: [skills/harness/agentic-engineering.md](agentic-engineering.md)
- Pipeline Templates: [pipelines/](../../pipelines)
