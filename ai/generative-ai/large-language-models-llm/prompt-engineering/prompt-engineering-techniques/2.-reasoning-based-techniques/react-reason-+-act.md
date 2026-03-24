# ReAct (Reason + Act)

## About

ReAct (Reason + Act) is a prompting technique where the model **alternates between reasoning and taking actions** to solve a problem.

Instead of only thinking internally (like Chain-of-Thought), the model:

* Reasons about the problem
* Decides an action to take
* Uses external information or tools (if available)
* Observes the result
* Continues reasoning based on new information

Core idea:

> Combine reasoning with interaction to improve decision-making.

ReAct introduces a loop:

**Reason → Act → Observe → Repeat → Final Answer**

This makes the model behave more like an **agent**, not just a responder.

## How ReAct Works (Model Behavior Perspective)

LLMs are trained on sequences that include:

* Problem solving
* Question answering
* Tool usage patterns (search, lookup, API calls)
* Multi-step reasoning

ReAct structures this into a repeatable loop:

1. **Thought (Reasoning)**\
   Model analyzes the current situation
2. **Action**\
   Model decides what to do next (e.g., query, lookup, calculate)
3. **Observation**\
   Model receives new information (from context or tool output)
4. **Next Thought**\
   Model updates reasoning using new data

This continues until the model reaches a final answer.

Example pattern:

Thought: I need more information\
Action: Search for X\
Observation: Result Y\
Thought: Now I can conclude…\
Final Answer: Z

This structure prevents premature conclusions.

## Strengths and Ideal Use Cases

### 1. Handles Incomplete or Dynamic Information

ReAct is useful when:

* All data is not available upfront
* Information must be retrieved step by step
* Decisions depend on intermediate findings

Examples:

* Knowledge retrieval systems
* API-based workflows
* Debugging unknown errors
* Investigation tasks

### 2. Reduces Hallucination

Instead of guessing, the model:

* Actively retrieves or uses information
* Bases reasoning on observations
* Updates conclusions dynamically

This reduces reliance on internal assumptions.

### 3. Enables Tool Integration

ReAct is the foundation for:

* AI agents
* Tool-calling systems
* API integrations
* Retrieval pipelines

The “Act” step can represent:

* Database queries
* API calls
* Search operations
* Code execution

### 4. Improves Multi-Step Decision Making

For complex workflows:

* Each step depends on previous output
* Decisions must adapt dynamically

ReAct ensures:

* Continuous feedback loop
* Incremental reasoning
* Better alignment with real-world processes

## Limitations and Practical Considerations

### 1. Increased Complexity

ReAct introduces:

* Multi-step interaction
* State management
* Intermediate outputs

This makes prompts and systems more complex to design and maintain.

### 2. Higher Cost and Latency

Each cycle (Reason → Act → Observe):

* Consumes tokens
* May involve external calls
* Increases response time

Not suitable for simple or real-time low-latency tasks.

### 3. Requires Structured Environment

For full effectiveness, ReAct often needs:

* Defined tools or APIs
* Controlled execution environment
* Clear action definitions

Without this, “actions” become simulated rather than real.

### 4. Risk of Incorrect Actions

If reasoning is flawed:

* Model may choose wrong actions
* Incorrect observations may propagate errors

Proper constraints and validation are important.

## Sample Prompts

### Without ReAct (Direct Reasoning)

```
Find the current exchange rate of USD to INR and calculate the value of 100 USD in INR.
```

Issue:

* Model may guess or hallucinate exchange rate
* No real-time validation
* No external interaction

### With ReAct (Reason + Act Pattern)

```
You are an intelligent agent.

Follow this format:

Thought: Analyze what information is needed  
Action: Specify the action to take (e.g., search, lookup)  
Observation: Result of the action  
... (repeat as needed)  
Final Answer: Provide the final result  

Task:
Find the current exchange rate of USD to INR and calculate the value of 100 USD in INR.
```

Expected behavior:

* Model identifies need for exchange rate
* Simulates or triggers retrieval
* Uses retrieved value
* Computes final answer
