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

## **Serialization Inclusion Strategies**

Serialization inclusion strategies determine **what data gets included** in the JSON output. This is important to reduce unnecessary data in API responses, especially when dealing with large objects or REST services.

#### **Options**

<table><thead><tr><th width="271.287353515625">Strategy</th><th>Description</th></tr></thead><tbody><tr><td><code>Include.ALWAYS</code></td><td>Always include the property (default)</td></tr><tr><td><code>Include.NON_NULL</code></td><td>Exclude <code>null</code> values</td></tr><tr><td><code>Include.NON_EMPTY</code></td><td>Exclude empty values (empty string, empty list, etc.)</td></tr><tr><td><code>Include.NON_DEFAULT</code></td><td>Exclude fields with default values</td></tr><tr><td><code>Include.NON_ABSENT</code></td><td>Exclude nulls and Java 8 <code>Optional.empty()</code></td></tr></tbody></table>

#### **Global Configuration**

```java
objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
```

#### **Field-Level Configuration**

```java
public class User {
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<String> tags;
}
```

#### **Spring Boot Configuration (application.yml)**

```yaml
spring:
  jackson:
    default-property-inclusion: non_null
```

#### **Use Case Example**

You may not want to return null or empty fields to reduce response payload size:

```json
{
  "name": "John",
  "email": null
}
```

With `NON_NULL`, `email` will be excluded.

## **Date and Time Handling**

Working with dates and times in Java can be tricky, especially when serializing and deserializing JSON in REST APIs. Jackson provides powerful capabilities for formatting and parsing date/time types, and Spring Boot makes this integration seamless—but only if you configure it correctly.

#### **Why Special Handling Is Needed**

Java 8 introduced a new Date-Time API under `java.time.*` packages like:

* `LocalDate`
* `LocalDateTime`
* `ZonedDateTime`
* `Instant`

These types are **not supported natively** by Jackson without additional configuration. Jackson treats them differently than older types like `java.util.Date`, and without proper setup, they are either:

* Serialized as **arrays** (e.g. `[2024, 6, 20]`)
* Serialized as **timestamps**
* Or cause **deserialization errors**

#### **Solution**

To handle Java 8 time types correctly:

1. **Register `JavaTimeModule`**
2. **Disable writing as timestamps**

```java
ObjectMapper mapper = new ObjectMapper();
mapper.registerModule(new JavaTimeModule());
mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
```

This enables human-readable ISO-8601 strings like:

```json
"2024-06-20T15:45:00"
```

instead of:

```json
[2024, 6, 20, 15, 45, 0]
```

#### **Field-Level Formatting**

Use `@JsonFormat` to define a custom date format for individual fields:

```java
public class Event {
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime dateTime;
}
```

This ensures consistent formatting even if the global `ObjectMapper` is shared across the application.

#### **Global Formatting in Spring Boot**

Spring Boot allows configuring date/time formats centrally using `application.yml` or `application.properties`.

**YAML Configuration**

```yaml
spring:
  jackson:
    date-format: yyyy-MM-dd'T'HH:mm:ss
    time-zone: Asia/Kolkata
```

**Effect**

This:

* Sets the format for all `java.util.Date` and `Calendar`
* Does **not** apply to Java 8 `java.time.*` types unless you register `JavaTimeModule`

> To apply it for both, combine Spring config + `JavaTimeModule` registration.

#### **Timezone Handling**

When serializing or deserializing time-zone-aware types like `ZonedDateTime` or `OffsetDateTime`, Jackson can:

* Use default system time zone
* Apply a specific time zone via config
* Respect explicit time zone in the string

**Set Global Time Zone**

```java
mapper.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
```

Or via Spring config:

```yaml
spring:
  jackson:
    time-zone: Asia/Kolkata
```

#### **Deserialization Considerations**

When parsing strings, Jackson expects them to match the format defined by:

* `@JsonFormat` (if present)
* `application.yml` format (if configured)
* ISO-8601 (default fallback for `JavaTimeModule`)

Mismatched formats will cause `JsonParseException`.

## **Field Naming Strategy**

Field naming strategies control how Java field names are mapped to JSON keys.

#### **Default: camelCase**

```java
firstName → "firstName"
```

#### **snake\_case:**

```java
mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
```

```java
firstName → "first_name"
```

#### **Spring Boot Configuration**

```yaml
spring:
  jackson:
    property-naming-strategy: SNAKE_CASE
```

#### **Use Case**

Aligns backend field names with frontend naming conventions, especially in REST APIs.

## **Working with JSON Tree (JsonNode)**

Use `JsonNode` when working with **dynamic, partially known, or schema-less** JSON structures.

#### **Parsing JSON as Tree**

```java
String json = "{\"name\":\"Alice\", \"age\":30}";
JsonNode root = objectMapper.readTree(json);
String name = root.get("name").asText();     // "Alice"
int age = root.get("age").asInt();           // 30
```

#### **Modifying Tree**

```java
((ObjectNode) root).put("name", "Bob");
```

#### **Traversing Nested Nodes**

```java
JsonNode address = root.path("address");
String city = address.path("city").asText();
```

#### **Creating a Tree Manually**

```java
ObjectNode node = objectMapper.createObjectNode();
node.put("username", "john");
node.put("active", true);
```

#### **Use Case**

Perfect for generic filters, form submissions, or when schema is not static.

## **Annotations for Fine-Grained Control**

Jackson provides annotations to control serialization/deserialization behavior per class or field.

#### **Common Annotations**

<table><thead><tr><th width="225.60589599609375">Annotation</th><th>Purpose</th></tr></thead><tbody><tr><td><code>@JsonProperty</code></td><td>Rename JSON property</td></tr><tr><td><code>@JsonIgnore</code></td><td>Exclude field</td></tr><tr><td><code>@JsonInclude</code></td><td>Conditional inclusion</td></tr><tr><td><code>@JsonFormat</code></td><td>Format dates</td></tr><tr><td><code>@JsonAlias</code></td><td>Accept multiple names</td></tr><tr><td><code>@JsonCreator</code></td><td>Constructor/factory-based deserialization</td></tr><tr><td><code>@JsonValue</code></td><td>Serialize enum or custom object as a value</td></tr></tbody></table>

#### **Examples**

```java
public class Product {
    @JsonProperty("item_name")
    private String name;

    @JsonIgnore
    private String internalCode;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate releaseDate;

    @JsonAlias({"cost", "price_value"})
    private double price;
}
```

#### **Use Case**

* Maintain compatibility with legacy JSON.
* Adjust naming or formatting without changing the class model.
* Control visibility per API contract.

## **Working with JSON Tree (JsonNode)**

Use `JsonNode` when working with **dynamic, partially known, or schema-less** JSON structures.

#### **Parsing JSON as Tree**

```java
String json = "{\"name\":\"Alice\", \"age\":30}";
JsonNode root = objectMapper.readTree(json);
String name = root.get("name").asText();     // "Alice"
int age = root.get("age").asInt();           // 30
```

#### **Modifying Tree**

```java
((ObjectNode) root).put("name", "Bob");
```

#### **Traversing Nested Nodes**

```java
JsonNode address = root.path("address");
String city = address.path("city").asText();
```

#### **Creating a Tree Manually**

```java
ObjectNode node = objectMapper.createObjectNode();
node.put("username", "john");
node.put("active", true);
```

#### **Use Case**

Perfect for generic filters, form submissions, or when schema is not static.

