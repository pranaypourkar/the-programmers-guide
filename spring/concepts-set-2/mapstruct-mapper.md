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

## Data type conversions <a href="#datatype-conversions" id="datatype-conversions"></a>

It is possible to have mapped attribute with the same type or different in the source and target objects. We need to understand how MapStruct deals with such data type conversions.

### Implicit type conversions <a href="#implicit-type-conversions" id="implicit-type-conversions"></a>

Mapstruct applies the following conversion automatically.

* Between all Java primitive data types and their corresponding wrapper types, e.g. between `int` and `Integer`, `boolean` and `Boolean` etc. When converting a wrapper type into the corresponding primitive type a `null` check will be performed.
* Between all Java primitive number types and the wrapper types, e.g. between `int` and `long` or `byte` and `Integer`

{% hint style="info" %}
The `Mapper` and `MapperConfig` annotations have a method `typeConversionPolicy` to control warnings / errors. Due to backward compatibility reasons the default value is `ReportingPolicy.IGNORE`.
{% endhint %}

* Between all Java primitive types (including their wrappers) and `String`, e.g. between `int` and `String` or `Boolean`and `String`. A format string as understood by `java.text.DecimalFormat` can be specified.

```java
@Mapper
public interface CarMapper {

    @Mapping(source = "price", numberFormat = "$#.00")
    CarDto carToCarDto(Car car);

    @IterableMapping(numberFormat = "$#.00")
    List<String> prices(List<Integer> prices);
}
```

* Between `enum` types and `String`.
* Between big number types (`java.math.BigInteger`, `java.math.BigDecimal`) and Java primitive types (including their wrappers) as well as String. A format string `java.text.DecimalFormat` can be specified.

```
@Mapper
public interface EventMapper {

    @Mapping(source = "fee", numberFormat = "#.##E0")
    EventDto eventToEventDto(Event event);

}
```

* Between `JAXBElement<T>` and `T`, `List<JAXBElement<T>>` and `List<T>`
* Between `java.util.Calendar`/`java.util.Date` and JAXB’s `XMLGregorianCalendar`
* Between `java.util.Date`/`XMLGregorianCalendar` and `String`. A format string as understood by `java.text.SimpleDateFormat` can be specified via the `dateFormat` option

```
@Mapper
public interface EventMapper {

    @Mapping(source = "paymenDate", dateFormat = "dd.MM.yyyy")
    EventDto eventToEventDto(Event event);

    @IterableMapping(dateFormat = "dd.MM.yyyy")
    List<String> stringListToDateList(List<Date> dates);
}
```

* Between Jodas `org.joda.time.DateTime`, `org.joda.time.LocalDateTime`, `org.joda.time.LocalDate`, `org.joda.time.LocalTime` and `String`. A format string as understood by `java.text.SimpleDateFormat` can be specified via the `dateFormat` option (see above).
* Between Jodas `org.joda.time.DateTime` and  `javax.xml.datatype.XMLGregorianCalendar`, `java.util.Calendar`.
* Between Jodas `org.joda.time.LocalDateTime`, `org.joda.time.LocalDate` and `javax.xml.datatype.XMLGregorianCalendar`, `java.util.Date`.
* Between `java.time.LocalDate`, `java.time.LocalDateTime` and `javax.xml.datatype.XMLGregorianCalendar`.
* Between `java.time.ZonedDateTime`, `java.time.LocalDateTime`, `java.time.LocalDate`, `java.time.LocalTime`from Java 8 Date-Time package and `String`. A format string as understood by `java.text.SimpleDateFormat` can be specified via the `dateFormat` option (see above).
* Between `java.time.Instant`, `java.time.Duration`, `java.time.Period` from Java 8 Date-Time package and `String` using the `parse` method in each class to map from `String` and using `toString` to map into `String`.
* Between `java.time.ZonedDateTime` from Java 8 Date-Time package and `java.util.Date` where, when mapping a `ZonedDateTime` from a given `Date`, the system default timezone is used.
* Between `java.time.LocalDateTime` from Java 8 Date-Time package and `java.util.Date` where timezone UTC is used as the timezone.
* Between `java.time.LocalDate` from Java 8 Date-Time package and `java.util.Date` / `java.sql.Date` where timezone UTC is used as the timezone.
* Between `java.time.Instant` from Java 8 Date-Time package and `java.util.Date`.
* Between `java.time.ZonedDateTime` from Java 8 Date-Time package and `java.util.Calendar`.
* Between `java.sql.Date` and `java.util.Date`
* Between `java.sql.Time` and `java.util.Date`
* Between `java.sql.Timestamp` and `java.util.Date`
* When converting from a `String`, omitting `Mapping#dateFormat`, it leads to usage of the default pattern and date format symbols for the default locale. An exception to this rule is `XmlGregorianCalendar` which results in parsing the `String` according to XML Schema.
* Between `java.util.Currency` and `String`.
  * When converting from a `String`, the value needs to be a valid ISO-4217 alphabetic code otherwise an `IllegalArgumentException` is thrown.
