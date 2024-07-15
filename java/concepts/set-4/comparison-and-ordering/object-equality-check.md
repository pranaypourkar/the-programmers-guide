# Object Equality Check

## About

Object comparison in Java refers to the process of determining whether two objects are considered equal or not based on specific criteria. Comparing two objects in Java can be approached differently depending on the type of objects being compared.

1. **Equality**:
   * **Reference Equality (`==`)**: Compares whether two references point to the same memory address.
   * **Value Equality (`equals()`)**: Compares whether the internal state or content of two objects is the same.
2. **Methods for Comparison**:
   * **`==` Operator**: Tests reference equality, i.e., whether two references point to the same object instance in memory.
   * **`equals()` Method**: Tests value equality, which compares the contents or state of two objects. By default, the `equals()` method in Java checks for reference equality (same as `==`), but it can be overridden in custom classes to compare based on object contents.
3. **Implementing `equals()` Method**:
   * When implementing the `equals()` method in a custom class, it's important to override it to provide a meaningful comparison based on the properties (fields) of the class.
   * The `equals()` method should adhere to the following principles:
     * **Reflexive**: `x.equals(x)` should always return true.
     * **Symmetric**: If `x.equals(y)` returns true, then `y.equals(x)` should also return true.
     * **Transitive**: If `x.equals(y)` and `y.equals(z)` both return true, then `x.equals(z)` should also return true.
     * **Consistent**: Repeatedly calling `x.equals(y)` should consistently return true or consistently return false, provided that the objects are not modified.
     * **Null Comparison**: `x.equals(null)` should return false.
4. **Comparison Strategies**:
   * **Primitive Types**: Compared using their respective `==` operators for value comparison.
   * **Wrapper Classes**: Compared using `equals()` for value comparison.
   * **String**: Compared using `equals()` for content comparison.
   * **Arrays**: Compared using `Arrays.equals()` or `Arrays.deepEquals()` for content comparison.
   * **Collections (`List`, `Set`, `Map`)**: Compared using `equals()` for content comparison.
   * **Custom Objects**: Implement `equals()` and `hashCode()` methods for meaningful comparison based on object properties.

## 1. `Object` Superclass

Every class in Java implicitly inherits from the `Object` class, which provides the basic methods for comparison: `equals()` and `==`.

* **`==` Operator**: Checks for reference equality, i.e., whether two references point to the same object in memory.
* **`equals()` Method**: Checks for value equality. By default, it behaves like the `==` operator (reference equality), but it can be overridden in custom classes to provide meaningful value comparison.

#### Example

```java
Object obj1 = new Object();
Object obj2 = new Object();

System.out.println(obj1 == obj2); // false, different references
System.out.println(obj1.equals(obj2)); // false, different objects (default behavior)
```

## 2. Primitive Types

Primitive types in Java are the most basic data types and they directly hold the values. They are not objects and are stored in the stack memory, which makes them fast and efficient.

* **Comparison**: Use the `==` operator to compare primitive values directly. This checks if the values are the same.
* **Performance**: Comparisons are fast because they directly compare the values stored in the stack.
* **Memory**: Stored in the stack, which is faster but has limited space.

