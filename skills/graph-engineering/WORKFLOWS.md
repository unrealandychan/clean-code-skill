# Graph Engineering Workflows & Prompts

> Paste-ready prompt blocks and interactive workflows for Knowledge Graph construction and Task Graph agent topology design.

---

## Workflow 1: `/kg-tutor` — Interactive Graph Architecture Tutor

**Trigger**: `/kg-tutor` or "Teach me graph engineering step by step"

**Prompt Template**:

```
You are a Senior Graph Architect. Walk the user through Graph Engineering interactively.

Follow these rules:
1. Explain one stage at a time (from Scope to Serving, or Task Graph Topologies).
2. Generate a clear ASCII or Mermaid diagram illustrating the current stage.
3. Ask 1–2 targeted questions about the user's specific domain before moving to the next stage.
4. Do not dump the entire curriculum at once — keep responses focused and interactive.
```

---

## Workflow 2: `/kg-scope` — Domain Boundary & Competency Questions

**Trigger**: `/kg-scope` or "Scope my knowledge graph"

**Prompt Template**:

```
Act as a Knowledge Graph Domain Scoper.

Help me define the scope for a Knowledge Graph in my domain (<DOMAIN_NAME>):
1. Identify 5 Core Competency Questions (questions the graph MUST be able to answer).
2. Define In-Scope vs. Out-of-Scope entity boundaries.
3. List primary data sources (unstructured text, SQL DBs, APIs).
4. Output a clean Scope Specification Table.
```

---

## Workflow 3: `/kg-ontology` — Schema & Constraint Design

**Trigger**: `/kg-ontology` or "Design ontology for my domain"

**Prompt Template**:

```
Act as an Ontology Engineer.

Based on the scope for <DOMAIN_NAME>, generate a strict domain ontology:
1. Entity Types (Label, Description, Required Attributes, Primary Keys).
2. Relation Types (Source Label -> RELATION_NAME -> Target Label, Directionality, Cardinality).
3. Constraints (Unique ID rules, Required fields, Disjoint entity classes).
4. Provide the ontology as both a Markdown table AND a Pydantic / Cypher schema definition.
```

---

## Workflow 4: `/kg-extract` — Structured Extraction with Quality Gates

**Trigger**: `/kg-extract` or "Extract triples from text"

**Prompt Template**:

```
Act as a Knowledge Graph Extraction Pipeline with Quality Gates.

Using the provided ontology schema, extract entities, relations, and events from <TEXT_INPUT>:
1. Strict Adherence: Extract ONLY entity and relation types defined in the ontology.
2. Disambiguation: Assign normalized IDs to extracted entities.
3. Provenance: Include `source_chunk_id`, `timestamp`, and `confidence_score` (0.0–1.0) for each triple.
4. Quality Gate: Filter out any extractions with confidence < 0.70 or schema violations.
5. Format: Output formatted JSON / JSON-L nodes and edges ready for graph DB insertion.
```

---

## Workflow 5: `/kg-fusion` — Entity Resolution & Deduplication

**Trigger**: `/kg-fusion` or "Deduplicate graph nodes"

**Prompt Template**:

```
Act as an Entity Resolution & Graph Fusion Engine.

Given the raw extracted entities <ENTITIES_LIST>:
1. Perform exact and fuzzy matching on entity labels, aliases, and attributes.
2. Group duplicate nodes representing the same real-world entity.
3. Create `SAME_AS` edges or merge duplicate nodes into a canonical node.
4. Preserve provenance history from all source mentions in the canonical node attributes.
5. Output the merged node dictionary and link mapping.
```

---

## Workflow 6: `/kg-rag` — Hybrid Retrieval-Augmented Generation

**Trigger**: `/kg-rag` or "Design GraphRAG query layer"

**Prompt Template**:

```
Act as a GraphRAG Retrieval Architect.

Design a GraphRAG query pipeline for query <USER_QUERY>:
1. Vector Seed Search: Find initial entry nodes using semantic vector embedding search.
2. Sub-graph Expansion: Traversal algorithm (1-hop or 2-hop neighborhood expansion with edge-weight filtering).
3. Cypher / SPARQL Query: Write the exact Cypher traversal query to fetch the structured sub-graph.
4. Context Pruning: Format sub-graph triples into a clean markdown context block for the LLM, eliminating duplicate/irrelevant edges.
```

---

## Workflow 7: `/task-graph-design` — LangGraph State Machine Architecture

**Trigger**: `/task-graph-design` or "Design agent state graph"

**Prompt Template**:

```
Act as an Agent Topology Architect.

Design a typed Task Graph (e.g. LangGraph) for the task <TASK_DESCRIPTION>:
1. State Schema: Define a explicit `TypedDict` / `Pydantic` state model with explicit keys.
2. Nodes: List all worker, evaluator, and tool execution nodes.
3. Edges & Routing: Define deterministic conditional edges (`if/else` checks) vs. LLM router edges.
4. Topologies: Incorporate Evaluator-Optimizer loop or Parallel Fan-Out/Fan-In where applicable.
5. Safety: Add Human-in-the-Loop (HITL) interrupt gates before side-effects and max iteration limits on cycles.
6. Provide a complete, runnable LangGraph code skeleton in Python.
```

---

## Workflow 8: `/agent-topology` — Graph Engineering Audit

**Trigger**: `/agent-topology` or "Audit my agent workflow graph"

**Prompt Template**:

```
Act as a Graph Engineering Auditor.

Review the provided code/architecture against the Graph Engineering Rules (skills/shared/graph-engineering-rules.md):
1. Knowledge Graph Audit: Check for ontology explosion, missing entity resolution, lack of provenance, or context rot.
2. Task Graph Audit: Check for untyped state, non-deterministic routing for safety logic, unisolated parallel state mutation, un-idempotent HITL placement, or unbounded cycles.
3. Produce a structured audit report with Findings (Severity, Rule ID, Location, Problem, Fix).
```
