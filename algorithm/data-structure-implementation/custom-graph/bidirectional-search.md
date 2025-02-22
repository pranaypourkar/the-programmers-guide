# Bidirectional Search

## About

Bidirectional search is an advanced graph search algorithm that runs two simultaneous searches:

* **Forward Search**: Starts from the initial node.
* **Backward Search**: Starts from the goal node.
* The search stops when both searches meet in the middle.

## Implementation Strategy

To implement bidirectional search:

1. Use **two queues** for BFS traversal from the start and goal nodes.
2. Maintain **two visited sets** to track explored nodes.
3. Stop when the search frontiers meet.

## Implementation of Bidirectional Search

### **Graph Representation (Adjacency List)**

```java
import java.util.*;

class Graph {
    private final Map<Integer, List<Integer>> adjList;

    public Graph() {
        this.adjList = new HashMap<>();
    }

    // Add edge in an undirected graph
    public void addEdge(int source, int destination) {
        adjList.putIfAbsent(source, new ArrayList<>());
        adjList.putIfAbsent(destination, new ArrayList<>());
        adjList.get(source).add(destination);
        adjList.get(destination).add(source);
    }

    // Returns the adjacency list
    public List<Integer> getNeighbors(int node) {
        return adjList.getOrDefault(node, new ArrayList<>());
    }

    // Print the graph
    public void printGraph() {
        for (var entry : adjList.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }
    }
}
```

### **Bidirectional Search Algorithm**

```java
class BidirectionalSearch {
    private final Graph graph;

    public BidirectionalSearch(Graph graph) {
        this.graph = graph;
    }

    public boolean search(int start, int goal) {
        if (start == goal) {
            System.out.println("Start is the same as goal.");
            return true;
        }

        // Queues for BFS from both directions
        Queue<Integer> forwardQueue = new LinkedList<>();
        Queue<Integer> backwardQueue = new LinkedList<>();

        // Visited sets
        Set<Integer> forwardVisited = new HashSet<>();
        Set<Integer> backwardVisited = new HashSet<>();

        // Initialize queues and visited sets
        forwardQueue.add(start);
        forwardVisited.add(start);

        backwardQueue.add(goal);
        backwardVisited.add(goal);

        while (!forwardQueue.isEmpty() && !backwardQueue.isEmpty()) {
            // Expand one level from start
            if (bfsStep(forwardQueue, forwardVisited, backwardVisited)) {
                System.out.println("Path found!");
                return true;
            }

            // Expand one level from goal
            if (bfsStep(backwardQueue, backwardVisited, forwardVisited)) {
                System.out.println("Path found!");
                return true;
            }
        }

        System.out.println("No path found.");
        return false;
    }

    private boolean bfsStep(Queue<Integer> queue, Set<Integer> visited, Set<Integer> oppositeVisited) {
        if (!queue.isEmpty()) {
            int node = queue.poll();
            for (int neighbor : graph.getNeighbors(node)) {
                if (oppositeVisited.contains(neighbor)) {
                    return true;  // The two searches meet
                }
                if (!visited.contains(neighbor)) {
                    visited.add(neighbor);
                    queue.add(neighbor);
                }
            }
        }
        return false;
    }
}
```

### **Testing the Algorithm**

```java
public class BidirectionalSearchTest {
    public static void main(String[] args) {
        Graph graph = new Graph();
        graph.addEdge(1, 2);
        graph.addEdge(1, 3);
        graph.addEdge(2, 4);
        graph.addEdge(3, 5);
        graph.addEdge(4, 6);
        graph.addEdge(5, 6);

        System.out.println("Graph representation:");
        graph.printGraph();

        BidirectionalSearch search = new BidirectionalSearch(graph);
        System.out.println("Finding path from 1 to 6:");
        boolean pathExists = search.search(1, 6);
        System.out.println("Path exists: " + pathExists);
        
        /* Output:
        Graph representation:
        1 -> [2, 3]
        2 -> [1, 4]
        3 -> [1, 5]
        4 -> [2, 6]
        5 -> [3, 6]
        6 -> [4, 5]
        
        Finding path from 1 to 6:
        Path found!
        Path exists: true
        */
    }
}
```

## **Time Complexity Analysis**

| **Search Algorithm**       | **Time Complexity** |
| -------------------------- | ------------------- |
| **BFS (Single Direction)** | O(b^d)              |
| **Bidirectional Search**   | O(b^{d/2})          |

Where:

* b = branching factor (average number of neighbors per node)
* d = depth of the shortest path

## **Why is Bidirectional Search Faster?**

* **BFS explores b^d nodes**, but bidirectional search **only explore 2xb^{d/2} nodes**.
* This leads to an exponential reduction in search space.

For example, if b=10 and d=6:

* **BFS explores** 10^6 = 1,000,000 nodes.
* **Bidirectional search explores** 2 x 10^3 = 2,000 nodes, which is significantly smaller.
