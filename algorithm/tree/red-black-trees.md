# Red-Black Trees

## About

In a regular **Binary Search Tree (BST)**, if we insert sorted data (say, 1, 2, 3, 4, ...), the tree becomes **unbalanced**, and performance degrades to **O(n)** — just like a linked list.

Self-balancing BSTs, such as **AVL Trees** and **Red-Black Trees**, solve this by **automatically restructuring** the tree to keep it balanced, so that all major operations (insert, delete, search) always stay **O(log n)** in time.

## Why the Red-Black Coloring ?

The idea behind the color system is to encode **balancing constraints** without storing height values (as AVL Trees do).

By tagging each node as **red** or **black**, we can:

* Enforce rules that keep paths from root to leaf relatively even in length.
* Use color flips and rotations to maintain balance after inserts or deletes, **without always recalculating heights**.

The coloring introduces **logical boundaries**, helping maintain a reasonably balanced structure with **fewer rotations than AVL Trees**.

#### Color Example

Consider this small Red-Black Tree:

```
        10(B)
       /    \
    5(R)    15(R)
```

* Root is black.
* Children are red.
* All paths have the same number of black nodes.&#x20;

## Why Red-Black Trees ?

* To maintain **logarithmic time complexity** for insertion, deletion, and lookup:
  * **O(log n)** for search, insert, delete.
* To avoid worst-case performance in unbalanced trees (like linked list structure in plain BSTs).
* Red-Black Trees are **less rigidly balanced** than AVL Trees, so insertions/deletions are faster in practice.

## What is Black Height ?

The **black height** of a node is the number of **black nodes on any path** from that node to its descendant leaves (excluding itself, including the leaves).

Red-black properties ensure that:

* The shortest path has only black nodes.
* The longest path alternates red and black, i.e., is **at most twice as long** as the shortest.

So even in the worst case, the tree doesn’t grow too tall.

## Properties

To ensure balance, every Red-Black Tree must follow these **5 properties**:

1. **Every node is either red or black.**
2. **The root is always black.**
3. **All leaves (nulls or NILs) are considered black.**
4. **Red nodes cannot have red children** (i.e., no two red nodes can be adjacent).
5. **Every path from a node to its descendant NIL nodes must have the same number of black nodes.**

This consistent black node count is called **black-height**.

### Example

We’ll build a Red-Black Tree from the following sequence of insertions:

**Insert:** 10, 20, 30, 15, 25, 5, 1

Let’s walk through the tree structure **after all insertions**, assuming proper rotations and recoloring have taken place to maintain Red-Black properties.

#### **Final Tree Structure**

```
         20 (Black)
        /         \
    10 (Red)     25 (Black)
   /     \           \
5 (Black) 15 (Black) 30 (Red)
 /
1 (Red)
```

#### **Color Assignment**

* `20`: Black → root must be black
* `10`: Red → red child of black (OK)
* `25`: Black
* `5`: Black → black child of red (OK)
* `15`: Black
* `30`: Red
* `1`: Red

#### **Red-Black Tree Properties Validation**

Let’s validate **all 5 Red-Black Tree properties** on this example:

#### **Property 1: Every node is either red or black**

All nodes have been assigned either red or black.

* Red nodes: `10`, `30`, `1`
* Black nodes: `20`, `5`, `15`, `25`

Valid

#### **Property 2: The root is black**

Root = `20` (Black)

Valid

#### **Property 3: All leaves (null children) are black**

All `null` children (not shown in diagram) are considered black.

Valid

#### **Property 4: If a node is red, then both its children are black**

Check all red nodes:

* `10`: Children = `5` (Black), `15` (Black)
* `1`: Both children are null (nulls are black)
* `30`: Child is null (null is black)

Valid

#### **Property 5: Every path from a node to its descendant leaves has the same number of black nodes**

Let’s count black nodes on different paths from root (`20`) to leaves:

1. `20 → 10 → 5 → 1 → null` = `Black(20), Red(10), Black(5), Red(1), null` → 3 black nodes
2. `20 → 10 → 15 → null` = `Black(20), Red(10), Black(15), null` → 3 black nodes
3. `20 → 25 → 30 → null` = `Black(20), Black(25), Red(30), null` → 3 black nodes

All paths have **exactly 3 black nodes**

## **Red-Black Tree** Insertion & Deletion Logic

### **Insertion Logic**

