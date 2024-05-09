# Access modifiers

Access modifiers in Java are keywords used to specify the accessibility or visibility of classes, methods, variables, and constructors. They control how these elements can be accessed from other classes or packages. Java provides four types of access modifiers:

{% hint style="info" %}
* Access modifiers can be applied to classes, methods, variables, and constructors.
* The choice of access modifier depends on the desired level of encapsulation and the requirements of the design.
* Access modifiers provide control over the visibility of members, which helps in maintaining code integrity and security.
{% endhint %}



## **Public**&#x20;

Accessible from anywhere, both within the same package and from other packages.

* **Usage**: Use `public` when you want a member to be widely accessible by any code.
* **Example**:

```java
public class MyClass {
    public int publicField;
    public void publicMethod() {
        // Code here
    }
}
```

## **Protected**

Accessible within the same package and by subclasses (even if they are in different packages).

* **Usage**: Use `protected` when you want to provide access to the member within the same package and to subclasses.
* **Example**:

```java
public class MyClass {
    protected int protectedField;
    protected void protectedMethod() {
        // Code here
    }
}
```

## **Default (Package-private)**

Accessible only within the same package. When no access modifier is specified, it defaults to package-private.

* **Usage**: Use the default access level when you want to restrict access to the member within the same package.
* **Example**:

```java
class MyClass {
    int defaultField;
    void defaultMethod() {
        // Code here
    }
}
```

## **Private**

Accessible only within the same class.

* **Usage**: Use `private` when you want to encapsulate the member and prevent access from outside the class.
* **Example**:

```java
public class MyClass {
    private int privateField;
    private void privateMethod() {
        // Code here
    }
}
```

