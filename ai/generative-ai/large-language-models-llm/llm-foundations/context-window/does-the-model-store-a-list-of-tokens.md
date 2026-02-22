# Does the Model Store a List of Tokens ?

## 1. During Inference (Single Request) ?

When we send input text:

1. It is tokenized.
2. Tokens are stored in a sequence.
3. That sequence is fed into the model.
4. The model processes the entire sequence at once.

So for that request:

Yes - the model holds the list of token IDs in memory.

Example:

```
[15496, 922, 318, 257, 1234]
```

That sequence is passed into the Transformer.

But:

The model does not store it permanently.

Once the request finishes:

* The tokens disappear.
* The model does not "remember" them unless we send them again.

## 2. During Training ?

During training:

* Huge batches of token sequences are processed.
* Each batch is stored temporarily in GPU memory.
* Gradients are computed.
* Then discarded.

Again:

Tokens are not permanently stored.

## 3. What Is Permanently Stored ?

The model permanently stores:

* Learned weights (billions of parameters)
* Embedding matrix (token ID → vector mapping)
* Transformer layer weights

It does NOT store:

* Every sentence ever seen
* A list of all past inputs
* User conversations

## Important Distinction

The model has:

1. A vocabulary (fixed list of possible tokens)
2. An embedding table
3. Learned statistical relationships

It does NOT have:

* Memory of our specific tokens
* A database of sentences
* A recallable log
