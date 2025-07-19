# Topological Sort

## About

Topological Sort (or Topological Ordering) of a **Directed Acyclic Graph (DAG)** is a linear ordering of its vertices such that **for every directed edge (u → v), vertex u comes before vertex v** in the ordering.

In other words, if there is a dependency from node u to node v, then u will appear earlier in the order than v.

{% hint style="success" %}
Topological Sort is a way of **arranging the nodes of a directed graph in a linear order** such that **for every directed edge (u → v), node u appears before node v**.

Think of it like scheduling tasks:\
If task A must happen before task B, then A should come before B in the list.
{% endhint %}

## Conditions for Topological Sort

* The graph **must be directed**.
* The graph **must not contain cycles**.
* If the graph contains a cycle (like A → B → C → A), topological sorting is **not possible**.

## Example

Consider the following graph:

```
A → B → C
↑       ↓
F ← E ← D
```

A valid topological sort of this graph could be:

```
A, B, D, E, C, F
```

Note: Topological ordering is **not unique**. There can be multiple valid topological sorts for a graph.

## Where is it Used?

Topological Sort is useful **whenever tasks have dependencies**, and we need to find a valid order to do the tasks.

**Examples:**

* **Course prerequisites**: You can’t take "Data Structures" before "Intro to Programming".
* **Build systems**: File B can only be compiled after file A.
* **Project planning**: Task X must be finished before Task Y starts.

## Algorithms for Topological Sort

There are two common approaches:

1. **Kahn’s Algorithm (BFS Based)**
2. **DFS Based Algorithm**

## 1. **Kahn’s Algorithm (BFS Based)**

Kahn’s algorithm is a **Breadth-First Search (BFS) based approach** for performing topological sort on a **Directed Acyclic Graph (DAG)**.\
It builds the topological ordering by **removing nodes with no incoming edges (indegree = 0)** and updating the rest of the graph gradually.

If a node has no incoming edges, it means **no other node must come before it** — so it can safely appear first in the topological order.

We repeat this process:

* Pick all nodes with **indegree = 0**,
* Add them to the topological order,
* Remove their outgoing edges,
* Update indegrees of other nodes.

### Steps of the Algorithm

#### Step 1: Calculate Indegree of Every Node

* **Indegree** of a node = number of edges coming **into** it.
* Go through the edge list of the graph.
* For each edge `u → v`, increase `indegree[v]` by 1.

#### Step 2: Add All Nodes with Indegree 0 to a Queue

* A node with indegree 0 has **no dependencies**.
* These are the **starting points** for topological sort.
* Add them to a queue (typically a `Queue<Integer>` in Java).

#### Step 3: Process the Queue

Repeat until the queue is empty:

1. **Remove** a node `current` from the front of the queue.
2. **Add** `current` to the topological order list.
3. For each neighbor `neighbor` of `current`:
   * Decrease `indegree[neighbor]` by 1 (since we’ve processed one of its incoming edges).
   * If `indegree[neighbor]` becomes 0, add it to the queue.

#### Step 4: Check for Cycle (Optional, but important)

* After the queue is empty, check if the number of nodes in the topological order list is equal to the total number of nodes.
* If not, it means there was a cycle in the graph — some nodes were **never processed** because they always had non-zero indegree.
* In that case, **topological sorting is not possible**.

#### Example 1

Graph edges:

```
A → C  
B → C  
C → D
```

1. Indegree:
   * A = 0, B = 0, C = 2, D = 1
2. Queue = \[A, B]
3. Process:
   * Remove A → result = \[A], C = 1
   * Remove B → result = \[A, B], C = 0 → add to queue
   * Remove C → result = \[A, B, C], D = 0 → add to queue
   * Remove D → result = \[A, B, C, D]
4. Done.

**Example 2**

**Input Graph:**

```
Vertices: 6  
Edges:
5 → 2  
5 → 0  
4 → 0  
4 → 1  
2 → 3  
3 → 1
```

1. Calculate indegree:

```
0 → 2 (from 4, 5)  
1 → 2 (from 3, 4)  
2 → 1 (from 5)  
3 → 1 (from 2)  
4 → 0  
5 → 0
```

