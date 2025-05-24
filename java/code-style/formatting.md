# Formatting

## About

Code formatting refers to the **visual layout** and **structuring of source code**—including indentation, line breaks, spacing, and alignment. Proper formatting makes the code more **consistent**, **readable**, and **maintainable**, especially in collaborative environments. Unlike naming or logic, formatting does not affect the behaviour of the code but heavily influences developer productivity and code review efficiency.

Most modern Java teams enforce formatting rules using tools like **Checkstyle**, **Spotless**, or **EditorConfig**, and integrate them with CI pipelines and IDEs.

## Importance of Consistent Formatting

* **Improves Readability:** Well-formatted code is easier to understand, especially for new team members.
* **Enhances Maintainability:** Reduces the mental overhead during code reviews and bug fixing.
* **Minimizes Diff Noise:** With consistent formatting, version control diffs show meaningful changes.
* **Supports Automation:** Code formatting can be enforced and auto-corrected using tools.
* **Facilitates Team Collaboration:** Everyone adheres to the same layout, preventing formatting debates.

## General Formatting Guidelines for Java

### 1. **Indentation**

* Use **4 spaces** per indentation level (not tabs).
* Avoid deep nesting; prefer early returns or method extraction.

{% hint style="info" %}
**Rationale:** Proper indentation helps visualize control flow and block scope, making it easier to trace logic, especially when dealing with deeply nested conditions, loops, or exception handling.
{% endhint %}

```java
// Good
if (isValid(user)) {
    userService.save(user);
}
```

### 2. **Line Length**

* Limit lines to **120 characters** maximum.
* Break long method calls, parameter lists, or chains onto multiple lines.

{% hint style="info" %}
**Rationale:** Readability drops significantly when lines exceed typical screen width. Shorter lines also reduce cognitive load during code review.
{% endhint %}

```java
// Good
userService.processUserDetails(userId, name, email, mobileNumber, address, countryCode);
```

### 3. **Braces and Blocks**

*   Always use **curly braces `{}`**, even for single-line `if`, `for`, or `while` blocks.&#x20;

    This avoids common bugs during future modifications and aligns with safety-oriented style guides like Google’s and Oracle’s.

{% hint style="info" %}
**Rationale:** Omitting braces increases the likelihood of errors when future developers insert additional statements. It also reduces clarity during code reviews.
{% endhint %}

```java
// Good
if (user != null) {
    log.info("User exists");
}

// Not recommended
if (user.isActive())
    sendNotification(user);
```

### 4. **Spacing**

* Add a **space** after `if`, `for`, `while`, `catch`, etc.
* Add **spaces around operators**: `=`, `+`, `-`, `==`, etc.
* No space between method name and opening bracket.

{% hint style="info" %}
**Rationale:** Proper spacing helps visually separate tokens and improves scanning efficiency for human readers.
{% endhint %}

```java
// Good
if (user == null) {
    return;
}

int total = value + tax;
userService.process(user);

// Avoid
if(value==10){
    result=value+1;
}
```

### 5. **Blank Lines**

*   Use blank lines intentionally to separate logical blocks and improve visual organization. For example:

    * Between fields and methods.
    * Between different logical operations inside methods.
    * Before `return` statements (optional but recommended for clarity).

    Avoid excessive blank lines that add visual clutter without adding structure.

{% hint style="info" %}
**Rationale:** Blank lines provide a visual pause, helping readers digest code in segments.
{% endhint %}

```java
public void validateUser() {
    if (user == null) {
        throw new ValidationException("User is required.");
    }

    if (!user.isActive()) {
        throw new ValidationException("User must be active.");
    }
}
```

### 6. **Annotations**

* Place annotations on a separate line above the element they annotate.

{% hint style="info" %}
**Rationale:** Improves visibility and makes it easy to scan for annotations like `@Transactional`, `@Autowired`, or `@Deprecated`.
{% endhint %}

