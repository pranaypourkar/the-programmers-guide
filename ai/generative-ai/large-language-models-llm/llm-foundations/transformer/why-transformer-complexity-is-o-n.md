# Why Transformer Complexity is O(n²)

## About

When we say:

> Transformer complexity is O(n²)

We are specifically referring to the **self-attention mechanism**.

Where:

* `n` = number of tokens in the sequence

## What Self-Attention Actually Does ?

In a Transformer, every token looks at **every other token** in the sequence.

If your input has:

```
n tokens
```

Each token computes attention with:

```
n tokens (including itself)
```

So total attention comparisons:

```
n × n = n²
```

That’s where the quadratic complexity comes from.

### Visual Example

Suppose we have 4 tokens:

```
["The", "model", "predicts", "tokens"]
```

Attention matrix:

|          | The | model | predicts | tokens |
| -------- | --- | ----- | -------- | ------ |
| The      | ✔   | ✔     | ✔        | ✔      |
| model    | ✔   | ✔     | ✔        | ✔      |
| predicts | ✔   | ✔     | ✔        | ✔      |
| tokens   | ✔   | ✔     | ✔        | ✔      |

Each token interacts with all 4 tokens.

Total interactions:

```
4 × 4 = 16
```

If tokens double to 8:

```
8 × 8 = 64
```

If tokens become 1000:

```
1000 × 1000 = 1,000,000 interactions
```

This grows very fast.

### Mathematical Breakdown

Self-attention involves these steps:

1. Compute Query (Q), Key (K), Value (V) matrices
2. Compute attention scores:

```
Attention(Q, K) = Q × Kᵀ
```

If:

* Q is n × d
* K is n × d

Then:

```
Q × Kᵀ → n × n matrix
```

This produces the attention matrix of size:

```
n²
```

Then:

* Softmax is applied to this matrix
* Weighted values are computed

The dominant cost is creating that n × n matrix.

## Why Tokens Directly Affect Complexity ?

Since:

```
n = number of tokens
```

If tokenization creates:

* Shorter sequences → smaller n → cheaper computation
* Longer sequences → larger n → expensive computation

This is why:

Character-level tokenization (long sequences)\
is computationally expensive.

Subword tokenization (shorter sequences)\
is more efficient.

### Does O(n²) Limit Tokens?

Yes. Directly.

This quadratic scaling is the main reason why context windows cannot grow infinitely.

Let’s see what happens.

#### Example: Doubling Tokens

If we increase tokens from:

```
4,000 → 8,000
```

Computation increases by:

```
(8000²) / (4000²) = 4×
```

Doubling tokens = 4× compute cost.

If we go from:

```
8,000 → 32,000
```

That is:

```
(32000²) / (8000²) = 16× increase
```

This becomes extremely expensive in:

* Memory
* GPU usage
* Latency
* Energy cost

### Memory Impact

The attention matrix size is:

```
n × n
```

If n = 100,000 tokens:

```
100,000 × 100,000 = 10 billion entries
```

That is enormous memory usage.

This is why:

Context window expansion is expensive.

### Real Implication

When a model says:

* 8K context
* 32K context
* 128K context

It is not just a configuration change.

It significantly increases:

* Training cost
* Inference cost
* Memory usage

This is directly caused by O(n²) attention.

## Why Tokenization Matters Here ?

Let’s compare:

Sentence length = 200 characters

Character-level tokens:\
200 tokens

Subword tokens:\
\~50 tokens

Attention cost comparison:

Character:

```
200² = 40,000
```

Subword:

```
50² = 2,500
```

That’s 16× cheaper.

This is one of the strongest reasons modern LLMs use subword tokenization.

## Not All Transformer Cost is O(n²)

Total transformer cost includes:

* Self-attention: O(n²)
* Feed-forward layers: O(n)

But attention dominates at large sequence sizes.

So we simplify complexity to:

```
O(n²)
```

Because that is the bottleneck.

## Does This Mean Tokens Are Limited ?

Yes - practically.

Because:

* Memory is finite
* GPUs are finite
* Cost is finite

This leads to: Context window limits.

Common context sizes:

* 4K tokens
* 8K tokens
* 32K tokens
* 128K tokens
* 200K+ tokens (advanced models)

But increasing this further becomes exponentially expensive.

## How Modern Research Tries to Solve This ?

Researchers are working on:

* Sparse attention
* Sliding window attention
* Linear attention
* Memory-compressed attention
* Chunked processing

These aim to reduce complexity to:

```
O(n)
```

Or near-linear scaling.

But classical full self-attention remains O(n²).
