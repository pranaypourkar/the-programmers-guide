# Logging with Lombok

## Primitive data types

**The primitive data types include boolean, char, byte, short, int, long, float and double.**

> Java uses the Unicode character set encoding system, not the ASCII code system. Java originally used UTF-16 for `char` values, meaning each `char` is 16 bits and can store a Unicode code unit (not always a full Unicode character if it’s outside the Basic Multilingual Plane).

**Application.java**

```java
@Slf4j
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        byte myByte = 31;
        short myShort = -1000;
        int myInt = 1234567;
        long myLong = 76543210L;
        float myFloat = 2.54f;
        double myDouble = 4.545569d;
        boolean myBoolean = true;
        char myChar = 65;
        
        log.info("byte: {}", myByte);
        log.info("short: {}", myShort);
        log.info("int: {}", myInt);
        log.info("long: {}", myLong);
        log.info("float: {}", myFloat);
        log.info("double: {}", myDouble);
        log.info("boolean: {}", myBoolean);
        log.info("char: {}", myChar);
    }
}
```

**Output**

<figure><img src="https://static.wixstatic.com/media/5fb94b_46702110c86540dea023a522dcd8821c~mv2.png/v1/fill/w_1480,h_208,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_46702110c86540dea023a522dcd8821c~mv2.png" alt="ree"><figcaption></figcaption></figure>

## Wrapper classes of the Java primitive data types

It includes eight wrapper classes Byte, Short, Integer, Long, Float, Double, Boolean, Character. Wrapper classes allow us to perform various operations on primitive values, such as converting them to strings, parsing strings to obtain primitive values, and providing utility methods for arithmetic operations and comparisons.

**Application.java**

```java
@Slf4j
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        // Declaration of wrapper variables
        Byte wrapperByte = 100;
        Short wrapperShort = 123;
        Integer wrapperInteger = 2000;
        Long wrapperLong = 30000L;
        Float wrapperFloat = 5.14f;
        Double wrapperDouble = 6.14159d;
        Boolean wrapperBoolean = true;
        Character wrapperCharacter = 'B';

        // Logging the values
        log.info("Byte - {}", wrapperByte);
        log.info("Short - {}", wrapperShort);
        log.info("Integer - {}", wrapperInteger);
        log.info("Long - {}", wrapperLong);
        log.info("Float - {}", wrapperFloat);
        log.info("Double - {}", wrapperDouble);
        log.info("Boolean - {}", wrapperBoolean);
        log.info("Character - {}", wrapperCharacter);
    }
}
```

**Output**

<figure><img src="https://static.wixstatic.com/media/5fb94b_c9a1782ae2494271abaaad72bb215dd2~mv2.png/v1/fill/w_1480,h_208,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_c9a1782ae2494271abaaad72bb215dd2~mv2.png" alt="ree"><figcaption></figcaption></figure>

## Non-primitive data types

The non-primitive data types includes Classes, Interfaces, and Arrays, Strings and Collections such as ArrayList, HashMap etc.

{% hint style="info" %}
A class does not necessarily have to have a toString() method, but it is often recommended to provide one. By default, if a class does not explicitly override the toString() method inherited from the Object class, it will inherit the default implementation provided by Object. The default toString() method returns a string representation of the object's class name along with its hash code. For example

```
Person@1f32e575
```
{% endhint %}

Note, we will use Lombok @Data annotation which will automatically override toString() method

### **Class**

**Person.java**

```java
package com.company.project.model;

import lombok.Data;

@Data
public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

**Application.java**

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        Person person = new Person("John", 25);
        log.info("Person - {}", person);
    }
}
```

**Output**

<figure><img src="https://static.wixstatic.com/media/5fb94b_8a6382f3ccd144628899093d1c9ea6cc~mv2.png/v1/fill/w_1480,h_36,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_8a6382f3ccd144628899093d1c9ea6cc~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Arrays**

\
<mark style="color:blue;">**Category: Based on Data Type**</mark>