When inserting into a **Red-Black Tree**, we want to:

1. Keep the **Binary Search Tree (BST)** property.
2. Restore all **Red-Black properties** after insertion.

#### Step 1: Insert as a Red Node

* Insert the new node just like in a regular BST.
* Color the new node **red** (this helps with maintaining the black-height).
* If the new node becomes the root, recolor it to **black**.

#### Step 2: Fix Violations (Balancing Phase)

There may be a violation of the Red-Black rules — specifically:

* If the **parent** of the new node is **black** → no violation.
* If the **parent** is **red** → violation of the "no two reds in a row" rule.

Depending on the color of the **uncle** (the sibling of the parent), we take different actions:

#### Case 1: Uncle is Red (Recoloring)

* Recolor the **parent** and **uncle** to black.
* Recolor the **grandparent** to red.
* Move the current pointer to the grandparent and repeat the process up the tree.

This case reduces red-red conflicts but may propagate the problem upward.

#### Case 2: Uncle is Black or Null (Rotation + Recoloring)

There are 4 sub-cases based on the direction of insertion:

* **Left-Left (LL)**: Right rotation at grandparent.
* **Right-Right (RR)**: Left rotation at grandparent.
* **Left-Right (LR)**: Left rotation at parent, then right rotation at grandparent.
* **Right-Left (RL)**: Right rotation at parent, then left rotation at grandparent.

After the rotations:

* Recolor the nodes so that the new parent becomes black and the two children are red.

These operations ensure:

* The red-red violation is fixed.
* The black-height remains balanced.

#### Final Step

Always ensure that the **root node is black** at the end.

### **Deletion Logic**

Deletion is more complex than insertion because removing a node — especially a **black node** — can disturb the black-height.

#### Step 1: Perform BST Deletion

* Use the standard BST delete logic:
  * If the node has two children, find its **in-order successor** and replace the node with it.
  * Then, delete the successor.

At this point, we might be deleting:

* A **red node** → no problem.
* A **black node** → this causes a **"black height deficit"**, which we need to fix.

#### Step 2: Fix Double Black Problem

After deleting a black node, the tree might temporarily contain an invalid state called **"double black"**, meaning a node that is missing a black count compared to its siblings.

We fix it based on the **sibling’s color** and its children’s colors.

#### Case 1: Sibling is Red

* Rotate at the parent to make the sibling black.
* This transforms the problem into a situation with a black sibling (Case 2 or 3).

#### Case 2: Sibling is Black and its children are both black

* Recolor the sibling to red.
* Move the "double black" problem up to the parent.

#### Case 3: Sibling is Black and has at least one red child

* Perform appropriate rotation based on the structure.
* Recolor the sibling and parent to restore Red-Black properties.
* After this, the tree is valid again.

#### Special Case: Deleting the Root

* If the deleted node was the root, no double black arises.
* Just remove the root and you're done.

## **Balancing via Rotation**

### **Why Rotation Is Needed**

Red-Black Trees enforce strict color and structural rules to maintain balance. When we insert or delete a node, these rules might get violated.

To **restore the red-black properties**, the tree must:

* **Restructure itself** (using rotations)
* Possibly **recolor** nodes

Rotations help **reorganize the nodes** without breaking the binary search tree (BST) ordering property.

### **Types of Rotations**

There are two basic types of rotations:

**1. Left Rotation**

* Shifts nodes **counter-clockwise**.
* Used when a new red node is inserted as a **right child** and causes a red-red violation.

**2. Right Rotation**

* Shifts nodes **clockwise**.
* Used when a new red node is inserted as a **left child** and causes a red-red violation.

Each of these can be visualized as rearranging a small 3-node subtree to change shape but preserve the BST ordering.

#### **Left Rotation**

Let’s say:

```
    x
     \
      y
     / 
    T1
```

After **left rotate(x)**:

```
      y
     / \
    x  T1
```

**Step-by-step:**

1. `y` becomes new parent
2. `x` becomes left child of `y`
3. `T1` becomes right child of `x`

This rotation is useful when a right-heavy subtree needs to be balanced.

#### **Right Rotation**

Let’s say:

```
      y
     /
    x
     \
     T1
```

After **right rotate(y)**:

```
      x
     / \
   T1   y
```

**Step-by-step:**

1. `x` becomes new parent
2. `y` becomes right child of `x`
3. `T1` becomes left child of `y`

