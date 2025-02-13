# Minimum Spanning Tree (MST) Algorithms

## About

A **Minimum Spanning Tree (MST)** is a subset of the edges of a connected, weighted graph that connects all vertices with the **minimum possible total edge weight** and **without forming any cycles**.

A spanning tree of a graph **G(V, E)** is a tree that:

* Includes all **V** vertices of the graph.
* Contains exactly **V-1** edges (since a tree with V nodes has V-1 edges).
* Does not contain **any cycles**.

A **Minimum Spanning Tree (MST)** is a spanning tree where the sum of the edge weights is **minimum** among all possible spanning trees.

### Properties of MST

1. A **graph can have multiple MSTs**, but all MSTs will have the same total weight.
2. If all edge weights are **distinct**, there will be a **unique MST**.
3. If an edge is the **smallest edge in a cycle**, it **must be included** in the MST (this is called the cut property).
4. If an edge is the **largest edge in a cycle**, it **cannot be part of any MST**.
5. The **MST of a connected graph is unique if the edge weights are distinct**.

### Example Graph

```
     (A)
    /   \
   1      3
  /        \
 (B)--- 2 --(C)
   \        /
    4      5
     \   /
      (D)
```

Possible MST (one of them):

```
     (A)
    /   \
   1     3
  /       \
 (B)     (C)
   \
    4
     \
     (D)
```

**Total MST Weight = 1 + 3 + 4 = 8**

### **MST Algorithms**

There are two main algorithms to find the MST:

* **Kruskal’s Algorithm** (Greedy approach using sorting and Union-Find).
* **Prim’s Algorithm** (Greedy approach using priority queue).

## **Kruskal’s Algorithm**

### **About**

Kruskal’s Algorithm is a **greedy algorithm** used to find the **Minimum Spanning Tree (MST)** of a connected, weighted, and undirected graph. It selects edges in **increasing order of weight** while ensuring that **no cycles are formed**. It is particularly efficient for **sparse graphs** (graphs with fewer edges). The algorithm is based on the **greedy approach**, where the best local decision (selecting the smallest edge) leads to a globally optimal solution (Minimum Spanning Tree).

* **Greedy Nature** – It picks the smallest edge first and grows the MST gradually.
* **Cycle Avoidance** – It ensures no cycles are formed while adding edges.
* **Uses Disjoint Set Union (DSU)** – Also known as **Union-Find** to detect cycles efficiently.
* **Works on Edge List** – The algorithm sorts edges by weight and processes them one by one.
* **Optimal for Sparse Graphs** – Performs efficiently when the number of edges **E** is much smaller than the number of vertices **V**.

### **Working of Kruskal’s Algorithm**

The algorithm follows these steps:

**Step 1: Sort Edges**

* Sort all edges of the graph in **ascending order of their weights**.

**Step 2: Initialize Disjoint Sets**

* Assign each vertex as an individual **disjoint set** (each vertex is its own component).

**Step 3: Process Edges**

* Iterate through the sorted edge list.
* **Include the edge** in the MST **if it does not form a cycle** (use **Union-Find** for cycle detection).

**Step 4: Repeat Until MST is Formed**

* Stop when **V-1 edges** have been included in the MST (where **V** is the number of vertices).

### **Time Complexity Analysis**

* **Sorting edges:** O(Elog⁡E)O(E \log E)O(ElogE) (using efficient sorting algorithms like **Merge Sort** or **Quick Sort**).
* **Union-Find operations (with path compression & union by rank):** O(Eα(V)), where 𝛼 ( 𝑉 ) is the **inverse Ackermann function**, which grows very slowly and is nearly constant for practical inputs.
* **Total Complexity:** O(Elog⁡E), which is efficient for **sparse graphs**.

### **Example of Kruskal’s Algorithm**

#### **Graph Representation**

Consider the following weighted graph:

```
      2
  A ------- B
  |  \    / |
  |   \  /  |
 4|    C    |3
  |   /  \  |
  |  /    \ |
  D ------- E
      1
```

#### **Step 1: Sort the Edges by Weight**

| Edge | Weight |
| ---- | ------ |
| D–E  | 1      |
| A–B  | 2      |
| B–E  | 3      |
| A–D  | 4      |
| B–C  | 4      |
| C–E  | 5      |

#### **Step 2: Initialize Each Vertex as a Separate Set**

Initially, each vertex **(A, B, C, D, E)** is its own component.

**Step 3: Pick the Smallest Edge That Doesn't Form a Cycle**

1. **Include D–E (1)** → No cycle, add to MST.
2. **Include A–B (2)** → No cycle, add to MST.
3. **Include B–E (3)** → No cycle, add to MST.
4. **Include A–D (4)** → No cycle, add to MST.
5. **Stop (MST contains 4 edges for 5 vertices).**

**Final MST**

```
      2
  A ------- B
  |         |
 4|         |3
  |         |
  D ------- E
      1
```

**Total MST Weight = 1 + 2 + 3 + 4 = 10**

### **Cycle Detection Using Union-Find**

To ensure that adding an edge does not form a **cycle**, we use the **Union-Find (Disjoint Set)** data structure with two operations:

1. **Find()** – Determines the root representative of a set (uses **path compression** for efficiency).
2. **Union()** – Merges two sets based on **rank** to keep the tree shallow.

If two vertices of an edge belong to the **same set**, adding the edge would form a **cycle**, so it is skipped.



## **Prim’s Algorithm**

### About

Prim’s Algorithm is a **greedy algorithm** used to find the **Minimum Spanning Tree (MST)** of a connected, weighted, and undirected graph. Unlike **Kruskal’s Algorithm**, which works edge-by-edge, **Prim’s Algorithm grows the MST vertex-by-vertex**, always adding the **minimum-weight edge** that connects a new vertex to the MST.

It is particularly efficient for **dense graphs** (graphs with many edges). The algorithm is based on the **greedy approach**, where **local optimal choices** (picking the smallest edge) lead to a **globally optimal solution** (MST).

* **Greedy Nature** – It always selects the **minimum-weight edge** from the vertices already in the MST.
* **Vertex-Based Expansion** – The MST starts from **one vertex** and grows by **adding one vertex at a time**.
* **No Cycle Formation** – The algorithm **never forms a cycle** because it only considers edges that connect an MST vertex to a non-MST vertex.
* **Efficient with Priority Queues** – Implemented using a **Min Heap (Priority Queue)** for efficiency.
* **Best for Dense Graphs** – Performs better when **E is close to V²**.

### **Working of Prim’s Algorithm**

The algorithm follows these steps:

**Step 1: Select an Initial Vertex**

* Start from any **random vertex** (commonly vertex **0**).
* Mark it as part of the **MST**.

**Step 2: Grow the MST**

* Among all edges that connect **a vertex in the MST** to **a vertex outside the MST**, **pick the smallest one**.
* Add the **new vertex** to the MST.

**Step 3: Repeat Until MST is Formed**

* Repeat until **V-1 edges** have been added to the MST (**where V is the number of vertices**).

### **Time Complexity Analysis**

* **Using an adjacency matrix (without a priority queue):** O(V^2).
* **Using a Min Heap (Priority Queue) with an adjacency list:** O(Elog⁡V), where **E** is the number of edges and **V** is the number of vertices.

### **Example of Prim’s Algorithm**

#### **Graph Representation**

Consider the following weighted graph:

```
        (A)
     2 /   \ 3
      /     \
     B ----- C
     |  \   /
    4|   \ /5
     |    D
     \   /
      1
     (E)
```

**Step 1: Select an Initial Vertex**

Let's start with **vertex A**.

**Step 2: Select the Smallest Edge Connected to MST**

| Step | Chosen Edge | Weight | MST Set         |
| ---- | ----------- | ------ | --------------- |
| 1    | A → B       | 2      | {A, B}          |
| 2    | A → C       | 3      | {A, B, C}       |
| 3    | C → D       | 5      | {A, B, C, D}    |
| 4    | D → E       | 1      | {A, B, C, D, E} |

**Final MST**

```
        (A)
     2 /   \ 3
      /     \
     B       C
      \     /
       \   /
        (D)
         |
         1
        (E)
```

**Total MST Weight = 2 + 3 + 5 + 1 = 11**

### **Implementation Details**

Prim’s Algorithm is efficiently implemented using a **Min Heap (Priority Queue)**:

* **Maintain a Min Heap of edges** that connect the MST to non-MST vertices.
* **Extract the smallest edge** at each step.
* **Update the heap** with new edges connecting the newly added vertex.

This results in an efficient implementation with **O(E log V) time complexity**.

## **Comparison of** Prim’s with **Kruskal’s Algorithm**

<table><thead><tr><th width="198">Feature</th><th>Prim’s Algorithm</th><th>Kruskal’s Algorithm</th></tr></thead><tbody><tr><td>Approach</td><td>Vertex-based</td><td>Edge-based</td></tr><tr><td>Best for</td><td>Dense Graphs (E is close to V²)</td><td>Sparse Graphs (E &#x3C;&#x3C; V²)</td></tr><tr><td>Complexity</td><td>O(Elog⁡V) with Min Heap</td><td>O(Elog⁡E)</td></tr><tr><td>Data Structure</td><td>Priority Queue (Min Heap)</td><td>Edge List + Union-Find</td></tr><tr><td>Edge Sorting</td><td>Not Required</td><td>Required</td></tr><tr><td>How it Grows</td><td>Expands from one vertex</td><td>Picks the lightest edge</td></tr></tbody></table>

## Applications of MST

* **Network Design**: Used in designing network topologies, including computer networks, telecommunication networks, and power grids to minimize wiring costs.
* **Clustering and Image Segmentation**: Used in clustering algorithms like Kruskal’s Clustering Algorithm in machine learning. Used in image segmentation for grouping pixels based on similarity.
* **Approximation Algorithms**: Used in approximate solutions for problems like Traveling Salesman Problem (TSP).
* **Circuit Design**: Used in circuit board design to minimize wiring and avoid redundant paths.
* **Road and Railway Construction**: Used in urban planning to minimize the cost of road, railway, or pipeline construction.
