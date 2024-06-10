# JUnit 4

## About

JUnit 4, released in 2006, is a popular and widely used version of the JUnit testing framework for Java applications. It introduced annotations to streamline unit test development, making it more efficient and easier to understand compared to JUnit 3.x.

### **Core Concepts**

* **Annotations:** JUnit 4 relies heavily on annotations to define test methods (@Test), set up/tear down logic (@Before, @After), and manage test execution lifecycle (@BeforeClass, @AfterClass).
* **Test Runners**: JUnit integrates with test runners like the built-in JUnit Runner or Maven Surefire plugin to execute and report test results.&#x20;
* **Assertions**: It provides assertions (like assertEquals, assertTrue) to verify expected outcomes within test methods.&#x20;
* **Test Suites**: JUnit allows grouping related tests into suites for better organization and execution control.

## Integration with Maven

### POM Dependency

Add the following dependencies to `pom.xml`

```xml
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### **JUnit 4 Maven Plugin (Optional)**

The JUnit 4 functionality is generally included with the Maven Surefire plugin, which is responsible for executing tests during the Maven build lifecycle. So, adding the Surefire plugin is usually not necessary for basic JUnit 4 usage.

However, if we want more advanced functionalities like custom test listeners or reports, we can optionally include the Surefire plugin in the pom.xml.

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>3.0.0-M5</version>  
  <configuration></configuration>
</plugin>
```

## Package `org.junit` Details

<figure><img src="../../../../.gitbook/assets/image (185).png" alt="" width="290"><figcaption></figcaption></figure>

## Annotations in `org.junit`

JUnit 4 introduced a variety of annotations to simplify test creation and management. `org.junit` provides core JUnit 4 annotations. Here is a list of JUnit 4 annotations categorized by their functionality.

### Test Annotations

**`@Test`**: Marks a method as a test method. This is the primary annotation to indicate that a method is a test.

### Setup and Teardown Annotations

* **`@Before`**: Executes a method before each test method in the current class. Used for setting up test environments.
* **`@After`**: Executes a method after each test method in the current class. Used for cleaning up after tests.
* **`@BeforeClass`**: Executes a method once before any test methods in the current class. This method must be static.
* **`@AfterClass`**: Executes a method once after all test methods in the current class. This method must be static.

### Exception and Timeout Annotations

* **`@Test(expected = Exception.class)`**: Indicates that a test method is expected to throw a specified exception.
* **`@Test(timeout = 1000)`**: Indicates that a test method must finish execution within the specified timeout period (in milliseconds).

### Ignoring Tests

* **`@Ignore`**: Ignores the test method it annotates. Optionally, a reason for ignoring the test can be provided.

### Parameterized Tests Annotations

* **`@RunWith(Parameterized.class)`**: Indicates that a test class should run with a custom runner (in this case, the Parameterized runner).
* **`@Parameters`**: Used to specify the parameters for a parameterized test.

### Rule Annotations

* **`@Rule`**: Annotates fields that reference rules or methods that return rules. Rules allow more flexible and powerful test configurations and setups.
* **`@ClassRule`**: Similar to `@Rule`, but applies to all tests in a class rather than individual tests. The field or method must be static.

### Category Annotations

* **`@Category`**: Assigns categories to test classes or methods, which can be used to include or exclude tests during execution based on their category.

### Test Order Annotations

* **`@FixMethodOrder`**: Specifies the order in which test methods are executed. This can be useful for tests that must run in a specific sequence.

### Custom Runner Annotations

* **`@RunWith`**: Specifies a custom runner to use for running tests. This is often used for running parameterized tests or tests with specific configurations.

## Classes in `org.junit`

### Assume

The `Assume` class in JUnit 4 provides a way to state assumptions about the conditions under which a test is meaningful. If an assumption fails, the test will be ignored rather than marked as failed. This is useful for tests that should only run in specific environments or conditions.

**Key Methods:**

* **`assumeTrue(boolean assumption)`**: Only continues with the test if the assumption is `true`.
* **`assumeFalse(boolean assumption)`**: Only continues with the test if the assumption is `false`.
* **`assumeNotNull(Object... objects)`**: Only continues with the test if all the given objects are not `null`.
* **`assumeThat(T actual, Matcher<T> matcher)`**: Only continues with the test if the actual value satisfies the matcher.

