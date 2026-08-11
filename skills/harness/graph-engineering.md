# Graph Engineering — Workflow Guide

> Detailed practices for Knowledge Graphs and Task Graphs.
> Rule definitions live in `skills/shared/graph-engineering-rules.md`.

---

## 1. Knowledge Graph Engineering Checklist

Before building or ingesting a Knowledge Graph:

- [ ] **Scope & Competency Questions**: Defined 3–5 competency questions the graph must answer.
- [ ] **Ontology Schema**: Defined explicit entity types, relation types, and required properties (`unbounded-ontology-explosion`).
- [ ] **Extraction Quality Gate**: Configured confidence threshold ($>0.70$) and Pydantic validation before DB ingestion (`graph-pollution-no-quality-gate`).
- [ ] **Entity Resolution**: Configured exact or fuzzy deduplication rules for merging duplicate entities (`missing-entity-resolution`).
- [ ] **Provenance & Metadata**: Attached extraction timestamp, source document ID, and confidence to every relation edge (`missing-temporal-provenance`).
- [ ] **GraphRAG Strategy**: Configured hybrid retrieval (vector seed search + 1-2 hop Cypher sub-graph traversal) with context pruning (`unoptimized-graphrag-traversal`).

---

## 2. Task Graph Engineering Checklist

Before deploying an agent state machine (LangGraph / ADK):

- [ ] **Typed State Contract**: Defined state using explicit `TypedDict` or `Pydantic` models (`untyped-graph-state`).
- [ ] **Control Flow Partition**: Used code logic for safety gates/business checks, LLM for semantic intent (`non-deterministic-control-flow`).
- [ ] **Parallel State Isolation**: Configured channels or reducers (`operator.add`) for concurrent worker branches (`unisolated-parallel-fanout`).
- [ ] **Human-in-the-Loop Safety**: Placed interrupt checkpoints _before_ non-idempotent side effects execute (`un-idempotent-hitl-interrupt`).
- [ ] **Checkpointing**: Configured short-term thread checkpointer (`MemorySaver` / DB checkpointer) (`missing-checkpoint-strategy`).
- [ ] **Evaluator Loop**: Configured verifier/evaluator node loop for complex code or artifact generation (`missing-evaluator-optimizer-loop`).
- [ ] **Recursion Bound**: Set `max_iterations` or `recursion_limit` on all feedback cycles (`unbounded-agent-cycle`).

---

## 3. Recommended Tech Stack

- **Graph Storage**: Neo4j, Memgraph, or AWS Neptune (Labelled Property Graphs).
- **Agent Framework**: LangGraph, Google Cloud ADK (`google-adk`), or LlamaIndex Property Graph Index.
- **Ontology & Schema**: Pydantic v2, JSON Schema, OWL/RDF (when required).
- **Visualization**: Mermaid.js, Cytoscape, Neo4j Bloom.
