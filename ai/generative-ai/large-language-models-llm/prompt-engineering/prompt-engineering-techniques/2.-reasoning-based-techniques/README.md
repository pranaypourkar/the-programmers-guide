# 2. Reasoning-Based Techniques

## About

Reasoning-Based Techniques focus on **how the model thinks through a problem**, rather than just what input it receives.

Instead of asking the model to directly produce an answer, these techniques guide the model to:

* Break down the problem
* Follow intermediate steps
* Explore multiple reasoning paths
* Validate its own conclusions

Core idea:

> Don’t just ask for the answer — guide the thinking process.

## Why Reasoning Matters in LLMs ?

By default, LLMs tend to:

* Generate direct answers
* Skip intermediate steps
* Rely on pattern matching instead of deep reasoning

This works for simple tasks but fails for:

* Multi-step problems
* Logical deductions
* Mathematical reasoning
* Decision-making tasks
* Complex validations

Without guided reasoning, the model may:

* Jump to incorrect conclusions
* Miss constraints
* Oversimplify problems
* Produce confident but wrong answers

Reasoning-based techniques improve correctness by forcing structured thinking.

{% hint style="success" %}
These techniques aim to:

1. Improve logical accuracy
2. Reduce reasoning errors
3. Handle multi-step problems
4. Increase transparency of output
5. Enable validation of intermediate steps

They operate **after input interpretation but before final output generation**.
{% endhint %}

## Where it Fit's in the Prompt Lifecycle ?

```
Problem Definition
      ↓
Input Design
      ↓
Reasoning Strategy  ← (Reasoning-Based Techniques live here)
      ↓
Output Generation
      ↓
Validation
```

If reasoning is weak, even well-structured input cannot guarantee correct results.

## Core Reasoning-Based Technique Types

Under Reasoning-Based Techniques, we include:

* Chain-of-Thought (CoT) Prompting
* Step-by-Step Reasoning
* Self-Consistency Prompting
* Tree-of-Thought (ToT)
* ReAct (Reason + Act)
* Decomposition Prompting
* Iterative Refinement

Each technique influences **how the model processes and validates information internally**.

### Engineering Analogy (Backend Perspective)

Think of reasoning-based prompting like defining **business logic execution flow**.

* Input-Based Techniques → API request design
* Reasoning-Based Techniques → Service layer logic

Without proper logic:

* Correct input → incorrect output

Reasoning techniques introduce:

* Stepwise execution
* Intermediate validation
* Decision branching
* Error reduction

### Common Reasoning Mistakes

* Jumping directly to conclusions
* Ignoring constraints in later steps
* Mixing unrelated logic
* Losing track of intermediate results
* Producing inconsistent answers across runs

These are typical failure modes in zero-shot or poorly structured prompts.