This rotation helps when a left-heavy subtree needs to be corrected.

### **When Rotations Are Used**

Rotations are used in **specific cases during insertion or deletion**:

**Insertion Case:**

* A **red-red violation** (both child and parent red) occurs
* If the **uncle node is black**, we use **rotation + recoloring**

**Deletion Case:**

* A black node is removed, which may cause **black-height imbalance**
* Rotations help push extra blackness or rearrange black nodes

### **Double Rotations (Left-Right or Right-Left)**

Sometimes, a single rotation is not enough to restore balance.

**Example:**

A red node is inserted as the **left-right child** (left child’s right subtree). This needs:

1. **Left rotation on the child**
2. **Right rotation on the parent**

These are called **double rotations** and are combinations of the basic ones.

### **How Rotations Preserve BST Property**

During a rotation:

* The **in-order relationship** among nodes remains unchanged.
* Only the **structure changes**, not the relative positions of values.

This ensures the rotated tree is still a valid Binary Search Tree.

#### **Effect of Rotations on Red-Black Properties**

| Property                    | Impact During Rotation   |
| --------------------------- | ------------------------ |
| Binary Search Tree property | Always preserved         |
| Red-red violation           | Resolved if applicable   |
| Black-height balance        | Restored via rotation    |
| Path length uniformity      | <p></p><p>Maintained</p> |

## Time Complexity

For a tree with `n` nodes:

* **Search:** O(log n)
* **Insert:** O(log n)
* **Delete:** O(log n)

Even in the worst case, the tree stays balanced enough to keep log-time performance.

## Java Implementation

