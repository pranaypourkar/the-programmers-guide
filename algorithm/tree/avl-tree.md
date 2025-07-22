# AVL Tree

## About

An **AVL Tree** is a **self-balancing Binary Search Tree (BST)** named after its inventors Adelson-Velsky and Landis. It ensures that the tree remains approximately balanced at all times, keeping operations efficient.

In a regular Binary Search Tree, the performance can degrade to linear time (O(n)) in the worst case (e.g., when the tree becomes a linked list). An AVL Tree maintains a balance condition to ensure that the height of the tree remains logarithmic (O(log n)).

## **Balance Factor**

For every node in an AVL Tree:

```
Balance Factor = Height of Left Subtree - Height of Right Subtree
```

* If the balance factor of a node is **-1, 0, or 1**, then the node is **balanced**.
* If it is **less than -1** or **greater than 1**, the tree becomes **unbalanced** and needs **rebalancing** via rotations.

{% hint style="info" %}
### **Height of AVL Tree**

The height `h` of an AVL tree with `n` nodes is strictly `O(log n)`. This is what differentiates AVL trees from unbalanced BSTs.

AVL trees achieve this logarithmic height by ensuring no node gets too deep compared to its siblings.
{% endhint %}

## **AVL Tree Properties**

1. **Binary Search Tree Property**: Left subtree contains smaller values, right subtree contains larger values.
2. **Balance Factor Property**: For every node, the balance factor must be -1, 0, or +1.
3. **Height-balanced**: Ensures tree height stays in O(log n).
4. **All operations** (insertion, deletion, search) take O(log n) time due to the balance condition.

## Rotations in AVL Trees

When we insert or delete nodes in an AVL tree, the balance factor (difference in height between the left and right subtrees) of certain nodes might become more than 1 or less than -1. This violates the AVL tree property of being balanced.

To restore balance, **rotations** are used. A rotation is a **local rearrangement of nodes** in a small part of the tree (typically three nodes) to rebalance it.

{% hint style="warning" %}
Rotations can also be needed after deletion. Deletion might cause height imbalance going up the tree. At each ancestor node, we must:

* Recalculate height and balance factor.
* Apply the appropriate rotation based on the case.
{% endhint %}

#### **Types of Rotations**

There are **four kinds of rotations** used in AVL trees, based on how the imbalance occurs:

### **1. Right Rotation (RR Rotation)**

**When to use:**\
Occurs when a node is inserted into the **left subtree of the left child** (Left-Left case).

**Structure before rotation**

```
      z
     /
    y
   /
  x
```

**Steps:**

* Make `y` the new root of this subtree.
* Move `z` to the right of `y`.
* Move the right subtree of `y` (if any) to be the left subtree of `z`.

**After rotation**

```
      y
     / \
    x   z
```

### **2. Left Rotation (LL Rotation)**

**When to use:**\
Occurs when a node is inserted into the **right subtree of the right child** (Right-Right case).

**Structure before rotation**

```
    z
     \
      y
       \
        x
```

**Steps:**

* Make `y` the new root of this subtree.
* Move `z` to the left of `y`.
* Move the left subtree of `y` (if any) to be the right subtree of `z`.

**After rotation**

```
      y
     / \
    z   x
```

### **3. Left-Right Rotation (LR Rotation)**

**When to use:**\
Occurs when a node is inserted into the **right subtree of the left child** (Left-Right case).

**Structure before rotation**

```
      z
     /
    y
     \
      x
```

**Steps:**

1. **Left Rotation on y** to convert it into a Left-Left case.
2. **Right Rotation on z**.

**After rotation**

```
      x
     / \
    y   z
```

### **4. Right-Left Rotation (RL Rotation)**

**When to use:**\
Occurs when a node is inserted into the **left subtree of the right child** (Right-Left case).

**Structure before rotation**

```
      z
       \
        y
       /
      x
```

**Steps:**

