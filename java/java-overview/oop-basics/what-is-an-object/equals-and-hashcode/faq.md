# FAQ

## **1. Is it mandatory to override `equals` and `hashCode`?**

**No, it is not mandatory** to override `equals()` and `hashCode()`, but it is recommended when working with **custom objects** that will be used in **collections like `HashSet`, `HashMap`, or `HashTable`**.

By default, `equals()` and `hashCode()` are inherited from `Object`:

* `equals()` compares object **references** (not values).
* `hashCode()` returns a unique integer for the object instance.

If you don't override them, two objects with the same data may be considered **different** in collections.

## **2. What if I just implement `equals()` and not `hashCode()`?**

If you override `equals()` but do not override `hashCode()`, our object may behave **unexpectedly** in hash-based collections.

Example:

```java
class Employee {
    int id;

    Employee(int id) {
        this.id = id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Employee)) return false;
        Employee emp = (Employee) obj;
        return this.id == emp.id;
    }
}

public class Main {
    public static void main(String[] args) {
        HashSet<Employee> set = new HashSet<>();
        Employee e1 = new Employee(1);
        Employee e2 = new Employee(1);

        set.add(e1);
        set.add(e2);

        System.out.println(set.size()); // Output: 2 ❌ (should be 1)
    }
}
```

**Why?**

* `equals()` considers `e1` and `e2` **equal**.
* But since `hashCode()` is not overridden, `e1` and `e2` may have **different hash codes**, so `HashSet` treats them as different objects.

{% hint style="info" %}
**Best practice:** Always override `hashCode()` when overriding `equals()`
{% endhint %}

## **3. What if I implement `hashCode()` but not `equals()`?**

If we override `hashCode()` but not `equals()`, two objects **may** have the same hash code but still be considered **not equal**.

Example:

```java
class Employee {
    int id;

    Employee(int id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        return id; // Simple hashCode implementation
    }
}

public class Main {
    public static void main(String[] args) {
        Employee e1 = new Employee(1);
        Employee e2 = new Employee(1);

        System.out.println(e1.hashCode() == e2.hashCode()); // Output: true ✅
        System.out.println(e1.equals(e2)); // Output: false ❌
    }
}
```

**Why?**

* Even though `hashCode()` returns the same value, `equals()` still checks **object references**, which are different.
* This can cause incorrect behavior in `HashMap`, `HashSet`, etc.

{% hint style="info" %}
**Best practice:** Always override `equals()` when overriding `hashCode()`.
{% endhint %}

## **4. Can two objects have the same hash code but not be equal?**

**Yes**, this is called a **hash collision**.

Example:

```java
class Person {
    String name;

    Person(String name) {
        this.name = name;
    }

    @Override
    public int hashCode() {
        return 100; // Same hash code for all objects
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Person)) return false;
        Person person = (Person) obj;
        return this.name.equals(person.name);
    }
}

public class Main {
    public static void main(String[] args) {
        Person p1 = new Person("Alice");
        Person p2 = new Person("Bob");

        System.out.println(p1.hashCode() == p2.hashCode()); // Output: true ✅ (same hashcode)
        System.out.println(p1.equals(p2)); // Output: false ❌ (different objects)
    }
}
```

**Why?**

* Since we forcefully return `100` for all objects, different objects have the same `hashCode`.
* But `equals()` differentiates them correctly.

{% hint style="info" %}
Two **different** objects can have the **same hashCode**, but they will still be considered **different** if `equals()` returns false. **Good hash functions** reduce collisions but cannot avoid them entirely.
{% endhint %}

## **5. Can two objects be equal but have different hash codes?**

**No, if two objects are equal, they must have the same hash code.**

According to the **contract** of `hashCode()` and `equals()`:

> If `a.equals(b) == true`, then `a.hashCode() == b.hashCode()` **must also be true**.

Example (Incorrect implementation breaking contract):

```java
class Car {
    String model;

    Car(String model) {
        this.model = model;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Car)) return false;
        Car car = (Car) obj;
        return this.model.equals(car.model);
    }

    @Override
    public int hashCode() { 
        return (int) (Math.random() * 1000); // ❌ BAD PRACTICE
    }
}

public class Main {
    public static void main(String[] args) {
        Car c1 = new Car("Toyota");
        Car c2 = new Car("Toyota");

        System.out.println(c1.equals(c2)); // Output: true ✅ (same model)
        System.out.println(c1.hashCode() == c2.hashCode()); // ❌ May be false (wrong implementation)
    }
}
```

**Why is this incorrect?**

* Since `equals()` says two cars with the same model are **equal**, their `hashCode()` **must** also be the same.
* But due to random hash generation, they have **different hash codes**, which violates the contract.

{% hint style="info" %}
**Best practice:** Always ensure **equal objects have the same hash code**.
{% endhint %}

