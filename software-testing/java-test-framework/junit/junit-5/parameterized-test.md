# Parameterized Test

## About

A `@ParameterizedTest` is a test method in JUnit 5 that runs multiple times with different arguments. Instead of duplicating test code with different input values, parameterized tests allow you to write a single test method that automatically receives different input values and runs multiple times.

This improves test readability and maintainability.

## Why Use Parameterized Tests?

* Reduce duplication in test code.
* Cover more input cases with less effort.
* Improve test coverage and reliability.

## 1. `@ValueSource` – Single Literal Values

Use `@ValueSource` when we want to run a test multiple times with a **single argument of the same type** (e.g., all integers or all strings). It is ideal for primitive or simple input validation.

#### Basic Usage

```java
@ParameterizedTest
@ValueSource(ints = {1, 2, 3})
void testWithInt(int number) {
    assertTrue(number > 0);
}
```

#### Advanced Usage

* **Supported types**: `int`, `long`, `double`, `short`, `byte`, `char`, `boolean`, `String`, `Class<?>`
* **Limitation**: Only **one parameter** is allowed.
* **Passing `null`**: Not supported directly. You must use `@NullSource` or `@NullAndEmptySource`.

#### Handling Nulls and Edge Cases

```java
@ParameterizedTest
@NullSource
@EmptySource
@ValueSource(strings = {"abc", " "})
void testStringInputs(String input) {
    assertNotNull(input);
}
```

* `@NullSource` → adds one null argument.
* `@EmptySource` → adds empty value (`""`, empty collection/array).

## 2. `@CsvSource`&#x20;

Use `@CsvSource` to test methods with **multiple parameters**. The values are given inline in a CSV format. It improves clarity when testing combinations of inputs.

### Inline CSV Data

#### Basic Usage

```java
@ParameterizedTest
@CsvSource({
  "apple, 1",
  "banana, 2"
})
void testWithCsvSource(String fruit, int quantity) {
    assertNotNull(fruit);
    assertTrue(quantity > 0);
}
```

#### Advanced Usage

*   **String values with commas**: Use quotes.

    ```java
    @CsvSource({ "'apple, red', 1", "'banana, ripe', 2" })
    ```
*   **Null values**: Use `null` as a literal string (quotes are required).

    ```java
    @CsvSource({
      "apple, 1",
      "null, 0"
    })
    void testNulls(String fruit, int quantity) {
        assertTrue(fruit == null || fruit.length() > 0);
    }
    ```

### Load Data from CSV File

#### Basic Usage

```java
@ParameterizedTest
@CsvFileSource(resources = "/sample-data.csv", numLinesToSkip = 1)
void testWithFile(String name, int age) {
    assertTrue(age > 0);
}
```

#### Advanced Usage

* **File format**: CSV file must be on the classpath.
* **Quotes** can be used to handle commas inside values.
* **Skipping header**: Use `numLinesToSkip = 1`.
* **Custom delimiters**: Use `delimiter = ';'` for semi-colon delimited files.

## 4. `@EnumSource` – Use Enum Constants

Use `@EnumSource` when testing logic based on different enum values. It ensures all or selected enum constants are covered.

#### Basic Usage

```java
enum Role { ADMIN, USER, GUEST }

@ParameterizedTest
@EnumSource(Role.class)
void testWithEnum(Role role) {
    assertNotNull(role);
}
```

#### Advanced Usage

*   **Include specific constants**:

    ```java
    @EnumSource(value = Role.class, names = {"ADMIN", "USER"})
    ```
*   **Exclude constants using regex**:

    ```java
    @EnumSource(value = Role.class, mode = EnumSource.Mode.EXCLUDE, names = {"GUEST"})
    ```

## 5. `@MethodSource` – Arguments from a Factory Method

Use `@MethodSource` when test arguments are **dynamic**, **complex**, or require **logic to generate**. It supports multiple parameters and `null`.

#### Basic Usage

```java
@ParameterizedTest
@MethodSource("stringProvider")
void testWithMethodSource(String value) {
    assertNotNull(value);
}

static Stream<String> stringProvider() {
    return Stream.of("java", "junit", "spring");
}
```

#### Multiple Parameters

```java
@ParameterizedTest
@MethodSource("multiParamProvider")
void testWithMultipleParams(String input, int length) {
    assertEquals(length, input.length());
}

static Stream<Arguments> multiParamProvider() {
    return Stream.of(
        Arguments.of("a", 1),
        Arguments.of("ab", 2)
    );
}
```

#### Advanced Usage

*   **Nullable arguments**: We can pass `null` safely.

    ```java
    static Stream<Arguments> nullProvider() {
        return Stream.of(
            Arguments.of("test", 4),
            Arguments.of(null, 0)
        );
    }
    ```
*   **Dynamic generation** using files, DB, or API:

    ```java
    static Stream<Arguments> dynamicProvider() throws IOException {
        return Files.lines(Path.of("data.txt"))
                    .map(line -> Arguments.of(line));
    }
    ```

## 6. `@ArgumentsSource` – Custom Provider

Use `@ArgumentsSource` when you want to provide parameters from a **custom provider** class. It's useful for reading from a DB, API, or complex logic.

#### Basic Usage

#### Example 1: Hardcoded List of Strings

```java
@ParameterizedTest
@ArgumentsSource(FixedStringProvider.class)
void testWithFixedStrings(String input) {
    assertNotNull(input);
}

static class FixedStringProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
        return Stream.of("apple", "banana", "cherry").map(Arguments::of);
    }
}
```

#### Example 2: Providing Multiple Parameters

```java
@ParameterizedTest
@ArgumentsSource(MultiArgProvider.class)
void testWithMultipleArgs(String name, int age) {
    assertNotNull(name);
    assertTrue(age > 0);
}

static class MultiArgProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
        return Stream.of(
            Arguments.of("Alice", 30),
            Arguments.of("Bob", 25),
            Arguments.of("Charlie", 40)
        );
    }
}
```

#### Example 3: Random Data Generator

```java
@ParameterizedTest
@ArgumentsSource(RandomIntProvider.class)
void testWithRandomInts(int value) {
    assertTrue(value >= 0 && value <= 100);
}

static class RandomIntProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
        Random random = new Random();
        return Stream.generate(() -> Arguments.of(random.nextInt(101)))
                     .limit(5); // 5 random values
    }
}
```

#### Example 4: Reading from a File

```java
@ParameterizedTest
@ArgumentsSource(FileLineProvider.class)
void testFromFile(String line) {
    assertFalse(line.trim().isEmpty());
}

static class FileLineProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) throws Exception {
        Path path = Paths.get("src/test/resources/testdata.txt");
        return Files.lines(path).map(Arguments::of);
    }
}
```

#### Example 5: Generating Null and Edge Cases

```java
@ParameterizedTest
@ArgumentsSource(NullEdgeCaseProvider.class)
void testWithEdgeCases(String input) {
    // handle null, empty, normal
}

static class NullEdgeCaseProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
        return Stream.of(
            Arguments.of((String) null),
            Arguments.of(""),
            Arguments.of("valid")
        );
    }
}
```

#### Advanced Usage

* Useful when input comes from:
  * **External services**
  * **Complex business logic**
  * **Random generators**
* We can inject dependencies into the provider if needed via Spring or custom mechanisms.

