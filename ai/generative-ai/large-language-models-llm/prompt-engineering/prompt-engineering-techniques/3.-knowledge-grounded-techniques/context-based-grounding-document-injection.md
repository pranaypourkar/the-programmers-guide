# Context-based grounding (document injection)

## About

Context-Based Grounding, also known as Document Injection, is a technique where **relevant documents or data are directly included inside the prompt** so the model can use them while generating a response.

Unlike RAG (which retrieves context dynamically), document injection assumes:

* You already have the required data
* You inject it directly into the prompt

Core idea:

> Provide the exact information the model should rely on during generation.

This technique turns the prompt into a **self-contained knowledge environment**, where both:

* The question
* The required data

exist together.

{% hint style="success" %}
* **Context-Based Grounding (Document Injection)** → _Providing data_
* **Source-Constrained Prompting** → _Restricting usage of data_
{% endhint %}

## Why Context-Based Grounding Is Critical ?

Without injecting context:

* The model relies on general training data
* Domain-specific accuracy drops
* Internal systems are unknown to the model
* Hallucination risk increases

With document injection:

* Responses align with provided data
* Domain knowledge becomes available instantly
* No need for external retrieval systems
* Behavior becomes more predictable

This is especially useful when:

* Data is already available at runtime
* You want full control over context
* Retrieval systems are not needed or not available

## The Purpose of Context-Based Grounding

This technique aims to:

1. Provide domain-specific knowledge directly
2. Improve factual accuracy
3. Reduce hallucination
4. Enable reasoning over custom data
5. Simplify architecture (no retrieval layer needed)

It transforms the model from:

Generic knowledge system → Context-aware system

## Where it Fits in the Prompt Lifecycle

```
User Query
      ↓
Context Injection (Document Injection)
      ↓
Reasoning (Model processes query + document)
      ↓
Output Generation
```

It acts as a **direct knowledge layer inside the prompt**.

## Different Context Injection Patterns

#### 1. Full Document Injection

* Entire document is added to the prompt
* Useful for small documents

Example:

* Policy documents
* API specs
* Config files

#### 2. Chunked Document Injection

* Large documents are split into smaller sections
* Only relevant chunks are injected

Improves efficiency and focus.

#### 3. Section-Based Injection

* Specific sections of documents are labeled and injected

Example:

Policy Section:\
...

Exceptions:\
...

Improves navigation within context.

#### 4. Multi-Document Injection

* Multiple documents are provided together

Example:

* API spec
* Business rules
* Validation guidelines

Requires clear separation and labeling.

## Common Mistakes

### 1. Injecting Too Much Data

Large context:

* Increases token usage
* Reduces model focus
* Causes important details to be ignored

Always inject only relevant information.

### 2. Poor Context Structuring

Unstructured data leads to:

* Confusion between sections
* Misinterpretation
* Missing relationships

Use:

* Labels
* Delimiters
* Clear formatting

### 3. No Instruction to Use Context

If you do not explicitly instruct:

* Model may ignore context
* May mix with prior knowledge

Always combine with:

“Use the provided context…”

### 4. Missing Context Boundaries

If context is not clearly separated:

* Model may confuse task and data
* Instructions may be treated as data

Use clear delimiters like:

### Context:

### ...

### 5. Ignoring Context Size Limits

LLMs have context window limits.

If exceeded:

* Important parts may be truncated
* Output becomes unreliable

Plan for chunking when needed.

## Sample Prompts

### Without Context-Based Grounding

```
Explain the validation rules for our transaction system.
```

Issue:

* Model does not know your system
* Output becomes generic or incorrect

### With Context-Based Grounding

```
Use the following document to answer the question.

Context:
---
Transaction Rules:
- Amount must be greater than 0
- Currency must be valid ISO code
- Status must be SUCCESS or FAILED
---

Question:
Explain the validation rules for the transaction system.
```

Benefits:

* Accurate, domain-specific output
* Reduced hallucination
* Controlled response
