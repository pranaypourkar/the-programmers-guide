# Citation-based prompting

## About

Citation-Based Prompting is a technique where the model is instructed to **generate answers along with references (citations) to the source content** used in the response.

Instead of only answering:

> “What is the answer?”

the model is required to also answer:

> “Where did this answer come from?”

Core idea:

> Every claim should be traceable to a source.

This technique is typically used with:

* Document injection
* RAG systems
* Knowledge bases
* Policy documents

The output includes:

* Answer
* Supporting references (sections, lines, documents)

## Why Citation-Based Prompting Is Critical ?

Even with context grounding, a key problem remains:

* You cannot easily verify which part of the context was used
* The model may still mix or reinterpret information
* Trust in output is limited

Citation-based prompting solves this by:

* Making reasoning traceable
* Enabling verification of outputs
* Increasing transparency
* Supporting audit and compliance requirements

This is critical in:

* Financial systems
* Legal workflows
* Compliance checks
* Enterprise knowledge systems

Without citations, outputs are harder to trust.\
With citations, outputs become **verifiable**.

## The Purpose of Citation-Based Prompting

This technique aims to:

1. Improve trust and transparency
2. Enable answer verification
3. Reduce hallucination (by forcing grounding)
4. Support auditability
5. Link outputs to source data

It transforms the model from:

Black-box generator → Explainable system

## Where it Fits in the Prompt Lifecycle

```
User Query
      ↓
Context Injection / Retrieval
      ↓
Reasoning
      ↓
Answer + Citation Generation  ← (Output includes references)
      ↓
Validation / Verification
```

It enhances the **output layer with traceability**.

## Different Citation Patterns

#### 1. Inline Citations

Answer includes references directly:

Example:\
“The refund is allowed within 7 days (Policy Section 2.1).”

Simple and readable.

#### 2. Section-Based Citations

Answer + separate reference section:

Answer:\
...

References:

* Section 2.1
* Section 3.4

Useful for structured outputs.

#### 3. Quote-Based Citations

Model includes exact excerpts:

“Refund is allowed within 7 days.”

Ensures precise traceability.

#### 4. Structured Citations (JSON)

Used in automation systems:

{\
"answer": "...",\
"citations": \["Section 2.1", "Section 3.4"]\
}

Machine-readable and deterministic.

## Common Mistakes

### 1. Not Enforcing Citation Requirement

Weak:\
“Provide references if possible.”

Strong:\
“Every statement must include a citation from the provided context.”

Strict instruction is necessary.

### 2. Allowing External Knowledge

If not constrained:

* Model may add uncited information
* Citations may not match actual content

Always combine with:

* Source-constrained prompting
* Context grounding

### 3. Vague Citation Format

If format is not defined:

* Model may produce inconsistent references
* Hard to parse or verify

Define clearly:

* Inline vs structured
* Section names vs line numbers

### 4. Incorrect or Fabricated Citations

Model may:

* Cite non-existent sections
* Misattribute information

Mitigation:

* Use structured context
* Use clear labels
* Combine with validation

### 5. Overloading Context Without Labels

If context is not labeled:

* Model cannot reference properly
* Citations become vague or incorrect

Always provide identifiable sections.

## Sample Prompts

### Without Citation-Based Prompting

```
Explain the refund policy based on the document.

<policy document>
```

Issue:

* No traceability
* Cannot verify correctness
* May mix assumptions

### With Citation-Based Prompting

```
Use the provided document to answer the question.

Include citations for every statement using section names.

Context:
---
Section 2.1: Refund allowed within 7 days  
Section 3.4: No refund after service usage  
---

Question:
Explain the refund policy.
```

Expected output:

* Clear answer
* Referenced sections
* Verifiable statements