<table data-header-hidden data-full-width="true"><thead><tr><th width="126"></th><th width="142"></th><th width="114"></th><th width="136"></th><th></th></tr></thead><tbody><tr><td>Primitive Type</td><td>Description</td><td>Size (bits)</td><td>Default Value</td><td>Example Comparison Using <code>==</code></td></tr><tr><td><code>byte</code></td><td>8-bit integer</td><td>8</td><td><code>0</code></td><td><code>byte a = 1; byte b = 1; System.out.println(a == b); // true</code></td></tr><tr><td><code>short</code></td><td>16-bit integer</td><td>16</td><td><code>0</code></td><td><p><code>short a = 1; short b = 1;</code></p><p><code>System.out.println(a == b); // true</code></p></td></tr><tr><td><code>int</code></td><td>32-bit integer</td><td>32</td><td><code>0</code></td><td><p><code>int a = 1; int b = 1;</code> </p><p><code>System.out.println(a == b); // true</code></p></td></tr><tr><td><code>long</code></td><td>64-bit integer</td><td>64</td><td><code>0L</code></td><td><code>long a = 1L; long b = 1L; System.out.println(a == b); // true</code></td></tr><tr><td><code>float</code></td><td>32-bit floating point</td><td>32</td><td><code>0.0f</code></td><td><code>float a = 1.0f; float b = 1.0f; System.out.println(a == b); // true</code></td></tr><tr><td><code>double</code></td><td>64-bit floating point</td><td>64</td><td><code>0.0d</code></td><td><code>double a = 1.0; double b = 1.0; System.out.println(a == b); // true</code></td></tr><tr><td><code>char</code></td><td>16-bit Unicode</td><td>16</td><td><code>\u0000</code></td><td><code>char a = 'a'; char b = 'a'; System.out.println(a == b); // true</code></td></tr><tr><td><code>boolean</code></td><td>true/false</td><td>1</td><td><code>false</code></td><td><code>boolean a = true; boolean b = true; System.out.println(a == b); // true</code></td></tr></tbody></table>

**Example**

```java
int a = 10;
int b = 10;
System.out.println(a == b); // true, because values are the same
```

## **3. Primitive Wrapper Classes**

Primitive wrapper classes in Java are objects that encapsulate the primitive types. They provide useful methods for manipulating these values and are stored in the heap memory.

* **Comparison Using `==`**: Compares the references, not the values. This checks if the two references point to the same object in memory.
* **Comparison Using `equals()`**: Compares the values inside the objects. This checks if the values encapsulated by the objects are the same.
* **Performance**: Slightly slower than primitive types because of the overhead of object creation and method calls.
* **Memory**: Stored in the heap, which allows for larger amounts of data but is slower to access than the stack.

**Special Cases with Wrapper Classes**

* **Integer Caching**: Java caches Integer objects for values between -128 and 127. This means that `Integer` objects within this range will be the same reference if created using `valueOf()` method or auto-boxing.
* **Boolean and Character Caching**: `Boolean` values `true` and `false` are always cached. `Character` values from `\u0000` to `\u007F` are cached.

<table data-header-hidden data-full-width="true"><thead><tr><th width="141"></th><th width="141"></th><th width="328"></th><th></th></tr></thead><tbody><tr><td>Wrapper Class</td><td>Description</td><td>Example Comparison Using <code>==</code> (Reference)</td><td>Example Comparison Using <code>equals()</code> (Value)</td></tr><tr><td><code>Byte</code></td><td>Wrapper for <code>byte</code></td><td><p><code>Byte a = 1; Byte b = 1; System.out.println(a == b);</code> </p><p><code>// false</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Short</code></td><td>Wrapper for <code>short</code></td><td><p><code>Short a = 1; Short b = 1; System.out.println(a == b);</code> </p><p><code>// false</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Integer</code></td><td>Wrapper for <code>int</code></td><td><p><code>Integer a = 1; Integer b = 1; System.out.println(a == b);</code> </p><p><code>// true (within cache range)</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Long</code></td><td>Wrapper for <code>long</code></td><td><p><code>Long a = 1L; Long b = 1L; System.out.println(a == b);</code> </p><p><code>// true (within cache range)</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Float</code></td><td>Wrapper for <code>float</code></td><td><p><code>Float a = 1.0f; Float b = 1.0f;</code> </p><p><code>System.out.println(a == b);</code> </p><p><code>// false</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Double</code></td><td>Wrapper for <code>double</code></td><td><p><code>Double a = 1.0; Double b = 1.0;</code> </p><p><code>System.out.println(a == b);</code> </p><p><code>// false</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Character</code></td><td>Wrapper for <code>char</code></td><td><p><code>Character a = 'a'; Character b = 'a';</code> </p><p><code>System.out.println(a == b);</code> </p><p><code>// true (within cache range)</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr><tr><td><code>Boolean</code></td><td>Wrapper for <code>boolean</code></td><td><p><code>Boolean a = true; Boolean b = true;</code> </p><p><code>System.out.println(a == b);</code> </p><p><code>// true</code></p></td><td><code>System.out.println(a.equals(b)); // true</code></td></tr></tbody></table>

