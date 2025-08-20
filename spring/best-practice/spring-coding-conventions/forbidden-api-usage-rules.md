# Forbidden API Usage Rules

## About

**Forbidden API Usage Rules** define which Java or third-party APIs should **not be used** in a Spring project. These rules help maintain **code quality, readability, thread safety, and consistency**, while preventing common pitfalls.

Typical forbidden APIs include:

* Legacy date/time APIs (`java.util.Date`, `java.util.Calendar`, `java.text.SimpleDateFormat`) in favor of `java.time` classes.
* Threading classes (`Thread`, `Runnable`) in favor of Spring’s task executors.
* Deprecated methods or classes.
* Direct JDBC or reflection in places where Spring abstractions exist.

By enforcing these rules, teams reduce **bugs, runtime errors, and maintainability issues** while aligning with modern Spring best practices.

## Purpose

The purpose of **Forbidden API Usage Rules** is to ensure **safe, maintainable, and modern coding practices** by restricting the use of APIs that are:

1. **Deprecated or obsolete**
   * Avoids introducing legacy code that may be removed in future Java or library versions.
2. **Error-prone or unsafe**
   * Prevents the use of APIs that can lead to thread-safety issues, memory leaks, or inconsistent behavior.
3. **Inconsistent with project standards**
   * Ensures all code follows **Spring’s abstractions and best practices**, such as using `RestTemplate` or `WebClient` instead of manual HTTP connections.
4. **Difficult to maintain or test**
   * Legacy or low-level APIs often require more boilerplate and increase testing complexity.
5. **Facilitates automated enforcement**
   * Tools like ArchUnit or static code analyzers can flag forbidden API usage to prevent violations during development.

#### Rules

## **1. Date and Time APIs**

* **Forbidden:**
  * `java.util.Date`
  * `java.util.Calendar`
  * `java.text.SimpleDateFormat`
* **Recommended:**
  * `java.time.LocalDate`, `LocalDateTime`, `ZonedDateTime`
  * `java.time.format.DateTimeFormatter`

## **2. Threading and Concurrency APIs**

* **Forbidden:**
  * `Thread`
  * `Runnable` (manual thread creation)
* **Recommended:**
  * Spring Task Executors (`@Async`, `TaskExecutor`)
  * `CompletableFuture` in combination with Spring’s async support
  * `ExecutorService`

## **3. Reflection and Unsafe APIs**

* **Forbidden:**
  * `java.lang.reflect.Field` / `Method` / `Constructor` (unless absolutely necessary)
  * `sun.misc.Unsafe` or internal JVM APIs
* **Recommended:**
  * Use Spring BeanUtils, Jackson, or MapStruct for field access and mapping

## **4. Direct JDBC Access**

* **Forbidden:**
  * `java.sql.Connection`, `Statement`, `ResultSet` in business or controller layers
* **Recommended:**
  * Spring Data JPA, JdbcTemplate, or repositories

## **5. Deprecated APIs**

* **Forbidden:**
  * Any class or method marked `@Deprecated` in Java or project libraries
* **Recommended:**
  * Use the suggested replacement APIs as per documentation

## **6. Collection and Stream Pitfalls**

* **Forbidden:**
  * `Vector`, `Hashtable` (legacy synchronized collections)
  * Iterating collections manually where streams or enhanced for-loop is suitable
* **Recommended:**
  * `List`, `Set`, `Map` from `java.util`
  * Java Streams API for functional operations

## **7. Logging**

* **Forbidden:**
  * `System.out.println` or `System.err.println` for production logging
* **Recommended:**
  * Use SLF4J / Logback / Log4j2 via Spring’s logging abstraction

## **8. Other Practices**

* Avoid using **magic numbers** and hard-coded paths.
* Avoid directly instantiating beans that should be injected via Spring.
