# Adjacency List

## About

The **Adjacency List** is one of the most **efficient ways** to represent a graph, especially when dealing with **sparse graphs** (i.e., graphs with fewer edges compared to the number of vertices).

Instead of using a **2D matrix** (which consumes O(V^2) space), an **Adjacency List** stores only the relevant edges for each vertex, leading to a space complexity of **O(V+E)**.

## **Structure**

Each vertex in the graph has a **list of adjacent vertices (neighbors)**. The adjacency list can be implemented using:

1. **Array of Linked Lists** (Traditional Approach)
2. **HashMap (Dictionary) of Lists** (For unordered graphs)
3. **Array of Dynamic Arrays (ArrayList)**

Each **entry** in the adjacency list contains:

* **The vertex**
* **A list of its adjacent vertices** (or tuples containing adjacent vertex and weight in weighted graphs)

## Implementation using an Array of Lists

```java
import java.util.*;

class Graph {
    private int vertices; // Number of vertices
    private LinkedList<Integer>[] adjacencyList; // Adjacency List

    // Constructor
    public Graph(int vertices) {
        this.vertices = vertices;
        adjacencyList = new LinkedList[vertices];

        // Initialize each adjacency list as an empty list
        for (int i = 0; i < vertices; i++) {
            adjacencyList[i] = new LinkedList<>();
        }
    }

    // Method to add an edge (Undirected Graph)
    public void addEdge(int src, int dest) {
        adjacencyList[src].add(dest);
        adjacencyList[dest].add(src); // Add this line for an undirected graph
    }

    // Method to print adjacency list representation
    public void printGraph() {
        for (int i = 0; i < vertices; i++) {
            System.out.print("Vertex " + i + " -> ");
            for (Integer neighbor : adjacencyList[i]) {
                System.out.print(neighbor + " ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        Graph graph = new Graph(5);
        graph.addEdge(0, 1);
        graph.addEdge(0, 4);
        graph.addEdge(1, 2);
        graph.addEdge(1, 3);
        graph.addEdge(1, 4);
        graph.addEdge(2, 3);
        graph.addEdge(3, 4);

        graph.printGraph();
    }
}
```

#### **Output**

```java
Vertex 0 -> 1 4 
Vertex 1 -> 0 2 3 4 
Vertex 2 -> 1 3 
Vertex 3 -> 1 2 4 
Vertex 4 -> 0 1 3 
```

## Weighted Graph Implementation (Using HashMap)

If the graph is **weighted**, each edge stores an additional **weight value**. This can be implemented using a **HashMap of Lists**, where each list contains **pairs of (neighbor, weight)**.

```java
import java.util.*;

class WeightedGraph {
    private Map<Integer, List<Pair>> adjacencyList;

    public WeightedGraph() {
        adjacencyList = new HashMap<>();
    }

    // Inner class to store edges with weights
    static class Pair {
        int vertex, weight;

        public Pair(int vertex, int weight) {
            this.vertex = vertex;
            this.weight = weight;
        }
    }

    // Method to add an edge
    public void addEdge(int src, int dest, int weight) {
        adjacencyList.putIfAbsent(src, new ArrayList<>());
        adjacencyList.putIfAbsent(dest, new ArrayList<>());
        adjacencyList.get(src).add(new Pair(dest, weight));
        adjacencyList.get(dest).add(new Pair(src, weight)); // Undirected graph
    }

    // Print Graph
    public void printGraph() {
        for (var entry : adjacencyList.entrySet()) {
            System.out.print("Vertex " + entry.getKey() + " -> ");
            for (Pair p : entry.getValue()) {
                System.out.print("(" + p.vertex + ", " + p.weight + ") ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        WeightedGraph graph = new WeightedGraph();
        graph.addEdge(0, 1, 10);
        graph.addEdge(0, 4, 20);
        graph.addEdge(1, 2, 30);
        graph.addEdge(1, 3, 40);
        graph.addEdge(1, 4, 50);
        graph.addEdge(2, 3, 60);
        graph.addEdge(3, 4, 70);

        graph.printGraph();
    }
}
```

#### **Output**

```
Vertex 0 -> (1, 10) (4, 20) 
Vertex 1 -> (0, 10) (2, 30) (3, 40) (4, 50) 
Vertex 2 -> (1, 30) (3, 60) 
Vertex 3 -> (1, 40) (2, 60) (4, 70) 
Vertex 4 -> (0, 20) (1, 50) (3, 70) 
```

## **Time Complexity Analysis**

| Operation                        | Adjacency List Time Complexity |
| -------------------------------- | ------------------------------ |
| **Adding an Edge**               | O(1)                           |
| **Removing an Edge**             | O(V) (worst case)              |
| **Checking if Edge Exists**      | O(V) (worst case)              |
| **Iterating Over All Neighbors** | O(E/V)  on average             |
| **Space Complexity**             | O(V+E)                         |





