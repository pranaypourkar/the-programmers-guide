# Junit 4

## About

JUnit 4, released in 2006, is a popular and widely used version of the JUnit testing framework for Java applications. It introduced annotations to streamline unit test development, making it more efficient and easier to understand compared to JUnit 3.x.

### **Core Concepts**

* **Annotations:** JUnit 4 relies heavily on annotations to define test methods (@Test), set up/tear down logic (@Before, @After), and manage test execution lifecycle (@BeforeClass, @AfterClass).
* **Test Runners**: JUnit integrates with test runners like the built-in JUnit Runner or Maven Surefire plugin to execute and report test results.&#x20;
* **Assertions**: It provides assertions (like assertEquals, assertTrue) to verify expected outcomes within test methods.&#x20;
* **Test Suites**: JUnit allows grouping related tests into suites for better organization and execution control.

## Integration with Maven

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



