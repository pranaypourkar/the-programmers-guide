# Problems

## **Basic Problems**

### **Convert List to Uppercase**&#x20;

Given a `List<String>`, convert all elements to uppercase.

```java
List<String> strList = List.of("Apple", "banana", "Orange", "Avocado");
List<String> strListUpperCase = strList.stream().map(String::toUpperCase).toList();
```

### **Filter Even Numbers**

Given a `List<Integer>`, filter out only even numbers.

```java
List<Integer> intList = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
List<Integer> intListEven = intList.stream().filter(n -> n % 2 == 0).toList();
```

### **Count Strings Starting with ‘A’**&#x20;

Given a `List<String>`, count how many strings start with ‘A’.

<pre class="language-java"><code class="lang-java">List&#x3C;String> strList = List.of("Apple", "banana", "Orange", "Avocado");
<strong>long strListStartsWithA = strList.stream().filter(str -> str.startsWith("A")).count();
</strong></code></pre>

### **Find Maximum Number**

Find the maximum number in a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(3, 5, 7, 2, 8, 1);
Optional<Integer> max = numbers.stream().max(Integer::compare);
max.ifPresent(System.out::println);
```

### **Find Minimum Number**

Find the minimum number in a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(3, 5, 7, 2, 8, 1);
Optional<Integer> min = numbers.stream().min(Integer::compare);
min.ifPresent(System.out::println);
```

### **Calculate Sum**

Find the sum of all elements in a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(3, 5, 7, 2, 8, 1);
int sum = numbers.stream().mapToInt(Integer::intValue).sum();
```

### **Check if All Elements are Positive**

Verify if all numbers in a `List<Integer>` are positive.

```java
List<Integer> numbers = Arrays.asList(3, 5, 7, 2, 8, 1);
boolean allPositive = numbers.stream() .allMatch(n -> n > 0);
boolean isAllPositive = intList.stream().noneMatch(n -> n < 0);
```

### **Concatenate List of Strings**

Join all strings in a `List<String>` using a comma.

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
String concatenated = names.stream().collect(Collectors.joining(", "));
```

### **Sort a List**

Given a `List<Integer>`, sort it in ascending and descending order.

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
// Sort list in ascending order
List<Integer> sortedAscending = numbers.stream().sorted().collect(Collectors.toList());

// Sort list in descending order
List<Integer> sortedDescending = numbers.stream().sorted(Comparator.reverseOrder()).collect(Collectors.toList());
```

### **Remove Duplicates from List**

Remove duplicates from a `List<String>`.

```java
List<String> strList = List.of("Apple", "banana", "Orange", "Avocado");
List<String> distinctString = strList.stream().distinct().toList();
```

## **Intermediate Problems**

### **Find Second Highest Number**

Find the second-highest number in a `List<Integer>`.

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
Optional<Integer> secondHighest = numbers.stream()
                                         .distinct()
                                         .sorted(Comparator.reverseOrder())
                                         .skip(1)
                                         .findFirst();
```

### **Group Strings by Length**

Group a `List<String>` based on string length.

```java
List<String> strList = List.of("Apple", "Banana", "Kiwi", "Orange", "tomato");
Map<Integer, List<String>> map = strList.stream().collect(Collectors.groupingBy(String::length));
// {4=[Kiwi], 5=[Apple], 6=[Banana, Orange, tomato]}
```

### **Partition List into Even and Odd**

Partition a `List<Integer>` into even and odd numbers.

```java
List<Integer> intList = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
Map<Boolean, List<Integer>> map = intList.stream().collect(Collectors.partitioningBy(n -> n % 2 == 0));
// {false=[1, 3, 5, 7, 9], true=[2, 4, 6, 8, 10]}
```

### **Find First Non-Repeating Character**

Find the first non-repeating character in a `String`.

```java
String str = "swiss";

Optional<Character> firstNonRepeating = str.chars()
            .mapToObj(c -> (char) c)
            .collect(Collectors.groupingBy(c -> c, LinkedHashMap::new, Collectors.counting()))
            .entrySet().stream()
            .filter(entry -> entry.getValue() == 1)
            .map(Map.Entry::getKey)
            .findFirst();

System.out.println(firstNonRepeating.orElse(null));
```

### **Convert List of Strings to Map**

Convert a `List<String>` into a `Map<String, Integer>` where the key is the string and the value is its length.

```java
List<String> strList = List.of("Apple", "Banana", "Kiwi", "Orange", "tomato");
Map<String, Integer> map = strList.stream().collect(Collectors.toMap(str->str, String::length));
// {Apple=5, Kiwi=4, tomato=6, Orange=6, Banana=6}   
```

### **Find the Most Frequent Element**

Find the most frequently occurring element in a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(1, 3, 2, 3, 4, 1, 3, 2, 1, 1, 4, 1);

