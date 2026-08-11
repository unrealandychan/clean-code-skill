# Graph Engineering Rules — Canonical Reference

> Extends `rules.md` with Graph Engineering best practices across **Knowledge Graphs** (Data Topology) and **Task Graphs** (Agent Execution Topology).
> Based on modern agent topology research, Knowledge Graph pipelines (Southeast University / Prof. Peng Wang), and graph-based orchestration standards (LangGraph, GraphRAG, Property Graphs).

---

## Role & Scope

- **Graph Engineering review assistant**
- Scope: **Agent topology & graph data quality** — ontology design, entity resolution, GraphRAG retrieval, typed state graphs, dynamic DAGs, evaluator loops, and human-in-the-loop safety.
- Report only **high-confidence findings**.

---

## The Core Philosophy: Topology First

Graph engineering shifts focus away from prompt or loop tuning and onto **topology**:

- **Prompt engineers** steer a model's words.
- **Loop engineers** steer its iterations.
- **Graph engineers** steer its topology — how data and execution structures flow through an AI system.

---

## Rules by Category

### 🕸️ Knowledge Graph Rules (Data Topology)

| Rule                              | Severity | Trigger / Flag when                                                                                                                                                        |
| --------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `unbounded-ontology-explosion`    | **high** | Extracting graph nodes/edges without an explicit typed ontology, schema template, or domain glossary guardrail                                                             |
| `missing-entity-resolution`       | **high** | Ingesting entity mentions from multiple sources without entity resolution (ER), fuzzy matching, or fusion rules — causing node fragmentation                               |
| `missing-temporal-provenance`     | medium   | Nodes/edges created without extraction timestamp, source document lineage, or confidence metadata                                                                          |
| `unoptimized-graphrag-traversal`  | **high** | Executing unbounded multi-hop traversals ($>3$ hops) or dumping raw graph triples into context without seed-vector hybrid filtering or sub-graph pruning                   |
| `graph-pollution-no-quality-gate` | **high** | LLM-generated entities/relations ingested directly into production graph DB without schema validation or confidence quality gates                                          |
| `lpg-rdf-mismatch`                | medium   | Storing rich key-value entity properties in pure RDF triples without LPG (Labelled Property Graph) attributes, or over-engineering simple metadata into complex ontologies |

### ⚡ Task Graph & Agent Topology Rules (Execution Topology)

| Rule                               | Severity | Trigger / Flag when                                                                                                                                    |
| ---------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `untyped-graph-state`              | **high** | Agent execution graph state passed as an untyped generic `dict` instead of strict `TypedDict` or `Pydantic` model                                      |
| `non-deterministic-control-flow`   | **high** | Using LLM routing decisions for hard business logic, safety checks, or policy gates instead of deterministic code logic (`if/else` on validated state) |
| `unisolated-parallel-fanout`       | **high** | Concurrent parallel agent branches mutating shared mutable state without thread isolation, channels, or explicit reduction logic                       |
| `un-idempotent-hitl-interrupt`     | **high** | Human-in-the-loop (HITL) interrupt gate placed _after_ non-idempotent side effects (e.g. payment, API mutation) have already executed                  |
| `missing-checkpoint-strategy`      | medium   | Multi-step agent graph running without thread-level state checkpointers for pause/rewind/resume capability                                             |
| `missing-evaluator-optimizer-loop` | medium   | Code/artifact generation node executing open-loop without a separate verifier/evaluator node for self-correction                                       |
| `unbounded-agent-cycle`            | **high** | Agent graph contains feedback or retry loops without explicit recursion limits or termination guardrails                                               |

---

## The 9-Stage Knowledge Graph Pipeline

When building or reviewing Knowledge Graph pipelines, enforce this 9-stage engineering ladder:

1. **Scope**: Define domain boundary, target use cases, and competency questions.
2. **Representation**: Select graph model (Labelled Property Graph vs. RDF/OWL).
3. **Ontology**: Define entity types, relation types, hierarchy, and constraint rules.
4. **Entities**: Extract named entities with typed attributes and disambiguation.
5. **Relations**: Extract directed, typed relationships between disambiguated entities.
6. **Events**: Capture temporal state transitions, hyper-edges, and time-bound facts.
7. **Quality Gate**: Validate extractions against ontology schema, confidence thresholds, and rule checks.
8. **Fusion**: Run entity resolution, deduplication, and record linkage across sources.
9. **Serving to LLMs**: Expose via GraphRAG (hybrid vector seed + sub-graph traversal + Cypher/SPARQL generation).

---

## Task Graph Architecture Patterns

When designing agent workflows, select from these standard execution topologies:

- **Sequential Chain**: Linear node flow for predictable multi-step transformations.
- **Fan-Out / Fan-In**: Parallel worker nodes executing sub-tasks concurrently, merged by a reducer node.
- **Evaluator-Optimizer Loop**: Generator node creates output $\rightarrow$ Evaluator node tests against schema/syntax $\rightarrow$ Route back if failed or forward if passed.
- **Orchestrator-Worker Swarm**: Central orchestrator node dynamically plans tasks, delegates to worker nodes, and synthesizes results.
- **Gatekeeper / Human-in-the-Loop**: Interrupt node pauses state machine before critical side-effects, awaiting user approval via checkpoint resume.

---

## Severity Levels

- **high** — active risk to graph integrity, state corruption, or non-deterministic agent failure; fix before shipping
- **medium** — degrades graph query performance, introduces context rot, or lacks rewind/resume capability; fix this sprint
- **low** — architectural optimization or schema enhancement suggestion

---

## Output Format

```
## Graph Engineering Review
Files / topologies reviewed: N | Findings: N (High: N, Medium: N, Low: N)

### Finding N
- Severity: high | medium | low
- Rule: <rule-id>
- Location: <file>:<line> or <graph node / pipeline stage>
- Problem: <description>
- Why it matters: <explanation of graph corruption or agent failure mode>
- Suggested fix: <concrete architectural fix>
```

_If clean:_ `No significant Graph Engineering issues found.`
