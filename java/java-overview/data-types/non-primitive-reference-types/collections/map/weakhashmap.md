# WeakHashMap

## About

The `WeakHashMap` in Java is a specialized implementation of the `Map` interface that uses weak references for its keys. This allows keys that are no longer referenced elsewhere in the application to be garbage collected, making `WeakHashMap` a useful choice in caching and memory-sensitive applications.

## **Features**

1. **Weak Keys:** The keys in a `WeakHashMap` are stored as weak references. A weak reference does not prevent the key from being garbage collected. When a key is garbage collected, its corresponding entry is automatically removed from the map during the next operation on the map (like adding, removing, or querying).
2. **Null Values and Keys:** `WeakHashMap` allows one `null` key and multiple `null` values.
3. **Not Thread-Safe:**`WeakHashMap` is not synchronized. If multiple threads access it concurrently, it must be synchronized externally.
4. **Efficient Cleanup:** The map automatically cleans up entries whose keys are garbage collected, reducing memory overhead without explicit removal.
5. **Use of ReferenceQueue:** `WeakHashMap` internally uses a `ReferenceQueue` to track weak references whose keys have been cleared by the garbage collector. This queue allows it to remove stale entries.

## **Internal Working of WeakHashMap**

1. **Key as WeakReference:** Keys are wrapped in `java.lang.ref.WeakReference` objects, which allow the garbage collector to reclaim the memory used by the key if it is no longer strongly referenced.
2. **Automatic Removal:** When the garbage collector reclaims a weak key, it adds the corresponding `WeakReference` object to the `ReferenceQueue`. `WeakHashMap` processes this queue to remove stale entries.
3. **Structure:** Internally, `WeakHashMap` uses a hash table similar to `HashMap`. However, instead of using the key directly, it uses a `WeakReference` to wrap the key.
4. **Entry Removal:** When performing operations like `put()`, `get()`, or `remove()`, `WeakHashMap` checks the `ReferenceQueue` for keys that have been cleared. It removes the entries associated with these keys from the map.

{% hint style="info" %}
* **Behavior with Large Objects:** Storing large objects in a `WeakHashMap` may lead to frequent garbage collection, so consider using it only for small objects.
* **Performance:** The performance of a `WeakHashMap` can degrade if frequent operations cause constant cleanup of stale entries.
* **WeakKey Equivalence:** The `equals()` and `hashCode()` methods of keys are used for comparison, so keys must implement them correctly.
{% endhint %}

## **When to Use WeakHashMap**

1. **Caches:** It is ideal for use in caches where the key should be automatically removed when it is no longer referenced elsewhere.
2. **Listeners or Observers:** When managing listeners or observers that should not prevent their associated objects from being garbage collected.
3. **Memory-Sensitive Applications:** In scenarios where memory optimization is critical, and you want to avoid memory leaks caused by unused keys.

## **Example Usage of WeakHashMap**

```java
import java.util.WeakHashMap;

public class WeakHashMapExample {
    public static void main(String[] args) {
        WeakHashMap<Object, String> weakMap = new WeakHashMap<>();

        Object key1 = new Object();
        Object key2 = new Object();

        weakMap.put(key1, "Value1");
        weakMap.put(key2, "Value2");

        System.out.println("Before GC: " + weakMap); // Before GC: {java.lang.Object@hashcode=Value1, java.lang.Object@hashcode=Value2}

        // Remove strong references
        key1 = null;

        // Request garbage collection
        System.gc();

        // Allow some time for GC to run
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("After GC: " + weakMap); // After GC: {java.lang.Object@hashcode=Value2}
    }
}
```

## **Advantages of WeakHashMap**

1. **Prevents Memory Leaks:** Automatically removes entries for keys that are no longer used, helping to manage memory efficiently.
2. **Lightweight Caching:** Simplifies cache implementation without the need for manual cleanup.
3. **Integration with GC:** Works seamlessly with the garbage collector to clean up unused entries.

## **Disadvantages of WeakHashMap**

1. **Unpredictable Entry Removal:** Entry removal depends on the garbage collector. This can make behavior unpredictable.
2. **Not Thread-Safe:** Requires external synchronization in multithreaded applications.
3. **Not Suitable for Strong References:** If strong references to the keys exist, entries will not be removed.

