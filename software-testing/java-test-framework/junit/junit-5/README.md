# JUnit 5

## About

JUnit 5, also known as JUnit Jupiter, is the latest version of the JUnit framework. It offers a more modular and flexible architecture compared to JUnit 4. JUnit 5 consists of three main modules:

1. **JUnit Jupiter**: Provides new programming and extension models for writing tests and extensions in JUnit 5.
2. **JUnit Vintage**: Provides a TestEngine for running JUnit 3 and JUnit 4 based tests on the JUnit Platform.
3. **JUnit Platform**: Serves as a foundation for launching testing frameworks on the JVM. It defines the TestEngine API for developing new testing frameworks that run on the platform.

## **Core Concepts**

* **Jupiter Extensions:** JUnit 5 leverages extensions for advanced test functionalities like parameterized tests, test lifecycle management, dependency injection, and more.
* **Annotations:** It utilizes annotations like @Test, @BeforeEach, @AfterEach, and others from the `org.junit.jupiter.api` package for defining test cases and behavior.
* **Assertions:** JUnit 5 offers assertions (like assertEquals, assertTrue) similar to JUnit 4 for verifying expected test outcomes.
* **Test Engine:** It separates test execution logic from the annotations, allowing different testing frameworks to integrate with JUnit 5 through the TestEngine API.

## **Key Features**

* **Modular Design:** The use of extensions promotes a modular approach, enabling customization and tailoring testing experiences based on project needs.
* **Improved Readability:** Annotations like @Test and @BeforeEach enhance test code readability and maintainability.
* **Support for Lambda Expressions (Java 8+):** JUnit 5 takes advantage of features like lambdas for concise and expressive test code (requires Java 8 or above).
* **Parameterized Tests:** This feature allows running the same test with different sets of data, improving test efficiency and coverage.
* **Dynamic Tests:** JUnit 5 supports creating tests dynamically at runtime based on certain conditions.
* **Integration with Build Tools and IDEs:** It integrates seamlessly with popular build tools like Maven and Gradle, as well as IDEs like IntelliJ IDEA and Eclipse, for a smooth testing workflow.

## **Benefits of Using JUnit 5**

* **Enhanced Developer Experience:** The modular design and powerful features make writing and managing unit tests more efficient and enjoyable.
* **Improved Code Quality:** JUnit 5 encourages writing clean, well-tested, and maintainable code.
* **Faster Feedback:** Features like parameterized tests and dynamic tests enable faster test execution and feedback cycles.
* **Increased Confidence:** JUnit 5 helps ensure core functionalities work as intended, leading to more robust applications.

## Integration with Maven

### POM Dependency