#### **Array of Primitive Types**

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        short[] shortArray = {1, 2, 3, 4, 5};
        byte[] byteArray = {10, 20, 30, 40, 50};
        int[] intArray = {100, 200, 300, 400, 500};
        long[] longArray = {1000000001L, 1000000002L, 1000000003L};
        float[] floatArray = {98.5f, 85.2f, 76.8f};
        double[] doubleArray = {2.3d, 4.7d, 6.1d, 8.9d};
        boolean[] booleanArray = {true, false, true};
        char[] charArray = {'a', 'b', 'c', 'd'};

        log.info("short[]: {}", Arrays.toString(shortArray));
        log.info("byte[]: {}", Arrays.toString(byteArray));
        log.info("int[]: {}", Arrays.toString(intArray));
        log.info("long[]: {}", Arrays.toString(longArray));
        log.info("float[]: {}", Arrays.toString(floatArray));
        log.info("double[]: {}", Arrays.toString(doubleArray));
        log.info("boolean[]: {}", Arrays.toString(booleanArray));
        log.info("char[]: {}", Arrays.toString(charArray));
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_f64e497ead0c4dc0ad7879c84419f4f2~mv2.png/v1/fill/w_1480,h_216,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_f64e497ead0c4dc0ad7879c84419f4f2~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **Array of Wrapper Classes**

**Arrays can be created to hold elements of wrapper classes for primitive types, such as Integer, Double, Character, etc.**

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        Short[] shortArray = {1, 2, 3, 4, 5};
        Byte[] byteArray = {10, 20, 30, 40, 50};
        Integer[] intArray = {100, 200, 300, 400, 500};
        Long[] longArray = {1000000001L, 1000000002L, 1000000003L};
        Float[] floatArray = {98.5f, 85.2f, 76.8f};
        Double[] doubleArray = {2.3d, 4.7d, 6.1d, 8.9d};
        Boolean[] booleanArray = {true, false, true};
        Character[] charArray = {'a', 'b', 'c', 'd'};

        log.info("Short[]: {}", Arrays.toString(shortArray));
        log.info("Byte[]: {}", Arrays.toString(byteArray));
        log.info("Integer[]: {}", Arrays.toString(intArray));
        log.info("Long[]: {}", Arrays.toString(longArray));
        log.info("Float[]: {}", Arrays.toString(floatArray));
        log.info("Double[]: {}", Arrays.toString(doubleArray));
        log.info("Boolean[]: {}", Arrays.toString(booleanArray));
        log.info("Char[]: {}", Arrays.toString(charArray));
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_8ec96c87d7b84f3a8faf594f9b8745c2~mv2.png/v1/fill/w_1480,h_216,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_8ec96c87d7b84f3a8faf594f9b8745c2~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **Array of Strings**

Since String is an object type in Java, an array can be created specifically to hold elements of type String.

```java
String[] names = {"Alice", "Bob", "Charlie"};
log.info("Short[]: {}", Arrays.toString(names));
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_a27006e65df84a2d97d7b9f48c46f6d2~mv2.png/v1/fill/w_1480,h_98,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_a27006e65df84a2d97d7b9f48c46f6d2~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **Array of Classes**

We can create an array of objects where each object is an instance of a class. This allows us to store multiple instances of the same class in an array.

**Person.java**

```java
import lombok.Data;

@Data
public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

**Application.java**

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        Person[] people = {new Person("John", 25), new Person("Jane", 30), new Person("Doe", 20)};
        log.info("Person[]: {}", Arrays.toString(people));
    }
}
```

**Output**

<figure><img src="https://static.wixstatic.com/media/5fb94b_cc010b30d3c14ed2bfc26b1d91e8eea3~mv2.png/v1/fill/w_1480,h_72,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_cc010b30d3c14ed2bfc26b1d91e8eea3~mv2.png" alt="ree"><figcaption></figcaption></figure>



**Array of Object class (java.lang.Object)**

Every class in Java directly or indirectly inherits from the Object class. It provides a set of methods and behaviors that are available to all objects in Java. We can create an array of objects of the Object class in Java. The Object class is a superclass of all other classes in Java, so an array of Object can hold instances of any class.

**Application.java**

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        // Create an array of Object
        Object[] objectArray = new Object[3];
        objectArray[0] = "Hello";
        objectArray[1] = 123;
        objectArray[2] = new Person("John", 23);

        // Access and use the elements of the array
        for (Object obj : objectArray) {
            if (obj instanceof String) {
                String str = (String) obj;
                log.info("String: {}", str);
            } else if (obj instanceof Integer) {
                int num = (int) obj;
                log.info("Integer: {}", num);
            } else if (obj instanceof Person) {
                Person myObj = (Person) obj;
                log.info("Custom Object: {}", myObj.getName());
            }
        }
        log.info("Object[]: {}", Arrays.toString(objectArray));
    }
}
```

