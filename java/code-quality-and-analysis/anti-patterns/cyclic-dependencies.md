# Cyclic dependencies

## About

**Cyclic dependencies** in Java occur when two or more components (e.g., classes, modules, or packages) depend on each other, either directly or indirectly, forming a circular chain. These dependencies create tight coupling, making the code harder to maintain, test, and extend.

## How Cyclic Dependencies Arise ?

### **1. Direct Circular Reference**

Class `A` depends on Class `B`, and Class `B` depends on Class `A`.

### **2. Indirect Circular Reference**

Class `A` depends on Class `B`, Class `B` depends on Class `C`, and Class `C` depends on Class `A`.

## Example of Cyclic Dependency

### **1. Direct Circular Dependency**

```java
class A {
    private B b;

    public A(B b) {
        this.b = b;
    }

    public void methodA() {
        b.methodB();
    }
}

class B {
    private A a;

    public B(A a) {
        this.a = a;
    }

    public void methodB() {
        a.methodA();
    }
}
```

Here:

* Class `A` depends on Class `B`.
* Class `B` depends on Class `A`.

This creates a circular reference, which can cause runtime issues like `StackOverflowError` if method calls are recursive.

### **2. Indirect Circular Dependency**

```java
class A {
    private B b;

    public void setB(B b) {
        this.b = b;
    }
}

class B {
    private C c;

    public void setC(C c) {
        this.c = c;
    }
}

class C {
    private A a;

    public void setA(A a) {
        this.a = a;
    }
}
```

Here:

* `A` depends on `B`, `B` depends on `C`, and `C` depends back on `A`.
* The cyclic dependency is less obvious but still exists.

## Problems with Cyclic Dependencies

1. **Tight Coupling**: Classes are tightly bound, making changes in one class likely to affect others.
2. **Code Smell**: Indicates poor design and lack of separation of concerns.
3. **Difficult Testing**: Dependencies are harder to mock or replace, complicating unit tests.
4. **Runtime Issues**: Circular references in constructors can lead to `StackOverflowError`.
5. **Dependency Injection Problems**: In frameworks like Spring, cyclic dependencies may prevent beans from being initialized.

## How to Avoid Cyclic Dependencies ?

### **1. Refactor to Break the Cycle**

Identify the dependencies and introduce a new class or interface to mediate.

* **Example**: Use an interface to decouple

```java
interface Service {
    void perform();
}

class A implements Service {
    @Override
    public void perform() {
        System.out.println("A performing");
    }
}

class B {
    private Service service;

    public B(Service service) {
        this.service = service;
    }

    public void useService() {
        service.perform();
    }
}
```

### **2. Dependency Injection**

Use frameworks like Spring to inject dependencies dynamically, avoiding explicit construction.

### **3. Follow SOLID Principles**

Especially the **Dependency Inversion Principle** (DIP) and **Single Responsibility Principle** (SRP). Ensure higher-level modules don’t depend on lower-level ones.

### **4. Restructure our Code**:

* Extract shared functionality into utility classes or services.
* Use a mediator pattern or event-driven design to decouple classes.

### **5. Use Lazy Initialization**:

* Break constructor-based cycles by using setter injection or lazy loading.

**Example**:

```java
class A {
    private B b;

    public void setB(B b) {
        this.b = b;
    }
}

class B {
    private A a;

    public void setA(A a) {
        this.a = a;
    }
}
```

### **6. Leverage Framework Features**:

* In Spring, use the `@Lazy` annotation to defer bean initialization:

```java
@Component
public class A {
    @Autowired
    @Lazy
    private B b;
}

@Component
public class B {
    @Autowired
    @Lazy
    private A a;
}
```

## Detecting Cyclic Dependencies

### **1. Static Analysis Tools**:

Use tools like SonarQube, IntelliJ IDEA inspections, or Eclipse to identify cyclic dependencies in our codebase.

### **2. Dependency Graphs**:

Visualize dependencies using libraries like JDepend or tools like Maven Dependency Plugin.
