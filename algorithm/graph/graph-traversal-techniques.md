# Graph Traversal Techniques

## About

Graph traversal is the process of visiting all the nodes (vertices) in a graph in a specific manner. It is essential for various applications like **pathfinding, connectivity checking, and network analysis**. There are two primary techniques:

* **Depth First Search (DFS)**
* **Breadth First Search (BFS)**
* **Bidirectional Search**

Each technique has unique properties, use cases, and performance characteristics.

## **1. Depth-First Search (DFS)**

### **About DFS**

Depth-First Search is a traversal algorithm that explores as far as possible along one branch before backtracking. It follows the "depth" path first and only moves to another branch when it cannot proceed further.

### **Characteristics of DFS**

* **Recursive or Stack-Based:** DFS can be implemented using recursion (which internally uses a stack) or explicitly using a stack data structure.
* **Backtracking Approach:** If a path is blocked, it backtracks to the last visited node and explores another path.
* **Visits One Path at a Time:** Unlike BFS, DFS doesn't explore all neighbors at the same level before going deeper.
* **Works Well for Path-Finding and Topological Sorting:** DFS is used in scenarios where exhaustive searching or ordering is needed.
* **Can Get Stuck in Cycles (Without Visited Set):** If cycles exist, DFS may revisit nodes indefinitely unless a **visited set** is maintained.

{% hint style="info" %}
In **trees**, pre-order traversal (**Root → Left → Right**) is a specific form of **Depth-First Search (DFS)**. Since trees **do not have cycles**, we do not need to check for **visited nodes**.

However, in **graphs**, DFS can **revisit nodes** if there are cycles or bidirectional edges. Without marking **visited nodes**, DFS can get stuck in an **infinite loop**.

#### **Example: Why Checking for Visited Nodes is Necessary?**

Consider the following **cyclic graph**:

```
     A
    / \
   B   C
    \ /
     D
```

* **Without marking visited nodes**, DFS could travel from **A → B → D → C → A** and keep looping infinitely.
* **With visited nodes tracking**, DFS ensures each node is processed only once, preventing cycles.
{% endhint %}

### **Algorithm to Find DFS**

1. **Start at a given source node**.
2. **Mark it as visited**.
3. **Visit an adjacent unvisited node**, mark it visited, and repeat.
4. **If no adjacent unvisited node exists, backtrack** to the last node with unvisited neighbors.
5. **Repeat until all nodes are visited**.

### **Example Usage**

* **Maze Solving:** DFS follows one path until it reaches a dead end, then backtracks to find another path.
* **Topological Sorting in DAGs (Directed Acyclic Graphs):** DFS helps in ordering tasks (e.g., task scheduling).
* **Finding Connected Components in an Undirected Graph:** DFS can identify all nodes connected to a given node.

### **Time and Space Complexity**

<table data-header-hidden><thead><tr><th></th><th width="288"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Time Complexity</strong></td><td><strong>Space Complexity</strong></td></tr><tr><td>Adjacency List (V = vertices, E = edges)</td><td>O(V + E)</td><td>O(V)</td></tr><tr><td>Adjacency Matrix</td><td>O(V²)</td><td>O(V)</td></tr></tbody></table>

* **Time Complexity Explanation:** Each vertex is visited once, and all edges are checked once.
* **Space Complexity Explanation:** In the worst case, the recursion stack (or explicit stack) may store all vertices.

## **2. Breadth-First Search (BFS)**

### **About BFS**

Breadth-First Search is a traversal technique that explores all neighbors of a node before moving to the next level of nodes. It follows a **level-order traversal** strategy.

### **Characteristics of BFS**

* **Queue-Based:** BFS uses a queue data structure for traversal.
* **Explores Neighbors First:** It visits all neighbors of a node before moving deeper.
* **Guaranteed Shortest Path (in Unweighted Graphs):** BFS ensures that the first time a node is reached, it's reached by the shortest path.
* **Memory Intensive in Large Graphs:** Since it stores all nodes of a level, it requires more memory than DFS in some cases.
* **Better for Finding the Shortest Path in an Unweighted Graph.**

### **Algorithm to Find BFS**

1. **Start at a given source node**.
2. **Enqueue the node and mark it as visited**.
3. **Dequeue a node**, explore all its unvisited neighbors, mark them as visited, and enqueue them.
4. **Repeat until the queue is empty**.

### **Example Usage**

* **Shortest Path in an Unweighted Graph:** BFS finds the shortest path from a source to a destination.
* **Social Network Friend Recommendations:** It finds connections at each level (e.g., friends of friends).
* **Web Crawlers:** BFS is used to crawl web pages in layers.

### **Time and Space Complexity**

| **Scenario**                             | **Time Complexity** | **Space Complexity** |
| ---------------------------------------- | ------------------- | -------------------- |
| Adjacency List (V = vertices, E = edges) | O(V + E)            | O(V)                 |
| Adjacency Matrix                         | O(V²)               | O(V)                 |

* **Time Complexity Explanation:** Every vertex and edge is processed once.
* **Space Complexity Explanation:** The queue stores all vertices at a given level.