**Output**

<figure><img src="https://static.wixstatic.com/media/5fb94b_156106ea8d85432baf105954a7de4f04~mv2.png/v1/fill/w_1480,h_110,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_156106ea8d85432baf105954a7de4f04~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### <mark style="color:blue;">**Category: Based on Dimensions**</mark>

In Java, we can create multi-dimensional arrays, which are arrays with more than one dimension. This allows to create arrays of arrays, forming a matrix-like structure. The Arrays.toString() method in Java is primarily designed to work with one-dimensional arrays. When we pass a multi-dimensional array (such as a two-dimensional array) to Arrays.toString(), it will not provide the desired output because it does not support nested arrays. The deepToString() method handles nested arrays and provides a string representation of the entire multi-dimensional array.

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);

        // One-Dimensional Array
        int[] oneDArray = {1, 2, 3};
        log.info("oneDArray[]: {}", Arrays.toString(oneDArray));

        // Two-Dimensional Array
        int[][] twoDArray = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
        log.info("twoDArray[][]: {}", Arrays.deepToString(twoDArray));

        // Three-Dimensional Array
        int[][][] threeDArray = { { {1, 2}, {3, 4}, {5, 6} }, { {7, 8}, {9, 10}, {11, 12} } };
        log.info("threeDArray[][][]: {}", Arrays.deepToString(threeDArray));
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_98d7f32dc76447cba6f965b0add958d8~mv2.png/v1/fill/w_1480,h_134,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_98d7f32dc76447cba6f965b0add958d8~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **List**

An ordered collection that allows duplicate elements.

#### **ArrayList**

ArrayList is a class in Java that provides a resizable array implementation of the List interface. It belongs to the java.util package and is commonly used to store and manipulate collections of objects.

Some commonly used types that can be used as the "type" parameter in ArrayList\<type>:

{% hint style="info" %}
ArrayList\<Integer>: Used to store integer values.

ArrayList\<String>: Used to store strings.

ArrayList\<Double>: Used to store floating-point numbers.

ArrayList\<Boolean>: Used to store boolean values.

ArrayList\<Character>: Used to store individual characters.

ArrayList\<Long>: Used to store long integer values.

ArrayList\<Byte>: Used to store byte values.

ArrayList\<Short>: Used to store short integer values.

ArrayList\<Float>: Used to store floating-point numbers with single precision.

ArrayList\<SomeClass>: Used to store objects of a custom class SomeClass.
{% endhint %}

```java
// List: ArrayList
List<String> arrayList = new ArrayList<>();
arrayList.add("Apple");
arrayList.add("Banana");
arrayList.add("Orange");
log.info("ArrayList: {}", arrayList);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_de3739af1ab94c9db5156b83dabf29fc~mv2.png/v1/fill/w_1480,h_56,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_de3739af1ab94c9db5156b83dabf29fc~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **LinkedList**

LinkedList uses a doubly-linked list structure to store elements and dynamically allocates memory for each element.

```java
// List: LinkedList
List<String> linkedList = new LinkedList<>();
linkedList.add("Elephant");
linkedList.add("Dog");
linkedList.add("Cat");
log.info("LinkedList: {}", linkedList);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_bf7d0aa361354bb7be37e1126db60fbe~mv2.png/v1/fill/w_1480,h_56,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_bf7d0aa361354bb7be37e1126db60fbe~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Vector**

Vector is a class in Java that provides a dynamic array-like implementation similar to ArrayList. It is part of the java.util package.

