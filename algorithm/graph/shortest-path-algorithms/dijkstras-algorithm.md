# Dijkstra’s Algorithm

## About

Dijkstra’s Algorithm is a **greedy algorithm** used to find the **shortest path from a single source vertex** to all other vertices in a graph with **non-negative weights**. It was developed by **Edsger W. Dijkstra** in 1956. It operates by selecting the **minimum distance vertex**, updating its neighbors, and repeating until all shortest paths are determined.

* **Type**: Single Source Shortest Path (SSSP)
* **Graph Type**: Weighted graphs (no negative weights)
* **Approach**: Greedy Algorithm
* **Time Complexity**:
  * **O(V²)** with an adjacency matrix (Basic version)
  * **O((V + E) log V)** with a priority queue (Optimized version using a Min-Heap)
* **Data Structure Used**: Priority Queue (Min-Heap) for efficient selection of the shortest path
* **Limitation**: Cannot handle negative weight edges

## **Working Principle**

1. **Initialize distances:** Set the source vertex’s distance to **0** and all other vertices to **infinity**.
2. **Select the minimum distance vertex:** Pick the vertex with the **smallest known distance** (initially the source).
3. **Update neighboring vertices:** For each adjacent vertex, update its shortest known distance **if a shorter path is found** through the current vertex.
4. **Repeat the process:** Continue selecting the **next minimum distance vertex** and updating neighbors until all vertices are processed.
5. **Terminate:** The algorithm stops when all vertices have been visited, and the shortest distances to all nodes are finalized.

## **Example Execution**

**Graph Representation**

Consider the following weighted graph:

```
        (A)
       /   \
      4     1
     /       \
   (B) --- 2 -- (C)
     \       /
      5     3
       \   /
        (D)
```

**Graph Representation in Adjacency List Form:**

| Vertex | Adjacent Nodes (Weight) |
| ------ | ----------------------- |
| A      | B(4), C(1)              |
| B      | A(4), C(2), D(5)        |
| C      | A(1), B(2), D(3)        |
| D      | B(5), C(3)              |

We want to find the shortest path from A to all other nodes using Dijkstra’s Algorithm.

**Step 1: Initialization**

* Set the source vertex (A) distance to 0.
* Set all other vertices to ∞ (infinity).
* Maintain a "visited" set to track processed nodes.
* Use a priority queue (Min-Heap) to always select the node with the smallest known distance.

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| B      | ∞                 | -             |
| C      | ∞                 | -             |
| D      | ∞                 | -             |

**Step 2: Process Node A (Starting Node)**

* Mark **A** as visited.
* Update the distances of **B** and **C** (its adjacent nodes).
* Since **C has a smaller weight (1) compared to B (4), it will be prioritized.**

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **4**             | **A**         |
| **C**  | **1**             | **A**         |
| D      | ∞                 | -             |

**Step 3: Process Node C (Smallest Distance: 1)**

* Mark **C** as visited.
* Update distances of its neighbors **B and D**:
  * B: Current distance = 4, alternative path through C = 1 + 2 = 3 (shorter, update)
  * D: Current distance = ∞, alternative path through C = 1 + 3 = 4 (update)

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **3**             | **C**         |
| **C**  | **1**             | **A**         |
| **D**  | **4**             | **C**         |

**Step 4: Process Node B (Smallest Distance: 3)**

* Mark **B** as visited.
* Update its neighbor **D**:
  * **Current distance = 4, alternative path through B = 3 + 5 = 8 (not shorter, no update).**

No changes in the table.

**Step 5: Process Node D (Smallest Distance: 4)**

* Mark **D** as visited.
* **No updates needed since all nodes are processed.**

Final shortest distances from **A**:

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **3**             | **C**         |
| **C**  | **1**             | **A**         |
| **D**  | **4**             | **C**         |

**Step 6: Extract Shortest Paths**

* **A → C** (1)
* **A → C → B** (3)
* **A → C → D** (4)

**Final Shortest Paths from A**

| Destination | Shortest Path | Total Cost |
| ----------- | ------------- | ---------- |
| **B**       | A → C → B     | **3**      |
| **C**       | A → C         | **1**      |
| **D**       | A → C → D     | **4**      |

