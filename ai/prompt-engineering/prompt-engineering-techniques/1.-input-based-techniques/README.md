# 1. Input-Based Techniques

## About

Input-Based Techniques focus on **how we present the problem to the model**.

Before a model reasons, retrieves knowledge, or generates output, it must first **interpret the input correctly**.\
If interpretation fails, everything that follows becomes unreliable.

Input-based techniques control:

* Task clarity
* Scope definition
* Context boundaries
* Instruction precision
* Role alignment

In simple terms:

> If reasoning is the brain, input design is the instruction manual.

{% hint style="success" %}
## Key Principle of Input-Based Prompting

Clarity > Length\
Specificity > Generality\
Structure > Free-form text

Good input does not mean longer input. It means clearer instruction.
{% endhint %}

## Why Input Design Is Critical ?

Large Language Models do not truly “understand” meaning.\
They interpret patterns in text based on probabilities.

If the input is:

* Ambiguous → output becomes inconsistent
* Vague → model fills missing gaps
* Overloaded → model loses focus
* Underspecified → assumptions increase

Good input design reduces these risks.

## The Purpose of Input-Based Techniques

Input-based techniques aim to:

1. Reduce ambiguity
2. Define clear task boundaries
3. Align the model to a specific role
4. Control scope before reasoning begins
5. Increase predictability

They operate at the **very first stage of prompt processing**.

## Where Input-Based Techniques Fit in the Prompt Lifecycle ?

```
Problem Definition
      ↓
Input Design  ← (Input-Based Techniques live here)
      ↓
Reasoning
      ↓
Output Generation
      ↓
Validation
```

If input design is weak, later techniques (reasoning, output control) cannot compensate effectively.

## Different Input-Based Technique Types

Under Input-Based Techniques, following are typically included. Each of these changes how the model **interprets the task before generating output**.

* Zero-shot prompting
* One-shot prompting
* Few-shot prompting
* Role-based prompting
* Instruction-based prompting
* Context injection
* Structured input formatting

## Common Input Design Mistakes

Before diving deeper, here are common issues:

* Asking multi-layered questions in one sentence
* Mixing instructions and examples without separation
* Not defining output expectations
* Providing insufficient context
* Providing too much irrelevant context
* Leaving role undefined

These lead to:

* Hallucination
* Irrelevant answers
* Overly verbose responses
* Incorrect assumptions