```java
// List: Vector
List<String> vector = new Vector<>();
vector.add("Red");
vector.add("Green");
vector.add("Blue");
log.info("Vector: {}", vector);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_763c1b3d93654c2db0b10fb7eb942669~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_763c1b3d93654c2db0b10fb7eb942669~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Stack**

Stack is a class that represents a last-in, first-out (LIFO) data structure. It is part of the java.util package and extends the Vector class. However, it is usually recommended to use the Deque interface and its implementing class LinkedList instead, as Stack inherits from Vector, which is a legacy class.

```java
// List: Stack
Stack<String> stack = new Stack<>();
stack.push("One");
stack.push("Two");
stack.push("Three");
log.info("Stack: {}", stack);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_8940c0e2d3f341b7a08711853c5ecf43~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_8940c0e2d3f341b7a08711853c5ecf43~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Set**

A collection that does not allow duplicate elements.

#### **HashSet**

HashSet is a class that implements the Set interface and provides an unordered collection of unique elements. It is part of the java.util package and offers constant-time performance for basic operations such as adding, removing, and checking for the presence of elements.

```java
// Set: HashSet
Set<String> hashSet = new HashSet<>();
hashSet.add("Apple");
hashSet.add("Banana");
hashSet.add("Orange");
log.info("HashSet: {}", hashSet);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_ed7ea9fbba6248f697ef872020e9ddf1~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_ed7ea9fbba6248f697ef872020e9ddf1~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **LinkedHashSet**

LinkedHashSet is a class that extends HashSet and provides a hash table implementation with predictable iteration order. It is part of the java.util package and combines the uniqueness of elements provided by HashSet with the insertion order preservation of LinkedHashMap

```java
// Set: LinkedHashSet
Set<String> linkedHashSet = new LinkedHashSet<>();
linkedHashSet.add("Cat");
linkedHashSet.add("Dog");
linkedHashSet.add("Elephant");
log.info("LinkedHashSet: {}", linkedHashSet);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_1f21cd20a01e4d4f98a78a1235274cd8~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_1f21cd20a01e4d4f98a78a1235274cd8~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **TreeSet**

TreeSet is a class that implements the SortedSet interface and provides a sorted set of unique elements. It is part of the java.util package and uses a self-balancing binary search tree to store and maintain its elements in sorted order.

```java
// Set: TreeSet
Set<String> treeSet = new TreeSet<>();
treeSet.add("Red");
treeSet.add("Green");
treeSet.add("Blue");
log.info("TreeSet: {}", treeSet);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_ec02df1b65f3495cb0a35b979aae2b88~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_ec02df1b65f3495cb0a35b979aae2b88~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Queue**

A collection designed for holding elements prior to processing.

#### **LinkedList**

LinkedList can also be used to implement a Queue data structure. A queue is a collection that follows the first-in, first-out (FIFO) principle, where elements are added at the end and removed from the beginning.

```java
// Queue: LinkedList
Queue<String> linkedListQueue = new LinkedList<>();
linkedListQueue.add("One");
linkedListQueue.add("Two");
linkedListQueue.add("Three");
log.info("LinkedList: {}", linkedListQueue);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_c6500441ccad4cd2bed67f68a681d37b~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_c6500441ccad4cd2bed67f68a681d37b~mv2.png" alt="ree"><figcaption></figcaption></figure>

**PriorityQueue**

PriorityQueue is a class that implements the Queue interface and provides a priority-based ordering of elements. It is part of the java.util package and internally uses a binary heap data structure to maintain the elements in the queue.

```java
// Queue: PriorityQueue
Queue<String> priorityQueue = new PriorityQueue<>();
priorityQueue.add("Apple");
priorityQueue.add("Banana");
priorityQueue.add("Orange");
log.info("PriorityQueue: {}", priorityQueue);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_4577433ebf49460a860648f5f5817486~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_4577433ebf49460a860648f5f5817486~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Deque**

A double-ended queue that supports adding and removing elements from both ends.\


**ArrayDeque**

ArrayDeque is a class that implements the Deque interface and provides a resizable-array implementation of a double-ended queue. It is part of the java.util package and offers efficient insertion and removal operations at both ends of the deque

```java
// Deque: ArrayDeque
Deque<String> arrayDeque = new ArrayDeque<>();
arrayDeque.addFirst("First");
arrayDeque.addLast("Second");
log.info("PriorityQueue: {}", arrayDeque);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_07649e1d9e204c72aa5c3ad71443582d~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_07649e1d9e204c72aa5c3ad71443582d~mv2.png" alt="ree"><figcaption></figcaption></figure>

**LinkedList**

