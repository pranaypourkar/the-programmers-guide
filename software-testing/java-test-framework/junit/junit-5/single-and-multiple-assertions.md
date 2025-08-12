# Single and Multiple Assertions

## About

Unit testing is a critical part of modern software development, and **JUnit 5** is one of the most popular frameworks used in Java applications. One key decision developers face while writing tests is whether to use **single assertions** or **multiple assertions** within a test method.

## What is an Assertion?

In the context of unit testing, an **assertion** is a statement used to verify that a certain condition holds true during the execution of a test. If the condition is false, the test fails and is reported by the testing framework.

In **JUnit 5**, assertions are provided through static methods in the `org.junit.jupiter.api.Assertions` class.

#### Example:

```java
import static org.junit.jupiter.api.Assertions.assertEquals;

@Test
void testAddition() {
    int result = Calculator.add(2, 3);
    assertEquals(5, result);
}
```

In this example:

* `Calculator.add(2, 3)` is the actual value returned by the method under test.
* `5` is the expected value.
* `assertEquals` checks if both values are equal. If not, the test fails.

Assertions help developers automatically verify that the code behaves as expected and catch issues early during development.

## Single Assertion

A **single assertion** test verifies one specific condition within a test method. It focuses on checking a **single behavior** or **outcome** of the code under test.

In JUnit 5, once a single assertion fails, the test immediately stops executing and reports that failure. This helps quickly pinpoint the root cause of the failure.

#### Example: Testing Simple Addition

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CalculatorTest {

    @Test
    void shouldReturnCorrectSum() {
        int result = Calculator.add(2, 3);
        assertEquals(5, result);
    }
}
```

## Multiple Assertions

While a single assertion focuses on verifying one condition, there are many scenarios where a test needs to check **multiple related outcomes** together. This is where **multiple assertions** are useful.

In JUnit 5, we can write multiple assertions either as sequential calls (which stop at the first failure) or using `assertAll()` to evaluate all assertions and report all failures in one go.

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class OrderTest {

    @Test
    void testOrderDetailsUsingAssertAll() {
        Order order = new Order(101, "CONFIRMED", 500);

        assertAll("Order Properties",
            () -> assertEquals(101, order.getId()),
            () -> assertEquals("CONFIRMED", order.getStatus()),
            () -> assertTrue(order.getAmount() > 0)
        );
    }
}
```

Each assertion inside `assertAll()` is a lambda expression. Even if one fails, the others still run. JUnit will report all failed assertions together, which is extremely useful for debugging.

### Different Ways

1. **Sequential Assertions (Not Recommended for Grouped Checks)**

```java
assertEquals(10, value1);
assertTrue(value2 > 0);
```

Only useful when we don’t care about completing the full set if one fails.

2. **Grouped Assertions with `assertAll()` – Recommended**

```java
assertAll(
    () -> assertEquals(10, value1),
    () -> assertTrue(value2 > 0)
);
```

All assertions are evaluated. Failures are collected and reported together.

3. **Nested `assertAll()` for Complex Scenarios**

When dealing with multiple groups of related assertions, we can nest `assertAll()` calls.

```java
assertAll("User and Account Validation",
    () -> assertAll("User Fields",
        () -> assertEquals("John", user.getFirstName()),
        () -> assertEquals("Doe", user.getLastName())
    ),
    () -> assertAll("Account Fields",
        () -> assertEquals(1000, account.getBalance()),
        () -> assertEquals("ACTIVE", account.getStatus())
    )
);
```

This is helpful in complex domain objects where grouping improves readability and logical clarity.

