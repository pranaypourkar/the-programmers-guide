---
description: Overview of Enum in Java.
---

# Enum

## About

Enums in Java are a special data type that represents a fixed set of constants. This is useful when we need a variable to hold a limited set of values, like days of the week or card suits. Enums in Java are also full-fledged classes with some special characteristics and limitations.

## Key Characteristics of Enums

1. **Fixed Set of Constants**: Enums represent a fixed set of predefined constants, such as `RED`, `GREEN`, and `BLUE` in a `Color` enum.
2. **Type-Safe**: Enums provide compile-time type safety, ensuring that a variable only holds valid values from the specified enum type.
3. **Extends `java.lang.Enum`**: Every enum implicitly extends `java.lang.Enum`, making them unique from other classes.
4. **Cannot be Instantiated**: Enums are implicitly `final`, meaning new instances cannot be created, and they cannot be subclassed.
5. **Utility Methods**: Enums come with built-in methods like `.values()`, `.name()`, and `.ordinal()`.

## Example of an Enum

```java
public enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY;
}
```

Enums can be used directly to restrict a variable’s possible values

```java
Day today = Day.MONDAY;
if (today == Day.FRIDAY) {
    System.out.println("It's almost the weekend!");
}
```

```java
System.out.println(Day.FRIDAY); // FRIDAY
System.out.println(Day.valueOf("monday")); //Exception - No enum constant sample.Day.monday
System.out.println(Day.valueOf("MONDAY")); // MONDAY
System.out.println(Arrays.toString(Day.values())); // [MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY]
System.out.println(Day.THURSDAY.name()); // THURSDAY
System.out.println(Day.THURSDAY.ordinal()); // 3
System.out.println(Day.MONDAY.ordinal()); // 0
```

## **Thread Safety of Enums**

Enums in Java are indeed thread-safe by design, and they offer several additional advanced features that make them both versatile and robust in multi-threaded environments.

* **Immutable by Nature**: Enums are inherently immutable because each enum constant is a static final instance, meaning it can only be created once and cannot be modified. This immutability makes enums thread-safe by default, as multiple threads accessing an enum instance can only read the constant’s state without risking data inconsistency or concurrency issues.
* **Static Initialization**: Enums are initialized at class loading time, in a thread-safe manner, following the Java Class Loading Mechanism. The JVM guarantees that each enum constant is only instantiated once and that no two threads can initialize the same enum class simultaneously, further reinforcing thread safety.

## Advantages of Using Enums

* **Compile-Time Safety**: Prevents invalid values from being assigned to variables.
* **Code Readability**: Makes code more readable by using meaningful constant names.
* **Consistent and Centralized**: The allowed values are defined in a single place.