### AssumptionViolatedException

`AssumptionViolatedException` is thrown when an assumption fails. JUnit handles this exception by marking the test as ignored. This exception allows tests to declare that they should be skipped based on dynamic conditions during test execution. We typically do not need to catch or throw `AssumptionViolatedException` directly, as it is managed by the `Assume` class methods.

### ComparisonFailure

`ComparisonFailure` is a subclass of `AssertionError` that is thrown when an assertion comparing two strings fails. This exception provides a more informative error message by highlighting the differences between the expected and actual strings, making it easier to understand why the test failed. When using assertion methods like `assertEquals(String expected, String actual)`, `ComparisonFailure` is automatically used to provide detailed failure messages

### Assert&#x20;

The `Assert` class in JUnit 4 provides a collection of static methods to perform various assertions in tests. These assertions are used to verify that certain conditions are met in the test code. If an assertion fails, the test fails, and a corresponding failure message is reported.

#### Equality and Identity

* **`assertEquals(expected, actual)`**: Asserts that two objects are equal.
* **`assertEquals(String message, expected, actual)`**: Asserts that two objects are equal with a custom failure message.
* **`assertEquals(long expected, long actual)`**: Asserts that two long values are equal.
* **`assertEquals(String message, long expected, long actual)`**: Asserts that two long values are equal with a custom failure message.
* **`assertEquals(double expected, double actual, double delta)`**: Asserts that two double values are equal within a specified delta.
* **`assertEquals(String message, double expected, double actual, double delta)`**: Asserts that two double values are equal within a specified delta with a custom failure message.
* **`assertNotEquals(expected, actual)`**: Asserts that two objects are not equal.
* **`assertNotEquals(String message, expected, actual)`**: Asserts that two objects are not equal with a custom failure message.
* **`assertNotEquals(long unexpected, long actual)`**: Asserts that two long values are not equal.
* **`assertNotEquals(String message, long unexpected, long actual)`**: Asserts that two long values are not equal with a custom failure message.
* **`assertNotEquals(double unexpected, double actual, double delta)`**: Asserts that two double values are not equal within a specified delta.
* **`assertNotEquals(String message, double unexpected, double actual, double delta)`**: Asserts that two double values are not equal within a specified delta with a custom failure message.
* **`assertSame(expected, actual)`**: Asserts that two objects refer to the same object.
* **`assertSame(String message, expected, actual)`**: Asserts that two objects refer to the same object with a custom failure message.
* **`assertNotSame(unexpected, actual)`**: Asserts that two objects do not refer to the same object.
* **`assertNotSame(String message, unexpected, actual)`**: Asserts that two objects do not refer to the same object with a custom failure message.

#### **Truth and False**

* **`assertTrue(boolean condition)`**: Asserts that a condition is true.
* **`assertTrue(String message, boolean condition)`**: Asserts that a condition is true with a custom failure message.
* **`assertFalse(boolean condition)`**: Asserts that a condition is false.
* **`assertFalse(String message, boolean condition)`**: Asserts that a condition is false with a custom failure message.

#### **Null and Non-Null**

* **`assertNull(Object object)`**: Asserts that an object is null.
* **`assertNull(String message, Object object)`**: Asserts that an object is null with a custom failure message.
* **`assertNotNull(Object object)`**: Asserts that an object is not null.
* **`assertNotNull(String message, Object object)`**: Asserts that an object is not null with a custom failure message.

**Arrays**

