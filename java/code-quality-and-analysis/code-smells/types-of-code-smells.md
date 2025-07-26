# Types of Code Smells

## About

Code smells can be categorized based on the kind of problem they indicate whether it's structural, behavioral, or related to object-oriented misuse. Understanding these categories helps in identifying and addressing them systematically.

Here are the most common types of code smells -

## 1. **Bloaters**

These are code elements that have **grown too large or too complex**, making them hard to understand and maintain.

* **Long Method**: A method that does too much or spans too many lines.
* **Large Class**: A class that tries to handle too many responsibilities.
* **Long Parameter List**: Methods with too many parameters, reducing clarity.
* **Primitive Obsession**: Overuse of primitive types instead of small domain-specific objects.
* **Data Clumps**: Groupings of variables that often appear together but are not encapsulated.

{% hint style="success" %}
_Refactoring_: Extract method, introduce parameter object, replace primitives with objects.
{% endhint %}

## 2. **Object-Oriented Abusers**

These smells arise from **violations of object-oriented principles** such as encapsulation or inheritance.

* **Switch Statements**: Overuse of conditional logic instead of polymorphism.
* **Temporary Field**: Fields that are only sometimes used by an object.
* **Refused Bequest**: Subclass uses only some of the inherited methods or fields.
* **Alternative Classes with Different Interfaces**: Two classes that do similar things but have different method names.

{% hint style="success" %}
_Refactoring_: Replace conditionals with polymorphism, extract subclasses, apply interface standardization.
{% endhint %}

## 3. **Change Preventers**

These smells make code **hard to change or extend** due to tight coupling or scattering.

* **Divergent Change**: One class needs to change for many different reasons.
* **Shotgun Surgery**: A single change requires edits in many different classes.
* **Parallel Inheritance Hierarchies**: Whenever you create a subclass in one hierarchy, you must create a corresponding subclass in another.

{% hint style="success" %}
_Refactoring_: Move methods, collapse hierarchies, use delegation.
{% endhint %}

## 4. **Dispensables**

These are **unnecessary or redundant code elements** that clutter the codebase.

* **Duplicate Code**: Same logic appearing in multiple places.
* **Dead Code**: Code that is never executed or used.
* **Speculative Generality**: Code written for anticipated future use that never materializes.
* **Lazy Class**: Classes that are not doing enough to justify their existence.
* **Comments**: Overuse of comments in place of readable, self-explanatory code.

{% hint style="success" %}
_Refactoring_: Remove, inline, or simplify code; rename methods for clarity.
{% endhint %}

## 5. **Couplers**

These smells indicate **excessive dependencies between classes**, violating the principle of low coupling.

* **Feature Envy**: A method that uses more features of another class than its own.
* **Inappropriate Intimacy**: Classes that are too familiar with each other's internals.
* **Message Chains**: A client asks one object for another and so on — a chain of method calls.
* **Middle Man**: A class that delegates most of its functionality elsewhere.

{% hint style="success" %}
_Refactoring_: Move methods, hide delegate chains, use wrappers or facades.
{% endhint %}

## 6. **Concurrency Smells**

These arise when **multi-threaded code** is poorly structured:

* **Shared Mutable State**: Multiple threads accessing/modifying the same data unsafely.
* **Excessive Locking**: Unnecessary or broad synchronization that harms performance.
* **Deadlocks**: Circular dependencies in locks leading to blocked threads.

{% hint style="success" %}
_Refactoring_: Use immutability, fine-grained locking, thread-safe constructs.
{% endhint %}

## 7. **Architecture Smells**

These occur at a **higher level** than individual classes or methods.

* **Cyclic Dependencies**: Modules or packages depend on each other circularly.
* **God Object / God Class**: A class that knows too much or does too much.
* **Unstable Dependencies**: High-level modules depend on low-level ones that change frequently.

{% hint style="success" %}
_Refactoring_: Break cycles, extract services, enforce architectural boundaries.
{% endhint %}
