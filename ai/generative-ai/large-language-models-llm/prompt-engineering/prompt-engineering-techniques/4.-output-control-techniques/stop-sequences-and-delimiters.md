# Stop sequences and delimiters

## About

Stop Sequences and Delimiters are techniques used to **control where the model stops generating output and how different parts of the prompt/output are clearly separated**.

They work at two levels:

* **Stop Sequences** → Define when generation should stop
* **Delimiters** → Define boundaries between sections (context, instructions, output)

Core idea:

> Clearly define boundaries — where input ends, sections change, and output must stop.

These techniques help prevent:

* Over-generation
* Mixing of sections
* Unstructured responses
* Leakage of unwanted text

## Why Stop Sequences and Delimiters Are Critical

Without clear boundaries, models may:

* Continue generating unnecessary text
* Blend instructions with output
* Include context in the response
* Produce inconsistent endings

In engineering systems, this leads to:

* Parsing failures
* Invalid outputs (especially JSON)
* Hard-to-control responses
* Unexpected behavior

Stop sequences and delimiters ensure:

* Clean separation of sections
* Controlled output termination
* Predictable response boundaries

## The Purpose of Stop Sequences and Delimiters

These techniques aim to:

1. Control output length and termination
2. Prevent unwanted text generation
3. Clearly separate context, instructions, and tasks
4. Improve parsing and reliability
5. Enforce strict response boundaries

They act as **guardrails around generation**.

## Where They Fit in the Prompt Lifecycle

```
Problem Definition
      ↓
Input Design (Use delimiters to separate sections)
      ↓
Reasoning
      ↓
Knowledge Grounding
      ↓
Output Generation
      ↓
Stop Sequences Applied  ← (Terminate output cleanly)
```

* **Delimiters** → applied during input design
* **Stop sequences** → applied during output generation

## Different Patterns

#### 1. Section Delimiters

Used to separate parts of the prompt:

Context:\
<<<\
...

> > >

Task:\
...

Benefits:

* Prevents mixing of context and instructions
* Improves clarity

#### 2. Instruction Delimiters

Clearly separate instructions from data:

### INSTRUCTIONS:

...

### DATA:

...

Helps the model distinguish intent vs input.

#### 3. Output Delimiters

Force output within boundaries:

START\_OUTPUT\
...\
END\_OUTPUT

Useful for:

* Parsing
* Preventing extra text

#### 4. Stop Sequences (Hard Stop)

Define exact token/phrase where generation must stop.

Example:

Stop sequence: `END_OUTPUT`

Model stops when this appears.

#### 5. Multi-Section Delimiter Patterns

For complex prompts:

* Context block
* Rules block
* Task block

Each clearly separated.

Improves reliability in large prompts.

## Common Mistakes

#### 1. Not Using Delimiters in Complex Prompts

Without boundaries:

* Model may confuse context with instructions
* Output may include unwanted sections

#### 2. Weak or Ambiguous Delimiters

Using common words like:

* “Start” / “End”

can confuse the model.

Prefer unique markers:

* `<<< >>>`
* `---`
* `##`

#### 3. Not Enforcing Output Boundaries

If you don’t define:

* Where output starts/ends

Model may:

* Add explanations
* Continue beyond expected output

#### 4. Ignoring Stop Sequences in API Usage

Even with good prompts:

* Model may over-generate

Stop sequences at API level are critical for strict control.

#### 5. Mixing Delimiters and Content

If delimiters appear inside actual data:

* Model may misinterpret boundaries

Choose delimiters that do not conflict with content.

## Sample Prompts

### Without Delimiters

```
Use the following data to validate the transaction.

Transaction data:
{id: 1, amount: 100}

Validate and return result.
```

Issues:

* Context and task not clearly separated
* Output may include extra explanation

### With Delimiters and Stop Control

```
INSTRUCTIONS:
---
Validate the transaction and return result in JSON.
Do not include any text outside JSON.
---

DATA:
<<<
{id: 1, amount: 100}
>>>

OUTPUT FORMAT:
START_OUTPUT
{
  "isValid": boolean
}
END_OUTPUT
```

Benefits:

* Clear section separation
* Controlled output boundaries
* Easier parsing
* Reduced ambiguity