```java
// Good
@Override
public void run() {
    // ...
}
```

### 7. **Chained Calls**

* Break chained method calls onto new lines if they exceed line limit.
* Break long chains of method calls (common in builders or stream APIs) onto multiple lines. Each chained method should begin on a new line and be aligned for clarity.

{% hint style="info" %}
**Rationale:** Improves readability and debugging. Readers can follow each step of the transformation or action.
{% endhint %}

```java
// Good
userRepository.findById(userId)
    .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
builder.setName("John")
       .setAge(30)
       .setEmail("john@example.com");

return userRepository.findByEmail(email)
    .map(this::mapToDto)
    .orElseThrow(() -> new NotFoundException("User not found"));
```

### 8. **Method Parameters**

* If a method has more than 3–4 parameters or the method signature exceeds the line length, split each parameter into a new line, indented under the opening parenthesis.

{% hint style="info" %}
**Rationale:** Clearly presents what inputs a method takes and avoids horizontal scrolling. Also makes version control diffs cleaner.
{% endhint %}

```java
// Good
public void sendEmail(
    String recipient,
    String subject,
    String message,
    boolean isHtml
) {
    // ...
}
```

### 9. **Imports**

* Imports should be ordered in the following groupings, each separated by a blank line:

1. Standard Java imports (e.g., `java.util.*`, `java.io.*`)
2. Third-party library imports (e.g., `org.springframework.*`, `com.fasterxml.*`)
3. Internal application imports (e.g., `com.company.project.*`)

* Avoid wildcard imports (`import java.util.*`) and unused imports.

{% hint style="info" %}
**Rationale:** Ordered and clean imports reduce noise and make it easier to trace dependencies.
{% endhint %}

```java
// Good
// 1. Standard Java imports
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

// 2. Third-party library imports
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// 3. Internal project/application imports
import com.example.user.dto.UserDto;
import com.example.user.service.UserService;
import com.example.user.util.DateUtils;
```

```java
// Bad
import java.util.*;
import org.springframework.web.bind.annotation.*;
import com.example.user.service.*;
import java.io.*;
```

### 10. **Comments**

* Use comments to explain **why**, not **what**—the code should be self-explanatory for the what.
* Use complete sentences, proper punctuation, and clear English.
* Prefer block comments above methods or complex logic.
* Avoid excessive commenting. If the code is self-explanatory, no comment is needed.
* Remove outdated or misleading comments. Outdated comments are worse than none.
* Don't Comment Out Large Code Blocks. Use version control (e.g., Git) to track removed code instead of leaving large blocks of commented code.

{% hint style="info" %}
**Rationale:** Clear and relevant comments aid maintainability and serve as documentation. Poor or incorrect comments do more harm than good.
{% endhint %}

```java
// Bad: no context
// Check user

// age check
if (user.getAge() < 18) {
    // throw
    throw new ValidationException("...");
}

// Check if the error is authentication failure
if (errorCode == AUTH_FAILURE) {
    return;
}

// Good
// Validate if user meets eligibility criteria before proceeding.

// Validate that the user is over 18 before allowing registration
if (user.getAge() < 18) {
    throw new ValidationException("Minimum age is 18");
}

// Avoid retrying if the error is related to authentication
if (errorCode == AUTH_FAILURE) {
    return;
}
```

```java
// Good
// Single-Line Comments
// Skip inactive users from processing
if (!user.isActive()) {
    continue;
}

// Multi-Line / Block Comments
/*
 This block initializes the default users when
 the application starts in development mode.
 */
if (env.equals("dev")) {
    initDefaultUsers();
}

// Javadoc Comments
/**
 * Calculates the total salary after tax.
 *
 * @param baseSalary The base salary amount
 * @param taxRate The tax rate as a percentage
 * @return The net salary after tax deduction
 */
public double calculateSalary(double baseSalary, double taxRate) {
    return baseSalary - (baseSalary * taxRate / 100);
}
```
