---
description: Overview of meta-annotation in Java.
---

# Meta Annotation

In Java, meta-annotations are annotations that can be applied to other annotations. These meta-annotations provide additional information about how the annotated annotation should be treated or processed.&#x20;

Here are some of commonly used meta-annotations in Java:

* **@Retention**: Indicates how long annotations with this type should be retained. The possible retention policies are SOURCE, CLASS, and RUNTIME.
* **@Target**: Specifies where the annotated annotation can be applied, such as METHOD, FIELD, TYPE, etc.
* **@Documented**: Indicates that annotations with this type should be included in the generated JavaDoc documentation.
* **@Inherited**: Specifies that the annotated annotation should be inherited by subclasses.
* **@Repeatable**: Allows an annotation to be applied multiple times to the same element.
* **@Native**: Indicates that the annotated annotation is implemented in a language other than Java.
* **@Deprecated**: Marks the annotated annotation as deprecated. Java recommends that in javadoc,  information should be provided for why this method is deprecated and what is the alternative to use.
* **@SuppressWarnings**: Suppresses compiler warnings for the annotated annotation. Usually used when using raw types in java generics.
