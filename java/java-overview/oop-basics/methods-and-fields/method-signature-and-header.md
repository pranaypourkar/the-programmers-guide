# Method Signature & Header

## **1. Method Signature**

A **method signature** in Java uniquely identifies a method. It consists of:

* **Method Name**
* **Parameter List** (number, type, and order of parameters)

{% hint style="danger" %}
**Return type, access modifiers, and exceptions are NOT part of the method signature.**
{% endhint %}

#### **Example: Method Signatures**

```java
void display(int x) { }       // Signature: display(int)
void display(String s) { }    // Signature: display(String)
void display(int x, int y) { } // Signature: display(int, int)
```

All these methods have different **signatures**, so method overloading is allowed.

{% hint style="success" %}
#### **2. Why is Return Type NOT Part of the Signature?**

Java **does NOT allow** method overloading based only on return type because it leads to ambiguity.

```java
int getData() { return 10; }
double getData() { return 10.5; }  // Compilation Error (Same signature: `getData()`)
```

Even though the return types differ, the method signature remains **`getData()`**, leading to a conflict.
{% endhint %}

## **2. What is a Method Header?**

A **method header** includes **more information** than the method signature. It consists of:

* **Access Modifiers** (`public`, `private`, `protected`, or default)
* **Return Type** (`void`, `int`, `String`, etc.)
* **Method Name**
* **Parameter List**
* **Exception List** (if the method declares exceptions using `throws`)

#### **Example: Method Header vs. Method Signature**

```java
public int calculateSum(int a, int b) throws IOException { }
```

* **Method Signature:** `calculateSum(int, int)`
* **Method Header:** `public int calculateSum(int a, int b) throws IOException`
