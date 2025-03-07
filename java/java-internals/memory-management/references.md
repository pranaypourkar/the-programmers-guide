# References

## About

In Java, **references** determine how an object is accessed and managed in memory, especially with regard to garbage collection (GC). Java provides different types of references **strong**, **weak**, **soft**, and **phantom** each with varying implications on memory management.&#x20;

## **1. Strong Reference**

### **About**

A **strong reference** is the default reference type in Java. It ensures that the referenced object remains in memory and is not eligible for garbage collection as long as the reference exists.

### **Characteristics**

* A strong reference prevents the garbage collector from reclaiming the memory of the referenced object.
* The object will only be garbage collected if the reference is explicitly set to `null` or goes out of scope.
* Most objects we create in Java are strong references by default.

### **Example of Strong Reference**

```java
public class StrongReferenceExample {
    public static void main(String[] args) {
        // The strongRef variable is a strong reference to the String object.
        String strongRef = new String("Hello, World!");
        
        // This object cannot be garbage collected until `strongRef` is set to null
        System.out.println(strongRef); // Output: Hello, World!
        
        // Nullify the reference
        strongRef = null;

        // Now the object is eligible for garbage collection
    }
}
```

### **When to Use**

* When we want to ensure the object is always accessible and not accidentally reclaimed by the garbage collector.
* For most regular object references.

## **2. Weak Reference**

### **About**

A **weak reference** allows the garbage collector to reclaim the referenced object if there are no other strong references to it. Weak references are used when we want to allow the object to be garbage collected while still having a reference to it.

### **Characteristics**

* A weak reference does not prevent its referent (the object it refers to) from being garbage collected.
* Used in conjunction with `java.lang.ref.WeakReference` class.
* Often used for memory-sensitive caching and maps like `WeakHashMap`.

### **Example of Weak Reference**

```java
import java.lang.ref.WeakReference;

public class WeakReferenceExample {
    public static void main(String[] args) {
        // Create a strong reference
        String strongRef = new String("WeakReference Example");

        // Create a weak reference to the object
        WeakReference<String> weakRef = new WeakReference<>(strongRef);

        // Print the value via weak reference
        System.out.println("Before GC: " + weakRef.get()); // Output: WeakReference Example

        // Nullify the strong reference
        strongRef = null;

        // Request garbage collection
        System.gc();

        // Allow some time for GC to run
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Check if the object was garbage collected
        System.out.println("After GC: " + weakRef.get()); // Output: null (if GC collected the object)
    }
}
```

### **When to Use**

* **Caches:** Weak references are used in `WeakHashMap` to allow keys to be garbage collected when no longer in use.
* **Listeners:** Weak references are used for listeners or observers in event-driven systems to avoid memory leaks.

### **What Happens in the Examples?**

#### **Strong Reference Example:**

```java
String strongRef = new String("Hello, World!");
```

* The `strongRef` variable is a strong reference to the `String` object.
* As long as `strongRef` exists and is not set to `null`, the garbage collector **cannot** reclaim the object, even if memory is low.

If we set `strongRef = null`, **there are no references to the object**, and it becomes eligible for garbage collection.

#### **Weak Reference Example:**

```java
String strongRef = new String("WeakReference Example");
WeakReference<String> weakRef = new WeakReference<>(strongRef);
```

* `strongRef` is a **strong reference** to the `String` object, and `weakRef` is a **weak reference** to the same object.
* As long as `strongRef` exists, the object is **not eligible for garbage collection**, because the strong reference keeps it alive.
* When we set `strongRef = null`, only the **weak reference** remains. This makes the object **eligible for garbage collection**, even if `weakRef` still points to it.

## **3. Soft Reference**

### **About**

A **soft reference** is a reference that allows the garbage collector to reclaim the referenced object **only when the JVM runs out of memory**. It is more lenient than a weak reference and is often used for implementing memory-sensitive caches.

### **Characteristics**

* The garbage collector clears a soft reference only when memory is low, making it useful for caching.
* If a soft reference is not reclaimed, you can still access the object.
* Implemented using the `java.lang.ref.SoftReference` class.
* Provides a balance between strong and weak references: the object remains accessible unless the JVM is under memory pressure.

### **Example of Soft Reference**

```java
import java.lang.ref.SoftReference;

public class SoftReferenceExample {
    public static void main(String[] args) {
        // Create a strong reference
        String strongRef = new String("SoftReference Example");

        // Create a soft reference to the object
        SoftReference<String> softRef = new SoftReference<>(strongRef);

        // Print the value via soft reference
        System.out.println("Before GC: " + softRef.get()); // Output: SoftReference Example

        // Nullify the strong reference
        strongRef = null;

        // Request garbage collection
        System.gc();

        // Allow some time for GC to run
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Check if the object was garbage collected
        System.out.println("After GC: " + softRef.get()); // Likely still accessible unless memory is low
    }
}
```

### **When to Use:**

* **Caching:** Soft references are often used for **memory-sensitive caching**. For example, in an image cache: Images can be held in memory as long as the JVM has enough memory. If memory runs low, the cache will release them.

## **Phantom Reference**

### **About**

A phantom reference is the weakest type of reference in Java. Unlike weak or soft references, a phantom reference does not allow access to the referenced object at any point. Phantom references are typically used in conjunction with a `ReferenceQueue` to track the lifecycle of objects and perform cleanup operations after the object has been finalized but before its memory is reclaimed by the garbage collector.

