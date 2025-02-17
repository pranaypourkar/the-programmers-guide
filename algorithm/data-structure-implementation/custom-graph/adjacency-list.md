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

### Code

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
        adjacencyList[dest].add(src); // For an undirected graph
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        adjacencyList[src].remove(Integer.valueOf(dest));
        adjacencyList[dest].remove(Integer.valueOf(src)); // Undirected Graph
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        return adjacencyList[src].contains(dest);
    }

    // Method to get neighbors of a vertex
    public List<Integer> getNeighbors(int vertex) {
        return adjacencyList[vertex];
    }

    // Method to perform Breadth-First Search (BFS)
    public void bfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[startVertex] = true;
        queue.add(startVertex);

        System.out.print("BFS Traversal: ");
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");

            for (int neighbor : adjacencyList[vertex]) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    queue.add(neighbor);
                }
            }
        }
        System.out.println();
    }

    // Method to perform Depth-First Search (DFS)
    public void dfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        System.out.print("DFS Traversal: ");
        dfsHelper(startVertex, visited);
        System.out.println();
    }

    private void dfsHelper(int vertex, boolean[] visited) {
        visited[vertex] = true;
        System.out.print(vertex + " ");

        for (int neighbor : adjacencyList[vertex]) {
            if (!visited[neighbor]) {
                dfsHelper(neighbor, visited);
            }
        }
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

        // Test Edge Existence
        System.out.println("Edge 1-3 exists? " + graph.hasEdge(1, 3)); // True
        System.out.println("Edge 2-4 exists? " + graph.hasEdge(2, 4)); // False

        // Remove an Edge and Print Again
        graph.removeEdge(1, 4);
        System.out.println("Graph after removing edge (1,4):");
        graph.printGraph();

        // Get Neighbors of a Vertex
        System.out.println("Neighbors of vertex 1: " + graph.getNeighbors(1));

        // Perform BFS and DFS
        graph.bfs(0);
        graph.dfs(0);
    }
}

```

### **Output**

```java
Vertex 0 -> 1 4 
Vertex 1 -> 0 2 3 4 
Vertex 2 -> 1 3 
Vertex 3 -> 1 2 4 
Vertex 4 -> 0 1 3 

Edge 1-3 exists? true
Edge 2-4 exists? false

Graph after removing edge (1,4):
Vertex 0 -> 1 4 
Vertex 1 -> 0 2 3 
Vertex 2 -> 1 3 
Vertex 3 -> 1 2 4 
Vertex 4 -> 0 3 

Neighbors of vertex 1: [0, 2, 3]

BFS Traversal: 0 1 4 2 3 
DFS Traversal: 0 1 2 3 4 
```

### **Time Complexity Analysis**

| Operation         | Time Complexity   |
| ----------------- | ----------------- |
| Add an Edge       | O(1)              |
| Remove an Edge    | O(V) (worst case) |
| Check Edge Exists | O(V) (worst case) |
| Get Neighbours    | O(1)              |
| BFS Traversal     | O(V+E)            |
| DFS Traversal     | O(V+E)            |

## Weighted Graph Implementation (Using HashMap)

If the graph is **weighted**, each edge stores an additional **weight value**. This can be implemented using a **HashMap of Lists**, where each list contains **pairs of (neighbour, weight)**.

### Code

```java
import java.util.*;

class WeightedGraph {
    private int vertices;
    private Map<Integer, Map<Integer, Integer>> adjacencyList; // Adjacency List using HashMap

    // Constructor
    public WeightedGraph(int vertices) {
        this.vertices = vertices;
        adjacencyList = new HashMap<>();

        for (int i = 0; i < vertices; i++) {
            adjacencyList.put(i, new HashMap<>());
        }
    }

    // Method to add an edge (Undirected Graph)
    public void addEdge(int src, int dest, int weight) {
        adjacencyList.get(src).put(dest, weight);
        adjacencyList.get(dest).put(src, weight); // Undirected graph
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        if (adjacencyList.containsKey(src)) {
            adjacencyList.get(src).remove(dest);
        }
        if (adjacencyList.containsKey(dest)) {
            adjacencyList.get(dest).remove(src);
        }
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        return adjacencyList.containsKey(src) && adjacencyList.get(src).containsKey(dest);
    }

