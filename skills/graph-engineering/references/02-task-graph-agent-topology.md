# Reference 02: Task Graph & Agent Topology Engineering

> In-depth reference for state machine architectures, dynamic execution graphs, and safety patterns in agent systems (LangGraph / ADK).

---

## 1. Typed State Schemas

Every agent graph must treat state as an explicit contract. Never pass unstructured dictionaries between graph nodes.

```python
from typing import Annotated, Sequence, TypedDict
from langchain_core.messages import BaseMessage
import operator

class AgentState(TypedDict):
    # State keys with explicit append/reduce operators for parallel isolation
    messages: Annotated[Sequence[BaseMessage], operator.add]
    task_goal: str
    current_plan: list[str]
    verification_errors: list[str]
    is_approved: bool
    iteration_count: int
```

---

## 2. Control Flow: Deterministic vs. LLM-Based Routing

- **Deterministic Routing (Code Logic)**: Use for hard constraints, security checks, rate limits, schema validation, and human approval flags.
- **Model-Based Routing (LLM Classification)**: Reserve strictly for open-ended semantic intent routing where outcomes cannot be enumerated statically.

```python
def route_after_verification(state: AgentState) -> str:
    # Deterministic safety routing
    if state["iteration_count"] >= 3:
        return "fallback_human_node"  # prevent infinite loops
    if state["verification_errors"]:
        return "optimizer_node"      # retry with error feedback
    return "execute_tool_node"       # clean pass
```

---

## 3. Core Execution Topologies

### A. Evaluator-Optimizer Loop

A generator node drafts code/content, and an independent evaluator node tests it against syntax or validation rules before proceeding.

```
[User Goal] -> (Generator Node) -> (Evaluator Node) --[Passed]--> (Output Node)
                                        |
                                    [Failed]
                                        v
                               (Feedback & Retry)
```

### B. Parallel Fan-Out / Fan-In

Divide a task into independent sub-tasks, execute worker nodes in parallel, and aggregate results in a reducer node.

- **Isolation Rule**: Parallel branches must NOT mutate shared non-reducer keys directly. Use `Annotated[..., operator.add]` or channel queues to prevent race conditions.

```
                   /--> (Research Worker A) \
(Planner Node) ---+                          +--> (Synthesizer Reducer Node)
                   \--> (Research Worker B) /

```

### C. Human-in-the-Loop (HITL) Gatekeeper

Pause the graph execution state before performing irreversible or high-risk actions (e.g. database updates, financial transactions, email sending).

```
(Plan Node) -> (Draft Action Node) -> [INTERRUPT GATE / Checkpoint] -> (User Approves) -> (Execute Side Effect)
```

**Crucial Safety Rule**: Place the interrupt gate BEFORE the side-effect execution node, NEVER after. Ensure any node prior to the interrupt is strictly idempotent.

---

## 4. Checkpointing & Long-Term Memory Separation

Maintain a clear distinction between:

1. **Thread Checkpoints (Short-Term Execution State)**: Transient snapshots of the current task graph turn. Used for `step-back`, `pause`, `resume`, and `time-travel debugging`.
2. **Long-Term Memory Store**: Cross-thread facts, user preferences, and entity knowledge saved into a persistent Knowledge Graph or Vector DB.

```python
from langgraph.checkpoint.memory import MemorySaver

# Short-term thread checkpointer
memory = MemorySaver()
graph = workflow.compile(checkpointer=memory, interrupt_before=["execute_payment_node"])

# Invoke with thread ID
config = {"configurable": {"thread_id": "session_123"}}
graph.invoke(inputs, config)
```

---

## 5. Recursion Limits & Circuit Breakers

Prevent runaway loops by enforcing explicit recursion guardrails on all cyclic edges:

```python
# Set max iteration bound on the graph compilation or invocation
config = {
    "configurable": {"thread_id": "session_123"},
    "recursion_limit": 15  # Max node transitions before raising GraphRecursionError
}
```