## **Time and Space Complexity**

* **Time Complexity**
  * **O(V²)** for an adjacency matrix
  * **O((V + E) log V)** using a priority queue (Min-Heap)
* **Space Complexity**
  * **O(V + E)** (to store the graph)

## Implementation

### 1. Using PriorityQueue

```java
import java.util.*;

public class DijkstraAlgorithm {

    // Class to represent a graph edge
    static class Edge {
        int destination;
        int weight;

        Edge(int destination, int weight) {
            this.destination = destination;
            this.weight = weight;
        }
    }

    // Dijkstra’s Algorithm implementation
    public static int[] dijkstra(int vertices, List<List<Edge>> adjList, int source) {
        int[] dist = new int[vertices];                  // Stores shortest distance from source
        Arrays.fill(dist, Integer.MAX_VALUE);            // Initialize distances to infinity
        dist[source] = 0;

        // Min-heap based on distance
        PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[1]));
        pq.add(new int[]{source, 0});                    // {node, distance}

        while (!pq.isEmpty()) {
            int[] current = pq.poll();
            int u = current[0];
            int currentDist = current[1];

            // Skip if we already have a better distance
            if (currentDist > dist[u]) continue;

            // Explore all neighbors
            for (Edge edge : adjList.get(u)) {
                int v = edge.destination;
                int weight = edge.weight;

                // Relaxation step
                if (dist[u] + weight < dist[v]) {
                    dist[v] = dist[u] + weight;
                    pq.add(new int[]{v, dist[v]});
                }
            }
        }

        return dist;
    }

    // Sample usage
    public static void main(String[] args) {
        int vertices = 5;
        List<List<Edge>> adjList = new ArrayList<>();

        // Initialize adjacency list
        for (int i = 0; i < vertices; i++) {
            adjList.add(new ArrayList<>());
        }

        // Add directed edges: from -> (to, weight)
        adjList.get(0).add(new Edge(1, 10));
        adjList.get(0).add(new Edge(4, 5));
        adjList.get(1).add(new Edge(2, 1));
        adjList.get(1).add(new Edge(4, 2));
        adjList.get(2).add(new Edge(3, 4));
        adjList.get(3).add(new Edge(2, 6));
        adjList.get(3).add(new Edge(0, 7));
        adjList.get(4).add(new Edge(1, 3));
        adjList.get(4).add(new Edge(2, 9));
        adjList.get(4).add(new Edge(3, 2));

        int source = 0;
        int[] distances = dijkstra(vertices, adjList, source);

        System.out.println("Shortest distances from source " + source + ":");
        for (int i = 0; i < vertices; i++) {
            System.out.println("To vertex " + i + " = " + distances[i]);
        }
        
        /*
            Shortest distances from source 0:
            To vertex 0 = 0
            To vertex 1 = 8
            To vertex 2 = 9
            To vertex 3 = 7
            To vertex 4 = 5
        */
    }
}

```

{% hint style="success" %}
* The graph is represented using an adjacency list.
* A **priority queue** is used to always process the node with the **smallest known distance**.
* The algorithm performs **relaxation** for each edge.
* Time complexity with priority queue and adjacency list: **O((V + E) log V)**
{% endhint %}

## **Limitations**

* Cannot handle negative weight edges
* Not suitable for dynamic graphs where edges change frequently
* _Less efficient than A for heuristic-based pathfinding_\*

## **Optimizations**

* **Use a priority queue (Min-Heap) instead of a simple array** to improve efficiency
* **Fibonacci Heap** reduces time complexity to **O(E + V log V)**
* **Bi-Directional Dijkstra** reduces search space by simultaneously searching from source and destination

## **Applications of Dijkstra’s Algorithm**

* **Navigation Systems** → GPS routing (Google Maps, Waze)
* **Network Routing** → Finding shortest paths in computer networks (OSPF protocol)
* **Robotics & AI** → Path planning in autonomous robots
* **Telecommunications** → Optimizing signal transmission paths
* **Game Development** → Pathfinding for AI characters