```java
Integer a = Integer.valueOf(127); // Boxing the value
Integer b = Integer.valueOf(127);
System.out.println(a == b); // true, because references are the same (within cache range)
System.out.println(a.equals(b)); // true, because values are the same

Integer c = 1;
Integer d = 1;
System.out.println(c == d); // true, because references are the same (within cache range)
System.out.println(c.equals(d)); // true, because values are the same

Integer e = Integer.valueOf(128);
Integer f = Integer.valueOf(128);
System.out.println(e == f); // false, because references are different (outside cache range)
System.out.println(e.equals(f)); // true, because values are the same
```

## 4. Custom Object Classes

In Java, the `equals()` and `hashCode()` methods are crucial for custom object classes primarily because they enable proper functionality when instances of these classes are used in collections that rely on hashing, such as `HashMap`, `HashSet`, and `Hashtable`.&#x20;

### `equals()` Method

The `equals()` method in Java is used to compare the equality of two objects based on their internal state or content rather than their memory address (reference equality). By default, the `equals()` method in the `Object` class compares references (`==` operator), which checks if two references point to the same object instance in memory. However, for custom classes, it's often necessary to override `equals()` to provide a meaningful comparison based on the attributes or fields of the objects.

#### **Reasons for Implementing `equals()`**

* **Semantic Equality**: Allows us to define what it means for two instances of our class to be considered equal. This is particularly important when the default reference equality is not sufficient.
* **Collection Operations**: Many Java collections (`HashSet`, `HashMap`, etc.) use `equals()` to determine if an object is already present in the collection. This is crucial for avoiding duplicates and ensuring proper collection behavior.
* **Consistent Behavior**: Provides a clear contract for how equality should be determined across different instances of our class.

#### **Example Implementation**

```java
public class Person {
    private String name;
    private int age;

    // Constructor, getters, setters

    @Override
    public boolean equals(Object o) {
        if (this == o) return true; // Check if same object reference
        if (o == null || getClass() != o.getClass()) return false; // Check if classes are the same

        Person person = (Person) o; // Cast to Person object

        // Compare individual fields for equality
        if (age != person.age) return false;
        return name != null ? name.equals(person.name) : person.name == null;
    }
}
```

### `hashCode()` Method

The `hashCode()` method returns a hash code value for an object, which is used by hash-based collections (`HashMap`, `HashSet`, etc.) to quickly locate objects in memory. Hash codes are essential for efficient storage and retrieval of objects in hash tables.

#### **Reasons for Implementing `hashCode()`**

* **Efficient Retrieval**: Ensures that objects are distributed evenly across the hash table, minimizing collisions and improving performance of hash-based collections.
* **Contract with `equals()`**: Objects that are equal according to `equals()` must have the same hash code. This ensures consistency when objects are used in collections.
* **Consistent Behavior**: Provides a consistent way to identify objects based on their content, even if they are not the same object instance.

#### **Example Implementation**

```java
public class Person {
    private String name;
    private int age;

    // Constructor, getters, setters

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + age;
        return result;
    }
}
```

### Custom Object Class Comparison

Overriding `equals()` and `hashCode()` provides meaningful comparison based on properties.

```java
public class Car {
    private String model;
    private int year;
    // Constructors, getters, setters

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Car car = (Car) o;
        return year == car.year && Objects.equals(model, car.model);
    }

    @Override
    public int hashCode() {
        return Objects.hash(model, year);
    }
}

Car car1 = new Car("Tesla", 2020);
Car car2 = new Car("Tesla", 2020);
System.out.println(car1.equals(car2)); // true
```

## 5. String

In Java, `String` is a special class that represents a sequence of characters.

**Comparison**:

* **Using `==`**: Compares references, not values.
* **Using `equals()`**: Compares the actual contents of the `String`.

```java
String str1 = "Hello";
String str2 = "Hello";
String str3 = new String("Hello");

System.out.println(str1 == str2); // true (String literals are interned)
System.out.println(str1.equals(str2)); // true
System.out.println(str1 == str3); // false (different objects)
System.out.println(str1.equals(str3)); // true (same contents)
```

## 6. Arrays

