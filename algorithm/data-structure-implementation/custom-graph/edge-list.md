# Edge List

## **About**

An **Edge List** is a simple way to represent a graph using a list of edges, where:

* **Each edge is stored as a pair (or triplet for weighted graphs) representing the two connected vertices**.
* **It is best for sparse graphs** because it stores only edges and not all possible connections.

## **Why Use an Edge List?**

* **Space Efficient for Sparse Graphs**: Only stores the edges, making it **O(E) space complexity**.
* **Simple Representation**: Easier to implement and manipulate compared to adjacency matrices.
* **Best for Edge-Centric Operations**: Useful when **iterating over edges** rather than neighbours.

## **Structure of an Edge List**

An **Edge List** consists of a **list of edges**, where each edge is stored as a **pair (u, v)** for an **unweighted graph** or **triplet (u, v, w)** for a **weighted graph**.

#### **Example Graph Representation**

Consider a graph with **4 vertices** (**V = 4**) and **4 edges** **(0→1, 0→2, 1→3, 2→3)**:

| **Edges** | **Start Vertex** | **End Vertex** | **Weight (if weighted)** |
| --------- | ---------------- | -------------- | ------------------------ |
| (0, 1)    | 0                | 1              | -                        |
| (0, 2)    | 0                | 2              | -                        |
| (1, 3)    | 1                | 3              | -                        |
| (2, 3)    | 2                | 3              | -                        |

For a **weighted** version of the graph with edge weights:

| **Edges**  | **Start Vertex** | **End Vertex** | **Weight** |
| ---------- | ---------------- | -------------- | ---------- |
| (0, 1, 10) | 0                | 1              | 10         |
| (0, 2, 20) | 0                | 2              | 20         |
| (1, 3, 30) | 1                | 3              | 30         |
| (2, 3, 40) | 2                | 3              | 40         |

## Implementation using an Edge List

### Code

```java
import java.util.*;

class Edge {
    int src, dest, weight;

    // Constructor for an unweighted edge
    public Edge(int src, int dest) {
        this.src = src;
        this.dest = dest;
        this.weight = 1; // Default weight (for unweighted graphs)
    }

    // Constructor for a weighted edge
    public Edge(int src, int dest, int weight) {
        this.src = src;
        this.dest = dest;
        this.weight = weight;
    }
}

class Graph {
    private List<Edge> edgeList; // List of edges
    private int vertices; // Number of vertices

    public Graph(int vertices) {
        this.vertices = vertices;
        this.edgeList = new ArrayList<>();
    }

    // Method to add an unweighted edge
    public void addEdge(int src, int dest) {
        edgeList.add(new Edge(src, dest));
    }

    // Method to add a weighted edge
    public void addEdge(int src, int dest, int weight) {
        edgeList.add(new Edge(src, dest, weight));
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        edgeList.removeIf(edge -> edge.src == src && edge.dest == dest);
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        for (Edge edge : edgeList) {
            if (edge.src == src && edge.dest == dest) {
                return true;
            }
        }
        return false;
    }

    // Method to get all neighbors of a vertex
    public List<Integer> getNeighbors(int vertex) {
        List<Integer> neighbors = new ArrayList<>();
        for (Edge edge : edgeList) {
            if (edge.src == vertex) {
                neighbors.add(edge.dest);
            }
        }
        return neighbors;
    }

    // Method to print the graph
    public void printGraph() {
        System.out.println("Graph (Edge List Representation):");
        for (Edge edge : edgeList) {
            System.out.println(edge.src + " --(" + edge.weight + ")--> " + edge.dest);
        }
    }

    public static void main(String[] args) {
        Graph graph = new Graph(5);

        // Add unweighted edges
        graph.addEdge(0, 1);
        graph.addEdge(0, 2);
        graph.addEdge(1, 3);
        graph.addEdge(2, 3);
        graph.addEdge(3, 4);

        // Add weighted edges
        graph.addEdge(1, 4, 10);
        graph.addEdge(2, 4, 15);

        // Print the graph
        graph.printGraph();

        // Check if an edge exists
        System.out.println("Edge (1 -> 4) exists? " + graph.hasEdge(1, 4));

        // Remove an edge and print the graph again
        graph.removeEdge(1, 4);
        System.out.println("After removing edge (1 -> 4):");
        graph.printGraph();

        // Get neighbors of vertex 3
        System.out.println("Neighbors of vertex 3: " + graph.getNeighbors(3));
    }
}
```

### Output

```java
Graph (Edge List Representation):
0 --(1)--> 1
0 --(1)--> 2
1 --(1)--> 3
2 --(1)--> 3
3 --(1)--> 4
1 --(10)--> 4
2 --(15)--> 4
Edge (1 -> 4) exists? true
After removing edge (1 -> 4):
Graph (Edge List Representation):
0 --(1)--> 1
0 --(1)--> 2
1 --(1)--> 3
2 --(1)--> 3
3 --(1)--> 4
2 --(15)--> 4
Neighbors of vertex 3: [4]

```