* Between `java.util.UUID` and `String`.
  * When converting from a `String`, the value needs to be a valid UUID otherwise an `IllegalArgumentException` is thrown.
* Between `String` and `StringBuilder`
* Between `java.net.URL` and `String`.
  * When converting from a `String`, the value needs to be a valid URL otherwise a `MalformedURLException` is thrown.

### Mapping nested object references <a href="#mapping-object-references" id="mapping-object-references"></a>

Suppose, Event has reference to Address object.

```java
@Mapper
public interface EventMapper {
    EventDto eventToEventDto(Event event);

    AddressDto addressToAddressDto(Address address);
}
```

### Controlling nested bean mappings <a href="#controlling-nested-bean-mappings" id="controlling-nested-bean-mappings"></a>

MapStruct will generate a method based on the name of the source and target property. In many occasions these names do not match. The ‘.’ notation in an `@Mapping` source or target type can be used to control how properties should be mapped when names do not match.

```java
@Mapper
public interface FishTankMapper {
    @Mapping(target = "fish.kind", source = "fish.type")
    @Mapping(target = "fish.name", ignore = true)
    @Mapping(target = "ornament", source = "interior.ornament")
    @Mapping(target = "material.materialType", source = "material")
    @Mapping(target = "quality.report.organisation.name", source = "quality.report.organisationName")
    FishTankDto map( FishTank source );
}
```

### Invoking custom mapping method <a href="#invoking-custom-mapping-method" id="invoking-custom-mapping-method"></a>

Sometimes, some fields require custom logic. For example, MapStruct will take the entire parameter `source` and generate code to call the custom method `mapVolume`in order to map the `FishTank` object to the target property `volume`.

```java
public class FishTank {
    Fish fish;
    String material;
    Quality quality;
    int length;
    int width;
    int height;
}

public class FishTankWithVolumeDto {
    FishDto fish;
    MaterialDto material;
    QualityDto quality;
    VolumeDto volume;
}

public class VolumeDto {
    int volume;
    String description;
}

@Mapper
public abstract class FishTankMapperWithVolume {

    @Mapping(target = "fish.kind", source = "source.fish.type")
    @Mapping(target = "material.materialType", source = "source.material")
    @Mapping(target = "quality.document", source = "source.quality.report")
    @Mapping(target = "volume", source = "source")
    abstract FishTankWithVolumeDto map(FishTank source);

    VolumeDto mapVolume(FishTank source) {
        int volume = source.length * source.width * source.height;
        String desc = volume < 100 ? "Small" : "Large";
        return new VolumeDto(volume, desc);
    }
}
```

### Invoking other mappers <a href="#invoking-other-mappers" id="invoking-other-mappers"></a>

MapStruct can also invoke mapping methods defined in other classes, be it mappers generated by MapStruct or hand-written mapping methods. For eg, when generating code for the implementation of the `carToCarDto()` method, MapStruct will look for a method which maps a `Date` object into a String, find it on the `DateMapper` class and generate an invocation of `asString()` for mapping the `manufacturingDate` attribute.

```java
// Manually implemented class
public class DateMapper {
    public String asString(Date date) {
        return date != null ? new SimpleDateFormat( "yyyy-MM-dd" )
            .format( date ) : null;
    }

    public Date asDate(String date) {
        try {
            return date != null ? new SimpleDateFormat( "yyyy-MM-dd" )
                .parse( date ) : null;
        }
        catch ( ParseException e ) {
            throw new RuntimeException( e );
        }
    }
}

// Using the DateMapper in a mapper
@Mapper(uses=DateMapper.class)
public interface CarMapper {
    CarDto carToCarDto(Car car);
}
```

### Passing context or state objects to custom methods <a href="#passing-context" id="passing-context"></a>

Additional _context_ or _state_ information can be passed through generated mapping methods to custom methods with `@Context` parameters. Such parameters are passed to other mapping methods, `@ObjectFactory` methods or `@BeforeMapping` / `@AfterMapping` methods when applicable and can thus be used in custom code.

