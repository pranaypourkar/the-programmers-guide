# Default Values

In Java, different types of variables have different default values when they are not explicitly initialized. Here are the default values for each type:

1. **Primitive Data Types**
   * `byte`, `short`, `int`, `long`: `0`
   * `float`, `double`: `0.0`
   * `char`: `'\u0000'` (null character)
   * `boolean`: `false`
2. **Reference Data Types**
   * For reference types (objects), the default value is `null`, meaning they do not refer to any object in memory.
3. **Local Variables**
   * Local variables must be explicitly initialized before they are used. They do not have default values. **Compilation** error will occur if not initialized and tried to use.

<figure><img src="../../../.gitbook/assets/image (312).png" alt="" width="563"><figcaption></figcaption></figure>

4. **Static and Instance Variables**

* If they are not explicitly initialized, they are automatically initialized with their default values. **Non-static - Non local variables will also be initialized.**

```java
public class Application {
    static int i1;
    static Integer i2;
    public static void main(String[] args) {
        System.out.println(i1); // 0
        System.out.println(i2); // null
    }
}
```
