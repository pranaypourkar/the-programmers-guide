# MapStruct Mapper

## About&#x20;

MapStruct is a code generator that simplifies the implementation of mappings between Java bean types based on a convention-over-configuration approach. It is a tool designed to help developers map data from one Java object to another. It is a popular choice for mapping objects, especially in large-scale enterprise applications, due to its performance and ease of use.

Refer to documentation for more details: [https://mapstruct.org/documentation/1.5/reference/html/](https://mapstruct.org/documentation/1.5/reference/html/)

{% hint style="info" %}
**What is "Convention-Over-Configuration"?**

"Convention-over-configuration" is a software design principle used to reduce the number of decisions developers need to make, without sacrificing flexibility. In simpler terms, it means that the framework will assume reasonable default behavior unless the developer specifies otherwise. This approach minimizes the need for extensive configuration by relying on common conventions.

**How Does MapStruct Use Convention-Over-Configuration?**

MapStruct uses this principle to simplify object mappings by following these conventions

* **Property Name Matching**:
  * By default, MapStruct maps properties in source and target objects that have the same name and compatible types.
  * For example, if we have a `UserDTO` class with a `name` field and a `UserEntity` class with a `name` field, MapStruct will automatically map `UserDTO.name` to `UserEntity.name`.
* **Type Matching**:
  * MapStruct can automatically convert between types that have a clear conversion path (e.g., `String` to `int`, `Date` to `String`).
  * This reduces the need for explicit type conversion configuration.
* **Default Method Generation**:
  * MapStruct generates implementation code for the mapping methods based on the interface definitions provided by the developer.
  * For instance, if we define a method `UserDTO toUserDTO(UserEntity entity);` in a mapper interface, MapStruct will generate the implementation for this method, mapping each field based on conventions.
{% endhint %}

## Maven POM Dependency and Plugin

Include the required dependencies in pom.xml file.

```xml
<!-- This dependency includes the core MapStruct library which provides 
the API and main functionality for object mapping. -->
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct</artifactId>
    <version>1.5.5.Final</version>
</dependency>
<!-- This dependency includes the MapStruct annotation processor which 
generates the implementation of the mapper interfaces at compile time. -->
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct-processor</artifactId>
    <version>1.5.5.Final</version>
</dependency>
```

It comprises the following artifacts:

* _org.mapstruct:mapstruct_: contains the required annotations such as `@Mapping`
* _org.mapstruct:mapstruct-processor_: contains the annotation processor which generates mapper implementations

```xml
<!-- The maven-compiler-plugin is a Maven plugin used to compile Java source files. 
In the context of using MapStruct, it is configured to ensure that the MapStruct annotation 
processor is correctly set up during the compilation phase. -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>${maven-compiler-plugin.version}</version>
    <configuration>
        <annotationProcessorPaths>
            <path>
                <groupId>org.mapstruct</groupId>
                <artifactId>mapstruct-processor</artifactId>
                <version>${mapstruct.version}</version>
            </path>
        </annotationProcessorPaths>
        <useIncrementalCompilation>false</useIncrementalCompilation>
        <showWarnings>true</showWarnings>
        <compilerArgs>
            <arg>-Amapstruct.suppressGeneratorTimestamp=true</arg>
            <arg>-Amapstruct.suppressGeneratorVersionInfoComment=true</arg>
            <arg>-Amapstruct.verbose=true</arg>
        </compilerArgs>
    </configuration>
</plugin>
```

MapStruct processor options -

<table data-full-width="true"><thead><tr><th width="207">Option</th><th width="605">    Purpose</th><th>   Default</th></tr></thead><tbody><tr><td><code>mapstruct. suppressGeneratorTimestamp</code></td><td>If set to <code>true</code>, the creation of a time stamp in the <code>@Generated</code> annotation in the generated mapper classes is suppressed.</td><td><code>false</code></td></tr><tr><td><code>mapstruct.verbose</code></td><td>If set to <code>true</code>, MapStruct in which MapStruct logs its major decisions. Note, at the moment of writing in Maven, also <code>showWarnings</code> needs to be added due to a problem in the maven-compiler-plugin configuration.</td><td><code>false</code></td></tr><tr><td><code>mapstruct. suppressGeneratorVersionInfoComment</code></td><td>If set to <code>true</code>, the creation of the <code>comment</code>attribute in the <code>@Generated</code> annotation in the generated mapper classes is suppressed. The comment contains information about the version of MapStruct and about the compiler used for the annotation processing.</td><td><code>false</code></td></tr><tr><td><code>mapstruct.defaultComponentModel</code></td><td><p>The name of the component model based on which mappers should be generated.</p><p>Supported values are:</p><ul><li><code>default</code>: the mapper uses no component model, instances are typically retrieved via <code>Mappers#getMapper(Class)</code></li><li><code>cdi</code>: the generated mapper is an application-scoped (from javax.enterprise.context or jakarta.enterprise.context, depending on which one is available with javax.inject having priority) CDI bean and can be retrieved via <code>@Inject</code></li><li><code>spring</code>: the generated mapper is a singleton-scoped Spring bean and can be retrieved via <code>@Autowired</code> or lombok annotation like <code>@RequiredArgsConstructor</code></li><li><code>jsr330</code>: the generated mapper is annotated with {@code @Named} and can be retrieved via <code>@Inject</code> (from javax.inject or jakarta.inject, depending which one is available with javax.inject having priority), e.g. using Spring</li><li><code>jakarta</code>: the generated mapper is annotated with {@code @Named} and can be retrieved via <code>@Inject</code> (from jakarta.inject), e.g. using Spring</li><li><code>jakarta-cdi</code>: the generated mapper is an application-scoped (from jakarta.enterprise.context) CDI bean and can be retrieved via <code>@Inject</code></li></ul><p>If a component model is given for a specific mapper via <code>@Mapper#componentModel()</code>, the value from the annotation takes precedence.</p></td><td><code>default</code></td></tr><tr><td><code>mapstruct.defaultInjectionStrategy</code></td><td><p>The type of the injection in mapper via parameter <code>uses</code>. This is only used on annotated based component models such as CDI, Spring and JSR 330.</p><p>Supported values are:</p><ul><li><code>field</code>: dependencies will be injected in fields</li><li><code>constructor</code>: will be generated constructor. Dependencies will be injected via constructor.</li></ul><p>When CDI <code>componentModel</code> a default constructor will also be generated. If a injection strategy is given for a specific mapper via <code>@Mapper#injectionStrategy()</code>, the value from the annotation takes precedence over the option.</p></td><td><code>field</code></td></tr><tr><td><code>mapstruct.unmappedTargetPolicy</code></td><td><p>The default reporting policy to be applied in case an attribute of the target object of a mapping method is not populated with a source value.</p><p>Supported values are:</p><ul><li><code>ERROR</code>: any unmapped target property will cause the mapping code generation to fail</li><li><code>WARN</code>: any unmapped target property will cause a warning at build time</li><li><code>IGNORE</code>: unmapped target properties are ignored</li></ul><p>If a policy is given for a specific mapper via <code>@Mapper#unmappedTargetPolicy()</code>, the value from the annotation takes precedence. If a policy is given for a specific bean mapping via <code>@BeanMapping#unmappedTargetPolicy()</code>, it takes precedence over both <code>@Mapper#unmappedTargetPolicy()</code> and the option.</p></td><td><code>WARN</code></td></tr><tr><td><code>mapstruct.unmappedSourcePolicy</code></td><td><p>The default reporting policy to be applied in case an attribute of the source object of a mapping method is not populated with a target value.</p><p>Supported values are:</p><ul><li><code>ERROR</code>: any unmapped source property will cause the mapping code generation to fail</li><li><code>WARN</code>: any unmapped source property will cause a warning at build time</li><li><code>IGNORE</code>: unmapped source properties are ignored</li></ul><p>If a policy is given for a specific mapper via <code>@Mapper#unmappedSourcePolicy()</code>, the value from the annotation takes precedence. If a policy is given for a specific bean mapping via <code>@BeanMapping#ignoreUnmappedSourceProperties()</code>, it takes precedence over both <code>@Mapper#unmappedSourcePolicy()</code> and the option.</p></td><td><code>WARN</code></td></tr><tr><td><code>mapstruct. disableBuilders</code></td><td>If set to <code>true</code>, then MapStruct will not use builder patterns when doing the mapping. This is equivalent to doing <code>@Mapper( builder = @Builder( disableBuilder = true ) )</code> for all of our mappers.</td><td><code>false</code></td></tr></tbody></table>

## **Core Features**

MapStruct provides a set of core features that allow to map properties between different objects seamlessly. These include:

* **Basic Type Mapping**: MapStruct automatically maps properties with the same name and compatible types.
* **Handling Null Values**: By default, MapStruct maps null values, but we can customize this behavior.
* **Customizing Mappings with `@Mapping`**: This annotation allows to define how individual fields are mapped.

## Basic Mapping

The `@Mapper` annotation causes the MapStruct code generator to create an implementation of the `UserMapper` interface during build-time.

{% hint style="info" %}
* When a property has the same name as its target entity counterpart, it will be mapped implicitly.
* When a property has a different name in the target entity, its name can be specified via the `@Mapping` annotation.
* The DTO or the objects being mapped should have getter setter to access fields.
* `@BeanMapping` with the `ignoreByDefault` attribute in MapStruct allows us to specify that all properties should be ignored by default, and we can then explicitly specify which properties to include in the mapping. This can be useful for partial updates or when you want to map only a subset of the properties.
* In some cases, it can be required to manually implement a specific mapping from one type to another which can’t be generated by MapStruct. Use the Default method for such case.
* In some cases, we may need mappings which don’t create a new instance of the target type but instead update an existing instance of that type. We can achieve this by adding a parameter for the target object and marking this parameter with `@MappingTarget.` There may be only one parameter marked as mapping target.
* MapStruct also supports mappings of `public` fields that have no getters/setters. MapStruct will use the fields as read/write accessor if it cannot find suitable getter/setter methods for the property. A field is considered as a read accessor if it is `public` or `public final`. If a field is `static` it is not considered as a read accessor. A field is considered as a write accessor only if it is `public`. If a field is `final` and/or `static` it is not considered as a write accessor.
{% endhint %}

```java
package mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {

    // UserId will be mapped implicitly since field name from both the object is same
    @Mapping(target = "userName", source = "name")
    @Mapping(target = "userEmail", source = "email")
    @Mapping(target = "addressDTO.pincode", source = "pincode")
    UserDTO mapToUserDTO(User user);
    
    // All properties need to map explicitly
    @BeanMapping(ignoreByDefault = true)
    AddressDTO mapToAddressDTO(Address address);
    
    // Implement custom method if it has complex mapping logic which cannot be handled by mapstruct
    default PersonDto personToPersonDto(Person person) {
        //hand-written mapping logic
    }
    
    // Mapping methods with several source parameters
    @Mapping(target = "description", source = "person.description")
    @Mapping(target = "houseNumber", source = "address.houseNo")
    DeliveryAddressDto personAndAddressToDeliveryAddressDto(Person person, Address address);
    
    // Mapping nested bean properties to current target. "." as target
    // Generated code will map every property from CustomerDto.record and Customer.account
    // to Customer directly, without manually naming. 
    @Mapping( target = "name", source = "record.name" )
    @Mapping( target = ".", source = "record" )
    @Mapping( target = ".", source = "account" )
    Customer customerDtoToCustomer(CustomerDto customerDto);
    
    // Updating existing bean instances
    // In some cases, we need to update an existing instance of a type rather a new instance
    void updateCarFromDto(CarDto carDto, @MappingTarget Car car);
    
    // We can return the target type as well
    Car updateAndReturnCarFromDto(CarDto carDto, @MappingTarget Car car);
    
    // Here, say CustomerDto has only public fields but no getter setter. Whereas Customer has private fields with getter setter
    // Mapstruct allows mapping even if no getter setter provided it satisfies accessor conditons
    @Mapping(target = "name", source = "customerName")
    Customer toCustomer(CustomerDto customerDto);
    
    // Annotation @InheritInverseConfiguration indicates that a method shall inherit the inverse configuration of the corresponding reverse method.
    @InheritInverseConfiguration
    CustomerDto fromCustomer(Customer customer);
}
```

### Using builders <a href="#mapping-with-builders" id="mapping-with-builders"></a>

MapStruct also supports mapping of immutable types via builders. When performing a mapping MapStruct checks if there is a builder for the type being mapped. This is done via the `BuilderProvider` SPI. If a Builder exists for a certain type, then that builder will be used for the mappings.

```java
// Builder Pattern for Person class
public class Person {

    private final String name;

    protected Person(Person.Builder builder) {
        this.name = builder.name;
    }
    public static Person.Builder builder() {
        return new Person.Builder();
    }

    public static class Builder {

        private String name;

        public Builder name(String name) {
            this.name = name;
            return this;
        }
        public Person create() {
            return new Person( this );
        }
    }
}

// Mapstruct mapper
@Mapper(componentModel = "spring")
public interface PersonMapper {
    Person map(PersonDto dto);
}
```

### Using Constructors <a href="#mapping-with-constructors" id="mapping-with-constructors"></a>

MapStruct supports using constructors for mapping target types. When doing a mapping MapStruct checks if there is a builder for the type being mapped. If there is no builder, then MapStruct looks for a single accessible constructor.&#x20;

* If a constructor is annotated with an annotation _named_ `@Default` it will be used.
* If a single public constructor exists then it will be used to construct the object, and the other non public constructors will be ignored.
* If a parameterless constructor exists then it will be used to construct the object, and the other constructors will be ignored.
* If there are multiple eligible constructors then there will be a compilation error due to ambiguous constructors.

```java
public class Vehicle {
    protected Vehicle() { }
    // MapStruct will use this constructor, because it is a single public constructor
    public Vehicle(String color) { }
}

public class Car {
    // MapStruct will use this constructor, because it is a parameterless empty constructor
    public Car() { }
    public Car(String make, String color) { }
}

public class Truck {
    public Truck() { }
    // MapStruct will use this constructor, because it is annotated with @Default
    @Default
    public Truck(String make, String color) { }
}

public class Van {
    // There will be a compilation error when using this class because MapStruct cannot pick a constructor
    public Van(String make) { }
    public Van(String make, String color) { }
}

// Mapper
@Mapper(componentModel = "spring")
public interface PersonMapper {
    Person map(PersonDto dto);
}
```

### Mapping `Map` to Bean <a href="#mapping-map-to-bean" id="mapping-map-to-bean"></a>

We want to map  `Map<String, ???>` into a specific bean. When a raw map or a map that does not have a String as a key is used, then a warning will be generated.

```java
public class Customer {
    private Long id;
    private String name;

    //getters and setter omitted for brevity
}

@Mapper
public interface CustomerMapper {
    // Here, source act as key. Mapstruct will try to use map.containsKey( "customerName" ) to check and then ex
    // map.get( "id" ) to get the value and assign to target
    @Mapping(target = "name", source = "customerName")
    Customer toCustomer(Map<String, String> map);
}
```

### Retrieving a mapper in another class to use its methods <a href="#retrieving-mapper" id="retrieving-mapper"></a>

#### Without using DI framework

```
CarMapper mapper = Mappers.getMapper( CarMapper.class );
```

But with this, we need to repeatedly instantiating new instances if we need to use it in several classes. To fix this, a mapper interface should define a member called `INSTANCE` which holds a single instance of the mapper type.

<pre class="language-java"><code class="lang-java"><strong>// Declaring an instance of a mapper (interface)
</strong><strong>@Mapper(componentModel = ComponentModel.SPRING)
</strong>public interface CarMapper {

    CarMapper INSTANCE = Mappers.getMapper( CarMapper.class );

    CarDto carToCarDto(Car car);
}

// Declaring an instance of a mapper (abstract class)
@Mapper
public abstract class CarMapper {

    public static final CarMapper INSTANCE = Mappers.getMapper( CarMapper.class );

    CarDto carToCarDto(Car car);
}

// Usage in other classes
CarDto dto = CarMapper.INSTANCE.carToCarDto( car );

</code></pre>

#### Using DI framework

&#x20;When using Spring Framework, it is recommended to obtain mapper objects via dependency injection and not via the `Mappers`class as described above.

```java
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface EventMapper {
...
}

// Usage
@RequiredArgsConstructor
@Component
public class SomeEventProcessor {
...
private final EventMapper eventMapper;
...
..
}
```

### Injection strategy <a href="#injection-strategy" id="injection-strategy"></a>

When using dependency injection, we can choose between field and constructor injection. This can be done by providing injection strategy via `@Mapper` or `@MapperConfig` annotation. Constructor injection is recommended to simplify testing. As per documentation, for abstract classes or decorators setter injection should be used.

```java
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, injectionStrategy = InjectionStrategy.CONSTRUCTOR)
public interface CarMapper {
    CarDto carToCarDto(Car car);
}
```



## Composition Mapping <a href="#mapping-composition" id="mapping-composition"></a>

MapStruct supports the use of meta annotations like @Retention. This allows `@Mapping` to be used on other (user defined) annotations for re-use purposes.&#x20;

For example below. The `@ToTransactionHeader` assumes both target beans `TransactionEntity` and `PaymentEntity` have properties: `"id"`, `"creationDate"` and `"name"`

```java
@Retention(RetentionPolicy.CLASS)
@Mapping(target = "id", ignore = true)
@Mapping(target = "creationDate", expression = "java(new java.util.Date())")
@Mapping(target = "name", source = "groupName")
public @interface ToTransactionHeader { }

@Mapper
public interface TransactionMapper {

    TransactionMapper INSTANCE = Mappers.getMapper( TransactionMapper.class );

    @ToTransactionHeader
    @Mapping( target = "type", source = "type")
    TransactionEntity map(TransactionDto source);

    @ToTransactionHeader
    @Mapping( target = "accountId", source = "accountId")
    PaymentEntity map(PaymentDto source);
}
```



