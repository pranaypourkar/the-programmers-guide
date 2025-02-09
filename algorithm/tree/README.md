# Tree

## About Tree Data Structure

A **Tree** is a non-linear data structure used to represent hierarchical relationships between elements. It consists of **nodes** connected by **edges**, with one node designated as the **root**. Unlike arrays, stacks, or linked lists, which store data sequentially, trees are structured to allow for efficient searching, insertion, and deletion operations.

Trees are fundamental in various computing applications, including databases, networking, artificial intelligence, and file systems. They provide fast lookups, efficient sorting mechanisms, and optimized memory usage for hierarchical data storage.

### **What is a Tree?**

A **Tree** is a **hierarchical data structure** that consists of nodes connected by edges. It has the following key characteristics:

1. **Root Node**: The topmost node in the hierarchy.
2. **Parent-Child Relationship**: Each node can have multiple child nodes, but only one parent (except the root, which has no parent).
3. **Leaf Nodes**: Nodes that do not have any children.
4. **Height of a Tree**: The longest path from the root to any leaf.
5. **Depth of a Node**: The distance from the root to that node.

### **Basic Terminologies**

<table><thead><tr><th width="176">Term</th><th>Description</th></tr></thead><tbody><tr><td><strong>Node</strong></td><td>A single element in the tree.</td></tr><tr><td><strong>Edge</strong></td><td>The connection between two nodes.</td></tr><tr><td><strong>Root</strong></td><td>The topmost node of the tree.</td></tr><tr><td><strong>Parent</strong></td><td>A node that has one or more child nodes.</td></tr><tr><td><strong>Child</strong></td><td>A node that has a parent.</td></tr><tr><td><strong>Sibling</strong></td><td>Nodes that share the same parent.</td></tr><tr><td><strong>Leaf</strong></td><td>A node that has no children.</td></tr><tr><td><strong>Degree</strong></td><td>The number of child nodes a node has.</td></tr><tr><td><strong>Height</strong></td><td>The longest path from a node to a leaf node.</td></tr><tr><td><strong>Depth</strong></td><td>The distance from the root node to a specific node.</td></tr><tr><td><strong>Breadth</strong></td><td>The breadth of a tree refers to the maximum number of nodes present at any level in the tree.</td></tr></tbody></table>

### **Example**

```asciidoc
                             (Root) A
                          /            \
                (Parent) B                C (Parent)
                /      \                   /   \  
        (Parent) D      E (Leaf)   (Parent) F   G (Leaf)
          /   |  \  \                 /  |   \
   (Leaf) H   I   J   K (Leaf)       L   M  (Leaf) N  
              |
       (Leaf) O

Root (A) → The topmost node of the tree.
Parent (B, C, D, F) → Nodes that have one or more children.
Child (B, C are children of A, etc.) → Nodes connected below a parent.
Sibling (B and C, D and E, F and G, etc.) → Nodes with the same parent.
Leaf (E, G, H, K, M, N, O) → Nodes with no children.
Internal Node (B, C, D, F) → Nodes that are neither root nor leaves.

Subtree:
The subtree rooted at D contains {D, H, I, J, K, O}.
The subtree rooted at F contains {F, L, M, N}.

Depth of a Node → Distance from the root:
Depth of A = 0
Depth of B, C = 1
Depth of D, E, F, G = 2
Depth of H, I, J, K, L, M, N = 3
Depth of O = 4

Height of a Tree → Longest path from root to leaf (Here, height = 4).

Breadth
Level 0 →  A  → 1 node
Level 1 →  B, C  → 2 nodes
Level 2 →  D, E, F, G  → 4 nodes
Level 3 →  H, I, J, K, L, M, N  → 7 nodes
Level 4 →  O  → 1 node
The maximum number of nodes at any level is 7 (at level 3).
Breadth of this tree = 7.
```

### **Real-World Examples of Trees**

Trees are widely used in real-world applications due to their hierarchical nature. Here are some practical examples:

#### **1. File System Hierarchy**

The file system in an operating system is organized as a tree:

```
Root Directory
│
├── Folder1
│   ├── File1
│   ├── File2
│
├── Folder2
│   ├── SubFolder1
│   │   ├── File3
│   │   ├── File4
```

Each directory is a **node**, and files or subdirectories are **children**.

#### **2. Organization Charts**

A company’s hierarchy is represented as a tree:

```
CEO
│
├── VP of Engineering
│   ├── Software Engineer
│   ├── QA Engineer
│
├── VP of Sales
│   ├── Sales Manager
│   ├── Sales Representative
```

This helps in structuring teams and workflow.



## **Types of Trees in Data Structures**

### **1. General Tree**

* A tree where **each node can have any number of children**.
* Used in hierarchical structures like **file systems, organization charts, etc.**
* **Height**: Maximum depth of the tree.
* **Breadth**: Maximum number of nodes at any level.

### **2. Binary Tree**

* Each node has **at most two children**: **left** and **right**.
* Types of binary trees include:
  * **Full Binary Tree**
  * **Complete Binary Tree**
  * **Perfect Binary Tree**
  * **Balanced Binary Tree**
  * **Degenerate Tree**
* **Height**: At most **O(n)** for an unbalanced tree, **O(log n)** for balanced trees.
* **Depth**: Varies depending on the structure.

#### **2.1. Full Binary Tree**

* A binary tree where **every node has either 0 or 2 children** (no nodes with only one child).
* **Height**: h=O(log⁡n)
* **Breadth**: Maximum at the last level.

