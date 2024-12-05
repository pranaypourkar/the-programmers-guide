# ArrayList

## **About**

`ArrayList` is a part of the Java Collections Framework and resides in the `java.util` package. It is a resizable array implementation of the `List` interface and provides dynamic array capabilities. Unlike standard arrays, `ArrayList` can grow and shrink dynamically, making it more flexible when dealing with an unknown number of elements.

## **Features of ArrayList**

1. **Dynamic Resizing:** Automatically resizes as elements are added or removed.
2. **Random Access:** Allows retrieving elements in constant time, O(1), using indices.
3. **Duplicates Allowed:** Allows duplicate elements, unlike `Set`.
4. **Maintains Insertion Order:** Elements are stored in the order they are inserted.
5.  **Generic Support:** Enables type safety, preventing runtime `ClassCastException`.

    ```java
    ArrayList<String> names = new ArrayList<>();
    ```
6.  **Custom Capacity Management:** Initial capacity can be set to avoid frequent resizing.

    ```java
    ArrayList<Integer> numbers = new ArrayList<>(100);
    ```
7. **Serialization Support:** Implements `Serializable`, making it suitable for object serialization.
8. **Iterator and ListIterator Support:** Traversing the list in both forward and backward directions.
9. **Fail-Fast Behavior:** Throws `ConcurrentModificationException` if the list is structurally modified while iterating.

## **Key Methods**

* `add(E e)`: Adds an element.
* `get(int index)`: Retrieves an element by index.
* `set(int index, E element)`: Replaces the element at a specified position.
* `remove(int index)` / `remove(Object o)`: Removes an element.
* `size()`: Returns the number of elements.
* `isEmpty()`: Checks if the list is empty.
* `contains(Object o)`: Checks if the list contains a specified element.
* `clear()`: Removes all elements.
* `addAll(Collection<? extends E> c)`: Adds all elements of a collection.
* `retainAll(Collection<?> c)`: Retains only elements present in the specified collection.
* `subList(int fromIndex, int toIndex)`: Returns a portion of the list.
* `toArray()`: Converts the list into an array.

## **Big(O) for Operations on ArrayList**

The performance of `ArrayList` operations depends on the dynamic resizing of the internal array and how elements are accessed or modified. Below is the time complexity for various operations:

<table data-header-hidden data-full-width="true"><thead><tr><th width="259"></th><th width="223"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Big(O) Time Complexity</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Access by Index</strong></td><td>O(1)</td><td>Direct indexing makes retrieval constant time.</td></tr><tr><td><strong>Add (at end)</strong></td><td>O(1) <em>Amortized</em></td><td>Appending is constant unless resizing occurs (then O(n) for resizing).</td></tr><tr><td><strong>Add (at specific index)</strong></td><td>O(n)</td><td>Shifts elements after the index to the right.</td></tr><tr><td><strong>Remove (by index)</strong></td><td>O(n)</td><td>Shifts elements after the removed index to the left.</td></tr><tr><td><strong>Remove (by value)</strong></td><td>O(n)</td><td>Searches for the value first (O(n)) and then removes it.</td></tr><tr><td><strong>Search (by value)</strong></td><td>O(n)</td><td>Iterates through the array to find the value.</td></tr><tr><td><strong>Contains</strong></td><td>O(n)</td><td>Iterates through the array to check if the value exists.</td></tr><tr><td><strong>Iteration (using for-loop)</strong></td><td>O(n)</td><td>Iterates through each element once.</td></tr><tr><td><strong>Dynamic Resizing (growth)</strong></td><td>O(n) <em>Rarely occurs</em></td><td>Copies all elements to a new larger array when resizing.</td></tr></tbody></table>

## Examples

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class ArrayListExample {
    public static void main(String[] args) {
        // Adding elements
        ArrayList<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        names.add("Charlie");
        System.out.println("Names: " + names); //Names: [Alice, Bob, Charlie]

        // Accessing Elements
        System.out.println("First Element: " + names.get(0)); //First Element: Alice

        // Modifying Elements
        names.set(1, "Brian");
        System.out.println("Modified Names: " + names); //Modified Names: [Alice, Brian, Charlie]

        // Removing Elements
        names.remove("Alice");
        System.out.println("After Removal: " + names); //After Removal: [Brian, Charlie]

        // Iteration
        System.out.println("Iterating with for-each:");
        for (String name : names) {
            System.out.println(name);
        }
        //Iterating with for-each:
        //Brian
        //Charlie

        System.out.println("Iterating with Iterator:");
        Iterator<String> iterator = names.iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
        //Iterating with Iterator:
        //Brian
        //Charlie

        // Adding multiple elements at once
        ArrayList<Integer> numbers = new ArrayList<>();
        Collections.addAll(numbers, 10, 20, 30, 40, 50);
        System.out.println("Numbers: " + numbers);

        // Sorting
        Collections.sort(numbers);
        System.out.println("Sorted Numbers: " + numbers); //Numbers: [10, 20, 30, 40, 50]

        // SubList
        List<Integer> subList = numbers.subList(1, 4);
        System.out.println("SubList: " + subList); //SubList: [20, 30, 40]

        // Generic ArrayList
        ArrayList<Double> scores = new ArrayList<>();
        scores.add(95.5);
        scores.add(87.0);
        System.out.println("Scores: " + scores); //Scores: [95.5, 87.0]

        // Contains
        System.out.println("Contains 20: " + numbers.contains(20)); //Contains 20: true

        // Clearing Elements
        scores.clear();
        System.out.println("Scores After Clear: " + scores); //Scores After Clear: []

        // List of Custom Objects
        ArrayList<Student> students = new ArrayList<>();
        students.add(new Student("John", 21));
        students.add(new Student("Emily", 22));

        for (Student student : students) {
            System.out.println("Student: " + student.getName() + ", Age: " + student.getAge());
        }
        //Student: John, Age: 21
        //Student: Emily, Age: 22

        // Fail-Fast Example
        try {
            Iterator<Integer> it = numbers.iterator();
            while (it.hasNext()) {
                numbers.add(60); // ConcurrentModificationException
                System.out.println(it.next());
            }
        } catch (Exception e) {
            System.out.println("Fail-Fast Example: " + e); // Fail-Fast Example: java.util.ConcurrentModificationException
        }
    }
}

// Custom Class
class Student {
    private String name;
    private int age;

    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}
```





