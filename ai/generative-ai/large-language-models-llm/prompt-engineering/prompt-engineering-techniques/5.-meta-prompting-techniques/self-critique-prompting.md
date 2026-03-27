# Self-Critique Prompting

## About

Self-Critique Prompting is a technique where the model is instructed to **review, evaluate, and identify issues in its own output (or a given output)** before producing a final response.

Instead of directly returning an answer, the model performs:

* Generation → Critique → Improvement

Core idea:

> Let the model act as both generator and reviewer.

This introduces an internal feedback loop:

**Draft → Analyze → Identify issues → Improve**

It helps simulate a **review process**, similar to code review or validation in software systems.

## Why Self-Critique Is Critical ?

LLMs often:

* Produce plausible but imperfect outputs
* Miss edge cases
* Introduce subtle errors
* Overlook constraints

Single-pass generation has limitations:

* No validation step
* No error detection
* No quality improvement

Self-critique adds a **quality control layer**.

It is especially important in:

* Code generation
* API design
* Validation systems
* Documentation
* Decision-making outputs

Without critique, errors remain hidden.\
With critique, errors become visible and correctable.

## The Purpose of Self-Critique Prompting

This technique aims to:

1. Identify errors and inconsistencies
2. Improve output quality
3. Reduce hallucination
4. Enforce constraints and rules
5. Introduce internal validation

It transforms output generation from:

One-step response → Multi-step validation process

## Where Self-Critique Fits in the Prompt Lifecycle

```
Problem Definition
      ↓
Initial Generation
      ↓
Self-Critique  ← (Analyze output for issues)
      ↓
Refinement
      ↓
Final Output
```

It acts as a **post-processing validation layer**.

## Different Self-Critique Patterns

#### 1. Explicit Critique Step

Separate steps:

* Generate output
* Review output
* List issues

Clear and structured.

#### 2. Guided Critique

Provide evaluation criteria:

* Check correctness
* Check completeness
* Check format

Improves quality of critique.

#### 3. Constraint-Based Critique

Focus on rules:

* Schema validation
* Business rules
* Format compliance

Useful for engineering workflows.

#### 4. Critique + Improve Pattern

Model:

1. Identifies issues
2. Fixes them

End-to-end refinement.

#### 5. Multi-Round Critique

Repeat critique cycle:

* Improve → Critique → Improve

Useful for high-quality outputs.

## Common Mistakes

#### 1. Vague Critique Instructions

Weak:\
“Review the output.”

Strong:\
“Identify missing fields, incorrect logic, and format violations.”

Specific criteria improve effectiveness.

#### 2. Skipping Improvement Step

If only critique is done:

* Output is not corrected

Always include refinement step.

#### 3. Over-Critiquing Simple Tasks

For simple outputs:

* Adds unnecessary overhead
* Increases cost and latency

Use selectively.

#### 4. No Constraint Definition

Without rules:

* Critique becomes generic
* May miss important issues

Define what to check.

#### 5. Mixing Generation and Critique

If both are in one step:

* Model may skip proper evaluation

Separate phases improve reliability.

## Sample Prompts

### Without Self-Critique

```
Generate a JSON schema for a payment API.
```

Issues:

* Missing fields
* Inconsistent structure
* No validation

### With Self-Critique Prompting

**Step 1: Generate**

```
Generate a JSON schema for a payment API.
```

**Step 2: Critique**

```
Review the generated schema.

Check for:
- Missing required fields  
- Inconsistent structure  
- Invalid data types  

List all issues.
```

**Step 3: Improve**

```
Improve the schema based on identified issues.

Ensure:
- Complete field coverage  
- Consistent structure  
- Valid data types  
Return final output in JSON.
```

Benefits:

* Higher accuracy
* Reduced errors
* Better structure
* More reliable output