Optional<Integer> mostFrequent = numbers.stream()
            .collect(Collectors.groupingBy(n -> n, Collectors.counting())) // Count occurrences
            .entrySet().stream()
            .max(Map.Entry.comparingByValue()) // Find entry with max count
            .map(Map.Entry::getKey);

System.out.println(mostFrequent.orElse(null)); // 1
```

### **Find the First Three Elements**

Get the first three elements from a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(10, 20, 30, 40, 50);

List<Integer> firstThree = numbers.stream()
            .limit(3) // Take the first 3 elements
            .collect(Collectors.toList());

System.out.println(firstThree); // [10, 20, 30]
```

### **Find All Palindromes**

Find all palindrome words in a `List<String>`.

```java
List<String> words = Arrays.asList("madam", "apple", "racecar", "banana", "level", "hello");

List<String> palindromes = words.stream()
            .filter(word -> word.equalsIgnoreCase(new StringBuilder(word).reverse().toString())) // Check for palindrome
            .collect(Collectors.toList());

System.out.println(palindromes);
```

### **Sort Employees by Salary**

Given a `List<Employee>`, sort employees by salary in descending order.

```java
import java.util.*;
import java.util.stream.Collectors;

class Employee {
    private String name;
    private double salary;

    public Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    public String getName() {
        return name;
    }

    public double getSalary() {
        return salary;
    }

    @Override
    public String toString() {
        return name + " - $" + salary;
    }
}

public class SortEmployees {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 75000),
            new Employee("Bob", 50000),
            new Employee("Charlie", 90000),
            new Employee("David", 60000)
        );

        List<Employee> sortedEmployees = employees.stream()
            .sorted(Comparator.comparingDouble(Employee::getSalary).reversed()) // Sort by salary (descending)
            .collect(Collectors.toList());

        sortedEmployees.forEach(System.out::println);
    }
}
// Charlie - $90000.0
// Alice - $75000.0
// David - $60000.0
// Bob - $50000.0
```

### **Convert List of Strings to a Single String**

Convert a `List<String>` into a single space-separated `String`.

```java
List<String> words = Arrays.asList("Hello", "world", "Java", "Streams");

String result = words.stream()
        .collect(Collectors.joining(" ")); // Join with space
// Hello world Java Streams
```

## **Advanced Problems**

### **Find the Longest Word**

Find the longest word in a `List<String>`.

```java
List<String> words = Arrays.asList("apple", "banana", "strawberry", "kiwi", "pineapple");

Optional<String> longestWord = words.stream()
            .max((s1, s2) -> Integer.compare(s1.length(), s2.length())); // Compare by length

longestWord.ifPresent(System.out::println); // strawberry

String longestWord2 = words.stream()
    .max(Comparator.comparingInt(String::length))
    .orElse(null);
```

### **Find the Average Salary of Employees**

Given a `List<Employee>`, calculate the average salary.

```java
class Employee {
    private String name;
    private double salary;

    public Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    public double getSalary() {
        return salary;
    }
}

public class AverageSalary {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 50000),
            new Employee("Bob", 60000),
            new Employee("Charlie", 70000)
        );

        OptionalDouble avgSalary = employees.stream()
            .mapToDouble(Employee::getSalary) // Convert Employee to salary
            .average(); // Calculate average

        System.out.println(avgSalary.isPresent() ? avgSalary.getAsDouble() : "No employees found");
        // 60000.0
    }
}
```

### **Group Employees by Department**

Group employees into a `Map<String, List<Employee>>` based on department.

```java
import java.util.*;
import java.util.stream.Collectors;

class Employee {
    private String name;
    private int departmentId;

    public Employee(String name, int departmentId) {
        this.name = name;
        this.departmentId = departmentId;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    @Override
    public String toString() {
        return name;
    }
}

public class GroupByDepartment {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 1),
            new Employee("Bob", 2),
            new Employee("Charlie", 1),
            new Employee("David", 3),
            new Employee("Eve", 2)
        );

        // Group employees by department ID
        Map<Integer, List<Employee>> employeesByDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::getDepartmentId));

        // Print the grouped result
        employeesByDept.forEach((dept, empList) -> 
            System.out.println("Department " + dept + ": " + empList));
    }
}
// Department 1: [Alice, Charlie]
// Department 2: [Bob, Eve]
// Department 3: [David]
```

### **Find the Oldest Employee in Each Department**

Find the oldest employee in each department.