1. **Right Rotation on y** to convert it into a Right-Right case.
2. **Left Rotation on z**.

**After rotation:**

```
      x
     / \
    z   y
```

### **Rules for Rotation**

1. **Rotation does not break the BST property.**\
   The in-order traversal before and after rotation remains the same.
2. **Rotation is a local operation.**\
   Only a small section of the tree is adjusted; the rest remains untouched.
3. **Rotation must be followed by height updates.**\
   After performing a rotation, we must recompute the height and balance factors for the involved nodes.

### **When Exactly to Perform Which Rotation?**

<table data-full-width="true"><thead><tr><th width="173.1015625">Imbalance Type</th><th>Description</th><th>Required Rotation</th></tr></thead><tbody><tr><td>Left-Left (LL)</td><td>Insertion in left subtree of left child</td><td>Right Rotation</td></tr><tr><td>Right-Right (RR)</td><td>Insertion in right subtree of right child</td><td>Left Rotation</td></tr><tr><td>Left-Right (LR)</td><td>Insertion in right subtree of left child</td><td>Left Rotation on child, then Right Rotation on root</td></tr><tr><td>Right-Left (RL)</td><td>Insertion in left subtree of right child</td><td>Right Rotation on child, then Left Rotation on root</td></tr></tbody></table>

## **AVL Tree Operations**

#### 1. **Insertion**

* Insert the node like in a BST.
* Update the heights.
* Check for imbalance.
* Perform rotation if needed.

#### 2. **Deletion**

* Delete the node like in a BST.
* Update the heights from the deleted node upward.
* Check for imbalance at every node.
* Perform rotations as necessary to rebalance.

#### 3. **Search**

* Same as a regular BST.
* O(log n) time because the tree remains balanced.

## **Example to Tie Everything Together**

Suppose we insert values in the following order: `30, 20, 25`

* Insert 30 → root is 30 → balanced.
* Insert 20 → left of 30 → still balanced.
* Insert 25 → right of 20 → causes Left-Right (LR) imbalance at 30.

Before rotation:

```
     30
    /
   20
     \
     25
```

Perform:

1. Left rotation on 20 → makes 25 the new child of 30.
2. Right rotation on 30 → makes 25 the new root.

After rotation:

```
     25
    /  \
   20  30
```

## Java Implementation

### 1. **AVL Tree Node Structure**

```java
class AVLNode {
    int key;
    int height;
    AVLNode left;
    AVLNode right;

    AVLNode(int key) {
        this.key = key;
        this.height = 1; // height starts from 1 (leaf)
    }
}
```

### 2. **AVL Tree Insert with Rotation**

```java
class AVLTree {
    private AVLNode root;

    // Helper: Get height of node
    int height(AVLNode node) {
        return (node == null) ? 0 : node.height;
    }

    // Helper: Get balance factor
    int getBalance(AVLNode node) {
        return (node == null) ? 0 : height(node.left) - height(node.right);
    }

    // Helper: Right rotate
    AVLNode rotateRight(AVLNode y) {
        AVLNode x = y.left;
        AVLNode T2 = x.right;

        x.right = y;
        y.left = T2;

        y.height = Math.max(height(y.left), height(y.right)) + 1;
        x.height = Math.max(height(x.left), height(x.right)) + 1;

        return x;
    }

    // Helper: Left rotate
    AVLNode rotateLeft(AVLNode x) {
        AVLNode y = x.right;
        AVLNode T2 = y.left;

        y.left = x;
        x.right = T2;

        x.height = Math.max(height(x.left), height(x.right)) + 1;
        y.height = Math.max(height(y.left), height(y.right)) + 1;

        return y;
    }

    // Insert a key and balance the tree
    AVLNode insert(AVLNode node, int key) {
        if (node == null)
            return new AVLNode(key);

        if (key < node.key)
            node.left = insert(node.left, key);
        else if (key > node.key)
            node.right = insert(node.right, key);
        else
            return node; // duplicates not allowed

        // Update height
        node.height = 1 + Math.max(height(node.left), height(node.right));

        // Balance
        int balance = getBalance(node);

        // Left Left
        if (balance > 1 && key < node.left.key)
            return rotateRight(node);

        // Right Right
        if (balance < -1 && key > node.right.key)
            return rotateLeft(node);

        // Left Right
        if (balance > 1 && key > node.left.key) {
            node.left = rotateLeft(node.left);
            return rotateRight(node);
        }

        // Right Left
        if (balance < -1 && key < node.right.key) {
            node.right = rotateRight(node.right);
            return rotateLeft(node);
        }

        return node;
    }

    // Public insert
    public void insert(int key) {
        root = insert(root, key);
    }
```

