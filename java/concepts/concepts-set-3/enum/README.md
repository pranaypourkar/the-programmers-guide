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

## **Enums as Singletons**

* **Singleton Design Pattern**: Enums can be used to implement singletons easily and reliably in Java, since the JVM guarantees that each enum constant is instantiated only once. This makes enums a preferred approach for implementing singletons over traditional patterns, which require additional measures to ensure thread safety.
* **Serialization Safety**: Enums provide built-in serialization safety. During deserialization, the JVM ensures that the same instance is returned, avoiding the risk of creating duplicate instances of a singleton.
*   **Example Singleton Implementation Using Enum**:

    ```java
    public enum DatabaseConnection {
        INSTANCE;
        
        private Connection connection;
        
        DatabaseConnection() {
            // Initialize the connection or resource here
        }
        
        public Connection getConnection() {
            return connection;
        }
    }
    ```
*   **Usage**:

    ```java
    DatabaseConnection connection = DatabaseConnection.INSTANCE;
    ```

{% hint style="warning" %}
In the above `DatabaseConnection` enum example, the purpose is to use an enum to implement a singleton pattern for managing a database connection.

**`INSTANCE;`**:

* This is a single enum constant, which represents the single instance of `DatabaseConnection`.
* This `INSTANCE` constant allows us to access the single `DatabaseConnection` object throughout the application by referencing `DatabaseConnection.INSTANCE`.

**`private Connection connection;`**:

* This field represents a database connection that we would typically use to interact with a database.
* Here, `Connection` is usually a class from a database library (like `java.sql.Connection`), which represents an active connection to the database.

**`DatabaseConnection()` Constructor**:

* This constructor initializes the singleton instance. In this pattern, the constructor is called only once, at the time of enum class loading.
*   Inside this constructor, we would normally include code to initialize the `connection` field, such as establishing a connection to a database.

    ```java
    DatabaseConnection() {
        // For example, initialize the connection here
        // this.connection = DriverManager.getConnection("jdbc:database_url", "user", "password");
    }
    ```

**`public Connection getConnection()` Method**:

* This method provides controlled access to the `connection` object.
* Any part of our application that needs to use this database connection can call Connection conn =`DatabaseConnection.INSTANCE.getConnection()`.
* By exposing `getConnection()`, the enum ensures that there’s only ever one connection in use, avoiding the creation of multiple connections across the application.
{% endhint %}



## Advantages of Using Enums

* **Compile-Time Safety**: Prevents invalid values from being assigned to variables.
* **Code Readability**: Makes code more readable by using meaningful constant names.
* **Consistent and Centralized**: The allowed values are defined in a single place.