```java
import java.util.*;
import java.util.stream.Collectors;

class Employee {
    private String name;
    private int departmentId;
    private int age;

    public Employee(String name, int departmentId, int age) {
        this.name = name;
        this.departmentId = departmentId;
        this.age = age;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public int getAge() {
        return age;
    }

    @Override
    public String toString() {
        return name + " (Age: " + age + ")";
    }
}

public class OldestEmployeeInDepartment {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 1, 45),
            new Employee("Bob", 2, 30),
            new Employee("Charlie", 1, 50),
            new Employee("David", 3, 40),
            new Employee("Eve", 2, 35)
        );

        // Find the oldest employee in each department
        Map<Integer, Optional<Employee>> oldestByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartmentId, 
                Collectors.maxBy(Comparator.comparingInt(Employee::getAge))
            ));

        // Print the result
        oldestByDept.forEach((dept, emp) -> 
            System.out.println("Department " + dept + ": " + emp.orElse(null)));
    }
}
/*
Department 1: Charlie (Age: 50)
Department 2: Eve (Age: 35)
Department 3: David (Age: 40)
*/
```

### **Find Duplicate Elements in a List**

Find all duplicate elements in a `List<Integer>`.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 2, 6, 3, 7, 8, 1, 9, 10, 6);

Set<Integer> seen = new HashSet<>();
List<Integer> duplicates = numbers.stream()
    .filter(n -> !seen.add(n)) // If add() returns false, it's a duplicate
    .distinct() // Ensure each duplicate appears only once in the result
    .collect(Collectors.toList());

System.out.println(duplicates); // [1, 2, 3, 6]

// Approach 2 without set
List<Integer> duplicates = numbers.stream()
    .collect(Collectors.groupingBy(n -> n, Collectors.counting())) // Count occurrences of each number
    .entrySet().stream() // Convert the map to a stream
    .filter(entry -> entry.getValue() > 1) // Keep only elements with count > 1 (duplicates)
    .map(Map.Entry::getKey) // Extract the keys (the duplicate numbers)
    .toList(); // Collect as a List
```

### **Convert a List of Employees into a Map**

Convert `List<Employee>` into `Map<Integer, String>` where key is `employeeId` and value is `employeeName`.



### **Find the Youngest Employee**

Find the youngest employee in the company.

```java
Employee youngestEmployee = employees.stream()
    .min(Comparator.comparingInt(Employee::getAge)) // Find the employee with the minimum age
    .orElse(null); // Return null if the list is empty
```

### **Find the Longest and Shortest Words in a Sentence**

Given a sentence, find the longest and shortest words.



### **Find the Average Age of Employees by Department**

Compute the average age of employees per department.



### **Count the Occurrences of Each Character in a String**

Given a `String`, count occurrences of each character.

```java
String input = "banana";

Map<Character, Long> charCount = input.chars() // Convert String to IntStream of characters
    .mapToObj(c -> (char) c) // Convert int to Character
    .collect(Collectors.groupingBy(Function.identity(), Collectors.counting())); // Group and count occurrences

System.out.println(charCount); // {a=3, b=1, n=2}
```

### **Flatten a List of Lists**

Convert `List<List<Integer>>` into a flat `List<Integer>`.



### **Find Top 3 Highest Salaries**

Find the top 3 highest salaries from `List<Employee>`.



### **Convert a List of Objects to JSON String**

Convert `List<Employee>` into a JSON-like `String`.



### **Find All Employees Older Than 30 and Sort by Salary**

Find employees older than 30 and sort them by salary.



### **Find the Median Salary**

Compute the median salary from `List<Employee>`.



### **Sort a List of Employees by Multiple Criteria**

Sort `List<Employee>` first by department, then by salary.



### **Find the First N Prime Numbers**

Generate the first `N` prime numbers using `Stream.iterate()`.



### **Calculate Factorial Using Streams**

Compute factorial of `n` using `reduce()`.



### **Find Employees with the Longest Name**

Find all employees who have the longest name.



### **Check if a String is an Anagram of Another String**

Verify if two given strings are anagrams.



### **Find the Kth Largest Element in a List**

Find the `K`th largest number in a `List<Integer>`.



### **Generate a Fibonacci Series Using Streams**

Generate Fibonacci numbers using `Stream.iterate()`.



### **Find the Most Expensive Product in Each Category**

Given a `List<Product>`, find the most expensive product in each category.



### **Find Employees with More Than One Role**

Given `List<Employee>`, find employees who have multiple roles.



### **Find Most Common Words in a Paragraph**

Given a `String paragraph`, count occurrences of each word and sort by frequency.



### **Merge Two Sorted Lists into One Sorted List**

Merge two sorted lists into a single sorted list.



### **Check if a Sentence is a Pangram**

Verify if a sentence contains every letter of the alphabet at least once.



### **Find the Sum of All Even-Indexed Elements in a List**

Sum all even-indexed elements.



### **Find the Nth Root of a Number Using Streams**

Compute the `N`th root of a number using `Stream.iterate()`.



### **Simulate a Voting System Using Streams**

Given a list of votes, count occurrences of each candidate and determine the winner.

