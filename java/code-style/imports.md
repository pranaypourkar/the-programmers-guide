# Imports

## About

The **import statement** in Java allows one class to use classes and interfaces defined in other packages. While the functionality is straightforward, how imports are structured and managed greatly impacts **readability**, **maintainability**, and **consistency** in large codebases.

Even though IDEs can manage imports automatically, **establishing import conventions** ensures uniformity across developers and reduces unnecessary clutter, merge conflicts, and cognitive overhead during code reviews.

## Importance of Import Style

* **Improves Clarity:** Organized imports reflect dependencies clearly.
* **Reduces Noise:** Removes unused or redundant imports.
* **Prevents Wildcards:** Avoids namespace ambiguity caused by wildcard imports (`*`).
* **Maintains Consistency:** Team-wide formatting helps enforce clean imports.
* **Optimizes Version Control:** Prevents unnecessary diff churn from reordering or adding unrelated imports.

## General Import Best Practices

### 1. **Avoid Wildcard Imports**

Avoid using wildcard (`*`) imports like:

```java
import java.util.*;
import org.springframework.beans.factory.annotation.*;
```

**Why avoid:**

* Can lead to namespace clashes.
* Obscures what classes are actually used.
* Makes code less readable.
* Affects static analysis tools and IDE suggestions.

**Preferred:**

```java
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
```

Use specific imports even if importing multiple classes from the same package.

### 2. **Remove Unused Imports**

Remove imports that are not used in the class.

**Why:**

* Reduces noise and distraction.
* Prevents misleading assumptions about dependencies.
* Keeps diffs clean in version control.

Most IDEs (e.g., IntelliJ or Eclipse) have a shortcut for this (e.g., `Ctrl + Alt + O` in IntelliJ).

### 3. **Group Imports Logically**

Organize import statements into logical groups with blank lines between them:

1. **Java standard libraries** (`java.`, `javax.`)
2. **Third-party libraries** (e.g., `org.springframework`, `com.fasterxml.jackson`)
3. **Project-specific imports** (e.g., `com.mycompany`)

**Example:**

```java
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycompany.project.domain.User;
import com.mycompany.project.util.DateUtils;
```

This grouping helps quickly identify the origin of each dependency.

### 4. **Use Static Imports Sparingly**

Use static imports when they improve readability, such as in test assertions or constants.

```java
import static org.junit.jupiter.api.Assertions.assertEquals;
```

Avoid overusing static imports for utility methods or constants in business logic, as it can reduce code clarity and make it harder to trace origin.

### 5. **Order Imports Alphabetically Within Groups**

Within each group, order imports **alphabetically** to maintain consistency.

This makes it easier to spot duplicates and reduces confusion during merges.

### 6. **Use IDE Auto-Formatting Rules**

Set up our IDE to:

* Automatically optimize imports on save.
* Apply correct ordering and spacing.
* Prevent wildcard imports after a certain threshold (e.g., don’t collapse to `*` after 5 imports).

Example for IntelliJ IDEA:

* Disable "Use single class import with more than 5 classes".
* Enable "Optimize imports on save".
* Use custom import order (standard, third-party, internal).

### 7. **Don’t Import Unused Framework Modules**

Only import what we need. For instance:

```java
// Bad
import org.springframework.web.bind.annotation.*;
```

This pulls in all annotations, even if we only need one.

```java
// Good
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
```

## Example (Google Style Preference)

```java
package com.example.usermanagement.controller;

import java.time.LocalDate;
import java.util.List;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.usermanagement.dto.UserDto;
import com.example.usermanagement.service.UserService;
import com.example.usermanagement.util.DateUtils;
```

#### Observations:

1. **Standard Java imports** come first (`java.time`, `java.util`).
2. **`javax.*` validation annotations** follow.
3. **Third-party libraries**:
   * Swagger/OpenAPI annotations (`io.swagger.v3.oas.*`) are grouped and listed alphabetically.
   * Spring framework imports (`org.springframework.*`) come next.
4. **Project-specific (internal)** imports are last (`com.example.*`).
5. **No wildcard imports** — even with many classes from the same package.
