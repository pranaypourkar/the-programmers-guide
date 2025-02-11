# Tree

## About Tree Data Structure

A **Tree** is a non-linear data structure used to represent hierarchical relationships between elements. It consists of **nodes** connectedT by **edges**, with one node designated as the **root**. Unlike arrays, stacks, or linked lists, which store data sequentially, trees are structured to allow for efficient searching, insertion, and deletion operations.

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

### **Examples of Trees**

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

## Tree Height, Depth & Breadth

### **1. Height of a Tree**

The **height of a tree** is defined as the **length of the longest path from the root node to a leaf node**. It represents the maximum number of edges from the root to any leaf.

* **Root node height** = The height of the entire tree.
* **Leaf node height** = Always `0`, as there are no children below it.

#### **How to Calculate the Height of a Tree?**

1. Start at the **root node**.
2. Recursively find the **height of all child subtrees**.
3. The height of the tree is `1 + max(height of all child subtrees)`.
4. If the tree has no nodes, the height is **-1** (for edge-based height) or **0** (for node-based height).

**Example:**

```
       A
      / \
     B   C
    /   / \
   D   E   F
  /
 G
```

* `G` is a **leaf node** → Height = `0`
* `D` has one child `G` → Height = `1`
* `B` has one child `D` → Height = `2`
* `E` and `F` are **leaves** → Height = `0`
* `C` has two children `E` and `F` → Height = `1`
* `A` (root) has two children `B` (Height `2`) and `C` (Height `1`) → **Height = `3`**

Thus, **Height of Tree = 3**.

### **2. Depth of a Node**

The **depth of a node** is the number of edges from the root to that node.

* **Root node depth** = Always `0`.
* **Child node depth** = `1 + depth of its parent`.

#### **How to Calculate the Depth of a Node?**

1. Start at the **root node (depth = 0)**.
2. Move down the tree, increasing depth by **1** at each level.
3. The depth of a node is the **number of edges from the root to that node**.

**Example:**

```
mathematicaCopyEdit       A (Depth 0)
      / \
     B   C  (Depth 1)
    /   / \
   D   E   F  (Depth 2)
  /
 G  (Depth 3)
```

* **Depth(A) = 0** (root node)
* **Depth(B) = 1**, **Depth(C) = 1** (children of A)
* **Depth(D) = 2**, **Depth(E) = 2**, **Depth(F) = 2** (children of B and C)
* **Depth(G) = 3** (child of D)

{% hint style="success" %}
#### **Edge-Based vs. Node-Based Height**

* **Edge-Based Height**: The number of **edges** in the longest path to a leaf (common in CS).
* **Node-Based Height**: The number of **nodes** in the longest path (sometimes used in theoretical problems).

For a tree with a **single node**,

* **Edge-Based Height** = `-1`
* **Node-Based Height** = `0`
{% endhint %}

### **3. Breadth of a Tree**

The **breadth of a tree** is the **maximum number of nodes at any level**.

For example:

```
       A
      / \
     B   C
    /   / \
   D   E   F
  /
 G
```

* Level 0: `A` → 1 node
* Level 1: `B, C` → 2 nodes
* Level 2: `D, E, F` → 3 nodes (**maximum**)
* Level 3: `G` → 1 node

**Breadth of this tree = 3** (since level 2 has the most nodes).

## Balanced and Unbalanced Tree

### **1. What is a Balanced Tree?**

A **Balanced Tree** is a tree in which the height difference between the left and right subtrees of any node is **at most 1**. This ensures that the tree remains efficient for operations like searching, inserting, and deleting.

**Characteristics of a Balanced Tree:**

* The difference in height (Balance Factor) between the left and right subtrees of every node is **at most 1**.
* Searching, inserting, and deleting operations run in **O(log N)** time.
* Prevents the tree from becoming too deep and inefficient.

**Examples of Balanced Trees:**

* **AVL Tree:** Self-balancing binary search tree where balance factor is maintained between `-1` and `1`.
* **Red-Black Tree:** A balanced binary search tree used in many libraries (e.g., TreeMap in Java).
* **B-Trees & B+ Trees:** Used in databases for indexing.
* **Heap (Min Heap / Max Heap):** Ensures a balanced structure to maintain efficient extraction of min/max.
* The height difference between left and right subtrees for every node is **≤1**.
* **Height = log(N)** → Searching is efficient.

**Example of a Balanced Tree**

```
        10
       /  \
      5    15
     / \   /  \
    2   7 12  18
   / \     \
  1   3     13
```

**Balance Factor Calculation**

All nodes have balance factors between `-1` and `1`, so this tree is balanced.

<table data-header-hidden data-full-width="true"><thead><tr><th width="175"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Node</strong></td><td><strong>Left Subtree Height</strong></td><td><strong>Right Subtree Height</strong></td><td><strong>Balance Factor (Left - Right)</strong></td></tr><tr><td>10</td><td>3</td><td>3</td><td>0</td></tr><tr><td>5</td><td>2</td><td>2</td><td>0</td></tr><tr><td>15</td><td>1</td><td>2</td><td>-1</td></tr><tr><td>2</td><td>1</td><td>1</td><td>0</td></tr><tr><td>7</td><td>0</td><td>1</td><td>-1</td></tr><tr><td>12</td><td>0</td><td>1</td><td>-1</td></tr><tr><td>18</td><td>0</td><td>0</td><td>0</td></tr></tbody></table>