LinkedList can also be used to implement a Deque data structure. A deque (short for double-ended queue) is a collection that allows insertion and removal of elements at both ends.

```java
// Deque: LinkedList
Deque<String> linkedListDeque = new LinkedList<>();
linkedListDeque.addFirst("First");
linkedListDeque.addLast("Last");
log.info("PriorityQueue: {}", linkedListDeque);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_6d447265d14848d496ee12b315569d8b~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_6d447265d14848d496ee12b315569d8b~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Map**

An object that maps keys to values, where each key is unique.

#### **HashMap**

HashMap is a class that implements the Map interface and provides a hash table-based implementation of a map. It is part of the java.util package and allows storing key-value pairs, where each key is unique.

```java
// Map: HashMap
Map<Integer, String> hashMap = new HashMap<>();
hashMap.put(1, "One");
hashMap.put(2, "Two");
hashMap.put(3, "Three");
log.info("HashMap: {}", hashMap);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_a2a1c7510ae34a91a05f01a59612767e~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_a2a1c7510ae34a91a05f01a59612767e~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **LinkedHashMap**

LinkedHashMap is a class that extends HashMap and provides a hash table-based implementation of a map that maintains the insertion order of elements. It is part of the java.util package and offers the same key-value mapping functionality as HashMap, with the additional guarantee of predictable iteration order based on the order of insertion.

```java
// Map: LinkedHashMap
Map<Integer, String> linkedHashMap = new LinkedHashMap<>();
linkedHashMap.put(1, "One");
linkedHashMap.put(2, "Two");
linkedHashMap.put(3, "Three");
log.info("LinkedHashMap: {}", linkedHashMap);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_682f4620edf24f2e868bf1124ea8f7fb~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_682f4620edf24f2e868bf1124ea8f7fb~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **TreeMap**

TreeMap is a class that implements the NavigableMap interface and provides a sorted map implementation based on a red-black tree data structure. It is part of the java.util package and offers key-value mapping where the keys are sorted in natural order or based on a custom comparator.

```java
// Map: TreeMap
Map<Integer, String> treeMap = new TreeMap<>();
treeMap.put(3, "Three");
treeMap.put(1, "One");
treeMap.put(2, "Two");
log.info("TreeMap: {}", treeMap);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_7470d16fb4f747ada59aac0a91dbebe8~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_7470d16fb4f747ada59aac0a91dbebe8~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **Hashtable**

Hashtable is a class that implements the Map interface and provides a hash table-based implementation of a map. It is part of the java.util package and offers key-value mapping where the keys are hashed to provide efficient lookup and retrieval.

```java
// Map: Hashtable
Map<String, Integer> hashtable = new Hashtable<>();
hashtable.put("One", 1);
hashtable.put("Two", 2);
hashtable.put("Three", 3);
log.info("Hashtable: {}", hashtable);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_79473edd1cf14b9e9deceb0aebd1260f~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_79473edd1cf14b9e9deceb0aebd1260f~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Properties**

The Properties class is a subclass of Hashtable that represents a persistent set of properties. It is part of the java.util package and provides a convenient way to handle key-value pairs, typically used for configuration settings or application properties.

```java
// Map: Properties
Properties properties = new Properties();
properties.setProperty("name", "John");
properties.setProperty("age", "25");
log.info("Properties: {}", properties);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_66e5a0780dd74ebabb5a09d3f1f641b0~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_66e5a0780dd74ebabb5a09d3f1f641b0~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **SortedSet**

A set that maintains its elements in sorted order.

#### TreeSet

TreeSet is a class that implements the SortedSet interface. It represents a sorted set of elements stored in a tree-like structure. It is part of the java.util package and offers functionality similar to HashSet, but with elements sorted in their natural order or according to a custom comparator.

