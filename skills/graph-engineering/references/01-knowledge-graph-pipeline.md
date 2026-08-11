# Reference 01: Knowledge Graph Pipeline Engineering

> In-depth reference for building, validating, and serving enterprise Knowledge Graphs for LLM context and GraphRAG.

---

## 1. Property Graphs vs. Triple Stores (LPG vs. RDF)

When selecting a graph storage model:

| Dimension                    | Labelled Property Graph (LPG)                                                                                                       | RDF Triple Store / OWL                                   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Primary Use Case             | Enterprise GraphRAG, high-performance traversal, property-heavy nodes                                                               | Semantic web, public open data, formal logical reasoning |
| Primary Query Language       | Cypher (Neo4j, Memgraph), Gremlin                                                                                                   | SPARQL                                                   |
| Node Attributes              | Native key-value properties on nodes & edges                                                                                        | Reification or RDF\* required for edge attributes        |
| Schema Rigidity              | Schema-flexible or schema-enforced property constraints                                                                             | Strict formal ontology (OWL, SHACL, RDFS)                |
| Recommendation for AI Agents | **LPG is recommended for 90% of AI agent architectures** due to native property support and performance in Cypher GraphRAG queries. |

---

## 2. The 9-Stage Pipeline Deep-Dive

### Stage 1: Scope & Competency Questions

Before ingesting data, define **Competency Questions** — natural language questions the graph must answer.

- Example: _"Which suppliers in Bounded Context X have experienced supply chain disruptions in Q3?"_
- If a proposed node or edge doesn't help answer a competency question, exclude it.

### Stage 2: Ontology Engineering

Define a formal schema template before extraction:

```yaml
EntityTypes:
  - Label: Person
    Properties: [id, name, email]
    PrimaryKey: id
  - Label: Organization
    Properties: [id, name, domain, industry]
    PrimaryKey: id

RelationTypes:
  - Name: WORKS_FOR
    Source: Person
    Target: Organization

    Properties: [role, start_date, is_current]
```

### Stage 3: Entity Extraction & Disambiguation

When using LLMs for extraction, pass the ontology in the prompt and enforce structured outputs (`Pydantic` / JSON Schema).

- Normalize name variants during extraction (e.g. `Acme Inc.`, `ACME Corporation` $\rightarrow$ `canonical_name: ACME Corp`).

### Stage 4: Relation Extraction & Provenance

Attach metadata attributes to every extracted relation edge:

```json
{
  "source_node": "person_123",
  "relation": "WORKS_FOR",
  "target_node": "org_456",
  "properties": {
    "role": "CTO",

    "confidence": 0.95,

    "extracted_at": "2026-08-11T19:00:00Z",
    "source_doc_id": "doc_8891"
  }
}
```

### Stage 5: Event & Temporal Graphs

Facts change over time. Treat state changes as time-bound edges or event nodes:

- `(Person)-[:HELD_ROLE {start: 2020, end: 2024}]->(Role)`

- Avoid overwriting historical facts; append new temporal nodes/edges instead.

### Stage 6: Extraction Quality Gates

Run automated validation before graph DB ingestion:

- **Ontology Match**: Reject nodes/edges not in ontology schema.
- **Confidence Threshold**: Reject extractions with confidence score $< 0.70$.
- **Completeness Check**: Ensure primary keys and required attributes are present.

### Stage 7: Entity Resolution (ER) & Fusion

Deduplicate entities across datasets:

1. **Exact Match**: Match on unique identifiers (`email`, `tax_id`, `domain`).
2. **Fuzzy & Semantic Match**: Use string distance (Jaro-Winkler / Levenshtein) or vector similarity on node embeddings.
3. **Graph Fusion**: Merge duplicate nodes or link them with `SAME_AS` edges.

### Stage 8: Graph Optimization & Indexing

- Create index constraints on Primary Keys (`CREATE CONSTRAINT ON (p:Person) ASSERT p.id IS UNIQUE`).
- Index frequently filtered properties (`CREATE INDEX FOR (p:Person) ON (p.email)`).

### Stage 9: GraphRAG Serving Strategy

Combine Vector Search with Graph Traversal (Hybrid GraphRAG):

1. **Vector Retrieval**: User query $\rightarrow$ embed query $\rightarrow$ search vector index for top-$k$ seed entities.
2. **Sub-graph Traversal**: Execute Cypher query to retrieve $1$-hop or $2$-hop neighbors of seed entities.
3. **Prompt Formatting**: Format sub-graph as a structured markdown table or JSON block for the LLM context.

```cypher
// Hybrid GraphRAG Traversal Pattern (Cypher)
MATCH (seed:Entity) WHERE seed.id IN $seed_ids
MATCH (seed)-[r:RELATION]-(neighbor:Entity)
RETURN seed.name, type(r) AS relationship, neighbor.name, r.confidence
LIMIT 50
```
