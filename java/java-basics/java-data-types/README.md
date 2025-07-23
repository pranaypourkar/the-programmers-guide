# Data Types

In Java, data types specify the size and type of values that can be stored in variables. Java has two categories of data types: **Primitive** data types and **Reference** data types.

## **Primitive D**ata Type

Primitive data types are predefined by the language and are named by a reserved keyword. They represent single values and are not objects.

### Different Types

<table data-full-width="true"><thead><tr><th>Data Type</th><th>Description</th><th>Size</th><th>Default Value</th></tr></thead><tbody><tr><td><code>byte</code></td><td>8-bit signed integer</td><td>1 byte</td><td>0</td></tr><tr><td><code>short</code></td><td>16-bit signed integer</td><td>2 bytes</td><td>0</td></tr><tr><td><code>int</code></td><td>32-bit signed integer</td><td>4 bytes</td><td>0</td></tr><tr><td><code>long</code></td><td>64-bit signed integer</td><td>8 bytes</td><td>0L</td></tr><tr><td><code>float</code></td><td>32-bit floating point</td><td>4 bytes</td><td>0.0f</td></tr><tr><td><code>double</code></td><td>64-bit floating point</td><td>8 bytes</td><td>0.0d</td></tr><tr><td><code>char</code></td><td>16-bit Unicode character</td><td>2 bytes</td><td>'\u0000'</td></tr><tr><td><code>boolean</code></td><td>true or false</td><td>not precisely defined</td><td>false</td></tr></tbody></table>

### Limits or Range

| Data Type | Size (in bits)        | Minimum Value                          | Maximum Value                           |
| --------- | --------------------- | -------------------------------------- | --------------------------------------- |
| `byte`    | 8                     | -128                                   | 127                                     |
| `short`   | 16                    | -32,768                                | 32,767                                  |
| `int`     | 32                    | -2,147,483,648                         | 2,147,483,647                           |
| `long`    | 64                    | -9,223,372,036,854,775,808             | 9,223,372,036,854,775,807               |
| `float`   | 32                    | Approximately ±3.40282347E+38F         | Approximately ±1.40239846E-45F          |
| `double`  | 64                    | Approximately ±1.7976931348623157E+308 | Approximately ±4.94065645841246544E-324 |
| `char`    | 16                    | 0                                      | 65,535                                  |
| `boolean` | not precisely defined | true or false                          | true or false                           |



{% hint style="info" %}
Size of data types is constant in java. The JVM (Java Virtual Machine) is designed to be platform independent. If data type sizes were different across platforms, then cross-platform consistency is sacrificed. The JVM isolates the program from the underlying OS and platform.
{% endhint %}



## Reference Data Types:

Reference data types are objects that hold references to the memory location where the data is stored. They include classes, interfaces, arrays, and enumerations.

### **Primitive Wrapper Classes:**

These are reference data types that wrap primitive data types into objects. For example:

* `Byte`
* `Short`
* `Integer`
* `Long`
* `Float`
* `Double`
* `Character`
* `Boolean`

These wrapper classes are useful when working with collections or when you need to treat primitive types as objects.