```plaintext
         A
       /   \
      B     C
     / \   / \
    D   E F   G
```

#### **2.2. Complete Binary Tree**

* A binary tree where **all levels except the last are completely filled**, and nodes in the last level are as **left as possible**.
* Example: **Heap data structures** follow this rule.
* **Height**: O(log⁡n)
* **Breadth**: Maximum at last level 2^(h−1)

```plaintext
         A
       /   \
      B     C
     / \   /
    D   E F  
```

#### **2.3. Perfect Binary Tree**

* A binary tree where **all levels are fully filled**.
* Number of nodes at depth d is **2^d**.
* **Height**: h=log⁡(n+1)−1 (log with base 2)
* **Breadth**: 2^(h−1) (maximum nodes at last level).

```plaintext
         A
       /   \
      B     C
     / \   / \
    D   E F   G
```

#### **2.4. Balanced Binary Tree**

* A binary tree where the height of **left and right subtrees differs by at most 1**.
* Example: **AVL Tree, Red-Black Tree**.
* **Height**: O(log⁡n).
* **Breadth**: Maximum at last level.

```plaintext
         A
       /   \
      B     C
     / \   / \
    D   E F   G
```

#### **2.5. Degenerate (Skewed Tree)**

* A **linked list-like structure**, where each node has only one child.
* **Height**: O(n)(worst case).
* **Breadth**: Always **1**.

```plaintext
    A
     \
      B
       \
        C
         \
          D
```

### **3. Binary Search Tree (BST)**

* A **sorted binary tree** where:
  * Left subtree **< root**.
  * Right subtree **> root**.
* Used for **efficient searching**.
* **Height**: O(log⁡n) (balanced), O(n) (worst case).

```plaintext
        8
       /  \
      3    10
     / \     \
    1   6     14
       / \    /
      4   7  13
```

### **4. AVL Tree (Self-Balancing BST)**

* A **BST with a balance factor** (height difference of left and right subtree is **at most 1**).
* **Height**: O(log⁡n).
* Used for **fast lookups**.

```plaintext
        8
       /  \
      4    12
     / \   /  \
    2   6 10  14
```

### **5. Red-Black Tree**

* A **self-balancing BST** with the following rules:
  * Nodes are either **Red** or **Black**.
  * **Root is always black**.
  * **Red nodes cannot be consecutive**.
  * **All paths from root to leaves have the same number of black nodes**.
* **Height**: O(log⁡n)

### **6. B-Trees & B+ Trees**

* **B-Tree**: A **self-balancing multi-way tree** (used in databases).
* **B+ Tree**: Variation of B-tree where **all values are stored in leaf nodes** (used in file systems).
* **Height**: O(log⁡n)

### **7. Trie (Prefix Tree)**

* A tree where **each path represents a prefix of a word**.
* Used in **autocomplete, spell-checkers**.
* **Height**: O(m)where m is the length of the longest word.

```plaintext
         (root)
         /  |  \
        a   b   c
       / \   \
      p   r   t
     /     \
    p       e
```

(Stores "apple", "ape", "bat", "cat")

### **8. Segment Tree**

* A tree used for **range queries and updates** (sum, min, max).
* **Height**: O(log⁡n).
* Example: **Finding the sum of elements in an array from index 2 to 5**.

### **9. Fenwick Tree (Binary Indexed Tree - BIT)**

* A **more space-efficient version of a segment tree**.
* Used for **fast prefix sum calculations**.
* **Height**: O(log⁡n)

### **10. Heap (Min Heap, Max Heap)**

* A **complete binary tree** where:
  * **Min-Heap**: Parent ≤ Children.
  * **Max-Heap**: Parent ≥ Children.
* Used in **priority queues**.
* **Height**: O(log⁡n).
* **Breadth**: 2^(h−1).

```plaintext
         1
       /   \
      3     5
     / \   / \
    7   9 11  13
```

(Min-Heap example)

### **11. Suffix Tree**

* A compressed **Trie** used for **string matching**.
* **Height**: O(m).
* Used in **bioinformatics, search engines**.

## **Comparisons of Tree Types**

<table data-full-width="true"><thead><tr><th>Tree Type</th><th width="235">Structure</th><th>Height</th><th>Breadth</th><th>Use Case</th></tr></thead><tbody><tr><td>General Tree</td><td>Any number of children</td><td>O(n)</td><td>O(n)</td><td>Hierarchical data</td></tr><tr><td>Binary Tree</td><td>At most 2 children</td><td>O(n)</td><td>O(n)</td><td>Basic tree structure</td></tr><tr><td>BST</td><td>Sorted Binary Tree</td><td>O(log n)</td><td>O(log n)</td><td>Searching</td></tr><tr><td>AVL Tree</td><td>Self-balancing BST</td><td>O(log n)</td><td>O(log n)</td><td>Fast lookups</td></tr><tr><td>Red-Black Tree</td><td>Self-balancing BST</td><td>O(log n)</td><td>O(log n)</td><td>Efficient insertions</td></tr><tr><td>Trie</td><td>Prefix-based</td><td>O(m)</td><td>O(n)</td><td>Autocomplete, dictionaries</td></tr><tr><td>Segment Tree</td><td>Interval-based</td><td>O(log n)</td><td>O(log n)</td><td>Range queries</td></tr><tr><td>Heap</td><td>Complete Binary Tree</td><td>O(log n)</td><td>O(2^h)</td><td>Priority Queues</td></tr></tbody></table>





