# Constrained formatting

## About

Constrained Formatting is a technique where the model is instructed to **generate output in a strictly controlled format**, using predefined patterns such as:

* Bullet points
* Numbered lists
* Tables
* Fixed templates
* Key-value pairs
* Delimited blocks

Unlike general structured output (which focuses on readability), constrained formatting focuses on:

* **Consistency**
* **Strict adherence to format**
* **Limited variation**

Core idea:

> Restrict how the output is written, not just what it contains.

This ensures that outputs are:

* Predictable
* Uniform across runs
* Easy to scan or parse

## Why Constrained Formatting Is Critical ?

Without constraints, outputs may:

* Change structure between runs
* Mix paragraphs and lists
* Include unnecessary explanations
* Be hard to parse or compare

In engineering workflows, this causes:

* Parsing issues
* Inconsistent UI rendering
* Difficulty in automation
* Poor readability

Constrained formatting ensures:

* Consistent structure
* Reduced variability
* Easier integration with systems
* Better human readability

## The Purpose of Constrained Formatting

This technique aims to:

1. Enforce consistent output layout
2. Improve readability and scan-ability
3. Reduce structural variability
4. Support partial automation (parsing lists/tables)
5. Align outputs with UI or reporting formats

It transforms output from:

Flexible text → Controlled format

## Where Constrained Formatting Fits in the Prompt Lifecycle ?

```
Problem Definition
      ↓
Input Design
      ↓
Reasoning
      ↓
Knowledge Grounding
      ↓
Formatting Constraints  ← (Apply strict output structure)
      ↓
Final Output
```

It acts as a **format enforcement layer before delivery**.

## Different Constrained Formatting Patterns

#### 1. Fixed Bullet Format

Define exact number and structure:

* Point 1:
* Point 2:
* Point 3:

Instruction example:

“Provide exactly 3 bullet points. Each point must be one sentence.”

#### 2. Numbered Step Format

Useful for processes:

1. Step 1
2. Step 2
3. Step 3

Ensures ordered and consistent output.

#### 3. Table Format

Define column structure:

| Field | Description |
| ----- | ----------- |

Useful for:

* Comparisons
* Validation reports
* Structured summaries

#### 4. Key-Value Format

Strict pairing:

Field: Value\
Field: Value

Useful for:

* Logs
* Metadata
* Configurations

#### 5. Delimited Blocks

Use markers:

START\
...\
END

Prevents mixing of content and improves parsing.

## Common Mistakes

#### 1. Not Defining Exact Constraints

Weak:\
“Use bullet points.”

Strong:\
“Provide exactly 4 bullet points, each under 15 words.”

Precision reduces variability.

#### 2. Allowing Extra Text

If not restricted:

* Model may add explanations before/after format

Always specify:

“Do not include text outside the defined format.”

#### 3. Mixing Multiple Formats

Example:

* Bullet points + paragraphs + tables

Leads to inconsistency and confusion.

Stick to one format per response.

#### 4. Not Defining Limits

If count is not specified:

* Number of items may vary

Always define:

* Number of bullets
* Number of rows
* Length constraints

#### 5. Ignoring Edge Cases

If output is empty or partial:

* Format may break

Define fallback:

“If no data, return empty list in same format.”

## Sample Prompts

### Without Constrained Formatting

```
List the benefits of microservices architecture.
```

Issues:

* Variable number of points
* Mixed formatting
* Inconsistent structure

### With Constrained Formatting

```
List the benefits of microservices architecture.

Provide exactly 4 bullet points.
Each bullet must be one concise sentence.
Do not include any text outside the bullet list.
```

Benefits:

* Consistent output
* Predictable structure
* Easy to scan and compare
* Reduced variability
