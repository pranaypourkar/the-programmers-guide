# Source-constrained prompting

### About

Source-Constrained Prompting is a technique where the model is explicitly instructed to **use only the provided information (context/source)** and avoid using its own general knowledge.

Unlike basic context injection, this technique adds a **strict constraint**:

> The model must not go beyond the given source.

Core idea:

> Limit the model’s knowledge scope to prevent hallucination.

This is typically used along with:

* Retrieved documents (RAG)
* API specifications
* Policies and rules
* Internal documentation

## Why Source Constraint Is Critical ?

Even when context is provided, LLMs tend to:

* Mix provided data with pre-trained knowledge
* Fill missing gaps with assumptions
* Add “helpful” but incorrect details

This leads to:

* Hallucinated facts
* Inconsistent outputs
* Non-auditable responses

Source constraint ensures:

* Responses are grounded
* No external assumptions are introduced
* Outputs are traceable to given data

This is critical in:

* Compliance systems
* Financial workflows
* Legal or policy-based reasoning
* Internal enterprise tools

## The Purpose of Source-Constrained Prompting

This technique aims to:

1. Eliminate hallucination
2. Ensure strict adherence to provided data
3. Improve auditability and traceability
4. Enforce domain boundaries
5. Increase reliability in high-risk systems

It transforms the model from:

Creative generator → Controlled reasoning engine

## Where it Fits in the Prompt Lifecycle

```
User Query
      ↓
Retrieval / Context Injection
      ↓
Source Constraint (Restrict to provided data)
      ↓
Reasoning
      ↓
Output Generation
```

It acts as a **control layer over knowledge usage**.

## Different Source Constraint Patterns

#### 1. Strict Source Usage

Instruction:

“Answer using only the provided context.”

Basic but essential.

#### 2. No-Assumption Constraint

Instruction:

“If information is not available in the context, return ‘Not Available’.”

Prevents guessing.

#### 3. Evidence-Based Answering

Instruction:

“Support each answer with reference to the provided content.”

Forces grounding.

#### 4. Context-Only Reasoning

Instruction:

“Do not use prior knowledge. Rely strictly on the given data.”

Stronger enforcement for sensitive systems.

## Common Mistakes

#### 1. Weak Constraint Language

Weak:\
“Use the context if helpful.”

Strong:\
“Use only the provided context. Do not add external information.”

Clarity matters.

#### 2. Missing Fallback Behavior

If the model cannot find an answer:

* It may hallucinate

Always define:

“What to do if data is missing.”

#### 3. Poor Context Quality

Even with strict constraints:

* If context is incomplete → output will be incomplete

Garbage in → garbage out.

#### 4. No Structure in Context

Unstructured context:

* Makes it hard for model to locate relevant information
* Reduces effectiveness of constraint

Combine with structured input formatting.

## Sample Prompts

### Without Source Constraint

```
Explain the refund policy based on the following document.

<policy text>
```

Issue:

* Model may add assumptions
* May generalize beyond document

### With Source-Constrained Prompting

```
Use only the provided policy document to answer the question.

If the answer is not present, return "Not Available".

Context:
---
<policy text>
---

Question:
Explain the refund policy.
```

Benefits:

* No hallucination
* Traceable output
* Reliable response