### 3. **AVL Delete Operation**

```java
    AVLNode minValueNode(AVLNode node) {
        AVLNode current = node;
        while (current.left != null)
            current = current.left;
        return current;
    }

    AVLNode delete(AVLNode root, int key) {
        if (root == null)
            return root;

        if (key < root.key)
            root.left = delete(root.left, key);
        else if (key > root.key)
            root.right = delete(root.right, key);
        else {
            // Node with one or no child
            if ((root.left == null) || (root.right == null)) {
                AVLNode temp = (root.left != null) ? root.left : root.right;
                root = (temp == null) ? null : temp;
            } else {
                // Node with two children: get inorder successor
                AVLNode temp = minValueNode(root.right);
                root.key = temp.key;
                root.right = delete(root.right, temp.key);
            }
        }

        if (root == null)
            return root;

        root.height = 1 + Math.max(height(root.left), height(root.right));
        int balance = getBalance(root);

        // Balance cases
        if (balance > 1 && getBalance(root.left) >= 0)
            return rotateRight(root);

        if (balance > 1 && getBalance(root.left) < 0) {
            root.left = rotateLeft(root.left);
            return rotateRight(root);
        }

        if (balance < -1 && getBalance(root.right) <= 0)
            return rotateLeft(root);

        if (balance < -1 && getBalance(root.right) > 0) {
            root.right = rotateRight(root.right);
            return rotateLeft(root);
        }

        return root;
    }

    public void delete(int key) {
        root = delete(root, key);
    }
```

### 4. **Level-Order Traversal**

```java
    public void levelOrder() {
        if (root == null) return;

        Queue<AVLNode> queue = new LinkedList<>();
        queue.add(root);
        while (!queue.isEmpty()) {
            AVLNode current = queue.poll();
            System.out.print(current.key + " ");
            if (current.left != null) queue.add(current.left);
            if (current.right != null) queue.add(current.right);
        }
        System.out.println();
    }
```

### 5. **Visual Tree Printing (Diagram Style)**

```java
    public void printTree() {
        printTree(root, "", true);
    }

    private void printTree(AVLNode node, String prefix, boolean isTail) {
        if (node == null) return;

        System.out.println(prefix + (isTail ? "└── " : "├── ") + node.key);
        if (node.left != null || node.right != null) {
            if (node.right != null)
                printTree(node.right, prefix + (isTail ? "    " : "│   "), false);
            if (node.left != null)
                printTree(node.left, prefix + (isTail ? "    " : "│   "), true);
        }
    }
```

### 6. **Check Tree Height**

```java
    public int getHeight() {
        return height(root);
    }
}
```

### **Sample Usage**

```java
public class Main {
    public static void main(String[] args) {
        AVLTree avl = new AVLTree();

        avl.insert(10);
        avl.insert(20);
        avl.insert(30);
        avl.insert(40);
        avl.insert(50);
        avl.insert(25);

        System.out.println("AVL Tree:");
        avl.printTree();

        System.out.println("Level Order:");
        avl.levelOrder();

        System.out.println("Height: " + avl.getHeight());

        avl.delete(30);
        System.out.println("After Deletion of 30:");
        avl.printTree();
    }
}
```

