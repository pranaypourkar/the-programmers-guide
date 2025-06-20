# Jackson ObjectMapper

## About

`ObjectMapper` is a core class provided by the **Jackson** library, used for converting between Java objects and JSON. It allows us to:

* Serialize Java objects to JSON
* Deserialize JSON to Java objects
* Work with Maps, Lists, and generic types
* Configure inclusion/exclusion rules
* Register modules for special data types like Java 8 date/time, Java records, etc.

Although Jackson is not a Spring-native library, **Spring Boot auto-configures Jackson** and provides seamless integration out-of-the-box, making `ObjectMapper` one of the most commonly used utilities in Spring-based applications.

## **Dependency**

If we are using Spring Boot with web or REST modules, Jackson is included automatically via the `spring-boot-starter-web` dependency:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

This transitively includes:

```xml
<dependency>
  <groupId>com.fasterxml.jackson.core</groupId>
  <artifactId>jackson-databind</artifactId>
</dependency>
```

If we are not using Spring Boot or want to include Jackson manually, add:

```xml
<dependency>
  <groupId>com.fasterxml.jackson.core</groupId>
  <artifactId>jackson-databind</artifactId>
  <version>2.17.0</version> <!-- Use latest stable -->
</dependency>
```

## **Spring Integration**

### **How Spring Boot Uses Jackson Internally ?**

Spring Boot uses Jackson as the default JSON processor. When we build a REST API or web application with `spring-boot-starter-web`, it:

* Automatically includes the Jackson library (`jackson-databind`)
* Registers a **singleton `ObjectMapper` bean** in the Spring context
* Uses that bean for:
  * Serializing controller response objects (`@ResponseBody`)
  * Deserializing request bodies into Java objects (`@RequestBody`)
  * JSON conversion in `RestTemplate`, `WebClient`, and Feign clients

We can inject and use this same ObjectMapper throughout our application:

```java
@Autowired
private ObjectMapper objectMapper;
```

### **Default Behavior in Spring Boot**

When using Spring Boot, the default `ObjectMapper` is configured with sensible defaults.

#### **Example Defaults**

<table data-full-width="true"><thead><tr><th width="328.5399169921875">Feature</th><th>Default Behavior</th></tr></thead><tbody><tr><td>Include <code>null</code> fields in JSON</td><td>Yes</td></tr><tr><td>Pretty-print JSON</td><td>No</td></tr><tr><td>Fail on unknown JSON properties</td><td>No (<code>FAIL_ON_UNKNOWN_PROPERTIES</code> is disabled)</td></tr><tr><td>Support for Java 8 Date/Time types</td><td>Yes (via <code>jackson-datatype-jsr310</code>)</td></tr><tr><td>Use of ISO-8601 for date serialization</td><td>Yes</td></tr><tr><td>Support for Java 8 Optional types</td><td>Yes</td></tr><tr><td>Snake case support</td><td>No (uses camelCase by default)</td></tr></tbody></table>

We can override these behaviors either:

1. Through application properties
2. By providing a custom `ObjectMapper` bean

### Customizing ObjectMapper via `application.yml`

```yaml
spring:
  jackson:
    # Include strategy for properties
    # Options: always, non_null, non_absent, non_default, non_empty
    default-property-inclusion: non_null  # Exclude null fields from JSON output

    # Serialization settings
    serialization:
      indent_output: true  # Pretty-print the JSON output (adds newlines and spaces)

    # Deserialization settings
    deserialization:
      fail-on-unknown-properties: false  # Do not fail if JSON has unknown fields

    # Date and time formatting
    date-format: yyyy-MM-dd'T'HH:mm:ss  # Custom global date-time format
    time-zone: Asia/Kolkata             # Time zone to use for date/time serialization

    # Naming strategy for property names
    # Options: SNAKE_CASE, LOWER_CAMEL_CASE (default), UPPER_CAMEL_CASE, KEBAB_CASE, etc.
    property-naming-strategy: SNAKE_CASE  # Converts Java fields like "firstName" to "first_name"

    # Enable/disable features (serialization/deserialization-level)
    mapper:
      # Allow use of getter methods as creators (if no constructor present)
      allow-getters-as-setters: true

    # Visibility control (used less frequently)
    visibility:
      # Property-level visibility configuration
      field: any                # Detect all fields regardless of access modifier
      getter: none              # Ignore getters
      is-getter: none           # Ignore "isX()" methods for booleans
      setter: any               # Detect all setters
      creator: any              # Detect constructors and factory methods
```