Arrays in Java are objects that hold a fixed number of values of the same type.

**Comparison**:

* **Using `Arrays.equals()`**: Compares two arrays for equality based on the values of their elements.

```java
int[] arr1 = {1, 2, 3};
int[] arr2 = {1, 2, 3};
int[] arr3 = {3, 2, 1};

System.out.println(Arrays.equals(arr1, arr2)); // true
System.out.println(Arrays.equals(arr1, arr3)); // false
```

* **Using `Arrays.deepEquals()`**: Compares nested arrays recursively.

```java
// Example 1: Comparing one-dimensional arrays
int[] arr1 = {1, 2, 3};
int[] arr2 = {1, 2, 3};
int[] arr3 = {3, 2, 1};

System.out.println("Comparing one-dimensional arrays:");
System.out.println(Arrays.deepEquals(arr1, arr2)); // true
System.out.println(Arrays.deepEquals(arr1, arr3)); // false

// Example 2: Comparing two-dimensional arrays
int[][] arr2D1 = {{1, 2}, {3, 4}};
int[][] arr2D2 = {{1, 2}, {3, 4}};
int[][] arr2D3 = {{3, 4}, {1, 2}};

System.out.println("\nComparing two-dimensional arrays:");
System.out.println(Arrays.deepEquals(arr2D1, arr2D2)); // true
System.out.println(Arrays.deepEquals(arr2D1, arr2D3)); // false

// Example 3: Comparing arrays with nested arrays
String[][] arrNested1 = {{"one", "two"}, {"three", "four"}};
String[][] arrNested2 = {{"one", "two"}, {"three", "four"}};
String[][] arrNested3 = {{"five", "six"}, {"seven", "eight"}};

System.out.println("\nComparing arrays with nested arrays:");
System.out.println(Arrays.deepEquals(arrNested1, arrNested2)); // true
System.out.println(Arrays.deepEquals(arrNested1, arrNested3)); // false
```

## 7. List, Set, Map

Collections in Java provide a way to group multiple elements into a single unit.

**List**:\
**Comparison**: Uses `equals()` method to compare lists by contents.

**Set**:\
**Comparison**: Uses `equals()` method to compare sets by contents.

**Map**:\
**Comparison**: Uses `equals()` method to compare maps by contents of keys and values.

### Primitive Wrapper values

```java
// List, Set, Map of Primitive Wrapper values

// List
List<Integer> list1 = Arrays.asList(1, 2, 3);
List<Integer> list2 = Arrays.asList(1, 2, 3);
List<Integer> list3 = Arrays.asList(3, 2, 1);

System.out.println(list1.equals(list2)); // true
System.out.println(list1.equals(list3)); // false

// Set
Set<String> set1 = new HashSet<>(Arrays.asList("a", "b", "c"));
Set<String> set2 = new HashSet<>(Arrays.asList("a", "b", "c"));
Set<String> set3 = new HashSet<>(Arrays.asList("c", "b", "a"));

System.out.println(set1.equals(set2)); // true
System.out.println(set1.equals(set3)); // true (order doesn't matter in sets)

// Map
Map<String, Integer> map1 = new HashMap<>();
map1.put("one", 1);
map1.put("two", 2);

Map<String, Integer> map2 = new HashMap<>();
map2.put("one", 1);
map2.put("two", 2);

Map<String, Integer> map3 = new HashMap<>();
map3.put("two", 2);
map3.put("one", 1);

System.out.println(map1.equals(map2)); // true
System.out.println(map1.equals(map3)); // true (order doesn't matter in maps)
```

### Custom Object values

```java
public class CustomObject {
    private String name;
    private int age;

    public CustomObject(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CustomObject that = (CustomObject) o;

        if (age != that.age) return false;
        return name != null ? name.equals(that.name) : that.name == null;
    }

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + age;
        return result;
    }
}
```

