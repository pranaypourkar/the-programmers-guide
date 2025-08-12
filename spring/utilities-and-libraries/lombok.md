# Lombok

## About

Lombok is a Java library that helps reduce boilerplate code by providing annotations to generate getter/setter methods, constructors, logging and has many more features. Lombok integrates with popular IDEs like Eclipse, IntelliJ IDEA etc. to automate the code generation process.

## Maven Dependency

```xml
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <version>1.18.28</version>
  <scope>provided</scope>
</dependency>
```

{% hint style="success" %}
The scope attribute of a Maven dependency specifies when and where the dependency is required. The "provided" scope indicates that the dependency is only required to compile the source code, but not to run or deploy the application. Lombok JAR file is not included in the application's deployment package with this scope. This makes the deployment package smaller and easier to deploy.
{% endhint %}

{% hint style="info" %}
Refer to the official documentation for more details -

* [https://projectlombok.org/setup/maven](https://projectlombok.org/setup/maven)
* &#x20;[https://projectlombok.org/features/](https://projectlombok.org/features/)
{% endhint %}

## Annotations and Features provided

### AccessLevel

1. **PUBLIC**: This is the default access level. The generated code will have a public access modifier, allowing it to be accessed from anywhere.
2. **PROTECTED**: The generated code will have a protected access modifier. It can be accessed within the same package and subclasses in different packages.
3. **PACKAGE**: The generated code will have the default package-level access modifier. It can be accessed within the same package.
4. **PRIVATE**: The generated code will have a private access modifier. It can only be accessed within the same class.
5. **MODULE**: The generated code will have module-level access, which is available since Java 9. It can be accessed within the same module.
6. **NONE**: This value indicates that no access modifier should be generated for the code. This can be useful when we want to prevent Lombok from generating a specific method or field altogether.

### @AllArgsConstructor

With this annotation, Lombok generates a constructor that accepts arguments for all fields in the class including final fields.

* Constructor injection is a type of dependency injection in which the dependencies of a bean are injected into its constructor. This annotation can be useful for constructor injection, as it allows to specify all of the dependencies of the bean in the constructor.
* We can also exclude specific fields from being included as parameters in the generated constructor.
* Fields marked with @NonNull result in null checks on those parameters.
* Static fields are skipped by this annotation.
* More configuration details can be found on this page - [https://projectlombok.org/features/constructor](https://projectlombok.org/features/constructor)

```
@AllArgsConstructor(exclude = "field2")
```

_**Constructor Injection with the help of @AllArgsConstructor**_

Dependency1.java

```java
@Getter
@Setter
@AllArgsConstructor
public class Dependency1 {
    private String name;
}

```

Dependency2.java

```java
@Getter
@Setter
@AllArgsConstructor
public class Dependency2 {
    private String age;
}

```

SampleService.java

```java
@Service
@Slf4j
@AllArgsConstructor
public class SampleService {

    private Dependency1 dependency1;
    private Dependency2 dependency2;
    
    public void sampleClass() {
        log.info("Dependency1 -> {}", dependency1.getName());
        log.info("Dependency2 -> {}", dependency2.getAge());
    }
}
```

Application.java

```java
@SpringBootApplication
public class Application {
    public static void main(final String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(Application.class, args);

        SampleService sampleService = context.getBean(SampleService.class);
        sampleService.sampleClass();
    }
}
```

Logs

<figure><img src="https://static.wixstatic.com/media/5fb94b_e0fe4faebf974f3ca12327c1b73f7ceb~mv2.png/v1/fill/w_1480,h_88,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_e0fe4faebf974f3ca12327c1b73f7ceb~mv2.png" alt="ree"><figcaption></figcaption></figure>

### @RequiredArgsConstructor

This annotation generates a constructor with parameters for final fields or fields marked with @NonNull in a class.

* An explicit null check is also generated for @NonNull fields.
* The constructor will throw a NullPointerException if any of the parameters intended for the fields marked with @NonNull contain null.
* Static fields are skipped by these annotations.
* It is useful to create an immutable class and allow the initialization of only a subset of fields.
* It excludes any fields that are not marked as final or @NonNull.
* This annotation can be use for constructor injection as well and allows us to specify all of the dependencies of the bean in the constructor.
* More configuration details can be found on this page -[https://projectlombok.org/features/constructor](https://projectlombok.org/features/constructor)

```java
@RequiredArgsConstructor
public class Employee {
    private final String name;
    @NonNull
    private final String age;
}
```

```
Employee emp = new Employee("sss", "12");
```

### @Getter

Lombok generates standard getter methods following the JavaBeans naming convention "getFieldName()".

* @Getter can be use at the class level or field level. Class level setting is as if we annotate all the non-static fields in that class with the annotation. To make the @Getter works for the static fields, we have to annotate the static field.
* The generated getter method will be public unless we explicitly specify an AccessLevel. Legal access levels are PUBLIC, PROTECTED, PACKAGE, and PRIVATE and NONE.
* We can manually disable getter generation for any field by using the special AccessLevel.NONE access level
* Lombok can generate a lazily initialized getter method for a field with @Getter(lazy=true). It generate a getter which will calculate a value once, the first time this getter is called, and cache it from then on. This can be useful if calculating the value takes a lot of CPU, or the value takes a lot of memory. To use this feature, create a private final variable, initialize it with the expression that's expensive to run, and annotate our field with @Getter(lazy=true).
* More configuration details can be found on this page - [https://projectlombok.org/features/GetterSetter](https://projectlombok.org/features/GetterSetter) [https://projectlombok.org/features/GetterLazy](https://projectlombok.org/features/GetterLazy)

```java
@Getter
public class Sample {
    // Getter method available
    private int id;
    private final int privateFinalId;

    // Getter method not available outside this class
    private static int privateStaticId;

    // Getter method is public and available
    @Getter(AccessLevel.PUBLIC)
    private static int privateStaticPublicId;

    // Disable getter generation
    @Getter(AccessLevel.NONE)
    private int secret;

    // Getter method is not available outside this class 
    @Getter(AccessLevel.PRIVATE)
    private int privateField;
    
    // Lazy initialization
    @Getter(lazy=true) 
    private final double[] cached = expensive();
    
    private double[] expensive() {
        double[] result = new double[1000000];
        for (int i = 0; i < result.length; i++) {
            result[i] = Math.asin(i);
        }
        return result;
    }  
}
```

### @Setter

Lombok generates standard setter methods following the JavaBeans naming convention "setFieldName()".

* @Setter can be use at the class level or field level. Class level setting is as if we annotate all the non-static and non-final fields in that class with the annotation. To make the @Setter works for the static fields, we have to annotate the static field.
* Lombok does not generate setter methods for final fields. This behavior is intentional because final fields are meant to be immutable and their values should not be changed once set.
* The generated setter method will be public unless we explicitly specify an AccessLevel. Legal access levels are PUBLIC, PROTECTED, PACKAGE, and PRIVATE and NONE.
* We can manually disable setter generation for any field by using the special AccessLevel.NONE access level
* More configuration details can be found on this page - [https://projectlombok.org/features/GetterSetter](https://projectlombok.org/features/GetterSetter)

```java
    // Setter method available
    private int id;

    // Setter method not available as it is final
    private final int privateFinalId;

    // Setter method not available outside this class
    private static int privateStaticId;

    // Setter method is public and available
    @Setter(AccessLevel.PUBLIC)
    private static int privateStaticPublicId;

    // Disable setter method generation
    @Setter(AccessLevel.NONE)
    private int secret;

    // Setter method is not available outside this class 
    @Setter(AccessLevel.PRIVATE)
    private int privateField;
```

### @ToString

This annotation provided in Lombok generates a toString() method for a class, allowing to easily obtain a string representation of an object's state.

* We can exclude field names from the generated string using @ToString(includeFieldNames = false)
* We can exclude specific fields from the generated string using @ToString(exclude = "somefield") at the class level or can annotate these fields with @ToString.Exclude
* We can include only specific fields in the generated string using @ToString(of = {"somefield1", "somefield2"}) at the class level or by using @ToString(onlyExplicitlyIncluded = true) and then marking each field we want to include with @ToString.Include.
* By default, all non-static fields will be printed.
* We can change the name used to identify the member with @ToString.Include(name = "other name")
* We can change the order in which the members are printed via @ToString.Include(rank = -1). Members of a higher rank are printed first, and members of the same rank are printed in the same order they appear in the source file.
* More configuration details can be found on this page - [https://projectlombok.org/features/ToString](https://projectlombok.org/features/ToString)

```java
@ToString
public class Employee {
    private int id;
    private String name;
    private String address;
    private int age;
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_f0626f8c97b449feb213291e076e7a37~mv2.png/v1/fill/w_1480,h_34,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_f0626f8c97b449feb213291e076e7a37~mv2.png" alt="ree"><figcaption></figcaption></figure>

```java
@ToString(includeFieldNames = false)
public class Employee {
    private int id;
    private String name;
    private String address;
    private int age;
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_d2ba53f17bd44fe39f19fb78510f16b4~mv2.png/v1/fill/w_1480,h_34,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_d2ba53f17bd44fe39f19fb78510f16b4~mv2.png" alt="ree"><figcaption></figcaption></figure>

```java
@ToString(exclude = "name")
public class Employee {
    private int id;
    private String name;
    private String address;
    private int age;
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_c53d5ebcca1647898977e6e5cd1c1e65~mv2.png/v1/fill/w_1480,h_34,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_c53d5ebcca1647898977e6e5cd1c1e65~mv2.png" alt="ree"><figcaption></figcaption></figure>

```java
@ToString(of = {"id", "age"})
public class Employee {
    private int id;
    private String name;
    private String address;
    private int age;
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_8e3915c6a1834030933c4825e78f3544~mv2.png/v1/fill/w_1480,h_34,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_8e3915c6a1834030933c4825e78f3544~mv2.png" alt="ree"><figcaption></figcaption></figure>

### @EqualsAndHashCode

This annotation generates equals() and hashCode() methods for a class based on its fields. This helps reduce boilerplate code when implementing equality and hashing logic.

* To exclude specific fields from equality and hashing checks, use @EqualsAndHashCode(exclude = "somefield") at the class level.
* To include the superclass fields in equality and hashing checks, use @EqualsAndHashCode(callSuper = true)
* To include only specific fields in equality and hashing checks, use @EqualsAndHashCode(of = {"field1", "field2"}) at the class level
* By default, it'll use all non-static, non-transient fields, but we can modify which fields to use by marking type members/fields with @EqualsAndHashCode.Include or @EqualsAndHashCode.Exclude
* We can even specify exactly which fields or methods to be used by marking them with @EqualsAndHashCode.Include and using @EqualsAndHashCode(onlyExplicitlyIncluded = true)
* More configuration details can be found on this page - [https://projectlombok.org/features/EqualsAndHashCode](https://projectlombok.org/features/EqualsAndHashCode)

```java
@EqualsAndHashCode
public class Employee {
    private int id;
    private String name;
}
```

```java
// Create an employee object and another employee object with the same values as employee1
Employee employee1 = new Employee(3, "Carol");
Employee employee2 = new Employee(3, "Carol");
log.info("Is Employee 1 with hashcode - {} same as Employee 2                                 
    with hashcode - {} ?? {}", employee1.hashCode(), 
    employee2.hashCode(), employee1.equals(employee2));
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_e8a81b7b949247af8b3cb8e181329cfc~mv2.png/v1/fill/w_1480,h_114,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_e8a81b7b949247af8b3cb8e181329cfc~mv2.png" alt="ree"><figcaption></figcaption></figure>

### @Data

This annotation bundles the features of @ToString, @EqualsAndHashCode, @Getter, @Setter and @RequiredArgsConstructor together.

* All generated getters and setters will be public. To override the access level, annotate the field or class with an explicit @Setter and/or @Getter annotation.
* More configuration details can be found on this page - [https://projectlombok.org/features/Data](https://projectlombok.org/features/Data)

```java
@Data
public class Employee {
    private int id;
    private String name;
}
```

### @Builder

This annotation is used to generate a builder pattern for a class. The builder pattern provides a convenient way to create instances of a class with many optional fields.

* This can be placed on a class, or on a constructor, or on a method and will only consider non-static non-final fields.
* It can generate 'singular' methods for collection parameters/fields. It will take 1 element instead of an entire list, and add the element to the list. Note that the field/parameter needs to be annotated with @Singular. With the @Singular annotation, lombok will treat that builder node as a collection, and it generates 2 'adder' methods instead of a 'setter' method. One which adds a single element to the collection, and one which adds all elements of another collection to the collection.
* If a certain field/parameter is never set during a build session, then it always gets 0 / null / false. If we have put @Builder on a class (and not a method or constructor) we can specify the default directly on the field, and annotate the field with @Builder.Default:
* Applying @Builder to a class is as if we added @AllArgsConstructor(access = AccessLevel.PACKAGE) to the class and applied the @Builder annotation to this all-args-constructor. This only works if we haven't written any explicit constructors ourself.
* More configuration details can be found on this page - [https://projectlombok.org/features/Builder](https://projectlombok.org/features/Builder)

```java
@Builder
public class Employee {
    private int id;
    private String name;

    @NonNull
    private String requiredField;

    @Singular
    private List<String> optionalFields;

    @Builder.Default
    private boolean flag = true;
}
```

```java
Employee employee1 = Employee.builder()
                             .id(0)
                             .name("aaa")
                             .requiredField("qqq")
                             .optionalField("ww")
                             .optionalField("rr")
                             .build(); 
log.info(employee1.toString());
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_9750a08fb9214d03943864ab6155b54a~mv2.png/v1/fill/w_1480,h_114,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_9750a08fb9214d03943864ab6155b54a~mv2.png" alt="ree"><figcaption></figcaption></figure>

### @NonNull

This annotation is used to mark fields, method parameters, or local variables as non-null. It helps enforce null-safety in the code by generating null-checking code automatically.

* If @NonNull annotation is applied to the name field, Lombok will generate null-checking code in the constructor and setter method to ensure that the field is not assigned a null value.
* If @NonNull is applied to a method parameter, Lombok will generate null-checking code at the beginning of the method to ensure that the parameter is not null. If a null value is passed as an argument to a method with a @NonNull parameter, a NullPointerException will be thrown automatically.
* If @NonNull is used on the local variable, Lombok will generate a null-checking statement to ensure that the variable is not null before it is used. If a null value is assigned to a @NonNull local variable, a NullPointerException will be thrown automatically.
* For constructors, the null-check will be inserted immediately following any explicit this() or super() calls
* More configuration details can be found on this page - [https://projectlombok.org/features/NonNull](https://projectlombok.org/features/NonNull)

```java
public class TestClass {
    @NonNull
    private String name;
}
```

```java
public void processName(@NonNull String name) {
    // method implementation
}
```

```java
public void processName(String name) {
    @NonNull
    String processedName = Objects.requireNonNull(name);
    // use processedName variable
}
```

### val

val is used to declare a local variable as final, which means that it cannot be reassigned.

This works on local variables and on foreach loops only, not on fields. The initializer expression is required.

More configuration details can be found on this page - [https://projectlombok.org/features/val](https://projectlombok.org/features/val)

```java
public void sampleClass() {
        // `val` declares a final local variable.
        val name = "John Doe";
        log.info("val -> {}", name);
}
```

### var

var is used to declares a local variable as mutable, which means that it can be reassigned. var works exactly like val, except the local variable is not marked as final.

More configuration details can be found on this page - [https://projectlombok.org/features/var](https://projectlombok.org/features/var)

```java
public void sampleClass() {
        // `var` declares a mutable local variable.
        var age = 30;
        log.info("var -> {}", age);
}
```

{% hint style="warning" %}
Java introduced the _var_ keyword in version 10, which allows to declare local variables without specifying the type. The type of the variable is inferred from the initializer expression. If we are using Java 10 or later, prefer to use the built-in _var_ keyword provided by the Java language itself.
{% endhint %}

### @Cleanup

This annotation is used for automatically closing resources such as streams, readers, or connections after they are used. It helps to ensure proper resource management and avoids the need for manual cleanup code.

* We can use it with any local variable declaration to ensure a given resource is automatically cleaned up before the code execution path exits the current scope. For example, input.close() is called at the end of scope.

```java
@Cleanup FileInputStream input = new FileInputStream("example.txt");
```

* If the type of object to cleanup does not have a close() method, but some other no-argument method then we can specify the name of this method. For example

```java
@Cleanup("dispose") DummyStream xyz;
```

* More configuration details can be found on this page - [https://projectlombok.org/features/Cleanup](https://projectlombok.org/features/Cleanup)

```java
import lombok.Cleanup;

public class ResourceExample {
    public static void main(String[] args) {
        @Cleanup FileInputStream input = new FileInputStream("example.txt");
        byte[] buffer = new byte[1024];
        while (input.read(buffer) != -1) {
            // Process the data
        }
        // The input stream will be closed automatically
    }
}
```

### @Value

This annotation is used to create an immutable class with final fields, constructor, and getter methods. It simplifies the process of creating immutable classes by generating the necessary code for us.

* It is the immutable version of @Data. all fields are made private and final by default, and setters are not generated.
* It makes the class itself final by default.
* @Value includes final @ToString @EqualsAndHashCode @AllArgsConstructor @FieldDefaults(makeFinal = true, level = AccessLevel.PRIVATE) @Getter
* It is possible to override the final-by-default and private-by-default behavior using either an explicit access level on a field, or by using the @NonFinal or @PackagePrivate annotations. @NonFinal can also be used on a class to remove the final keyword.
* It is possible to override any default behavior for any of the 'parts' that make up @Value by explicitly using that annotation.
* More configuration details can be found on this page - [https://projectlombok.org/features/Value](https://projectlombok.org/features/Value)

```java
@Value
public class Employee {
    // Here, name is made final automatically
    private String name;

    private final String age;
}
```

```java
Employee emp = new Employee("sss", "12");
log.info(emp.getAge());
log.info(emp.getName());
```

### @SneakyThrows

This annotation is used to automatically throw checked exceptions without the need for explicit try-catch blocks or declaring the exceptions in the method signature. It simplifies exception handling by allowing us to throw checked exceptions as if they were unchecked.

* The code generated by lombok will not ignore, wrap, replace, or modify the thrown checked exception.
* It is difficult to use @SneakyThrows in combination with lambdas since lambdas cannot be annotated.
* We can pass any number of exceptions to the @SneakyThrows annotation. If no exceptions is passed then it may throw any exception.
* More configuration details can be found on this page - [https://projectlombok.org/features/SneakyThrows](https://projectlombok.org/features/SneakyThrows)

```java
import lombok.SneakyThrows;

public class SampleExceptionExample {
    @SneakyThrows
    public void throwException() {
        throw new Exception("Something went wrong");
    }
}
```

```java
import lombok.SneakyThrows;

public class SampleClassNotFoundExceptionExample {
    @SneakyThrows
    public void loadClass() {
        // No need to declare throws ClassNotFoundException on the method signature
        throw new ClassNotFoundException("Class not found");
    }
}
```

{% hint style="info" %}
\--> Some of the checked exceptions are listed below\
**IOException** - Thrown when an I/O operation encounters an error.\
**FileNotFoundException** - Thrown when attempting to access a file that does not exist.\
**ParseException** - Thrown when an error occurs while parsing a string into a specific data type.\
**ClassNotFoundException** - Thrown when a class is not found at runtime.\
**SQLException** - Thrown when an error occurs while interacting with a database.\
**NoSuchMethodException** - Thrown when attempting to access a method that does not exist.\
**IllegalAccessException** - Thrown when attempting to access a class or member that is not accessible due to access modifiers.\
**InstantiationException** - Thrown when an error occurs while creating an instance of a class using reflection.\
**InterruptedException** - Thrown when a thread is interrupted while it is waiting, sleeping, or otherwise occupied.\
**NoSuchFieldException** - Thrown when attempting to access a field that does not exist.\
**NumberFormatException** - Thrown when a string cannot be parsed into a numeric value.
{% endhint %}

### @Synchronized

This annotations is used to automatically add synchronization to a method or a block of code. It simplifies the process of adding thread-safe behavior by generating the necessary synchronization code.

* It is a safer variant of the synchronized method modifier as per Lombok.
* It can be used on static and instance methods only similar to synchronized.
* The synchronized keyword locks on this, but the annotation locks on a field named $lock which is private.
* If the field does not exist, it will be created automatically. If a static method is annotated, the annotation locks on a static field named $LOCK instead.
* More configuration details can be found on this page - [https://projectlombok.org/features/Synchronized](https://projectlombok.org/features/Synchronized)

```java
import lombok.Synchronized;

public class SampleSynchronizationExample {
    private final Object lock = new Object();

    @Synchronized
    public void synchronizedMethod() {
        // Thread-safe code here
    }
    
    @Synchronized
    public static void synchronizedMethod2() {
       // Thread-safe code here
    }

    public void nonSynchronizedMethod() {
        synchronized (lock) {
            // Thread-safe code here
        }
    }
}
```

```java
public class Application {
    public static void main(String[] args) {
        SampleSynchronizationExample example = new SampleSynchronizationExample();

        Runnable runnable = () -> {
            example.synchronizedMethod();
            // or
            example.synchronizedMethod2();
            // or
            example.nonSynchronizedMethod();
        };

        Thread thread1 = new Thread(runnable);
        Thread thread2 = new Thread(runnable);

        thread1.start();
        thread2.start();
    }
}

```

### @With

This annotation is used to create a temporary object that can be used to access the fields and methods of another object. The temporary object is created using the _with_ method, which takes the object as an argument.

* The @With relies on a constructor for all fields in order to work otherwise it may result in compiler time error.
* It can be useful when we need to access the fields and methods of an object without creating a new object. Also to perform a short-lived operation on the object, or to access the object from a different thread.
* Use the @With annotation on the fields where we want to generate the withX() methods.
* More configuration details can be found on this page - [https://projectlombok.org/features/With](https://projectlombok.org/features/With)

```java
@Value
public class Employee {
    @With private String name;
    private String age;
}
```

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(final String[] args) {
        SpringApplication.run(Application.class, args);

        Employee emp = new Employee("sss", "12");
        log.info("emp age -> {}", emp.getAge());
        log.info("emp name -> {}", emp.getName());

        Employee emp2 = emp.withName("ppp");
        log.info("emp2 age -> {}", emp2.getAge());
        log.info("emp2 name -> {}", emp2.getName());
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_6ab9c1a67a70489fb77533e6e61e3662~mv2.png/v1/fill/w_1480,h_144,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_6ab9c1a67a70489fb77533e6e61e3662~mv2.png" alt="ree"><figcaption></figcaption></figure>

### @Log

This annotation is used to automatically generate a logger field for a class. It simplifies the process of adding logging to our code by generating the necessary logger initialization code for us. There are several choices available. @Slf4j is one of the choice which is commonly used.

More configuration details can be found on this page - [https://projectlombok.org/features/log](https://projectlombok.org/features/log)

```java
@Slf4j
@SpringBootApplication
public class Application {
    public static void main(final String[] args) {
        SpringApplication.run(Application.class, args);

        Employee emp = new Employee("sss", "12");
        log.info("emp age -> {}", emp.getAge());
        log.info("emp name -> {}", emp.getName());
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_075beedac9e044b9ae45462b5fd69d16~mv2.png/v1/fill/w_1480,h_110,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_075beedac9e044b9ae45462b5fd69d16~mv2.png" alt="ree"><figcaption></figcaption></figure>

## Lombok configuration via lombok.config file

We can have additional configuration through lombok.config file and place the file in the base directory of the project. Some of the configuration are listed below.

<figure><img src="https://static.wixstatic.com/media/5fb94b_f0d462caf5cc4eeb9fe7506db34e96ef~mv2.png/v1/fill/w_769,h_542,al_c,lg_1,q_90,enc_avif,quality_auto/5fb94b_f0d462caf5cc4eeb9fe7506db34e96ef~mv2.png" alt="ree" width="375"><figcaption></figcaption></figure>

{% file src="../../.gitbook/assets/lombok.config.zip" %}

```
lombok.copyableAnnotations += org.springframework.beans.factory.annotation.Qualifier
lombok.copyableAnnotations += org.springframework.beans.factory.annotation.Value
```

This config allows Lombok to copy the @Qualifier annotation from the instance variables to the constructor. The @Qualifier annotation is used in Spring to resolve bean dependencies by specifying the bean's qualifier or name.

When generating constructors using Lombok annotations like @AllArgsConstructor or @RequiredArgsConstructor, Lombok will replicate the @Qualifier annotation from the instance variables to the corresponding constructor parameters.

Below class has a field annotated with @Qualifier

```java
import org.springframework.beans.factory.annotation.Qualifier;

public class SampleClass {
    @Qualifier("sampleBean")
    private SampleDependency sampleDependency;
    // ...
}
```

If we define a constructor using @AllArgsConstructor, Lombok will copy the @Qualifier annotation to the constructor parameter:

```java
import org.springframework.beans.factory.annotation.Qualifier;
import lombok.AllArgsConstructor;

@AllArgsConstructor
public class SampleClass {
    @Qualifier("sampleBean")
    private SampleDependency sampleDependency;
    // ...

    public SampleClass(@Qualifier("sampleBean") SampleDependency sampleDependency) {
        this.sampleDependency = sampleDependency;
    }
}
```

This will ensure that @Qualifier annotation is retained on both the field and the constructor parameter.

Same is the case with @Value annotation which is used to inject values into Spring-managed beans.
