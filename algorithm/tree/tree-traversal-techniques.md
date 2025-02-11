# Tree Traversal Techniques

## **About**

Tree traversal refers to the process of systematically visiting all nodes of a tree in a specific order. There are two main categories of traversal techniques:

1. **Depth-First Traversal (DFS)**
   * **Preorder Traversal (Root → Left → Right)**
   * **Inorder Traversal (Left → Root → Right)**
   * **Postorder Traversal (Left → Right → Root)**
2. **Breadth-First Traversal (BFS)**
   * **Level Order Traversal (Top to Bottom, Left to Right at each level)**

## **1. Depth First Search (DFS)**

Depth First Search (DFS) is a fundamental tree and graph traversal algorithm that explores as far as possible along each branch before backtracking. It follows the **LIFO (Last In, First Out)** principle using either recursion (implicitly using the call stack) or an explicit stack data structure.

#### **Characteristics**

* **Explores the depth of the tree/graph first** before visiting siblings.
* Uses **backtracking** to revisit previous nodes when it reaches a dead-end.
* Often implemented using **recursion** or a **stack**.
* **Time Complexity**: O(V+E) where **V** is the number of vertices (nodes) and **E** is the number of edges.
* **Space Complexity**: O(h) for recursive DFS (where h is the height of the tree), or O(V) in the worst case when storing all nodes.

#### **DFS Traversal Order**

DFS can be performed in different orders, leading to three types of **tree traversals**:

1. **Preorder Traversal** (Root → Left → Right)
2. **Inorder Traversal** (Left → Root → Right)
3. **Postorder Traversal** (Left → Right → Root)

### **1.1 Preorder Traversal**

Preorder traversal is a method of visiting the nodes of a tree where the **root node is processed first**, followed by the **left subtree**, and then the **right subtree**.

#### **Traversal Order**

1. Visit the **root** node.
2. Recursively traverse the **left subtree**.
3. Recursively traverse the **right subtree**.

```java
private void preorderRec(TreeNode root) {
        if (root != null) {
            System.out.print(root.data + " ");
            preorderRec(root.left);
            preorderRec(root.right);
        }
}
```

#### **Characteristics**

* **Starts at the root** and processes it before its children.
* **Used to create a copy of the tree** since the root is visited before its subtrees.
* **Commonly used for expression trees**, where operators are visited before operands.
* **Time Complexity**: O(n), where n is the number of nodes.
* **Space Complexity**: O(h) (recursive stack space), where h is the height of the tree.

#### **Example Use Cases**

* **Prefix Notation (Polish Notation)** in expression trees.
* Used in **serialization and deserialization** of a tree.
* Finding **parent-child relationships** in hierarchical structures.

### **1.2 Inorder Traversal**

Inorder traversal processes the nodes of a tree by **visiting the left subtree first**, then the **root**, and finally the **right subtree**. (Ascending order)

#### **Traversal Order**

1. Recursively traverse the **left subtree**.
2. Visit the **root** node.
3. Recursively traverse the **right subtree**.

```java
private void inorderRec(TreeNode root) {
        if (root != null) {
            inorderRec(root.left);
            System.out.print(root.data + " ");
            inorderRec(root.right);
        }
}
```

#### **Characteristics**

* Visits **nodes in sorted order for a Binary Search Tree (BST)**.
* **Used for in-order processing of hierarchical data**.
* **Time Complexity**: O(n), where n is the number of nodes.
* **Space Complexity**: O(h) (recursive stack space).

#### **Example Use Cases**

* Extracting sorted elements from a BST.
* Solving mathematical expressions, where operands appear in natural order.
* Reconstructing a BST from sorted data.

### **1.3 Postorder Traversal**

Postorder traversal is a method where the **left subtree is processed first**, followed by the **right subtree**, and then the **root node**.

#### **Traversal Order**

1. Recursively traverse the **left subtree**.
2. Recursively traverse the **right subtree**.
3. Visit the **root** node.

```java
private void postorderRec(TreeNode root) {
        if (root != null) {
            postorderRec(root.left);
            postorderRec(root.right);
            System.out.print(root.data + " ");
        }
}
```

#### **Characteristics**

* **Useful for deleting nodes** in hierarchical structures.
* **Used in expression trees** where operands are processed before operators (Reverse Polish Notation).
* **Time Complexity**: O(n), where n is the number of nodes.
* **Space Complexity**: O(h) (recursive stack space).

#### **Example Use Cases**

* Deleting a tree in a bottom-up manner.
* Postfix Notation (Reverse Polish Notation) evaluation in expression trees.
* Dependency resolution (e.g., in build systems like Make).

## **2. Breadth First Search (BFS) or Level Order Traversal**

Breadth First Search (BFS) is a traversal algorithm that **explores all nodes at a given depth level before moving to the next level**. It follows the **FIFO (First In, First Out) principle**, typically implemented using a **queue**.

#### **Traversal Order**

1. Start at the **root**.
2. Visit all nodes at **level 1** (children of root).
3. Visit all nodes at **level 2**, then **level 3**, and so on.

#### **Characteristics**

* **Explores nodes level by level** rather than diving deep like DFS.
* Uses a **queue** to process nodes in the order they were discovered.
* **Time Complexity**: O(n) as each node is visited once.
* **Space Complexity**: O(n) in the worst case (storing all nodes in the queue at the last level).

#### **Example Use Cases**

* **Shortest path problems** (e.g., in graphs, BFS finds the shortest path in an unweighted graph).
* **Finding connected components** in a graph.
* **Network broadcasting**, where messages need to be sent to all users level-wise.
* **Scheduling processes** where tasks need to be executed in order of dependency levels.

## **Key Differences Between DFS and BFS**

<table data-full-width="true"><thead><tr><th width="240">Feature</th><th>Depth First Search (DFS)</th><th>Breadth First Search (BFS)</th></tr></thead><tbody><tr><td><strong>Traversal Order</strong></td><td>Goes <strong>deep first</strong>, then backtracks</td><td>Explores <strong>level by level</strong></td></tr><tr><td><strong>Data Structure</strong></td><td>Uses <strong>Stack (Recursion or Explicit Stack)</strong></td><td>Uses <strong>Queue</strong></td></tr><tr><td><strong>Best Use Case</strong></td><td>Works well for <strong>deep trees</strong></td><td>Works well for <strong>wide trees</strong></td></tr><tr><td><strong>Time Complexity</strong></td><td>O(V+E)</td><td>O(V+E)</td></tr><tr><td><strong>Space Complexity</strong></td><td>O(h) (recursive depth)</td><td>O(n) (storing nodes in queue)</td></tr><tr><td><strong>Applications</strong></td><td>Solving mazes, backtracking, topological sorting</td><td>Shortest paths, graph connectivity, AI pathfinding</td></tr></tbody></table>