```java
// Java implementation of Red-Black Tree with Insertion and Deletion
// Includes explanation as inline comments

public class RedBlackTree {

    private static final boolean RED = true;
    private static final boolean BLACK = false;

    class Node {
        int data;
        Node left, right, parent;
        boolean color;

        Node(int data) {
            this.data = data;
            this.color = RED;
        }
    }

    private Node root;

    // Left Rotation
    private void rotateLeft(Node x) {
        Node y = x.right;
        x.right = y.left;
        if (y.left != null) y.left.parent = x;
        y.parent = x.parent;
        if (x.parent == null) root = y;
        else if (x == x.parent.left) x.parent.left = y;
        else x.parent.right = y;
        y.left = x;
        x.parent = y;
    }

    // Right Rotation
    private void rotateRight(Node x) {
        Node y = x.left;
        x.left = y.right;
        if (y.right != null) y.right.parent = x;
        y.parent = x.parent;
        if (x.parent == null) root = y;
        else if (x == x.parent.left) x.parent.left = y;
        else x.parent.right = y;
        y.right = x;
        x.parent = y;
    }

    // Insertion fixup to maintain red-black properties
    private void fixInsert(Node z) {
        while (z.parent != null && z.parent.color == RED) {
            if (z.parent == z.parent.parent.left) {
                Node y = z.parent.parent.right; // uncle
                if (y != null && y.color == RED) {
                    z.parent.color = BLACK;
                    y.color = BLACK;
                    z.parent.parent.color = RED;
                    z = z.parent.parent;
                } else {
                    if (z == z.parent.right) {
                        z = z.parent;
                        rotateLeft(z);
                    }
                    z.parent.color = BLACK;
                    z.parent.parent.color = RED;
                    rotateRight(z.parent.parent);
                }
            } else {
                Node y = z.parent.parent.left; // uncle
                if (y != null && y.color == RED) {
                    z.parent.color = BLACK;
                    y.color = BLACK;
                    z.parent.parent.color = RED;
                    z = z.parent.parent;
                } else {
                    if (z == z.parent.left) {
                        z = z.parent;
                        rotateRight(z);
                    }
                    z.parent.color = BLACK;
                    z.parent.parent.color = RED;
                    rotateLeft(z.parent.parent);
                }
            }
        }
        root.color = BLACK;
    }

    public void insert(int data) {
        Node node = new Node(data);
        Node y = null;
        Node x = root;

        while (x != null) {
            y = x;
            if (node.data < x.data)
                x = x.left;
            else
                x = x.right;
        }

        node.parent = y;
        if (y == null) root = node;
        else if (node.data < y.data) y.left = node;
        else y.right = node;

        fixInsert(node);
    }

    // Transplant helper (used in deletion)
    private void transplant(Node u, Node v) {
        if (u.parent == null) root = v;
        else if (u == u.parent.left) u.parent.left = v;
        else u.parent.right = v;
        if (v != null) v.parent = u.parent;
    }

    // Find minimum node
    private Node minimum(Node x) {
        while (x.left != null) x = x.left;
        return x;
    }

    // Deletion fixup to maintain red-black properties
    private void fixDelete(Node x) {
        while (x != root && colorOf(x) == BLACK) {
            if (x == x.parent.left) {
                Node w = x.parent.right;
                if (colorOf(w) == RED) {
                    w.color = BLACK;
                    x.parent.color = RED;
                    rotateLeft(x.parent);
                    w = x.parent.right;
                }
                if (colorOf(w.left) == BLACK && colorOf(w.right) == BLACK) {
                    w.color = RED;
                    x = x.parent;
                } else {
                    if (colorOf(w.right) == BLACK) {
                        w.left.color = BLACK;
                        w.color = RED;
                        rotateRight(w);
                        w = x.parent.right;
                    }
                    w.color = x.parent.color;
                    x.parent.color = BLACK;
                    w.right.color = BLACK;
                    rotateLeft(x.parent);
                    x = root;
                }
            } else {
                Node w = x.parent.left;
                if (colorOf(w) == RED) {
                    w.color = BLACK;
                    x.parent.color = RED;
                    rotateRight(x.parent);
                    w = x.parent.left;
                }
                if (colorOf(w.right) == BLACK && colorOf(w.left) == BLACK) {
                    w.color = RED;
                    x = x.parent;
                } else {
                    if (colorOf(w.left) == BLACK) {
                        w.right.color = BLACK;
                        w.color = RED;
                        rotateLeft(w);
                        w = x.parent.left;
                    }
                    w.color = x.parent.color;
                    x.parent.color = BLACK;
                    w.left.color = BLACK;
                    rotateRight(x.parent);
                    x = root;
                }
            }
        }
        if (x != null) x.color = BLACK;
    }

    private boolean colorOf(Node node) {
        return node == null ? BLACK : node.color;
    }

    public void delete(int data) {
        Node z = root;
        while (z != null && z.data != data) {
            if (data < z.data) z = z.left;
            else z = z.right;
        }
        if (z == null) return;

        Node y = z;
        boolean yOriginalColor = y.color;
        Node x;

        if (z.left == null) {
            x = z.right;
            transplant(z, z.right);
        } else if (z.right == null) {
            x = z.left;
            transplant(z, z.left);
        } else {
            y = minimum(z.right);
            yOriginalColor = y.color;
            x = y.right;
            if (y.parent == z) {
                if (x != null) x.parent = y;
            } else {
                transplant(y, y.right);
                y.right = z.right;
                y.right.parent = y;
            }
            transplant(z, y);
            y.left = z.left;
            y.left.parent = y;
            y.color = z.color;
        }

        if (yOriginalColor == BLACK && x != null)
            fixDelete(x);
    }

    // In-order traversal to test tree contents
    public void inorder() {
        inorderHelper(root);
        System.out.println();
    }

    private void inorderHelper(Node node) {
        if (node != null) {
            inorderHelper(node.left);
            System.out.print(node.data + " ");
            inorderHelper(node.right);
        }
    }

    public static void main(String[] args) {
        RedBlackTree tree = new RedBlackTree();
        int[] values = {20, 15, 25, 10, 18, 30, 5};
        for (int v : values) tree.insert(v);
        System.out.print("Inorder after insertion: ");
        tree.inorder();

        tree.delete(15);
        System.out.print("Inorder after deleting 15: ");
        tree.inorder();
    }
}

```

## Structure of Red-Black Tree vs AVL Tree

Red-Black Trees tend to look more **bushy** (wider and shallower), while AVL Trees are more **tightly balanced** (more height-aware).

Example of tree heights:

* **AVL Tree**: height \~ 1.44 log₂(n)
* **Red-Black Tree**: height \~ 2 log₂(n)

So Red-Black Trees can afford a little imbalance in favor of **fewer rotations**.

{% hint style="success" %}
#### Red-Black Trees Are Not Perfectly Balanced

Unlike AVL Trees, Red-Black Trees:

* **Allow some imbalance** (up to 2x difference in path lengths)
* **Prioritize fewer rotations** over strict height balance

This tradeoff is preferred in environments where insertions and deletions are frequent.
{% endhint %}
