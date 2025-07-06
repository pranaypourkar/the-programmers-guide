# Handle Null Value

## Scenario 1

We are working with the method chain:

```java
response.getSuccess().getAccounts().get(0).getId()
```

This is vulnerable to a `NullPointerException` if **any part of the chain** is `null` or the list is empty.

**Goal:** Return the result of `getId()` if all parts are non-null. If **any part is null** or the list is empty, return `""` (empty string).

### 1. **Classic Nested Null Checks**

This is the most straightforward and safe method.

```java
if (response != null &&
    response.getSuccess() != null &&
    response.getSuccess().getAccounts() != null &&
    !response.getSuccess().getAccounts().isEmpty() &&
    response.getSuccess().getAccounts().get(0) != null &&
    response.getSuccess().getAccounts().get(0).getId() != null) {
    
    return response.getSuccess().getAccounts().get(0).getId();
} else {
    return "";
}
```

* Safe and explicit
* Verbose but readable
* Recommended in core business logic when full control is needed

### 2. **Using `Optional` (Java 8+)**

This method is more concise and uses functional style.

```java
return Optional.ofNullable(response)
        .map(r -> r.getSuccess())
        .map(s -> s.getAccounts())
        .filter(accounts -> !accounts.isEmpty())
        .map(accounts -> accounts.get(0))
        .map(account -> account.getId())
        .orElse("");

return Optional.ofNullable(response)
        .map(Response::getSuccess)
        .map(Success::getAccounts)
        .flatMap(accounts -> accounts.stream().findFirst())
        .map(Account::getId)
        .orElse("");
```

* Null-safe
* Cleaner
* Useful for deep object trees
* May not be as readable to developers unfamiliar with functional chains

### 3. **Custom Helper Method**

Encapsulate the null-safe logic inside a method:

```java
public String getFirstAccountId(Response response) {
    if (response == null) return "";
    var success = response.getSuccess();
    if (success == null) return "";
    var accounts = success.getAccounts();
    if (accounts == null || accounts.isEmpty()) return "";
    var firstAccount = accounts.get(0);
    if (firstAccount == null || firstAccount.getId() == null) return "";
    return firstAccount.getId();
}
```

* Centralized
* Reusable
* Easy to unit test
* Keeps business code clean

### 4. **Using Try-Catch Block** _(Not Recommended)_

```java
try {
    return response.getSuccess().getAccounts().get(0).getId();
} catch (NullPointerException | IndexOutOfBoundsException e) {
    return "";
}
```

* Works, but poor style
* Exceptions should not be used for control flow
* Hides logic issues and makes debugging harder
* Slower at runtime due to exception overhead