Indegree table:

| Node | Indegree |
| ---- | -------- |
| 0    | 2        |
| 1    | 2        |
| 2    | 1        |
| 3    | 1        |
| 4    | 0        |
| 5    | 0        |

2. Start with queue: `[4, 5]`
3. Pop 4 → result: `[4]`, update indegrees
   * 0: 1, 1: 1
   * Queue: `[5]`
4. Pop 5 → result: `[4, 5]`
   * 2: 0, 0: 0
   * Queue: `[2, 0]`
5. Pop 2 → result: `[4, 5, 2]`
   * 3: 0
   * Queue: `[0, 3]`
6. Pop 0 → result: `[4, 5, 2, 0]`
7. Pop 3 → result: `[4, 5, 2, 0, 3]`
   * 1: 0
   * Queue: `[1]`
8. Pop 1 → result: `[4, 5, 2, 0, 3, 1]`

Done.

**Final topological order: `[4, 5, 2, 0, 3, 1]`**

### Time and Space Complexity

| Measure          | Complexity |
| ---------------- | ---------- |
| Time Complexity  | O(V + E)   |
| Space Complexity | O(V)       |

* V = Number of vertices
* E = Number of edges

We visit each node once and process each edge once.

### How Does It Detect Cycles?

At the end of the process:

* If the number of nodes in the result list is **less than the total number of nodes**, the graph has a cycle.
* That’s because some nodes always have indegree > 0 due to circular dependencies.

### Implementation

```java
import java.util.*;

public class TopologicalSortKahn {

    public static List<Integer> topologicalSort(int numVertices, List<List<Integer>> adjList) {
        int[] indegree = new int[numVertices];

        // Step 1: Calculate indegree of each vertex
        for (int u = 0; u < numVertices; u++) {
            for (int v : adjList.get(u)) {
                indegree[v]++;
            }
        }

        // Step 2: Add all vertices with indegree 0 to the queue
        Queue<Integer> queue = new LinkedList<>();
        for (int i = 0; i < numVertices; i++) {
            if (indegree[i] == 0) {
                queue.offer(i);
            }
        }

        List<Integer> topoOrder = new ArrayList<>();

        // Step 3: Process the queue
        while (!queue.isEmpty()) {
            int node = queue.poll();
            topoOrder.add(node);

            // Reduce indegree of neighbors
            for (int neighbor : adjList.get(node)) {
                indegree[neighbor]--;
                if (indegree[neighbor] == 0) {
                    queue.offer(neighbor);
                }
            }
        }

        // Step 4: Check for cycle
        if (topoOrder.size() != numVertices) {
            throw new RuntimeException("Graph has a cycle. Topological sort not possible.");
        }

        return topoOrder;
    }

    // Example usage
    public static void main(String[] args) {
        int numVertices = 6;
        List<List<Integer>> adjList = new ArrayList<>();

        // Initialize adjacency list
        for (int i = 0; i < numVertices; i++) {
            adjList.add(new ArrayList<>());
        }

        // Define the directed edges
        adjList.get(5).add(2);
        adjList.get(5).add(0);
        adjList.get(4).add(0);
        adjList.get(4).add(1);
        adjList.get(2).add(3);
        adjList.get(3).add(1);

        List<Integer> result = topologicalSort(numVertices, adjList);

        System.out.println("Topological Order: " + result);
        // Sample Topological Order: [4, 5, 2, 3, 1, 0]
    }
}
```

{% hint style="warning" %}
Note: The actual topological order may vary (there can be multiple valid answers), but all will maintain the constraint that **a node appears after all its prerequisites**.
{% endhint %}

## 2. **DFS Based Algorithm**

This approach uses **Depth-First Search (DFS)** to perform a **topological sort** on a **Directed Acyclic Graph (DAG)**.\
It explores each node's dependencies first, then adds the node itself to the result.\
In short: **"visit all children first, then the node."**

In a DAG, if there’s an edge from `u → v`, then `u` should come **before** `v` in the topological order.

So, in DFS:

* We start from each unvisited node.
* We visit all its descendants recursively.
* Once we’ve visited everything that depends on the current node, we can safely add it to the result (usually pushed onto a stack).

After the traversal, **reversing the result gives the correct topological order.**

### Steps of the Algorithm

**1. Initialize data structures**

* Create a **visited\[]** array or set to keep track of which nodes are already visited.
* Create an empty **stack** (or list) to store the result in **reverse order**.

**2. Traverse all vertices**

For each vertex `v` in the graph:

* If `v` is not visited, call the **DFS function** starting from `v`.

**3. Inside the DFS function**

For each node `v`, do the following:

1. Mark `v` as visited.
2. For each neighbor `n` of `v`:
   * If `n` is **not visited**, recursively call DFS on `n`.
3. After all neighbors of `v` are processed, **push `v` to the result stack**.

> This is the key idea: **push the current node after processing all its children**. So, nodes that come later in the graph are added earlier in the result.

**4. After DFS completes**

* Once DFS is done for all vertices, **reverse the stack** to get the topological order.

#### Example

Let's say we have:

```
Graph:
5 → 0  
5 → 2  
4 → 0  
4 → 1  
2 → 3  
3 → 1
```

Initial state:

* visited = \[false, false, false, false, false, false]
* resultStack = \[]

Run DFS:

* Start with node 5:
  * Visit 2
    * Visit 3
      * Visit 1
      * Add 1 to stack
    * Add 3
  * Add 2
  * Visit 0
  * Add 0
* Add 5

Then start DFS(4):

* Visit 0 (already visited)
* Visit 1 (already visited)
* Add 4

Final stack: \[1, 3, 2, 0, 5, 4]

Reverse it: **\[4, 5, 0, 2, 3, 1]**

### Time and Space Complexity

| Measure          | Complexity |
| ---------------- | ---------- |
| Time Complexity  | O(V + E)   |
| Space Complexity | O(V)       |

Same as Kahn’s Algorithm:

* We visit each vertex and edge once.

### How to Detect Cycles?

To detect cycles (which make topological sorting **impossible**):

* Maintain an additional **recursion stack** (or a “currently visiting” set).
* If we revisit a node that’s already in the recursion stack, a cycle exists.

### Implementation

```java
import java.util.*;

public class TopologicalSortDFS {

    // Method to perform Topological Sort
    public static List<Integer> topologicalSort(int vertices, List<List<Integer>> adjList) {
        boolean[] visited = new boolean[vertices];
        Stack<Integer> stack = new Stack<>();

        // Call DFS for each unvisited vertex
        for (int i = 0; i < vertices; i++) {
            if (!visited[i]) {
                dfs(i, adjList, visited, stack);
            }
        }

        // Pop elements from stack to get topological order
        List<Integer> topoOrder = new ArrayList<>();
        while (!stack.isEmpty()) {
            topoOrder.add(stack.pop());
        }
        return topoOrder;
    }

    // DFS helper function
    private static void dfs(int node, List<List<Integer>> adjList, boolean[] visited, Stack<Integer> stack) {
        visited[node] = true;

        // Visit all unvisited neighbors
        for (int neighbor : adjList.get(node)) {
            if (!visited[neighbor]) {
                dfs(neighbor, adjList, visited, stack);
            }
        }

        // All neighbors processed, push node to stack
        stack.push(node);
    }

    // Sample usage
    public static void main(String[] args) {
        int vertices = 6;

        // Create adjacency list for the graph
        List<List<Integer>> adjList = new ArrayList<>();
        for (int i = 0; i < vertices; i++) {
            adjList.add(new ArrayList<>());
        }

        // Add directed edges: from -> to
        adjList.get(5).add(0);
        adjList.get(5).add(2);
        adjList.get(4).add(0);
        adjList.get(4).add(1);
        adjList.get(2).add(3);
        adjList.get(3).add(1);

        List<Integer> result = topologicalSort(vertices, adjList);

        System.out.println("Topological Order: " + result);
        // Sample Topological Order: [4, 5, 2, 3, 1, 0]
    }
}

```

{% hint style="warning" %}
Note: There may be multiple valid topological orders depending on the graph structure.
{% endhint %}
