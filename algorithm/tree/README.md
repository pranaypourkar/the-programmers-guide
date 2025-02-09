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





## Types of Trees

* **General Trees**
* **Binary Trees**
  * Full Binary Tree
  * Complete Binary Tree
  * Perfect Binary Tree
  * Balanced Binary Tree
  * Degenerate Tree
* **Binary Search Tree (BST)**
* **AVL Tree** (Self-Balancing BST)
* **Red-Black Tree**
* **B-Trees and B+ Trees**
* **Trie (Prefix Tree)**
* **Segment Tree**
* **Fenwick Tree (Binary Indexed Tree - BIT)**
* **Heap (Min Heap, Max Heap)**
* **Suffix Tree**