### Internally, Spring Boot does this

Spring Boot binds these properties into a `Jackson2ObjectMapperBuilder` and applies them when initializing the `ObjectMapper` bean.

This is equivalent to doing this programmatically:

```java
ObjectMapper mapper = new ObjectMapper();
mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
mapper.enable(SerializationFeature.INDENT_OUTPUT);
mapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"));
```

### Overriding the Default ObjectMapper

If we need full control, define our own `@Bean` of type `ObjectMapper`. Spring Boot will use our version instead of the default.

```java
@Configuration
public class JacksonConfig {
    
    @Bean
    public ObjectMapper customObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        mapper.registerModule(new JavaTimeModule());
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
        return mapper;
    }
}
```

> Note: If we do this, make sure to register required modules like `JavaTimeModule`, otherwise date/time parsing may break.

## Use Cases

### 1. **Serialization: Java Object to JSON**

Convert a Java object into a JSON string.

```java
Person person = new Person("John", 30);
String json = objectMapper.writeValueAsString(person);
```

Write to file or output stream:

```java
objectMapper.writeValue(new File("person.json"), person);
```

Pretty-printing:

```java
objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
String prettyJson = objectMapper.writeValueAsString(person);
```

### 2. **Deserialization: JSON to Java Object**

Convert a JSON string to a Java object.

```java
String json = "{\"name\":\"John\",\"age\":30}";
Person person = objectMapper.readValue(json, Person.class);
```

From file:

```java
Person person = objectMapper.readValue(new File("person.json"), Person.class);
```

### 3. **Convert Between Java Objects (Object to Object Mapping)**

Convert one type to another using intermediate JSON conversion. Useful for mapping DTOs to entities.

```java
UserDTO dto = new UserDTO("john.doe", "Admin");
UserEntity entity = objectMapper.convertValue(dto, UserEntity.class);
```

### 4. Convert to and from Map

#### **POJO Class**

```java
public class User {
    private String name;
    private int age;

    // Constructors, getters, setters
}
```

#### **Convert POJO to Map**

```java
User user = new User("Alice", 25);
Map<String, Object> map = objectMapper.convertValue(user, new TypeReference<>() {});
System.out.println(map);
```

```
{name=Alice, age=25}
```

#### **Convert Map to POJO**

```java
<String, Object> map = new HashMap<>();
map.put("name", "Bob");
map.put("age", 30);

User user = objectMapper.convertValue(map, User.class);
System.out.println(user.getName());  // Bob
System.out.println(user.getAge());   // 30
```

### 5. **Handling Collections and Generics**

Deserialize a JSON array into a list of objects:

```java
String json = "[{\"name\":\"John\",\"age\":30},{\"name\":\"Jane\",\"age\":25}]";

List<Person> people = objectMapper.readValue(
    json, new TypeReference<List<Person>>() {}
);
```

Deserialize a nested structure:

```java
String json = "{\"group\":\"team1\",\"members\":[{\"name\":\"John\"},{\"name\":\"Jane\"}]}";

Group group = objectMapper.readValue(json, Group.class);
```

### **6. Deserialization with Unknown or Partial JSON**

#### **POJO Class**

```java
public class Product {
    private String name;
    private double price;

    // Constructors, getters, setters
}
```

#### **JSON with Extra Field (unknown)**

```java
String json = """
{
    "name": "Laptop",
    "price": 999.99,
    "warranty": "2 years"  // Not present in Product class
}
""";
```

#### **Default Behavior (in Spring Boot)**

By default, Spring Boot configures `ObjectMapper` to **ignore unknown fields**, so this will **work fine**.

```java
Product product = objectMapper.readValue(json, Product.class);
System.out.println(product.getName());   // Laptop
System.out.println(product.getPrice());  // 999.99
```

#### **Manually Ensuring it Ignores Unknown Fields**

If we are not in Spring Boot, or just want to be sure:

```java
objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
```

#### **Partial JSON**

```java
String partialJson = """
{
    "name": "Phone"
}
""";
```

If `price` is missing, it will be set to its default value (e.g., `0.0` for `double`).

```java
Product product = objectMapper.readValue(partialJson, Product.class);
System.out.println(product.getName());   // Phone
System.out.println(product.getPrice());  // 0.0
```



