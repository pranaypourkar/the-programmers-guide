# Apache Commons Lang

Apache Commons Lang is a widely-used Java library that provides various utility functions for working with basic Java objects, including strings, arrays, numbers, and more.

### **Maven Dependency**

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version>
</dependency>
```

### **Categories**

**Splitting of various utility methods across different categories.**



* **StringUtils Class**

```java
import org.apache.commons.lang3.StringUtils;
```

**Methods**

```java
abbreviate(String str, int maxWidth)
```

It is used to abbreviate or shorten a string to a specified length while appending an ellipsis ("...") to indicate that the string has been shortened.







* **ArrayUtils Class**

```java
import org.apache.commons.lang3.ArrayUtils
```





* **NumberUtils Class**

```java
import org.apache.commons.lang3.math.NumberUtils;
```



* **SystemUtils Class**

```java
import org.apache.commons.lang3.SystemUtils;
```



* **RandomStringUtils Class**

```java
import org.apache.commons.lang3.RandomStringUtils;
```



* **DateUtils Class**

```java
import org.apache.commons.lang3.time.DateUtils;
```



* **EqualsBuilder**&#x20;

```java
import org.apache.commons.lang3.builder.EqualsBuilder;
```



* **HashCodeBuilder Class**

```java
import org.apache.commons.lang3.builder.HashCodeBuilder;
```