```java
// List, Set, Map of Custom Object values

// List
List<CustomObject> list1 = new ArrayList<>(Arrays.asList(
    new CustomObject("Alice", 30),
    new CustomObject("Bob", 25)
));

List<CustomObject> list2 = new ArrayList<>(Arrays.asList(
    new CustomObject("Alice", 30),
    new CustomObject("Bob", 25)
));

List<CustomObject> list3 = new ArrayList<>(Arrays.asList(
    new CustomObject("Bob", 25),
    new CustomObject("Alice", 30)
));

System.out.println(list1.equals(list2)); // true
System.out.println(list1.equals(list3)); // false (order matters)

// Map
Map<String, CustomObject> map1 = new HashMap<>();
map1.put("A", new CustomObject("Alice", 30));
map1.put("B", new CustomObject("Bob", 25));

Map<String, CustomObject> map2 = new HashMap<>();
map2.put("A", new CustomObject("Alice", 30));
map2.put("B", new CustomObject("Bob", 25));

Map<String, CustomObject> map3 = new HashMap<>();
map3.put("B", new CustomObject("Bob", 25));
map3.put("A", new CustomObject("Alice", 30));

System.out.println(map1.equals(map2)); // true
System.out.println(map1.equals(map3)); // true (order doesn't matter in maps)

// Set
Set<CustomObject> set1 = new HashSet<>(Arrays.asList(
    new CustomObject("Alice", 30),
    new CustomObject("Bob", 25)
));

Set<CustomObject> set2 = new HashSet<>(Arrays.asList(
    new CustomObject("Alice", 30),
    new CustomObject("Bob", 25)
));

Set<CustomObject> set3 = new HashSet<>(Arrays.asList(
    new CustomObject("Bob", 25),
    new CustomObject("Alice", 30)
));

System.out.println(set1.equals(set2)); // true
System.out.println(set1.equals(set3)); // true (order doesn't matter in sets)
```

## 8. Queue and Stack

**Queue**:\
**Comparison**: Typically, queues are compared based on their elements using `equals()`.

**Stack**:\
**Comparison**: Stacks are compared similarly to lists, based on the equality of their elements.

```java
Queue<Integer> queue1 = new LinkedList<>(Arrays.asList(1, 2, 3));
Queue<Integer> queue2 = new LinkedList<>(Arrays.asList(1, 2, 3));
Queue<Integer> queue3 = new LinkedList<>(Arrays.asList(3, 2, 1));

System.out.println(queue1.equals(queue2)); // true
System.out.println(queue1.equals(queue3)); // false

Stack<Integer> stack1 = new Stack<>();
stack1.push(1);
stack1.push(2);
stack1.push(3);

Stack<Integer> stack2 = new Stack<>();
stack2.push(1);
stack2.push(2);
stack2.push(3);

Stack<Integer> stack3 = new Stack<>();
stack3.push(3);
stack3.push(2);
stack3.push(1);

System.out.println(stack1.equals(stack2)); // true
System.out.println(stack1.equals(stack3)); // false
```

## 9. Nested List, Map and Set Comparison

### 9.1 Nested List

A nested list in Java is a list where the values can themselves be list.

**Using `equals()` Method**:

* The `equals()` method of `List` compares the elements of the lists recursively.
* It ensures that each corresponding pair of nested lists is also compared recursively.

```java
List<List<Integer>> list1 = Arrays.asList(
    Arrays.asList(1, 2),
    Arrays.asList(3, 4)
);

List<List<Integer>> list2 = Arrays.asList(
    Arrays.asList(1, 2),
    Arrays.asList(3, 4)
);

List<List<Integer>> list3 = Arrays.asList(
    Arrays.asList(3, 4),
    Arrays.asList(1, 2)
);

System.out.println(list1.equals(list2)); // true
System.out.println(list1.equals(list3)); // false (order matters)
```

### 9.2 Nested Map

A nested map in Java is a map where the values can themselves be maps.

**Using `equals()` Method**:

* The `equals()` method of `Map` compares the keys and values of the maps recursively.
* It ensures that each corresponding pair of nested maps is also compared recursively.