```java
public abstract CarDto toCar(Car car, @Context Locale translationLocale);

protected OwnerManualDto translateOwnerManual(OwnerManual ownerManual, @Context Locale locale) {
    // manually implemented logic to translate the OwnerManual with the given Locale
}
```

```java
//GENERATED CODE
public CarDto toCar(Car car, Locale translationLocale) {
    if ( car == null ) {
        return null;
    }

    CarDto carDto = new CarDto();

    carDto.setOwnerManual( translateOwnerManual( car.getOwnerManual(), translationLocale );
    // more generated mapping code

    return carDto;
}
```

### Mapping method resolution <a href="#mapping-method-resolution" id="mapping-method-resolution"></a>

When mapping a property from one type to another, MapStruct looks for the most specific method which maps the source type into the target type. The method may either be declared on the same mapper interface or on another mapper which is registered via `@Mapper#uses()`

### Combining qualifiers @Named with defaults <a href="#combining_qualifiers_with_defaults" id="combining_qualifiers_with_defaults"></a>

Default value will be used if the returned value from the @Named method is null.

```java
@Mapper
public interface MovieMapper {
     @Mapping( target = "category", qualifiedByName = "CategoryToString", defaultValue = "DEFAULT" )
     GermanRelease toGerman( OriginalRelease movies );

     @Named("CategoryToString")
     default String defaultValueForQualifier(Category cat) {
         // some mapping logic
     }
}
```

## Basic Mapping

The `@Mapper` annotation causes the MapStruct code generator to create an implementation of the `UserMapper` interface during build-time. MapStruct will generate a method based on the name of the source and target property.

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

## Mapping collections <a href="#mapping-collections" id="mapping-collections"></a>

As per documentation, the mapping of collection types (`List`, `Set` etc.) is done in the same way as mapping bean types, i.e. by defining mapping methods with the required source and target types in a mapper interface

```java
@Mapper
public interface CarMapper {
    Set<String> integerSetToStringSet(Set<Integer> integers);

    List<CarDto> carsToCarDtos(List<Car> cars);

    CarDto carToCarDto(Car car);
}
```

{% hint style="info" %}
MapStruct has a `CollectionMappingStrategy`, with the possible values: `ACCESSOR_ONLY`, `SETTER_PREFERRED`, `ADDER_PREFERRED` and `TARGET_IMMUTABLE`. The option `DEFAULT` is synonymous to `ACCESSOR_ONLY`.

An `adder` method is typically used in case of generated (JPA) entities, to add a single element (entity) to an underlying collection. Invoking the adder establishes a parent-child relation between parent - the bean (entity) on which the adder is invoked - and its child(ren), the elements (entities) in the collection
{% endhint %}

### Mapping maps <a href="#mapping-maps" id="mapping-maps"></a>

```java
public interface SourceTargetMapper {
    @MapMapping(valueDateFormat = "dd.MM.yyyy")
    Map<String, String> longDateMapToStringStringMap(Map<Long, Date> source);
}
```

### Implementation types used for collection mappings <a href="#implementation-types-for-collection-mappings" id="implementation-types-for-collection-mappings"></a>

As per documentation, when an iterable or map mapping method declares an interface type as return type, one of its implementation types will be instantiated in the generated code.&#x20;

<table><thead><tr><th width="286">Interface type</th><th>Implementation type</th></tr></thead><tbody><tr><td><code>Iterable</code></td><td><code>ArrayList</code></td></tr><tr><td><code>Collection</code></td><td><code>ArrayList</code></td></tr><tr><td><code>List</code></td><td><code>ArrayList</code></td></tr><tr><td><code>Set</code></td><td><code>LinkedHashSet</code></td></tr><tr><td><code>SortedSet</code></td><td><code>TreeSet</code></td></tr><tr><td><code>NavigableSet</code></td><td><code>TreeSet</code></td></tr><tr><td><code>Map</code></td><td><code>LinkedHashMap</code></td></tr><tr><td><code>SortedMap</code></td><td><code>TreeMap</code></td></tr><tr><td><code>NavigableMap</code></td><td><code>TreeMap</code></td></tr><tr><td><code>ConcurrentMap</code></td><td><code>ConcurrentHashMap</code></td></tr><tr><td><code>ConcurrentNavigableMap</code></td><td><code>ConcurrentSkipListMap</code></td></tr></tbody></table>