## **3.** Bidirectional Search

### About Bidirectional Search

Bidirectional Search is an efficient graph traversal technique used to find the shortest path between a **source node** and a **target node**. Instead of exploring the entire graph from one direction (as in BFS or DFS), Bidirectional Search **runs two simultaneous searches**:

* **One forward search from the source**
* **One backward search from the target**

The search stops when the two frontiers **meet in the middle**, significantly reducing the number of nodes explored compared to a traditional BFS. This makes it particularly useful for **large graphs**, such as road networks and AI pathfinding.

### **Characteristics of Bidirectional Search**

* **Simultaneous searches** → Starts from both the source and the target.
* **Faster than BFS/DFS in large graphs** → Reduces the search space from **O(V + E)** to approximately **O(2 × b^(d/2))**, where `b` is the branching factor and `d` is the shortest path length.
* **Memory-efficient compared to BFS** → Each frontier requires storing only half the explored nodes.
* **Works best on undirected graphs** → For directed graphs, both searches must account for directionality.
* **Heuristic can improve performance** → Informed search techniques (like A\* combined with bidirectional search) are often more optimal.

### **Algorithm to Find the Shortest Path Using Bidirectional Search**

1. **Initialize two queues**:
   * One for forward BFS (`Queue1`) from the source.
   * One for backward BFS (`Queue2`) from the target.
2. **Initialize two visited sets**:
   * `Visited1` for nodes visited from the source.
   * `Visited2` for nodes visited from the target.
3. **Expand nodes alternately from both searches**:
   * Pop the front node from `Queue1`, explore its neighbours, and add them to `Queue1`.
   * Pop the front node from `Queue2`, explore its neighbours, and add them to `Queue2`.
4. **Check for intersection**:
   * If any node appears in both `Visited1` and `Visited2`, the shortest path is found.
5. **Reconstruct the path** using parent pointers.

### **Example Usage**

Consider a graph where we need to find the shortest path from **A** to **G**.

```
    A -- B -- C -- D -- G
     \               /
      E ----------- F
```

* **Forward Search (from A):** `A → B → C → D`
* **Backward Search (from G):** `G → D`
* **Meeting Point:** `D`
* **Shortest Path Found:** `A → B → C → D → G`

**Use Case: Finding the shortest route in a city road network**

* **Start:** A traveller in city **X** wants to go to city **Y**.
* **Search starts from both X and Y** → Expanding roads leading toward the other city.
* **They meet at a common intersection** → The shortest path is found faster than traditional BFS

### **Time and Space Complexity**

| Approach                   | Time Complexity | Space Complexity |
| -------------------------- | --------------- | ---------------- |
| **BFS** (Single-direction) | **O(b^d)**      | **O(b^d)**       |
| **Bidirectional BFS**      | **O(b^(d/2))**  | **O(b^(d/2))**   |

* **Time Complexity:** **O(b^(d/2))**, where `b` is the branching factor and `d` is the shortest path length. Since we search from both directions, each search only explores half the depth, significantly reducing time complexity.
* **Space Complexity:** **O(b^(d/2))**, since each search only stores nodes up to `d/2` depth.

## **Comparison**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Criteria</strong></td><td><strong>BFS (Breadth-First Search)</strong></td><td><strong>DFS (Depth-First Search)</strong></td><td><strong>Bidirectional Search</strong></td></tr><tr><td><strong>Data Structure Used</strong></td><td>Queue (FIFO)</td><td>Stack (LIFO) or Recursion</td><td>Two Queues (FIFO)</td></tr><tr><td><strong>Traversal Pattern</strong></td><td>Level-wise (Expands all neighbors before deeper levels)</td><td>Depth-wise (Explores one branch completely before backtracking)</td><td>Expands from both source and target until they meet</td></tr><tr><td><strong>Best Use Case</strong></td><td>Finding <strong>shortest path</strong> in an <strong>unweighted graph</strong>, solving maze problems</td><td>Solving puzzles, topological sorting, detecting cycles, exhaustive searches</td><td>Finding <strong>shortest path faster</strong> in large graphs (e.g., road networks, AI)</td></tr><tr><td><strong>Space Complexity (Worst Case)</strong></td><td><strong>O(b^d)</strong> (Storing all nodes at each level)</td><td><strong>O(d)</strong> (Storing only path nodes)</td><td><strong>O(b^(d/2))</strong> (Stores fewer nodes than BFS)</td></tr><tr><td><strong>Guaranteed Shortest Path?</strong></td><td><strong>Yes</strong> (if edge weights are equal)</td><td><strong>No</strong> (may take a longer or suboptimal path)</td><td><strong>Yes</strong> (Same as BFS but more efficient)</td></tr><tr><td><strong>Memory Usage</strong></td><td><strong>High</strong> (stores all nodes at a level)</td><td><strong>Low</strong> (stores only one path at a time)</td><td><strong>Medium</strong> (stores two frontiers, but still lower than BFS)</td></tr></tbody></table>

