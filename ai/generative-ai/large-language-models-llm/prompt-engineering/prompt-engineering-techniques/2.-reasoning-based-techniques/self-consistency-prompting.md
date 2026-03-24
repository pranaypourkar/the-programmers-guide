# Self-Consistency Prompting

## About

Self-Consistency Prompting is a technique where the model generates **multiple independent reasoning paths for the same problem** and the final answer is selected based on the **most consistent or majority result**.

Instead of relying on a single reasoning chain, you:

* Run the same prompt multiple times
* Allow the model to produce different reasoning paths
* Compare final answers
* Select the most frequent or most consistent one

Core idea:

> Multiple reasoning attempts reduce the risk of a single incorrect path.

This technique addresses a key limitation of Chain-of-Thought:

* A single reasoning chain may look correct but still be wrong

Self-consistency improves reliability by introducing **redundancy and consensus**.

## How Self-Consistency Prompting Works (Model Behavior Perspective)

LLMs are probabilistic systems. Even with the same prompt:

* Different runs can produce different reasoning paths
* Intermediate steps may vary
* Final answers may differ slightly

This variability is usually seen as a limitation.\
Self-consistency turns it into an advantage.

Process:

1. Use a reasoning-based prompt (e.g., Chain-of-Thought or step-by-step)
2. Run the prompt multiple times (with some randomness, e.g., temperature > 0)
3. Collect multiple outputs
4. Extract final answers from each response
5. Select the most common answer (majority voting)

Why it works:

* Correct reasoning paths tend to converge on the same answer
* Incorrect paths are more diverse and inconsistent

Consistency becomes a signal of correctness.

## Strengths and Ideal Use Cases

### 1. Higher Accuracy in Complex Reasoning Tasks

Self-consistency significantly improves performance in:

* Mathematical problems
* Logical reasoning
* Multi-step decision problems
* Constraint-based evaluations

It reduces dependence on a single reasoning path.

### 2. Reduces Impact of Random Errors

Even if one reasoning chain is incorrect:

* Other runs may produce correct answers
* Majority voting filters out outliers

This improves robustness.

### 3. Works Well with Chain-of-Thought

Self-consistency is most effective when combined with:

* Chain-of-Thought prompting
* Step-by-step reasoning

Each run generates a different reasoning chain, increasing diversity.

### 4. Improves Confidence in Outputs

If multiple independent runs produce the same answer:

* Confidence in correctness increases
* Results become more reliable

This is useful in:

* Decision support systems
* Validation pipelines
* Risk-sensitive applications

## Limitations and Practical Considerations

### 1. Higher Cost and Latency

Self-consistency requires:

* Multiple model invocations
* More tokens
* Increased processing time

For example:

* 1 request → standard prompting
* 5–10 requests → self-consistency

This can be expensive in production.

### 2. Requires Output Extraction Logic

To apply majority voting, you must:

* Extract final answers from each response
* Normalize formats
* Compare results

This often requires additional processing logic.

### 3. Not Useful for Simple Tasks

For tasks like:

* Basic summarization
* Simple classification

Self-consistency adds overhead without meaningful benefit.

### 4. Dependent on Diversity of Outputs

If all runs produce similar incorrect reasoning:

* Majority voting will still be wrong

To improve diversity:

* Slight randomness (temperature) is needed
* Prompt design should allow variation in reasoning

## Sample Prompts

### Without Self-Consistency (Single Run)

```
Solve the following problem step by step:

A shop gives 20% discount on a product priced at 1000. After discount, 18% tax is applied. What is the final price?
```

Issue:

* If the model makes a mistake, the result is wrong
* No fallback or correction

### With Self-Consistency (Multiple Runs Strategy)

```
Solve the following problem step by step:

A shop gives 20% discount on a product priced at 1000. After discount, 18% tax is applied. What is the final price?

Provide clear step-by-step reasoning and final answer.
```

Execution approach:

* Run this prompt 5–10 times
* Collect outputs
* Extract final answers
* Choose the most frequent result

Example outcomes:

Run 1 → 944\
Run 2 → 944\
Run 3 → 944\
Run 4 → 960 (incorrect)\
Run 5 → 944

Final answer → **944 (majority result)**
