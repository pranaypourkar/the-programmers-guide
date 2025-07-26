# Use Case

## 1. Custom Card Type annotation for ParameterizedTest tests

We currently have **repeated test methods** like this:

```java
@ParameterizedTest
@CsvSource(value = {
    "debit",     // for prepaid card
    "null"         // default/optional case
}, nullValues = {"null"})
void testCardType(String cardType) {
    // test logic
}
```

We want to avoid repeating the boilerplate and allow:

* a single custom annotation
* configurable `cardType` values via the annotation

#### Solution

Define a Custom Annotation

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@ParameterizedTest
@CsvSource(value = {
    "debit",
    "null"
}, nullValues = {"null"})
public @interface CardTypeTest {
}
```

We can now use

```java
@CardTypeTest
void testCardType(String cardType) {
    // test logic
}
```
