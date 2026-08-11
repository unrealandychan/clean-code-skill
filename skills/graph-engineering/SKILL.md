# Graph Engineering Skill

## Purpose

Guide developers in designing, auditing, and building production-grade **Knowledge Graphs** (Data Topology) and **Task Graphs** (Agent Execution Topology).

---

## When to Invoke This Skill

Trigger this skill when the developer:

- Mentions "Graph Engineering", "Knowledge Graph", "Task Graph", "LangGraph", "GraphRAG", "Neo4j", "Property Graph", "Ontology", or "Agent Topology".
- Wants to build or review a Knowledge Graph pipeline (`/kg-scope`, `/kg-ontology`, `/kg-extract`, `/kg-rag`).
- Asks for interactive tutoring on graph architectures (`/kg-tutor` or `/graph-engineer`).
- Designs multi-agent execution topologies (`/task-graph-design`, `/agent-topology`, state machines, evaluator loops, fan-out/fan-in).

---

## Core Principles

### 1. Topology First

- **Prompt Engineers** steer model words.

- **Loop Engineers** steer iterations.
- **Graph Engineers** steer topology — the directed flow of knowledge and task execution.

### 2. Dual-Engine Architecture

- **Knowledge Graphs (What agents know & remember)**: Structured entity-relation-event network with strict ontologies, entity resolution, and temporal provenance.
- **Task Graphs (How agents work & execute)**: Typed state machine DAGs with deterministic routing, parallel isolation, checkpointing, and human-in-the-loop gates.

---

## Interactive Commands & Shortcuts

| Command              | Action                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------- |
| `/kg-tutor`          | Walk through Knowledge Graph & Task Graph architecture stage-by-stage with ASCII/Mermaid diagrams |
| `/kg-scope`          | Stage 1: Define domain boundaries, use cases, and competency questions                            |
| `/kg-ontology`       | Stages 2–3: Define entity types, relation types, properties, and constraint rules                 |
| `/kg-extract`        | Stages 4–6: Extract entities, relations, and events with quality validation gates                 |
| `/kg-fusion`         | Stages 7–8: Apply entity resolution, deduplication, and cross-source linkage                      |
| `/kg-rag`            | Stage 9: Design GraphRAG hybrid retrieval (vector seeds + sub-graph traversal)                    |
| `/task-graph-design` | Design typed LangGraph state machine, evaluator loops, or fan-out topologies                      |
| `/agent-topology`    | Audit existing agent workflows against Graph Engineering rules                                    |

---

## Rule Enforcement Summary

Full canonical rules: `skills/shared/graph-engineering-rules.md`

### Knowledge Graph Checkpoints

1. **Ontology Guardrail**: Never allow LLMs to extract unstructured entities without a schema (`unbounded-ontology-explosion`).
2. **Entity Resolution**: Always deduplicate mentions before inserting into the graph (`missing-entity-resolution`).
3. **Provenance**: Attach source document, extraction timestamp, and confidence to every triple (`missing-temporal-provenance`).
4. **GraphRAG Sub-graph Pruning**: Combine vector seed retrieval with $k$-hop sub-graph expansion (`unoptimized-graphrag-traversal`).

### Task Graph Checkpoints

1. **Typed State**: Use `TypedDict` or `Pydantic` for state schema (`untyped-graph-state`).
2. **Deterministic Control**: Use code logic for business rules/safety gates, LLM for semantic intent (`non-deterministic-control-flow`).
3. **Parallel Isolation**: Ensure parallel branches use channels or immutable state (`unisolated-parallel-fanout`).
4. **HITL Safety**: Place interrupts _before_ non-idempotent side effects execute (`un-idempotent-hitl-interrupt`).
5. **Recursion Guard**: Bound all cycles with `max_iterations` limits (`unbounded-agent-cycle`).

---

## Reference Guides

- Knowledge Graph Pipeline: `skills/graph-engineering/references/01-knowledge-graph-pipeline.md`
- Task Graph & Agent Topology: `skills/graph-engineering/references/02-task-graph-agent-topology.md`
- Workflows & Prompts: `skills/graph-engineering/WORKFLOWS.md`
