# EqualsBuilder & HashCodeBuilder

## About

Java classes often override the `equals()` and `hashCode()` methods to define custom object equality and ensure correct behavior in collections (like `HashMap`, `HashSet`, etc.).

Apache Commons Lang provides utility classes — `EqualsBuilder` and `HashCodeBuilder` — to:

* Simplify implementation of these methods
* Avoid common mistakes
* Improve readability and consistency

These builders use **reflection** or **explicit field appending**, supporting **both shallow and deep comparisons**.

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
```

## 1. `EqualsBuilder`

#### Purpose

Helps implement the `equals(Object other)` method in a clean and consistent way by comparing multiple fields.

#### Key Methods

| Method                         | Description                                         |
| ------------------------------ | --------------------------------------------------- |
| `append(field1, field2)`       | Appends field-by-field comparison                   |
| `isEquals()`                   | Returns final comparison result (`true` or `false`) |
| `reflectionEquals(obj1, obj2)` | Compares all fields via reflection                  |

#### Example – Manual Field Comparison

```java
public class Person {
    private String name;
    private int age;

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;

        Person other = (Person) obj;

        return new EqualsBuilder()
            .append(name, other.name)
            .append(age, other.age)
            .isEquals();
    }
}
```

#### Example – Reflection-Based Comparison

```java
@Override
public boolean equals(Object obj) {
    return EqualsBuilder.reflectionEquals(this, obj);
}
```

> Reflection-based comparison includes **all non-static**, **non-transient** fields. It is convenient but less performant and not recommended when performance is critical or field-level control is needed.

## 2. `HashCodeBuilder`

#### Purpose

Helps implement the `hashCode()` method by building a consistent hash from multiple fields.

#### Key Methods

| Method                       | Description                            |
| ---------------------------- | -------------------------------------- |
| `append(field)`              | Adds the field to the hash calculation |
| `toHashCode()`               | Returns the final hash code            |
| `reflectionHashCode(object)` | Generates hash code via reflection     |

#### Example – Manual Field HashCode

```java
@Override
public int hashCode() {
    return new HashCodeBuilder(17, 37)  // Two non-zero odd numbers (recommended)
        .append(name)
        .append(age)
        .toHashCode();
}
```

#### Example – Reflection-Based HashCode

```java
@Override
public int hashCode() {
    return HashCodeBuilder.reflectionHashCode(this);
}
```

> Like `reflectionEquals()`, `reflectionHashCode()` includes all non-static, non-transient fields and is less performant but convenient.

## Why Use These Builders?

<table><thead><tr><th width="161.521728515625">Concern</th><th width="334.61895751953125">Plain Java</th><th>Apache Commons Builders</th></tr></thead><tbody><tr><td>Verbosity</td><td>High (manual <code>equals</code> and <code>hashCode</code>)</td><td>Concise, easy to read</td></tr><tr><td>Null handling</td><td>Manual</td><td>Built-in</td></tr><tr><td>Consistency</td><td>Prone to error</td><td>Consistent and standard</td></tr><tr><td>Reflection option</td><td>Not available</td><td>Available with one line</td></tr><tr><td>Performance</td><td>Manual is slightly faster</td><td>Builders have minor overhead</td></tr></tbody></table>