```xml
<dependencies>
    <!-- Junit Jupiter API and Engine -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-api</artifactId>
        <version>5.9.3</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-engine</artifactId>
        <version>5.9.3</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Junit Vintage Engine for running JUnit 3 and JUnit 4 tests -->
    <dependency>
        <groupId>org.junit.vintage</groupId>
        <artifactId>junit-vintage-engine</artifactId>
        <version>5.9.3</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Optional: Junit Platform Runner -->
    <dependency>
        <groupId>org.junit.platform</groupId>
        <artifactId>junit-platform-runner</artifactId>
        <version>1.9.3</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### **JUnit 4 Maven Plugin (Optional)**

The Maven Surefire plugin, typically already included in most Maven projects, is responsible for executing tests during the build lifecycle. While not strictly necessary for basic JUnit 5 usage, it can be helpful for advanced functionalities.

{% hint style="info" %}
The Surefire Plugin is the default Maven plugin used to execute tests and generate reports. Configuring the Surefire Plugin explicitly in`pom.xml` is optional if we are using the default settings, as Maven will use the plugin's default settings.

If we do not specify the Surefire Plugin in`pom.xml`, Maven will use the default version bundled with the Maven installation to run the tests. This default configuration might not always be suitable, especially for JUnit 5.
{% endhint %}

```xml
<build>
    <plugins>
        <!-- Surefire Plugin for Unit Tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0-M7</version>
            <configuration>
                <includes>
                    <include>**/*Tests.java</include>
                    <include>**/*Test.java</include>
                    <include>**/*Spec.java</include>
                </includes>
            </configuration>
        </plugin>
        
        <!-- Failsafe Plugin for Integration Tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-failsafe-plugin</artifactId>
            <version>3.0.0-M7</version>
            <executions>
                <execution>
                    <goals>
                        <goal>integration-test</goal>
                        <goal>verify</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <includes>
                    <include>**/*IT.java</include>
                    <include>**/*ITCase.java</include>
                </includes>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Package `org.junit.jupiter` Details

### Sub-package

```
org.junit.jupiter.api
```

<div align="left">

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="322"><figcaption></figcaption></figure>

 

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="268"><figcaption></figcaption></figure>

</div>

```
org.junit.jupiter.engine
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="239"><figcaption></figcaption></figure>

```
org.junit.jupiter.api.condition
```

<figure><img src="../../../../.gitbook/assets/image (191).png" alt="" width="301"><figcaption></figcaption></figure>



## Annotations

This package contains the core annotations and assertions for writing tests in JUnit Jupiter.

### Test Annotations (`org.junit.jupiter.api)`

These annotations are used to define and configure tests.

* **`@Test`**: Marks a method as a test method.
* **`@RepeatedTest`**: Marks a method to be repeated a specified number of times.
* **`@TestFactory`**: Marks a method as a factory for dynamic tests.
* **`@TestTemplate`**: Marks a method as a template for tests to be invoked multiple times.
* **`@Disabled`**: Disables a test class or test method.

### Lifecycle Annotations (`org.junit.jupiter.api)`

These annotations are used to define setup and teardown logic for tests.

* **`@BeforeEach`**: Indicates that the annotated method should be executed before each `@Test` method.
* **`@AfterEach`**: Indicates that the annotated method should be executed after each `@Test` method.
* **`@BeforeAll`**: Indicates that the annotated method should be executed before all `@Test` methods in the current class.
* **`@AfterAll`**: Indicates that the annotated method should be executed after all `@Test` methods in the current class.

### Display and Tag Annotations (`org.junit.jupiter.api)`

These annotations are used for setting display names and tagging tests for selective execution.

* **`@DisplayName`**: Sets a custom display name for the test class or test method.
* **`@DisplayNameGeneration`**: Defines a custom display name generation strategy for test classes.
* **`@Tag`**: Declares tags for filtering tests.

### Conditional Test Execution Annotations (`org.junit.jupiter.api.condition`)

These annotations are used to enable or disable tests based on certain conditions.

* **`@EnabledIf`**: Enables a test or container if the specified condition is met (used with a custom condition).
* **`@DisabledIf`**: Disables a test or container if the specified condition is met (used with a custom condition).
* **`@EnabledOnJre`**: Enables a test or container only on the specified Java runtime environments.
* **`@DisabledOnJre`**: Disables a test or container on the specified Java runtime environments.
* **`@EnabledOnOs`**: Enables a test or container only on the specified operating systems.
* **`@DisabledOnOs`**: Disables a test or container on the specified operating systems.
* **`@EnabledIfEnvironmentVariable`**: Enables a test or container if the specified environment variable is set to the specified value.
* **`@DisabledIfEnvironmentVariable`**: Disables a test or container if the specified environment variable is set to the specified value.
* **`@EnabledIfSystemProperty`**: Enables a test or container if the specified system property is set to the specified value.
* **`@DisabledIfSystemProperty`**: Disables a test or container if the specified system property is set to the specified value.

### Timeout Annotations

These annotations are used to enforce timeouts on test execution.

* **`@Timeout`**: Fails a test if execution exceeds the specified duration.

### Nested Test Annotations

These annotations are used to create nested test classes.

* **`@Nested`**: Denotes that the annotated class is a nested, non-static test class.

### Extension Annotations

These annotations are used to register extensions to extend the behavior of tests.

* **`@ExtendWith`**: Registers extensions for the annotated test class or test method.

### Parameterized Test Source Annotations

These annotations are used to provide sources of arguments for parameterized tests.

* **`@ValueSource`**: Provides a single array of values for a parameterized test.
* **`@EnumSource`**: Provides enum values for a parameterized test.
* **`@MethodSource`**: Provides values from a method for a parameterized test.
* **`@CsvSource`**: Provides CSV values for a parameterized test.
* **`@CsvFileSource`**: Provides CSV values from a file for a parameterized test.
* **`@ArgumentsSource`**: Specifies a custom `ArgumentsProvider` for a parameterized test.