```java
// SortedSet: TreeSet
SortedSet<Integer> sortedSet = new TreeSet<>();
sortedSet.add(3);
sortedSet.add(1);
sortedSet.add(2);
log.info("TreeSet: {}", sortedSet);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_4ac1f349465a4ac7946f4ee2067a2bfd~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_4ac1f349465a4ac7946f4ee2067a2bfd~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **SortedMap**

A map that maintains its entries in sorted order.

#### **TreeMap**

TreeMap is a class that implements the SortedMap interface. It represents a sorted map based on a red-black tree data structure. It is part of the java.util package and offers functionality similar to HashMap, but with the keys sorted in their natural order or according to a custom comparator.

```java
// SortedMap: TreeMap
SortedMap<Integer, String> sortedMap = new TreeMap<>();
sortedMap.put(3, "Three");
sortedMap.put(1, "One");
sortedMap.put(2, "Two");
log.info("TreeMap: {}", sortedMap);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_d5f42f3bae4a4cec90b01f83124ed319~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_d5f42f3bae4a4cec90b01f83124ed319~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **Enumeration**

An interface representing an enumeration of a collection of objects.

#### **Vector**

Vector is a class that represents a dynamic array, similar to ArrayList, and is part of the java.util package. The Enumeration interface is also part of the java.util package and provides a way to iterate over a collection of objects.

```java
// Enumeration: Vector
 Vector<String> vectorEnum = new Vector<>();
 vectorEnum.add("One");
 vectorEnum.add("Two");
 vectorEnum.add("Three");
 Enumeration<String> enumeration = vectorEnum.elements(); // Prints to java.util.Vector$1@11478137
 String elements = Stream.generate(enumeration::nextElement)
                .limit(vectorEnum.size())
                .collect(Collectors.joining(" "));
log.info("Enumeration Elements: {}", elements);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_f028d22f8ef64f6091fa0041f442d355~mv2.png/v1/fill/w_1480,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_f028d22f8ef64f6091fa0041f442d355~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **Stack**

Stack class implements the Vector class and provides additional methods to support a LIFO (Last-In-First-Out) stack of objects. The Enumeration interface is part of the java.util package and provides a way to iterate over a collection of objects.

```java
Stack<String> stack = new Stack<>();
stack.push("One");
stack.push("Two");
stack.push("Three");
Enumeration<String> enumeration = stack.elements();
String elements = Stream.generate(enumeration::nextElement)
        .limit(stack.size())
        .collect(Collectors.joining(" "));
log.info("Enumeration Elements: {}", elements);
```

### **Iterator**

An interface that provides a way to access elements in a collection. All collection classes provide iterators.

```java
List<String> arrayList = new ArrayList<>();
arrayList.add("Apple");
arrayList.add("Banana");
arrayList.add("Orange");

// Iterator: All collection classes provide iterators.
Iterator<String> iterator = arrayList.listIterator();

String str = Stream.generate(iterator::next).limit(arrayList.size()).collect(Collectors.joining(" "));
log.info("Iterator Elements: {}", str);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_7da6e33f7b314f49a4201e94e2ad0d9c~mv2.png/v1/fill/w_1480,h_60,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_7da6e33f7b314f49a4201e94e2ad0d9c~mv2.png" alt="ree"><figcaption></figcaption></figure>

### **ListIterator**

An interface that extends the Iterator interface to provide additional functionality for traversing and modifying lists.

#### **ArrayList**

```java
List<String> arrayList = new ArrayList<>();
arrayList.add("Apple");
arrayList.add("Banana");
arrayList.add("Orange");

// ListIterator: ArrayList
ListIterator<String> arrayListIterator = arrayList.listIterator();

String str = Stream.generate(arrayListIterator::next).limit(arrayList.size()).collect(Collectors.joining(" "));
log.info("ListIterator Elements: {}", str);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_d3fa139f59904365863a111cf3526240~mv2.png/v1/fill/w_1480,h_60,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_d3fa139f59904365863a111cf3526240~mv2.png" alt="ree"><figcaption></figcaption></figure>

#### **LinkedList**

```java
List<String> linkedList = new LinkedList<>();
linkedList.add("Apple");
linkedList.add("Banana");
linkedList.add("Orange");

// ListIterator: LinkedList
ListIterator<String> linkedListIterator = linkedList.listIterator();

String str = Stream.generate(linkedListIterator::next).limit(linkedList.size()).collect(Collectors.joining(" "));
log.info("ListIterator Elements: {}", str);
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_af9a101f38fd45dba14fc7cf1a95a767~mv2.png/v1/fill/w_1480,h_60,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_af9a101f38fd45dba14fc7cf1a95a767~mv2.png" alt="ree"><figcaption></figcaption></figure>
