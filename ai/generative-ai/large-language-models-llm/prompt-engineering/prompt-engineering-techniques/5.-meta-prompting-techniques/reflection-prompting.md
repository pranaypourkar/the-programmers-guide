# Reflection Prompting

## About

Reflection Prompting is a technique where the model is instructed to **analyze its reasoning process and improve it by reflecting on mistakes, assumptions, or alternative approaches**.

Unlike self-critique (which evaluates the output), reflection focuses on:

* The **reasoning process itself**
* Identifying where thinking could be improved
* Revising the approach before producing the final answer

Core idea:

> Improve the thinking process, not just the final output.

It introduces a deeper loop:

**Reason → Reflect → Adjust reasoning → Final Answer**

This makes the model behave more like a **problem solver that learns during execution**.

## Why Reflection Is Critical

Even with techniques like:

* Chain-of-Thought
* Step-by-step reasoning

the model can still:

* Follow incorrect logic
* Miss better approaches
* Stick to initial assumptions
* Produce suboptimal solutions

Reflection addresses this by:

* Re-evaluating reasoning
* Considering alternative paths
* Correcting flawed logic

This is especially important in:

* Complex problem solving
* Algorithm design
* Decision-making systems
* Optimization tasks

Without reflection:

* Errors in reasoning persist

With reflection:

* Reasoning improves before final output

## The Purpose of Reflection Prompting

This technique aims to:

1. Improve reasoning quality
2. Identify flawed assumptions
3. Explore better approaches
4. Enhance solution accuracy
5. Introduce adaptive thinking

It transforms reasoning from:

Static process → Adaptive process

## Where Reflection Fits in the Prompt Lifecycle

```
Problem Definition
      ↓
Initial Reasoning
      ↓
Reflection  ← (Analyze reasoning process)
      ↓
Refined Reasoning
      ↓
Final Output
```

It acts as a **reasoning improvement layer**.

## Different Reflection Patterns

#### 1. Single Reflection Pass

Model:

* Solves problem
* Reflects on reasoning
* Improves answer

Simple and effective.

#### 2. Guided Reflection

Provide criteria:

* Check logical consistency
* Identify missing steps
* Consider alternative approaches

Improves reflection quality.

#### 3. Multi-Perspective Reflection

Model evaluates:

* Different possible approaches
* Trade-offs

Useful for decision-making.

#### 4. Reflection Before Final Answer

Model:

* Generates draft reasoning
* Reflects
* Produces final answer

Prevents premature conclusions.

#### 5. Reflection with Constraints

Focus on:

* Domain rules
* Business logic
* Optimization goals

Ensures alignment with system requirements.

## Common Mistakes

#### 1. Vague Reflection Instructions

Weak:\
“Reflect on your answer.”

Strong:\
“Check for logical errors, missing steps, and alternative approaches.”

Clarity improves effectiveness.

#### 2. Confusing Reflection with Critique

* Critique → evaluates output
* Reflection → evaluates reasoning

They serve different purposes.

#### 3. Overuse for Simple Tasks

For simple problems:

* Reflection adds unnecessary overhead
* Increases cost and latency

Use for complex reasoning tasks.

#### 4. No Clear Improvement Step

If reflection is done but not applied:

* No benefit

Always follow reflection with refinement.

#### 5. Lack of Constraints

Without guidance:

* Reflection may be shallow
* Model may repeat same reasoning

Define what to evaluate.

## Sample Prompts

### Without Reflection Prompting

```
Design a scalable payment processing system.
```

Issues:

* Single approach
* No evaluation of alternatives
* May miss better design

### With Reflection Prompting

```
Design a scalable payment processing system.

Step 1: Propose an initial architecture  
Step 2: Reflect on the design by identifying:
- Potential bottlenecks  
- Scalability issues  
- Failure points  
Step 3: Improve the architecture based on reflection  

Provide final optimized design.
```

Benefits:

* Better reasoning quality
* Improved solution
* Consideration of edge cases
* More robust output