### **Characteristics**

* Accessing the referent through `PhantomReference.get()` always returns `null`.
* The primary use is for cleanup actions, as the reference is enqueued in a `ReferenceQueue` after the object is finalized but before memory is reclaimed.
* Implemented using `java.lang.ref.PhantomReference`.
* Requires a `ReferenceQueue` to be useful.
* Used for advanced memory management tasks, such as ensuring certain cleanup tasks are performed before memory is freed.

### **Example of Phantom Reference**

```java
import java.lang.ref.PhantomReference;
import java.lang.ref.Reference;
import java.lang.ref.ReferenceQueue;

public class PhantomReferenceExample {
    public static void main(String[] args) {
        // Create a strong reference
        String strongRef = new String("PhantomReference Example");

        // Create a reference queue
        ReferenceQueue<String> referenceQueue = new ReferenceQueue<>();

        // Create a phantom reference to the object
        PhantomReference<String> phantomRef = new PhantomReference<>(strongRef, referenceQueue);

        System.out.println(phantomRef.get()); // Always returns null

        // Nullify the strong reference
        strongRef = null;

        // Request garbage collection
        System.gc();

        // Allow some time for GC to run
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Check if the object was enqueued
        Reference<? extends String> refFromQueue = referenceQueue.poll();
        if (refFromQueue != null) {
            System.out.println("The phantom-referenced object has been enqueued for cleanup.");
        } else {
            System.out.println("The object is not yet garbage collected.");
        }
    }
}
```

### **Why Are Phantom References Useful?**

Phantom references solve problems that weak references cannot handle:

1. **Finalization Tracking:**
   * Weak references cannot detect when an object has been finalized; they only indicate when the object is garbage collected.
   * Phantom references ensure that we can track an object's finalization and take appropriate actions before memory is reclaimed.
2. **Post-Finalization Cleanup:**
   * Phantom references are used to clean up resources (e.g., close file descriptors, release native memory) associated with an object after it has been finalized.
   * Weak references do not provide such capabilities.

{% hint style="success" %}
#### **When is an Object Finalized?**

An object is considered **finalized** after the following steps occur:

1. **Object Becomes Unreachable**:
   * The object is no longer accessible through any strong references in your program.
   * The garbage collector identifies it as eligible for garbage collection.
2. **`finalize()` Method is Called**:
   * The garbage collector invokes the `finalize()` method on the object **before reclaiming its memory**.
   * If the object overrides the `finalize()` method, it can perform cleanup operations.
3. **Object Memory is Reclaimed**:
   * After `finalize()` finishes execution, the object's memory is freed, and the object is destroyed (unless it resurrects itself, explained below).
{% endhint %}

## Comparison of all four reference types

<table data-header-hidden data-full-width="true"><thead><tr><th width="136"></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Strong Reference</strong></td><td><strong>Soft Reference</strong></td><td><strong>Weak Reference</strong></td><td><strong>Phantom Reference</strong></td></tr><tr><td><strong>Definition</strong></td><td>Default type of reference in Java; ensures the object remains in memory.</td><td>Prevents object collection unless JVM memory is low.</td><td>Allows object collection as soon as no strong references exist.</td><td>Tracks object lifecycle post-finalization but does not allow access to the object.</td></tr><tr><td><strong>Garbage Collection</strong></td><td>Object is never garbage collected unless reference is explicitly cleared or nullified.</td><td>Object is garbage collected only if memory is low.</td><td>Object is garbage collected immediately after no strong references exist.</td><td>Object is collected after finalization, just before memory is reclaimed.</td></tr><tr><td><strong>Access to Object</strong></td><td>Object is always accessible until explicitly cleared.</td><td>Accessible via <code>get()</code> until the object is collected.</td><td>Accessible via <code>get()</code> until the object is collected.</td><td>Always returns <code>null</code> when accessed via <code>get()</code>.</td></tr><tr><td><strong>Strength of Reference</strong></td><td>Strongest (default behavior in Java).</td><td>Weaker than strong references but stronger than weak references.</td><td>Weaker than both strong and soft references.</td><td>Weakest of all reference types.</td></tr><tr><td><strong>Reference Class</strong></td><td>No special class required (default reference).</td><td><code>java.lang.ref.SoftReference</code>.</td><td><code>java.lang.ref.WeakReference</code>.</td><td><code>java.lang.ref.PhantomReference</code>.</td></tr><tr><td><strong>ReferenceQueue Usage</strong></td><td>Not applicable.</td><td>Optional (to monitor when object is collected).</td><td>Optional (to monitor when object is collected).</td><td>Mandatory (used to track objects for cleanup before memory reclamation).</td></tr><tr><td><strong>Use Case</strong></td><td>General-purpose programming where the object must persist in memory.</td><td>Caching, where objects can be retained until memory is needed elsewhere.</td><td>Mapping objects (e.g., <code>WeakHashMap</code>), listeners, and avoiding memory leaks.</td><td>Post-finalization cleanup, resource deallocation, and advanced resource tracking.</td></tr><tr><td><strong>Example Collection</strong></td><td>Never garbage collected until explicitly cleared.</td><td>Collected only under memory pressure.</td><td>Collected as soon as no strong references exist.</td><td>Collected after finalization and queued for cleanup.</td></tr></tbody></table>
