# One-shot prompting

## About

One-shot prompting is a technique where the model is given **exactly one example** demonstrating how a task should be performed.

It is a special case of few-shot prompting - but with only one demonstration.

Core idea:

> Show the model one correct example, then ask it to replicate the pattern for a new input.

Structure typically looks like:

Example Input → Example Output\
New Input → Model generates output

The single example acts as a behavioral guide.

#### Why One Example Can Be Enough ?

LLMs are extremely good at pattern recognition.

Even a single demonstration helps the model understand:

* Expected output structure
* Formatting style
* Labeling conventions
* Level of detail
* Task interpretation

Compared to zero-shot, one-shot reduces ambiguity significantly.

It works especially well when:

* The task format is simple
* The output structure is repetitive
* The domain is not highly complex
* You need minimal guidance

## Strengths of One-Shot Prompting

### 1. Improved Structural Control (Compared to Zero-Shot)

Even one example can stabilize output format.

If you want:

* JSON structure
* Specific label format
* Defined bullet pattern
* Controlled sentence style

One-shot helps anchor the structure.

### 2. Lower Token Cost Than Few-Shot

Compared to 3–5 examples, one-shot:

* Uses fewer tokens
* Is cheaper
* Has lower latency
* Leaves more space in context window

It is a good compromise between reliability and efficiency.

### 3. Faster Setup

Sometimes you don’t need multiple examples.

If the pattern is clear and repetitive, one-shot is sufficient.

Example use cases:

* Basic classification
* Field extraction
* Structured response formatting
* Simple transformation tasks

## Limitations and When It Fails

### 1. Overfitting to the Single Example

With only one example, the model may:

* Copy stylistic details too literally
* Assume narrow scope
* Miss edge cases

If the example is too specific, generalization weakens.

### 2. Insufficient for Complex Logic

One-shot struggles when tasks involve:

* Multi-step reasoning
* Edge case handling
* Complex business rules
* Domain-specific compliance logic

In such cases, multiple examples provide better coverage.

### 3. Sensitive to Example Quality

Since there is only one demonstration:

* If it is unclear → output degrades
* If formatting is inconsistent → instability increases
* If logic is flawed → error propagates

Example quality matters significantly.

## Design Considerations

#### 1. Choose a Representative Example

Your single example should:

* Reflect typical use case
* Avoid extreme edge cases
* Clearly demonstrate structure
* Be concise and clean

It becomes the reference behavior.

### 2. Separate Example Clearly from Task

Structure should look like:

Example:\
Input:\
...\
Output:\
...

Now perform the same task for:\
Input:\
...

Clear separation prevents blending.

### 3. Combine With Constraints

One-shot becomes stronger when combined with:

* Role definition
* Output format restriction
* Length constraint
* Scope boundaries

Example:

“You are a backend validation engine.\
Follow the format shown in the example.\
Return output strictly in JSON.”

This increases determinism.

## Engineering Perspective

Think of one-shot prompting as:

> Providing a single reference implementation in API documentation.

It does not define full specification, but it shows expected behavior.

Zero-shot:

* No reference

One-shot:

* Minimal reference

Few-shot:

* Broader behavioral specification

One-shot is often the most efficient balance when:

* Structure matters
* Cost must be controlled
* Task is repetitive
* Full few-shot examples are unnecessary