## Mapping Streams <a href="#mapping-streams" id="mapping-streams"></a>

As per documentation, mapping of `java.util.Stream` is done in a similar way as the mapping of collection types, i.e. by defining mapping methods with the required source and target types in a mapper interface.

```java
@Mapper
public interface CarMapper {
    Set<String> integerStreamToStringSet(Stream<Integer> integers);

    List<CarDto> carsToCarDtos(Stream<Car> cars);

    CarDto carToCarDto(Car car);
}
```

## Mapping Values <a href="#mapping-enum-types" id="mapping-enum-types"></a>

### Mapping enum to enum types <a href="#mapping_enum_to_enum_types" id="mapping_enum_to_enum_types"></a>

```java
@Mapper
public interface OrderMapper {
    OrderMapper INSTANCE = Mappers.getMapper( OrderMapper.class );

    @ValueMappings({
        @ValueMapping(target = "SPECIAL", source = "EXTRA"),
        @ValueMapping(target = "DEFAULT", source = "STANDARD"),
        @ValueMapping(target = "DEFAULT", source = "NORMAL")
    })
    ExternalOrderType orderTypeToExternalOrderType(OrderType orderType);
}
```

{% hint style="info" %}
As per documentation, MapStruct also support for mapping any remaining (unspecified) mappings to a default. This can be used only once in a set of value mappings and only applies to the source. It comes in two flavors: `<ANY_REMAINING>` and `<ANY_UNMAPPED>`. They cannot be used at the same time.

In case of source `<ANY_REMAINING>` MapStruct will continue to map a source enum constant to a target enum constant with the same name. The remainder of the source enum constants will be mapped to the target specified in the `@ValueMapping` with `<ANY_REMAINING>` source.

MapStruct will **not** attempt such name based mapping for `<ANY_UNMAPPED>` and directly apply the target specified in the `@ValueMapping` with `<ANY_UNMAPPED>` source to the remainder.

MapStruct is able to handle `null` sources and `null` targets by means of the `<NULL>` keyword.

In addition, the constant value `<THROW_EXCEPTION>` can be used for throwing an exception for particular value mappings.
{% endhint %}

```java
@Mapper
public interface SpecialOrderMapper {

    SpecialOrderMapper INSTANCE = Mappers.getMapper( SpecialOrderMapper.class );

    // MapStruct would have refrained from mapping the RETAIL and B2B when <ANY_UNMAPPED> was used instead of <ANY_REMAINING>
    @ValueMappings({
        @ValueMapping( source = MappingConstants.NULL, target = "DEFAULT" ),
        @ValueMapping( source = "STANDARD", target = MappingConstants.NULL ),
        @ValueMapping( source = MappingConstants.ANY_REMAINING, target = "SPECIAL" )
    })
    ExternalOrderType orderTypeToExternalOrderType(OrderType orderType);
}
```

```java
@Mapper
public interface SpecialOrderMapper {

    SpecialOrderMapper INSTANCE = Mappers.getMapper( SpecialOrderMapper.class );

    @ValueMappings({
        @ValueMapping( source = "STANDARD", target = "DEFAULT" ),
        @ValueMapping( source = "C2C", target = MappingConstants.THROW_EXCEPTION )
    })
    ExternalOrderType orderTypeToExternalOrderType(OrderType orderType);
}
```

### Mapping enum-to-String or String-to-enum <a href="#mapping_enum_to_string_or_string_to_enum" id="mapping_enum_to_string_or_string_to_enum"></a>

MapStruct supports enum to a String mapping on the similar lines.

### Custom name transformation <a href="#custom_name_transformation" id="custom_name_transformation"></a>

As per documentation, when no `@ValueMapping`(s) are defined then each constant from the source enum is mapped to a constant with the same name in the target enum type. However, there are cases where the source enum needs to be transformed before doing the mapping. E.g. a suffix needs to be applied to map from the source into the target enum.

MapStruct provides the following enum name transformation strategies:

* _suffix_ - Applies a suffix on the source enum
* _stripSuffix_ - Strips a suffix from the source enum
* _prefix_ - Applies a prefix on the source enum
* _stripPrefix_ - Strips a prefix from the source enum
* _case_ - Applies case transformation to the source enum. Supported _case_ transformations are:
  * _upper_ - Performs upper case transformation to the source enum
  * _lower_ - Performs lower case transformation to the source enum
  * _capital_ - Performs capitalisation of the first character of every word in the source enum and everything else to lowercase. A word is split by "\_"\
    \