    // Method to get the weight of an edge
    public int getEdgeWeight(int src, int dest) {
        return adjacencyList.getOrDefault(src, Collections.emptyMap()).getOrDefault(dest, -1);
    }

    // Method to get neighbors of a vertex
    public Map<Integer, Integer> getNeighbors(int vertex) {
        return adjacencyList.getOrDefault(vertex, Collections.emptyMap());
    }

    // Method to perform Breadth-First Search (BFS)
    public void bfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        Queue<Integer> queue = new LinkedList<>();

        visited[startVertex] = true;
        queue.add(startVertex);

        System.out.print("BFS Traversal: ");
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");

            for (int neighbor : adjacencyList.get(vertex).keySet()) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    queue.add(neighbor);
                }
            }
        }
        System.out.println();
    }

    // Method to perform Depth-First Search (DFS)
    public void dfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        System.out.print("DFS Traversal: ");
        dfsHelper(startVertex, visited);
        System.out.println();
    }

    private void dfsHelper(int vertex, boolean[] visited) {
        visited[vertex] = true;
        System.out.print(vertex + " ");

        for (int neighbor : adjacencyList.get(vertex).keySet()) {
            if (!visited[neighbor]) {
                dfsHelper(neighbor, visited);
            }
        }
    }

    // Method to print adjacency list representation with weights
    public void printGraph() {
        for (int i = 0; i < vertices; i++) {
            System.out.print("Vertex " + i + " -> ");
            for (Map.Entry<Integer, Integer> entry : adjacencyList.get(i).entrySet()) {
                System.out.print("(" + entry.getKey() + ", weight: " + entry.getValue() + ") ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        WeightedGraph graph = new WeightedGraph(5);

        graph.addEdge(0, 1, 10);
        graph.addEdge(0, 4, 20);
        graph.addEdge(1, 2, 30);
        graph.addEdge(1, 3, 40);
        graph.addEdge(1, 4, 50);
        graph.addEdge(2, 3, 60);
        graph.addEdge(3, 4, 70);

        graph.printGraph();

        // Test Edge Existence
        System.out.println("Edge 1-3 exists? " + graph.hasEdge(1, 3)); // True
        System.out.println("Edge 2-4 exists? " + graph.hasEdge(2, 4)); // False

        // Get Edge Weight
        System.out.println("Weight of Edge (1,3): " + graph.getEdgeWeight(1, 3));

        // Remove an Edge and Print Again
        graph.removeEdge(1, 4);
        System.out.println("Graph after removing edge (1,4):");
        graph.printGraph();

        // Get Neighbors of a Vertex
        System.out.println("Neighbors of vertex 1: " + graph.getNeighbors(1));

        // Perform BFS and DFS
        graph.bfs(0);
        graph.dfs(0);
    }
}
```

### **Output**

```java
Vertex 0 -> (1, weight: 10) (4, weight: 20) 
Vertex 1 -> (0, weight: 10) (2, weight: 30) (3, weight: 40) (4, weight: 50) 
Vertex 2 -> (1, weight: 30) (3, weight: 60) 
Vertex 3 -> (1, weight: 40) (2, weight: 60) (4, weight: 70) 
Vertex 4 -> (0, weight: 20) (1, weight: 50) (3, weight: 70) 

Edge 1-3 exists? true
Edge 2-4 exists? false
Weight of Edge (1,3): 40

Graph after removing edge (1,4):
Vertex 0 -> (1, weight: 10) (4, weight: 20) 
Vertex 1 -> (0, weight: 10) (2, weight: 30) (3, weight: 40) 
Vertex 2 -> (1, weight: 30) (3, weight: 60) 
Vertex 3 -> (1, weight: 40) (2, weight: 60) (4, weight: 70) 
Vertex 4 -> (0, weight: 20) (3, weight: 70) 

Neighbors of vertex 1: {0=10, 2=30, 3=40}

BFS Traversal: 0 1 4 2 3 
DFS Traversal: 0 1 2 3 4 
```

### **Time Complexity Analysis**

| Operation         | Time Complexity |
| ----------------- | --------------- |
| Add an Edge       | O(1)            |
| Remove an Edge    | O(1)            |
| Check Edge Exists | O(1)            |
| Get Edge Weight   | O(1)            |
| Get Neighbors     | O(1)            |
| BFS Traversal     | O(V+E)          |
| DFS Traversal     | O(V+E)          |





