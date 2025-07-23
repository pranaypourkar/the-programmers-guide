# Method Overriding & Overloading

## **What is meant by Method Overriding?**

Method overriding happens if the sub-class method satisfies the below conditions with the Super-class method:

* Method name should be the same
* The argument or parameters should be the same
* Return type should also be the same
* The method cannot have a weaker access modifier (e.g., `protected` method in superclass cannot be `private` in subclass).
* The method cannot throw new or broader checked exceptions.
* Only instance methods can be overridden (`static` methods are hidden, not overridden).
* Subclass can return a subtype of the superclass method’s return type.

The key benefit of overriding is that the Sub-class can provide some specific information about that sub-class type than the super-class.

{% hint style="success" %}
* Also called Runtime-time Polymorphism.
* It is resolved at **runtime** (also called **dynamic binding**).
* Covariant Return Type **avoids unnecessary type casting** when dealing with overridden methods.
{% endhint %}

#### Example

```java
// Basic Overriding Example
class Parent {
    void show() { System.out.println("Parent method"); }
}

class Child extends Parent {
    @Override
    void show() { System.out.println("Child method"); }
}

// Overriding with Covariant Return Type
// The overridden method in the subclass can return a subtype of the superclass method’s return type.
class Parent {
    Number getValue() { return 10; }
}

class Child extends Parent {
    @Override
    Integer getValue() { return 20; } // Covariant return type (Integer is a subtype of Number)
}

// Overriding with Exception Handling
// The overridden method cannot throw broader checked exceptions.
class Parent {
    void method() throws IOException {}  
}

class Child extends Parent {
    @Override
    void method() throws FileNotFoundException {} // Allowed (Narrower exception)
    
    // void method() throws Exception {} // Not allowed (Broader exception)
}

// Hiding Static Methods (Not Overriding)
// Static methods are not overridden, they are hidden.
class Parent {
    static void show() { System.out.println("Parent static method"); }
}

class Child extends Parent {
    static void show() { System.out.println("Child static method"); }
}

// Final Methods Cannot Be Overridden
class Parent {
    final void show() { System.out.println("Final method"); }
}

class Child extends Parent {
    // void show() {} // Compilation error (Cannot override final method)
}

// Using super to Call Parent Method
class Parent {
    void show() { System.out.println("Parent method"); }
}

class Child extends Parent {
    @Override
    void show() {
        super.show(); // Calls the parent method
        System.out.println("Child method");
    }
}

// Incorrect use of @Override
class Parent {
    void method(int a) {}
}

class Child extends Parent {
    // @Override void method(double a) {} // Compilation error (Not the same signature)
}

// Private methods cannot be overridden (they are not inherited)
class Parent {
    private void secret() {} 
}

class Child extends Parent {
    void secret() {} // This is a new method, NOT an override
}

// Illegal Case (Incompatible Covariant Type)
class Parent {
    Number getValue() {
        return 10;
    }
}

class Child extends Parent {
    @Override
    String getValue() { // Compilation error: String is NOT a subclass of Number
        return "Error";
    }
}
```

## **What is meant by Method Overloading?**

Method overloading happens for different classes or within the same class.

For method overloading, sub-class method should satisfy the below conditions with the Super-class method (or) methods in the same class itself:

* Same method name
* Different argument types and ordering
* Return type alone cannot differentiate overloaded methods. Does not support covariant return type.&#x20;
* They can have different access modifiers and exceptions.&#x20;

{% hint style="success" %}
- It is resolved at **compile time** (also called **static binding**).
- Also called Compile-time Polymorphism.
- Return type alone cannot distinguish methods.
{% endhint %}

#### Example

```java
// Different Number of Parameters
class Calculator {
    int add(int a, int b) { return a + b; }
    int add(int a, int b, int c) { return a + b + c; }
}

// Different Parameter Types
class Display {
    void show(int num) { System.out.println("Int: " + num); }
    void show(double num) { System.out.println("Double: " + num); }
    
    int add(int a, int b) { return a + b; }
    int add(Integer a, int b) { return a + b; }
    int add(int a, Integer b) { return a + b; }
    int add(Integer a, Integer b) { return a + b; }
}

// Different Order of Parameters
class Printer {
    void print(String s, int i) { System.out.println("String first: " + s + ", " + i); }
    void print(int i, String s) { System.out.println("Int first: " + i + ", " + s); }
}

// Overloading with Type Promotion
// That is commenting method display(int a) will still work here without compilation issue
class TypePromotionExample {
    void display(int a) { System.out.println("int: " + a); }
    void display(double a) { System.out.println("double: " + a); }
    
    public static void main(String[] args) {
        TypePromotionExample obj = new TypePromotionExample();
        obj.display(10); // Calls display(int), but if it were absent, it would promote to display(double)
    }
}

// Overloading with Type Promotion
// Commenting display(int a) will make compiler use display(double a) and commenting it as well will
// take void display(Integer a)
class TypePromotionExample {
    void display(int a) { System.out.println("int: " + a); }
    void display(double a) { System.out.println("double: " + a); }
    void display(Integer a) { System.out.println("integer: " + a); }
    
    public static void main(String[] args) {
        TypePromotionExample obj = new TypePromotionExample();
        obj.display(10); // Calls display(int), but if it were absent, it would promote to display(double)
    }
}

// Overloading with Varargs (Variable Arguments)
class VarargsExample {
    void sum(int... numbers) {
        int total = 0;
        for (int num : numbers) total += num;
        System.out.println("Sum: " + total);
    }
}

// Cannot overload just by changing the return type
class Test {
    int method() { return 1; }
    // double method() { return 2.0; } // Compilation error (Return type alone cannot distinguish methods)
}

// Varargs ambiguity when combined with other methods
class Ambiguous {
    void show(int a, int b) {}  
    void show(int... nums) {}  // Ambiguous when called with two int arguments
}

// Invalid Overloading with Covariant Return Type
class Example {
    Number getValue() { return 10; }

    // Compilation error: Overloading is based only on parameters, not return type
    Integer getValue() { return 20; }
}

class Example {
    Number getValue() { return 10; }  // Method 1

    Integer getValue(int x) { return 20; }  // Method 2 (Valid overload because of different parameter)
}

// Overloading with Different Checked Exceptions
class ExceptionOverloading {
    // Method with IOException
    void readFile(String filePath) throws IOException {
        System.out.println("Reading file: " + filePath);
    }

    // Overloaded method with SQLException
    void readFile(int fileId) throws SQLException {
        System.out.println("Fetching file with ID: " + fileId);
    }
}

// Overloading with Different Unchecked Exceptions
// Method with ArithmeticException
class UncheckedExceptionOverloading {
    // Method with ArithmeticException
    void divide(int a, int b) throws ArithmeticException {
        System.out.println("Result: " + (a / b));
    }

    // Overloaded method with NullPointerException
    void divide(String a, String b) throws NullPointerException {
        if (a == null || b == null) {
            throw new NullPointerException("Input cannot be null");
        }
        System.out.println("Concatenated: " + a + b);
    }
}

// Overloading with and without Exception
class MixedExceptionOverloading {
    // Method without exception
    void process(int num) {
        System.out.println("Processing number: " + num);
    }

    // Overloaded method with an exception
    void process(String data) throws NumberFormatException {
        int num = Integer.parseInt(data); // May throw NumberFormatException
        System.out.println("Converted number: " + num);
    }
}
```