### **2. What is an Unbalanced Tree?**

An **Unbalanced Tree** is a tree in which the height difference between the left and right subtrees is greater than 1, leading to inefficiencies in operations.

**Characteristics of an Unbalanced Tree:**

* The height of one subtree is much greater than the other.
* Searching, inserting, and deleting operations can take **O(N)** time instead of **O(log N)**.
* The tree resembles a **linked list** in extreme cases (degenerate tree).
* The height of the tree is **N** instead of **log(N)**.
* Searching for `4` requires **O(N)** operations instead of **O(log N)**.

**Examples of Unbalanced Trees:**

* **Skewed Binary Tree:** All nodes are aligned to one side.
* **Degenerate Tree:** Every node has only one child, forming a linked list.

**Example of an Unbalanced Tree (Right-Skewed):**

```
       1
        \
         2
          \
           3
            \
             4
```

#### **Example of an Unbalanced Tree (Without Being Skewed)**

```
        10
       /  \
      5    15
     / \      \
    2   7      18
   /            \
  1              20
```

**Balance Factor Calculation**

* **Node 15 has a balance factor of `-2`**, making the tree **unbalanced**.
* Although the left subtree of 10 is balanced, the right subtree is **too deep**.
* Searching for **20** would take longer than expected.

<table data-header-hidden data-full-width="true"><thead><tr><th width="135"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Node</strong></td><td><strong>Left Subtree Height</strong></td><td><strong>Right Subtree Height</strong></td><td><strong>Balance Factor (Left - Right)</strong></td></tr><tr><td>10</td><td>2</td><td>3</td><td><strong>-1</strong> (Balanced)</td></tr><tr><td>5</td><td>2</td><td>1</td><td><strong>1</strong> (Balanced)</td></tr><tr><td>15</td><td>0</td><td>2</td><td><strong>-2</strong> (Unbalanced) <strong>X</strong></td></tr><tr><td>2</td><td>1</td><td>0</td><td><strong>1</strong> (Balanced)</td></tr><tr><td>7</td><td>0</td><td>0</td><td><strong>0</strong> (Balanced)</td></tr><tr><td>18</td><td>0</td><td>1</td><td><strong>-1</strong> (Balanced)</td></tr><tr><td>1</td><td>0</td><td>0</td><td><strong>0</strong> (Balanced)</td></tr><tr><td>20</td><td>0</td><td>0</td><td><strong>0</strong> (Balanced)</td></tr></tbody></table>

### **3. Why Should a Tree Be Balanced?**

* **Ensures Fast Operations**: A balanced tree guarantees that operations like searching, inserting, and deleting run in **O(log N)** time.
* **Prevents Performance Degradation**: An unbalanced tree degenerates into a linked list, leading to inefficient operations.
* **Used in Many Real-World Applications**: Databases (B-Trees), Memory Management (Heap), and File Systems (Trie) rely on balanced trees.

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

A **Binary Search Tree (BST)** is a **binary tree** in which:

* Each node has at most two children (left and right).
* The left subtree contains only nodes with values smaller than the parent node.
* The right subtree contains only nodes with values greater than the parent node.
* The left and right subtrees must also be BSTs.
* Used for **efficient searching**.
* Height: O(log⁡n) (balanced), O(n) (worst case).

#### **Example of a BST**

```
        10
       /  \
      5    15
     / \   /  \
    2   7 12  20
```

**BST Property Holds:**

* Left subtree of `10` → `{5, 2, 7}` (All values < 10)&#x20;
* Right subtree of `10` → `{15, 12, 20}` (All values > 10)&#x20;
* This rule applies to all nodes recursively.

A Non-Binary Search Tree is any tree that does not follow the BST property. It can be:

1. A Binary Tree that does not maintain BST ordering.
2. A tree that is not even binary (i.e., nodes have more than two children).

**Example of a Non-Binary Search Tree (Binary but not BST)**

```
        10
       /  \
      5    15
     / \   /  \
    12  2 7   20
```

**Not a BST because:**

* The left subtree of `5` contains `12`, but `12 > 5`
* The right subtree of `15` contains `7`, but `7 < 15`

This is **not a BST**, even though it is a **binary tree**.

**Example of a Non-Binary Search Tree (Non-Binary)**

A **General Tree** where each node can have **more than two children**:

```
        A
       /|\
      B C D
     / \   \
    E   F   G
```

**Not a BST because:**

* **More than two children per node**&#x20;
* **No strict left < parent < right rule**

This is an **n-ary tree** and does not qualify as a BST.

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

A **Trie** (pronounced "try") is a **tree-based data structure** used to store strings efficiently for fast retrieval. It is also called a **prefix tree** because all common prefixes are shared among words.

**Features of a Trie:**