```java
Map<String, Map<String, Integer>> map1 = new HashMap<>();
map1.put("A", new HashMap<>(Map.of("one", 1, "two", 2)));
map1.put("B", new HashMap<>(Map.of("three", 3)));

Map<String, Map<String, Integer>> map2 = new HashMap<>();
map2.put("A", new HashMap<>(Map.of("one", 1, "two", 2)));
map2.put("B", new HashMap<>(Map.of("three", 3)));

Map<String, Map<String, Integer>> map3 = new HashMap<>();
map3.put("B", new HashMap<>(Map.of("three", 3)));
map3.put("A", new HashMap<>(Map.of("one", 1, "two", 2)));

System.out.println(map1.equals(map2)); // true
System.out.println(map1.equals(map3)); // true (order doesn't matter in maps)
```

### 9.3 Nested Set

A nested set in Java is a set where each element can itself be a set.

**Using `equals()` Method**:

* The `equals()` method of `Set` compares the elements of the sets recursively.
* It ensures that each corresponding pair of nested sets is also compared recursively.

```java
Set<Set<Integer>> set1 = new HashSet<>();
set1.add(new HashSet<>(Set.of(1, 2)));
set1.add(new HashSet<>(Set.of(3, 4)));

Set<Set<Integer>> set2 = new HashSet<>();
set2.add(new HashSet<>(Set.of(1, 2)));
set2.add(new HashSet<>(Set.of(3, 4)));

Set<Set<Integer>> set3 = new HashSet<>();
set3.add(new HashSet<>(Set.of(3, 4)));
set3.add(new HashSet<>(Set.of(1, 2)));

System.out.println(set1.equals(set2)); // true
System.out.println(set1.equals(set3)); // true (order doesn't matter in sets)
```

### 9.4 List of Map

```java
List<Map<String, Integer>> list1 = new ArrayList<>(Arrays.asList(
    Map.of("one", 1, "two", 2),
    Map.of("three", 3)
));

List<Map<String, Integer>> list2 = new ArrayList<>(Arrays.asList(
    Map.of("one", 1, "two", 2),
    Map.of("three", 3)
));

List<Map<String, Integer>> list3 = new ArrayList<>(Arrays.asList(
    Map.of("three", 3),
    Map.of("one", 1, "two", 2)
));

System.out.println(list1.equals(list2)); // true
System.out.println(list1.equals(list3)); // false (order matters)
```

### 9.5 List of Set

```java
List<Set<Integer>> list1 = new ArrayList<>(Arrays.asList(
    new HashSet<>(Set.of(1, 2)),
    new HashSet<>(Set.of(3, 4))
));

List<Set<Integer>> list2 = new ArrayList<>(Arrays.asList(
    new HashSet<>(Set.of(1, 2)),
    new HashSet<>(Set.of(3, 4))
));

List<Set<Integer>> list3 = new ArrayList<>(Arrays.asList(
    new HashSet<>(Set.of(3, 4)),
    new HashSet<>(Set.of(1, 2))
));

System.out.println(list1.equals(list2)); // true
System.out.println(list1.equals(list3)); // false (order matters)
```

### 9.6 Map of String and List

```java
Map<String, List<Integer>> map1 = new HashMap<>();
map1.put("A", Arrays.asList(1, 2, 3));
map1.put("B", Arrays.asList(4, 5));

Map<String, List<Integer>> map2 = new HashMap<>();
map2.put("A", Arrays.asList(1, 2, 3));
map2.put("B", Arrays.asList(4, 5));

Map<String, List<Integer>> map3 = new HashMap<>();
map3.put("B", Arrays.asList(4, 5));
map3.put("A", Arrays.asList(1, 2, 3));

System.out.println(map1.equals(map2)); // true
System.out.println(map1.equals(map3)); // true (order doesn't matter in maps)
```

### 9.7 Set of List

```java
Set<List<Integer>> set1 = new HashSet<>(Arrays.asList(
    Arrays.asList(1, 2, 3),
    Arrays.asList(4, 5)
));

Set<List<Integer>> set2 = new HashSet<>(Arrays.asList(
    Arrays.asList(1, 2, 3),
    Arrays.asList(4, 5)
));

Set<List<Integer>> set3 = new HashSet<>(Arrays.asList(
    Arrays.asList(4, 5),
    Arrays.asList(1, 2, 3)
));

System.out.println(set1.equals(set2)); // true
System.out.println(set1.equals(set3)); // true (order doesn't matter in sets)
```