### **Time Complexity Analysis**

| Operation                      | Time Complexity |
| ------------------------------ | --------------- |
| **Adding an Edge**             | O(1)            |
| **Removing an Edge**           | O(E)            |
| **Checking if an Edge Exists** | O(E)            |
| **Getting Neighbours**         | O(E)            |
| **Iterating All Edges**        | O(E)            |
| **Space Complexity**           | O(E)            |

## Weighted Graph Implementation

If the graph is **weighted**, we store **(src, dest, weight)** instead of just **(src, dest)**.

### Code

```java
import java.util.*;

class Edge {
    int src, dest, weight;

    // Constructor for a weighted edge
    public Edge(int src, int dest, int weight) {
        this.src = src;
        this.dest = dest;
        this.weight = weight;
    }
}

class Graph {
    private List<Edge> edgeList; // List of edges
    private int vertices; // Number of vertices

    public Graph(int vertices) {
        this.vertices = vertices;
        this.edgeList = new ArrayList<>();
    }

    // Method to add a weighted edge
    public void addEdge(int src, int dest, int weight) {
        edgeList.add(new Edge(src, dest, weight));
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        edgeList.removeIf(edge -> edge.src == src && edge.dest == dest);
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        for (Edge edge : edgeList) {
            if (edge.src == src && edge.dest == dest) {
                return true;
            }
        }
        return false;
    }

    // Method to get the weight of an edge
    public int getEdgeWeight(int src, int dest) {
        for (Edge edge : edgeList) {
            if (edge.src == src && edge.dest == dest) {
                return edge.weight;
            }
        }
        return -1; // Return -1 if the edge doesn't exist
    }

    // Method to get all neighbors of a vertex
    public List<Integer> getNeighbors(int vertex) {
        List<Integer> neighbors = new ArrayList<>();
        for (Edge edge : edgeList) {
            if (edge.src == vertex) {
                neighbors.add(edge.dest);
            }
        }
        return neighbors;
    }

    // Method to print the graph
    public void printGraph() {
        System.out.println("Graph (Weighted Edge List Representation):");
        for (Edge edge : edgeList) {
            System.out.println(edge.src + " --(" + edge.weight + ")--> " + edge.dest);
        }
    }

    public static void main(String[] args) {
        Graph graph = new Graph(5);

        // Add weighted edges
        graph.addEdge(0, 1, 5);
        graph.addEdge(0, 2, 10);
        graph.addEdge(1, 3, 2);
        graph.addEdge(2, 3, 4);
        graph.addEdge(3, 4, 7);

        // Print the graph
        graph.printGraph();

        // Check if an edge exists
        System.out.println("Edge (1 -> 3) exists? " + graph.hasEdge(1, 3));

        // Get the weight of an edge
        System.out.println("Weight of edge (2 -> 3): " + graph.getEdgeWeight(2, 3));

        // Remove an edge and print the graph again
        graph.removeEdge(2, 3);
        System.out.println("After removing edge (2 -> 3):");
        graph.printGraph();

        // Get neighbors of vertex 3
        System.out.println("Neighbors of vertex 3: " + graph.getNeighbors(3));
    }
}
```

### Output

```java
Graph (Weighted Edge List Representation):
0 --(5)--> 1
0 --(10)--> 2
1 --(2)--> 3
2 --(4)--> 3
3 --(7)--> 4
Edge (1 -> 3) exists? true
Weight of edge (2 -> 3): 4
After removing edge (2 -> 3):
Graph (Weighted Edge List Representation):
0 --(5)--> 1
0 --(10)--> 2
1 --(2)--> 3
3 --(7)--> 4
Neighbors of vertex 3: [4]

```

### **Time Complexity Analysis**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Time Complexity</strong></td><td><strong>Explanation</strong></td></tr><tr><td><code>addEdge(int src, int dest, int weight)</code></td><td>O(1)</td><td>Adding an edge to an <code>ArrayList</code> is a constant-time operation (appending to the list).</td></tr><tr><td><code>removeEdge(int src, int dest)</code></td><td>O(E)</td><td>The <code>removeIf()</code> method checks each edge, so it may iterate over all edges in the list.</td></tr><tr><td><code>hasEdge(int src, int dest)</code></td><td>O(E)</td><td>It iterates over all edges to check if a specific edge exists.</td></tr><tr><td><code>getEdgeWeight(int src, int dest)</code></td><td>O(E)</td><td>Similar to <code>hasEdge()</code>, it checks each edge to find the weight of a matching edge.</td></tr><tr><td><code>getNeighbours(int vertex)</code></td><td>O(E)</td><td>Checks all edges to find neighbours of the given vertex.</td></tr><tr><td><code>printGraph()</code></td><td>O(E)</td><td>Iterates through all edges to print them, making it linear in the number of edges.</td></tr></tbody></table>



