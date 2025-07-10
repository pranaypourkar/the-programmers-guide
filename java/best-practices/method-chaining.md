# Method Chaining

#### 1. We have two versions of a method that checks conditions on a deeply nested object structure.

**Version 1: Repeated method chains**

```java
private boolean isRequestNotValidated(PaymentValidationRequest paymentValidationRequest) {
    return paymentValidationRequest.getPayment().getPaymentType().equals(TRANSFER)
        &&
        paymentValidationRequest.getPayment().getTransferTransactionInformation().getAdditions()
            .get(SESSION_ID)
            == null
        && !hashGenerator.generateValidationHash(requestDataUtils.getShortCIF()).equals(
        paymentValidationRequest.getPayment().getTransferTransactionInformation().getAdditions()
            .get(VALIDATION_HASH));
}
```

**Version 2: Intermediate variable for reuse**

```java
private boolean isRequestNotValidated(PaymentValidationRequest paymentValidationRequest) {
    var additions = paymentValidationRequest.getPayment().getTransferTransactionInformation().getAdditions();

    return paymentValidationRequest.getPayment().getPaymentType().equals(TRANSFER)
        &&
        additions.get(SESSION_ID) == null
        && !hashGenerator.generateValidationHash(requestDataUtils.getShortCIF()).equals(
        additions.get(VALIDATION_HASH));
}
```

**Version 2 is better** for the following reasons:

#### **1. Readability**

* Extracting intermediate results (`additions`) improves readability and reduces mental load.
* Readers only need to understand the logic of the condition, not how it’s fetched every time.

#### **2. Maintainability**

* If the method chain changes, we only have to update it in one place.
* Prevents errors from inconsistent calls.

#### **3. Performance**

* **No noticeable performance difference** in most cases.
* JVM performs **common subexpression elimination** and **method inlining** during Just-In-Time (JIT) compilation.
* Repeated chains may result in slightly more bytecode but won’t affect runtime efficiency significantly — **if the getter methods are cheap** (simple field accesses).

**But** if:

* The getters are doing more than returning a value (e.g., performing logic or expensive computation),
* Or they involve **reflection**, **network calls**, or **dynamic proxies** (common in some frameworks),

Then **repeated calls could degrade performance**.

So while JVM _might_ optimize it, **don't depend on it for correctness or speed** — extracting to a variable is the cleaner and safer approach.

#### **Null Safety**

With repeated method calls, it’s easy to accidentally get a `NullPointerException` if any level in the chain is null.

Extracting intermediate variables allows:

* Easier null-checks
* Optional usage
* Better error messages and logging

