# Collections - TBU

## About

Collections in Java are part of the **Java Collections Framework (JCF)**, a set of classes and interfaces designed to handle and manipulate groups of objects effectively. They provide data structures like lists, sets, and maps, along with algorithms to operate on these data structures, such as searching, sorting, and iterating. The Java Collections Framework is a vital tool for any Java developer, offering flexibility, scalability, and efficiency in managing large amounts of data.

### **Components**

* **Interfaces**: Define abstract data types (e.g., `List`, `Set`, `Map`).
* **Implementations**: Concrete classes implementing these interfaces (e.g., `ArrayList`, `HashSet`, `HashMap`).
* **Algorithms**: Utility methods for common operations (e.g., `Collections.sort()`).

### **Hierarchy**

* **Collection Interface** (base interface for `List`, `Set`, and `Queue`).
* **Map Interface** (key-value pairs, not part of `Collection`).

## **Core Interfaces**

### **a. List**

* **Purpose**: Ordered collection allowing duplicate elements.
* **Common Implementations**: `ArrayList`, `LinkedList`, `Vector`.
* **Features**:
  * Access elements by index.
  * Dynamic resizing.

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");
System.out.println(list.get(0)); // Output: A
```

### **b. Set**

* **Purpose**: Unordered collection that does not allow duplicate elements.
* **Common Implementations**: `HashSet`, `LinkedHashSet`, `TreeSet`.
* **Features**:
  * Ensures uniqueness of elements.
  * `TreeSet` maintains sorted order.

```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A"); // Duplicate ignored
System.out.println(set); // Output: [A, B]
```

### **c. Queue**

* **Purpose**: Collection designed for holding elements prior to processing.
* **Common Implementations**: `PriorityQueue`, `LinkedList`.
* **Features**:
  * Follows FIFO (First-In-First-Out) order.
  * `PriorityQueue` orders elements based on their natural order or a comparator.

```java
Queue<Integer> queue = new LinkedList<>();
queue.add(1);
queue.add(2);
System.out.println(queue.poll()); // Output: 1
```

### **d. Map**

* **Purpose**: Key-value pair collection.
* **Common Implementations**: `HashMap`, `LinkedHashMap`, `TreeMap`.
* **Features**:
  * Keys are unique.
  * Allows null keys and values (except `TreeMap`).

```java
Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
map.put("B", 2);
System.out.println(map.get("A")); // Output: 1
```

## **Utility Classes**

### **Collections**

Utility class with static methods for operations like sorting and searching.

```
Collections.sort(list);
```

### **Arrays**

Utility class for array operations.

```
Arrays.sort(array);
```

## **Choosing the Right Collection**

| **Requirement**          | **Recommended Collection**        |
| ------------------------ | --------------------------------- |
| Maintain insertion order | `ArrayList`, `LinkedHashSet`      |
| Fast lookup by key       | `HashMap`, `ConcurrentHashMap`    |
| Unique elements          | `HashSet`, `TreeSet`              |
| Thread-safe operations   | `Vector`, `ConcurrentLinkedQueue` |
| Sorted order             | `TreeSet`, `TreeMap`              |