* Each node represents a character in a string.
* The root node represents an empty string.
* Each path from the root to a leaf forms a word.
* Efficient for **prefix-based searching, autocomplete, and dictionary implementations**.

**Structure of a Trie**

A Trie consists of:

1. **Nodes** – Each node contains:
   * A **character**
   * A **list of child nodes (pointers to next characters)**
   * A **flag to mark the end of a word**
2. **Edges** – Represent connections between characters.

#### **Example of a Trie storing "car", "cat", "bat", and "bar":**

```
        (root)
       /     \
      b       c
     / \      |
    a   a     a
   /     \    |
  r       t   r
              |
              t  
```

**Words Stored:** `"car"`, `"cat"`, `"bat"`, `"bar"`\
**Common Prefixes are Shared:** `"ca"` is shared between `"car"` and `"cat"`.

### **8. Segment Tree**

* A tree used for **range queries and updates** (sum, min, max).
* **Height**: O(log⁡n).
* Example: **Finding the sum of elements in an array from index 2 to 5**.

### **9. Fenwick Tree (Binary Indexed Tree - BIT)**

* A **more space-efficient version of a segment tree**.
* Used for **fast prefix sum calculations**.
* **Height**: O(log⁡n)

### **10. Heap (Min Heap, Max Heap)**

A **Heap** is a specialized tree-based **data structure** that satisfies the **Heap Property**. It is commonly used for **priority queues, scheduling algorithms, and efficient sorting techniques (Heap Sort).**

#### **1. What is a Heap?**

A **Heap** is a **complete binary tree** (every level is fully filled except possibly the last level, which is filled from left to right) that satisfies one of the following properties:

1. **Min Heap Property** → The **parent node is always smaller** than its children.
2. **Max Heap Property** → The **parent node is always greater** than its children.

#### **2. Min Heap**

A **Min Heap** is a binary tree where:

* The **root node is the smallest element** in the tree.
* Every parent node has a **value smaller than or equal to its children**.
* The **smallest element** is always at the root.

**Example of a Min Heap**

```
         2
       /   \
      5     7
     / \   / \
    10  15 17 25
```

**Min Heap Property Holds:**

* `2 < 5`, `2 < 7` (Root is smallest)
* `5 < 10`, `5 < 15`, `7 < 17`, `7 < 25`

**Operations in Min Heap**

| **Operation**                       | **Time Complexity**      |
| ----------------------------------- | ------------------------ |
| **Insertion**                       | `O(log N)`               |
| **Deletion (extract min)**          | `O(log N)`               |
| **Heapify (convert array to heap)** | `O(N)`                   |
| **Find Min**                        | `O(1)` (always the root) |

#### **3. Max Heap**

A **Max Heap** is a binary tree where:

* The **root node is the largest element** in the tree.
* Every parent node has a **value greater than or equal to its children**.
* The **largest element** is always at the root.

**Example of a Max Heap**

```
         25
       /    \
      17     10
     /  \   /  \
    7   5  2   15
```

&#x20;**Max Heap Property Holds:**

* `25 > 17`, `25 > 10` (Root is largest)
* `17 > 7`, `17 > 5`, `10 > 2`, `10 > 15`

**Operations in Max Heap**

| **Operation**                       | **Time Complexity**      |
| ----------------------------------- | ------------------------ |
| **Insertion**                       | `O(log N)`               |
| **Deletion (extract max)**          | `O(log N)`               |
| **Heapify (convert array to heap)** | `O(N)`                   |
| **Find Max**                        | `O(1)` (always the root) |

### **11. Suffix Tree**

* A compressed **Trie** used for **string matching**.
* **Height**: O(m).
* Used in **bioinformatics, search engines**.

## **Comparisons of Tree Types**

<table data-full-width="true"><thead><tr><th>Tree Type</th><th width="235">Structure</th><th>Height</th><th>Breadth</th><th>Use Case</th></tr></thead><tbody><tr><td>General Tree</td><td>Any number of children</td><td>O(n)</td><td>O(n)</td><td>Hierarchical data</td></tr><tr><td>Binary Tree</td><td>At most 2 children</td><td>O(n)</td><td>O(n)</td><td>Basic tree structure</td></tr><tr><td>BST</td><td>Sorted Binary Tree</td><td>O(log n)</td><td>O(log n)</td><td>Searching</td></tr><tr><td>AVL Tree</td><td>Self-balancing BST</td><td>O(log n)</td><td>O(log n)</td><td>Fast lookups</td></tr><tr><td>Red-Black Tree</td><td>Self-balancing BST</td><td>O(log n)</td><td>O(log n)</td><td>Efficient insertions</td></tr><tr><td>Trie</td><td>Prefix-based</td><td>O(m)</td><td>O(n)</td><td>Autocomplete, dictionaries</td></tr><tr><td>Segment Tree</td><td>Interval-based</td><td>O(log n)</td><td>O(log n)</td><td>Range queries</td></tr><tr><td>Heap</td><td>Complete Binary Tree</td><td>O(log n)</td><td>O(2^h)</td><td>Priority Queues</td></tr></tbody></table>





