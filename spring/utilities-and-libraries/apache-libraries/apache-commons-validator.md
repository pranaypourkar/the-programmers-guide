# Apache Commons Validator

## About

**Apache Commons Validator** is a library from the Apache Commons project that provides a simple and extensible framework for performing validation of data such as email addresses, URLs, dates, credit card numbers, and more.

It is often used in web applications to validate user input before processing or persisting it. The library includes a set of predefined validation routines and also supports defining custom validation rules using XML configuration.

## Maven Dependency

To use Apache Commons Validator in a Maven-based project, add the following dependency:

```xml
<dependency>
    <groupId>commons-validator</groupId>
    <artifactId>commons-validator</artifactId>
    <version>1.7</version>
</dependency>
```

## Key Packages and Classes

### `org.apache.commons.validator.routines`

This is the **most commonly used** package. It contains **ready-to-use, stateless utility classes** for validating strings, numbers, emails, dates, URLs, and more. These classes are thread-safe and do **not** require any XML configuration.

#### Commonly Used Classes:

**EmailValidator**

* Validates email address format.
* Supports domain name validation (including DNS MX record check if configured).

```java
EmailValidator validator = EmailValidator.getInstance();
boolean valid = validator.isValid("test@example.com");
```

**UrlValidator**

* Validates URLs with optional allowed schemes.

```java
UrlValidator validator = new UrlValidator(new String[] {"http", "https"});
boolean valid = validator.isValid("https://www.apache.org");
```

**DateValidator**

* Validates and parses date strings against a format.

```java
DateValidator validator = DateValidator.getInstance();
Date date = validator.validate("2024-06-21", "yyyy-MM-dd");
```

**RegexValidator**

* Allows custom validation using regular expressions.

```java
RegexValidator validator = new RegexValidator("^[a-z0-9]{6,12}$");
boolean valid = validator.isValid("abc123");
```

**CreditCardValidator**

* Validates major credit card numbers (Visa, MasterCard, Amex, Discover, etc.)

```java
CreditCardValidator validator = new CreditCardValidator();
boolean valid = validator.isValid("4111111111111111");
```

**IntegerValidator, LongValidator, DoubleValidator, FloatValidator**

* Validates numeric values in different types.

```java
IntegerValidator validator = IntegerValidator.getInstance();
Integer num = validator.validate("1234");
```

**DomainValidator**

* Validates domain names and top-level domains (TLDs).

```java
DomainValidator validator = DomainValidator.getInstance();
boolean valid = validator.isValid("example.com");
```

**IBANValidator**

* Validates International Bank Account Numbers.

```java
IBANValidator validator = IBANValidator.getInstance();
boolean valid = validator.isValid("GB82WEST12345698765432");
```

**ISBNValidator**

* Validates ISBN-10 and ISBN-13 numbers.

```java
ISBNValidator validator = new ISBNValidator();
boolean valid = validator.isValid("9780470059029");
```

**CodeValidator, CodeValidatorUtils**

* Utility classes for building custom format validators using ISO standards (e.g., for language, country codes).

### `org.apache.commons.validator`

This package includes the **original framework** for validation based on **XML configuration files**. It is designed to support reusable validation definitions and was commonly used with **Struts** and similar MVC frameworks.

#### Core Classes:

**Validator**

* The main class that runs validation checks.
* Takes in a `ValidatorResources` instance and a `ValidatorAction` definition.

**ValidatorResources**

* Loads and holds validation definitions from XML files (e.g., `validation.xml` and `validator-rules.xml`).
* Allows reusable, declarative validation configurations.

**ValidatorAction**

* Defines the actual validation logic and maps to a Java class/method.
* Each `ValidatorAction` represents a single rule (like required, email, minLength, etc.).

**Field**

* Represents a form field being validated.
* Has properties like `depends`, `page`, and `message`.

**Form**

* Represents a logical group of fields (usually a web form or DTO).

**ResultStatus, ValidatorResult**

* Used internally to represent whether a field passed or failed validation and what error message should be shown.

### `org.apache.commons.validator.util`

Utility package with supporting classes:

* **ValidatorUtils**
  * Contains helper methods for getting field values, trimming, etc.
* **Flags**
  * Utility to manage flags for composite validators (e.g., multiple options for `UrlValidator` or `CreditCardValidator`).