* **`assertArrayEquals(Object[] expecteds, Object[] actuals)`**: Asserts that two object arrays are equal.
* **`assertArrayEquals(String message, Object[] expecteds, Object[] actuals)`**: Asserts that two object arrays are equal with a custom failure message.
* **`assertArrayEquals(byte[] expecteds, byte[] actuals)`**: Asserts that two byte arrays are equal.
* **`assertArrayEquals(String message, byte[] expecteds, byte[] actuals)`**: Asserts that two byte arrays are equal with a custom failure message.
* **`assertArrayEquals(char[] expecteds, char[] actuals)`**: Asserts that two char arrays are equal.
* **`assertArrayEquals(String message, char[] expecteds, char[] actuals)`**: Asserts that two char arrays are equal with a custom failure message.
* **`assertArrayEquals(short[] expecteds, short[] actuals)`**: Asserts that two short arrays are equal.
* **`assertArrayEquals(String message, short[] expecteds, short[] actuals)`**: Asserts that two short arrays are equal with a custom failure message.
* **`assertArrayEquals(int[] expecteds, int[] actuals)`**: Asserts that two int arrays are equal.
* **`assertArrayEquals(String message, int[] expecteds, int[] actuals)`**: Asserts that two int arrays are equal with a custom failure message.
* **`assertArrayEquals(long[] expecteds, long[] actuals)`**: Asserts that two long arrays are equal.
* **`assertArrayEquals(String message, long[] expecteds, long[] actuals)`**: Asserts that two long arrays are equal with a custom failure message.
* **`assertArrayEquals(float[] expecteds, float[] actuals, float delta)`**: Asserts that two float arrays are equal within a specified delta.
* **`assertArrayEquals(String message, float[] expecteds, float[] actuals, float delta)`**: Asserts that two float arrays are equal within a specified delta with a custom failure message.
* **`assertArrayEquals(double[] expecteds, double[] actuals, double delta)`**: Asserts that two double arrays are equal within a specified delta.
* **`assertArrayEquals(String message, double[] expecteds, double[] actuals, double delta)`**: Asserts that two double arrays are equal within a specified delta with a custom failure message.

#### **Fail**

* **`fail()`**: Fails a test with no message.
* **`fail(String message)`**: Fails a test with a custom failure message.

## Packages in `org.junit`

### org.junit.runners

This package contains built-in runners that JUnit uses to execute tests.

<figure><img src="../../../../.gitbook/assets/image (186).png" alt="" width="224"><figcaption></figcaption></figure>

* **Classes**:
  * `BlockJUnit4ClassRunner`: The default JUnit 4 test runner.
  * `Parameterized`: Runner for parameterized tests.
  * `JUnit4`: A simple runner for running tests in a JUnit 4 environment.
  * `Suite`: A runner for aggregating multiple test classes into a suite.

### org.junit.matchers&#x20;

This package provides additional matchers for use in assertions.

<figure><img src="../../../../.gitbook/assets/image (187).png" alt="" width="209"><figcaption></figcaption></figure>

* **Classes**:
  * `JUnitMatchers`: Contains additional matchers (generic) that can be used with `assertThat` to create more readable and flexible assertions.

### org.junit.runner&#x20;

This package contains classes related to running tests and getting results.

<figure><img src="../../../../.gitbook/assets/image (188).png" alt="" width="227"><figcaption></figcaption></figure>

* **Classes**:
  * `JUnitCore`: A facade for running tests.
  * `Result`: Contains the result of running a test, including details about failures and the number of tests run.
  * `Notification`: Class used to notify listeners about test execution events.
  * `Request`: Represents a request to run a test.
  * `RunWith`: Annotation used to specify a custom runner.
  * `Description`: Represents a test or a suite of tests.

### org.junit.validator

This package contains classes for validating test classes.

<figure><img src="../../../../.gitbook/assets/image (189).png" alt="" width="231"><figcaption></figcaption></figure>

* **Classes**:
  * `AnnotationValidator`: An interface for validating custom annotations.
  * `PublicClassValidator`: Validates that a class is public.
  * `ValidateWith`: An annotation used to specify a custom validator.
  * `ValidationError`: Represents an error found during validation.

### org.junit.rules

This package contains classes for creating and using rules, which can modify the behavior of tests.

<figure><img src="../../../../.gitbook/assets/image (190).png" alt="" width="287"><figcaption></figcaption></figure>

* **Classes**:
  * `ExternalResource`: A base class for rules that set up and tear down external resources.
  * `TemporaryFolder`: A rule that creates and deletes a temporary folder for use in tests.
  * `TestName`: A rule that makes the name of the currently running test method available.
  * `Timeout`: A rule that applies a timeout to all test methods in a class.









