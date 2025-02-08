# Tree

## **About Tree**

A **tree** is a hierarchical data structure in which elements (called **nodes**) are connected by **edges**. It is a non-linear structure, meaning elements are not stored sequentially but in a parent-child relationship.

<table data-header-hidden data-full-width="true"><thead><tr><th width="248"></th><th></th></tr></thead><tbody><tr><td><strong>Term</strong></td><td><strong>Definition</strong></td></tr><tr><td><strong>Node</strong></td><td>A basic unit of a tree that contains a value and references to child nodes.</td></tr><tr><td><strong>Root</strong></td><td>The topmost node in a tree. It has no parent.</td></tr><tr><td><strong>Parent</strong></td><td>A node that has one or more child nodes.</td></tr><tr><td><strong>Child</strong></td><td>A node that is connected to another node (parent) above it.</td></tr><tr><td><strong>Sibling</strong></td><td>Nodes that share the same parent.</td></tr><tr><td><strong>Leaf</strong></td><td>A node that has no children.</td></tr><tr><td><strong>Edge</strong></td><td>A connection between two nodes (parent and child).</td></tr><tr><td><strong>Depth</strong></td><td>The number of edges from the root to a particular node.</td></tr><tr><td><strong>Height</strong></td><td>The number of edges from a node to the deepest leaf.</td></tr><tr><td><strong>Subtree</strong></td><td>A smaller tree within a larger tree, starting at any node.</td></tr></tbody></table>

```
        A
       / \
      B   C
     / \   \
    D   E   F

A is the root.
B and C are children of A (siblings).
D and E are children of B.
F is a child of C.
D, E, and F are leaf nodes (no children).
```

## **Binary Search Tree (BST)**

A **Binary Search Tree (BST)** is a tree where each node has at most two children, and the left subtree contains smaller values while the right subtree contains larger values.

| Operation | Average Case | Worst Case            |
| --------- | ------------ | --------------------- |
| Search    | **O(log n)** | **O(n)** (Unbalanced) |
| Insert    | **O(log n)** | **O(n)** (Unbalanced) |
| Delete    | **O(log n)** | **O(n)** (Unbalanced) |

* In a balanced BST, operations are logarithmic **O(log n)**.
* In a skewed (unbalanced) BST, operations degrade to **O(n)**.

## **Balanced Binary Search Trees (AVL, Red-Black Trees)**

Balanced BSTs maintain a height of **O(log n)**, ensuring efficient operations.

| Operation | AVL Tree     | Red-Black Tree |
| --------- | ------------ | -------------- |
| Search    | **O(log n)** | **O(log n)**   |
| Insert    | **O(log n)** | **O(log n)**   |
| Delete    | **O(log n)** | **O(log n)**   |

* **AVL Trees** maintain a strict balance, requiring more rotations during insertions/deletions.
* **Red-Black Trees** allow some imbalance but guarantee **O(log n)** operations with fewer rotations.

## **B-Trees (Used in Databases & File Systems)**

A **B-Tree** is a self-balancing tree where nodes can have multiple children (typically used in databases).

| Operation | Complexity   |
| --------- | ------------ |
| Search    | **O(log n)** |
| Insert    | **O(log n)** |
| Delete    | **O(log n)** |

* B-Trees ensure **logarithmic complexity** due to their balanced nature.
* They are optimized for disk-based storage.

## **Heap (Binary Heap, Fibonacci Heap)**

A **Heap** is a complete binary tree where the parent node is always smaller (Min-Heap) or larger (Max-Heap) than its children.

| Operation    | Binary Heap  | Fibonacci Heap |
| ------------ | ------------ | -------------- |
| Insert       | **O(log n)** | **O(1)**       |
| Delete Min   | **O(log n)** | **O(log n)**   |
| Extract Min  | **O(log n)** | **O(log n)**   |
| Decrease Key | **O(log n)** | **O(1)**       |

* **Binary Heaps** are used in **Priority Queues**.
* **Fibonacci Heaps** improve `Decrease Key` operations and are useful in **Dijkstra's Algorithm**.

## **Trie (Prefix Tree)**

A **Trie** stores strings where each node represents a character.

| Operation | Complexity                |
| --------- | ------------------------- |
| Insert    | **O(m)** (m = key length) |
| Search    | **O(m)**                  |
| Delete    | **O(m)**                  |

* Tries allow **fast lookups** but can consume more space.
* They are used in **autocomplete and dictionary applications**.
