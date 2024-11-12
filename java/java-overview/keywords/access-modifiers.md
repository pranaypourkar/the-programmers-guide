# Access Modifiers

## About

Access modifiers in Java are keywords used to specify the accessibility or visibility of classes, methods, variables, and constructors. They control how these elements can be accessed from other classes or packages. Java provides four types of access modifiers.

{% hint style="info" %}
* Access modifiers can be applied to classes, methods, variables, and constructors.
* The choice of access modifier depends on the desired level of encapsulation and the requirements of the design.
* Access modifiers provide control over the visibility of members, which helps in maintaining code integrity and security.
{% endhint %}

<table data-full-width="true"><thead><tr><th width="162">Modifier</th><th>Class-Level Visibility</th><th width="208">Field/Method-Level Visibility</th><th>Description</th></tr></thead><tbody><tr><td><code>public</code></td><td>Visible to all classes</td><td>Visible to all classes</td><td>Allows unrestricted access to the method or field from any other class. Useful for methods that need to be accessible across packages.</td></tr><tr><td><code>protected</code></td><td>Only visible to subclasses and classes in the same package</td><td>Visible to subclasses and classes in the same package</td><td>Provides visibility within the same package and to any subclass, regardless of the package. Helpful for methods that should only be accessible to subclasses.</td></tr><tr><td><code>default</code></td><td>Package-private: visible only to classes in the same package</td><td>Package-private: visible only to classes in the same package</td><td>Restricts visibility to the same package. Useful for methods or fields intended for internal use within a package structure.</td></tr><tr><td><code>private</code></td><td>Not applicable to top-level classes</td><td>Visible only within the same class</td><td>Only accessible within the class itself.</td></tr></tbody></table>

## **Public**

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
