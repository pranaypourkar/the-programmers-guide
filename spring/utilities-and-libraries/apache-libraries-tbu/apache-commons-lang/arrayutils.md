# ArrayUtils

## About

`ArrayUtils` is a utility class provided by **Apache Commons Lang** to simplify working with Java arrays. Java arrays are low-level and have limited built-in methods, making operations like searching, copying, checking for emptiness, or merging somewhat cumbersome.

`ArrayUtils` provides **null-safe**, **convenient**, and **readable** methods to handle arrays of all primitive types and objects. It also helps avoid manual loops, `System.arraycopy`, and verbose boilerplate code.

## Characteristics

* All methods are **static**.
* Handles both **primitive** and **object** arrays.
* Offers **null safety** — no need to check for `null` before calling utility methods.
* Reduces common array operations to one-liners.

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.ArrayUtils;
```

## Common Categories of Methods

### 1. Null and Empty Checks

<table><thead><tr><th width="260.76214599609375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>isEmpty(array)</code></td><td>Returns <code>true</code> if array is <code>null</code> or length is 0</td></tr><tr><td><code>isNotEmpty(array)</code></td><td>Returns <code>true</code> if array is not <code>null</code> and has elements</td></tr></tbody></table>

**Example:**

```java
if (ArrayUtils.isEmpty(myArray)) {
    // safely handle empty case
}
```

### 2. Array Creation and Conversion

<table><thead><tr><th width="293.48345947265625">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>toObject(int[])</code></td><td>Converts a primitive array to wrapper array</td></tr><tr><td><code>toPrimitive(Integer[])</code></td><td>Converts wrapper array to primitive array</td></tr><tr><td><code>nullToEmpty(array)</code></td><td>Converts <code>null</code> array to empty array</td></tr></tbody></table>

**Example:**

```java
int[] ints = {1, 2, 3};
Integer[] boxed = ArrayUtils.toObject(ints);
```

### 3. Element Checks

| Method                      | Description                                 |
| --------------------------- | ------------------------------------------- |
| `contains(array, value)`    | Checks if array contains a specific element |
| `indexOf(array, value)`     | Returns the index of the element, or -1     |
| `lastIndexOf(array, value)` | Returns the last index of the element       |

**Example:**

```java
if (ArrayUtils.contains(new int[]{1, 2, 3}, 2)) {
    // element found
}
```

### 4. Adding and Removing Elements

| Method                        | Description                       |
| ----------------------------- | --------------------------------- |
| `add(array, value)`           | Adds value at the end             |
| `add(array, index, value)`    | Inserts value at a specific index |
| `remove(array, index)`        | Removes value at index            |
| `removeElement(array, value)` | Removes first occurrence of value |

**Example:**

```java
int[] result = ArrayUtils.add(new int[]{1, 2}, 3); // [1, 2, 3]
```

### 5. Concatenation and Cloning

| Method                                  | Description                  |
| --------------------------------------- | ---------------------------- |
| `addAll(array1, array2)`                | Concatenates arrays          |
| `clone(array)`                          | Returns a clone of the array |
| `subarray(array, startIndex, endIndex)` | Gets a range of elements     |

**Example:**

```java
int[] combined = ArrayUtils.addAll(new int[]{1, 2}, new int[]{3, 4});
```

### 6. Array Reversal and Shuffling

<table><thead><tr><th width="168.470458984375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>reverse(array)</code></td><td>Reverses the array in place</td></tr><tr><td><code>shuffle(array)</code></td><td>Randomizes the order (not in standard <code>ArrayUtils</code>, but can use custom logic)</td></tr></tbody></table>

**Example:**

```java
int[] nums = {1, 2, 3};
ArrayUtils.reverse(nums); // nums becomes {3, 2, 1}
```

### 7. Equality and Comparison

| Method                         | Description                                 |
| ------------------------------ | ------------------------------------------- |
| `isSameLength(array1, array2)` | Checks if two arrays are of the same length |
| `isEquals(array1, array2)`     | Checks if all elements are equal            |

### 8. Array Type Checking

| Method                | Description                               |
| --------------------- | ----------------------------------------- |
| `isArray(Object obj)` | Checks whether a given object is an array |

## Why Use `ArrayUtils` Instead of Raw Java?

<table data-header-hidden><thead><tr><th width="220.4366455078125"></th><th></th><th></th></tr></thead><tbody><tr><td>Concern</td><td>Raw Java Approach</td><td><code>ArrayUtils</code> Advantage</td></tr><tr><td>Null-safety</td><td>Manual checks</td><td>Built-in null checks</td></tr><tr><td>Adding/removing</td><td>Manual resizing or arraycopy</td><td>Simple one-liners</td></tr><tr><td>Searching</td><td>Manual loops</td><td>Ready-made methods</td></tr><tr><td>Conversion</td><td>Tedious type boxing/unboxing</td><td>Simplified conversions</td></tr></tbody></table>
