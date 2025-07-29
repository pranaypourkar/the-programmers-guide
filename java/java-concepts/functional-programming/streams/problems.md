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
// Using Collectors utility
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
String concatenated = names.stream().collect(Collectors.joining(", "));

// Using Reduce
List<String> words = List.of("Java", "is", "powerful");
String sentence = words.stream()
                .reduce((a, b) -> a + ", " + b)
                .orElse("");
System.out.println(sentence); // Java is powerful
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

```java
Map<Integer, String> employeeMap = employees.stream()
    .collect(Collectors.toMap(Employee::getId, Employee::getName));

System.out.println(employeeMap); // {101=Alice, 102=Bob, 103=Charlie}
```

### **Find the Youngest Employee**

Find the youngest employee in the company.

```java
Employee youngestEmployee = employees.stream()
    .min(Comparator.comparingInt(Employee::getAge)) // Find the employee with the minimum age
    .orElse(null); // Return null if the list is empty
```

### **Find the Longest and Shortest Words in a Sentence**

Given a sentence, find the longest and shortest words.

```java
String sentence = "Java Streams are powerful and concise";

String max = Arrays.stream(sentence.split(" "))
    .max(Comparator.comparingInt(String::length))
    .get();

String min = Arrays.stream(sentence.split(" "))
    .min(Comparator.comparingInt(String::length))
    .get();

System.out.println("Longest Word: " + max); //Longest Word: powerful
System.out.println("Shortest Word: " + min); //Shortest Word: are
```

### **Find the Average Age of Employees by Department**

Compute the average age of employees per department.

```java
Map<Integer, Double> avgAgePerDepartment = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartmentId, 
        Collectors.averagingInt(Employee::getAge)
    ));
```

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

```java
List<Integer> flatList = nestedList.stream()
    .flatMap(List::stream)
    .toList();

System.out.println(flatList);
```

### **Find Top 3 Highest Salaries**

Find the top 3 highest salaries from `List<Employee>`.

```java
List<Employee> topSalaries = employees.stream()
    .sorted(Comparator.comparingDouble(Employee::getSalary).reversed()) // Sort by salary in descending order
    .limit(3) // Get top 3
    .toList();
```

### **Convert a List of Objects to JSON String**

Convert `List<Employee>` into a JSON-like `String`.

```java
class Employee {
    private final String name;
    private final double salary;

    public Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    public String toJson() {
        return String.format("{\"name\":\"%s\", \"salary\":%.2f}", name, salary);
    }
}

public class EmployeeJsonConverter {
    public static void main(String[] args) {
        List<Employee> employees = List.of(
            new Employee("Alice", 50000),
            new Employee("Bob", 60000),
            new Employee("Charlie", 70000)
        );

        String json = employees.stream()
            .map(Employee::toJson)
            .collect(Collectors.joining(", ", "[", "]"));

        System.out.println(json);
        // [{"name":"Alice", "salary":50000.00}, {"name":"Bob", "salary":60000.00}, {"name":"Charlie", "salary":70000.00}]
    }
}
```

### **Find All Employees Older Than 30 and Sort by Salary**

Find employees older than 30 and sort them by salary.

```java
List<Employee> filteredEmployees = employees.stream()
    .filter(emp -> emp.getAge() > 30) // Filter employees older than 30
    .sorted(Comparator.comparingDouble(Employee::getSalary)) // Sort by salary in ascending order
    .toList();
```

### **Find the Median Salary**

Compute the median salary from `List<Employee>`.

```java
OptionalDouble median = employees.stream()
    .mapToDouble(Employee::getSalary)
    .sorted()
    .skip((employees.size() - 1) / 2) // Skip first half for odd/even cases
    .limit(2 - employees.size() % 2) // Take 1 element if odd, 2 if even
    .average(); // Compute median
```

### **Sort a List of Employees by Multiple Criteria**

Sort `List<Employee>` first by department, then by salary.

```java
import java.util.*;
import java.util.stream.Collectors;

class Employee {
    String name;
    String department;
    double salary;

    public Employee(String name, String department, double salary) {
        this.name = name;
        this.department = department;
        this.salary = salary;
    }

    @Override
    public String toString() {
        return name + " (" + department + ", $" + salary + ")";
    }
}

public class EmployeeSorting {
    public static void main(String[] args) {
        List<Employee> employees = List.of(
                new Employee("Alice", "HR", 60000),
                new Employee("Bob", "IT", 75000),
                new Employee("Charlie", "IT", 72000),
                new Employee("David", "HR", 55000),
                new Employee("Eve", "Finance", 90000),
                new Employee("Frank", "Finance", 85000)
        );

        // Sorting using streams
        List<Employee> sortedEmployees = employees.stream()
                .sorted(Comparator.comparing(Employee::department)
                        .thenComparing(Employee::salary))
                .collect(Collectors.toList());

        // Print sorted employees
        sortedEmployees.forEach(System.out::println);
        // Output:
        // Frank (Finance, $85000.0)
        // Eve (Finance, $90000.0)
        // David (HR, $55000.0)
        // Alice (HR, $60000.0)
        // Charlie (IT, $72000.0)
        // Bob (IT, $75000.0)
    }
}
```

### **Find the First N Prime Numbers**

Generate the first `N` prime numbers using `Stream.iterate()`.

```java
import java.util.List;
import java.util.stream.Stream;

public class PrimeNumbersUsingStream {
    public static void main(String[] args) {
        int N = 10; // Change N to get more primes

        List<Integer> primes = Stream.iterate(2, i -> i + 1)  // Start from 2, increment by 1
                .filter(PrimeNumbersUsingStream::isPrime)      // Keep only prime numbers
                .limit(N)                                      // Take the first N primes
                .toList();                                     // Collect to a List (Java 16+)

        System.out.println("First " + N + " prime numbers: " + primes);
        // Output: First 10 prime numbers: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    }

    // Method to check if a number is prime
    private static boolean isPrime(int num) {
        if (num < 2) return false;
        for (int i = 2; i <= Math.sqrt(num); i++) {
            if (num % i == 0) return false;
        }
        return true;
    }
}
```

### **Calculate Factorial Using Streams**

Compute factorial of `n` using `reduce()`.

```java
int n = 5; // Change this value to compute factorial of a different number

int factorial = IntStream.rangeClosed(1, n) // Generates numbers from 1 to n
    .reduce(1, (a, b) -> a * b);        // Multiplies all elements

System.out.println("Factorial of " + n + " is: " + factorial);
// Output: Factorial of 5 is: 120
```

### **Check if a String is an Anagram of Another String**

Verify if two given strings are anagrams.

```java
import java.util.stream.Collectors;

public class AnagramChecker {
    public static void main(String[] args) {
        String str1 = "listen";
        String str2 = "silent";

        boolean isAnagram = areAnagrams(str1, str2);

        System.out.println(str1 + " and " + str2 + " are anagrams: " + isAnagram);
        // Output: listen and silent are anagrams: true
    }

    public static boolean areAnagrams(String str1, String str2) {
        if (str1.length() != str2.length()) return false; // Different lengths can't be anagrams

        return str1.chars().sorted()
                .mapToObj(c -> String.valueOf((char) c))
                .collect(Collectors.joining())
                .equals(
                    str2.chars().sorted()
                        .mapToObj(c -> String.valueOf((char) c))
                        .collect(Collectors.joining())
                );
    }
}
```

### **Find the Kth Largest Element in a List**

Find the `K`th largest number in a `List<Integer>`.

```java
List<Integer> numbers = List.of(10, 5, 8, 20, 15, 3, 25);
int K = 3; // Change K to find a different Kth largest element

int kthLargest = numbers.stream()
                .sorted(Comparator.reverseOrder()) // Sort in descending order
                .skip(K - 1)                       // Skip (K-1) elements
                .findFirst()                       // Get the Kth element
                .orElseThrow(() -> new IllegalArgumentException("K is out of range"));
```

### **Generate a Fibonacci Series Using Streams**

Generate Fibonacci numbers using `Stream.iterate()`.

```java
int n = 10; // Generate first N Fibonacci numbers

Stream.iterate(new long[]{0, 1}, fib -> new long[]{fib[1], fib[0] + fib[1]}) // Generate pairs
  .limit(n) // Limit to first N numbers
  .map(fib -> fib[0]) // Extract first element from pair
  .forEach(System.out::println);

// Output: 0 1 1 2 3 5 8 13 21 34
```

### **Find the Most Expensive Product in Each Category**

Given a `List<Product>`, find the most expensive product in each category.

```java
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

class Product {
    String name;
    String category;
    double price;

    public Product(String name, String category, double price) {
        this.name = name;
        this.category = category;
        this.price = price;
    }

    @Override
    public String toString() {
        return name + " ($" + price + ")";
    }
}

public class MostExpensiveProduct {
    public static void main(String[] args) {
        List<Product> products = List.of(
                new Product("Laptop", "Electronics", 1200),
                new Product("Smartphone", "Electronics", 900),
                new Product("TV", "Electronics", 1500),
                new Product("Blender", "Appliances", 300),
                new Product("Vacuum Cleaner", "Appliances", 400),
                new Product("Shampoo", "Personal Care", 15),
                new Product("Perfume", "Personal Care", 60)
        );

        Map<String, Product> mostExpensiveByCategory = products.stream()
                .collect(Collectors.toMap(
                        Product::category,                  // Group by category
                        Function.identity(),                // Keep the product
                        (p1, p2) -> p1.price > p2.price ? p1 : p2 // Keep the most expensive
                ));

        System.out.println("Most Expensive Product in Each Category: " + mostExpensiveByCategory);
        // Output: {Electronics=TV ($1500.0), Appliances=Vacuum Cleaner ($400.0), Personal Care=Perfume ($60.0)}
    }
}
```

### **Find Most Common Words in a Paragraph**

Given a `String paragraph`, count occurrences of each word and sort by frequency.

```java
String paragraph = "Java is great and Java is powerful. Java is fun and powerful.";

List<Map.Entry<String, Long>> sortedWordCount = Arrays.stream(paragraph.toLowerCase().split("\\W+"))
  .collect(Collectors.groupingBy(word -> word, Collectors.counting())) // Count occurrences
  .entrySet().stream()
  .sorted(Map.Entry.<String, Long>comparingByValue(Comparator.reverseOrder())) // Sort by frequency
  .toList(); // Collect as a list

System.out.println("Word frequencies sorted by count: " + sortedWordCount);
// Output: Word frequencies sorted by count: [java=3, is=3, powerful=2, and=2, great=1, fun=1]
```

### **Merge Two Sorted Lists into One Sorted List**

Merge two sorted lists into a single sorted list.

```java
List<Integer> list1 = List.of(1, 3, 5, 7, 9);
List<Integer> list2 = List.of(2, 4, 6, 8, 10);

List<Integer> mergedSortedList = Stream.concat(list1.stream(), list2.stream()) // Merge two lists
  .sorted() // Sort the merged stream
  .collect(Collectors.toList()); // Collect to a list

System.out.println("Merged Sorted List: " + mergedSortedList);
// Output: Merged Sorted List: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

### **Check if a Sentence is a Pangram**

Verify if a sentence contains every letter of the alphabet at least once.

```java
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class PangramChecker {
    public static void main(String[] args) {
        String sentence = "The quick brown fox jumps over the lazy dog";

        boolean isPangram = sentence.toLowerCase()
                .chars() // Convert to IntStream of characters
                .filter(Character::isLetter) // Keep only letters
                .mapToObj(c -> (char) c) // Convert int to Character
                .collect(Collectors.toSet()) // Collect unique letters
                .size() == 26; // Check if all 26 letters are present

        System.out.println("Is Pangram? " + isPangram);
        // Output: Is Pangram? true
    }
}
```

### **Find the Sum of All Even-Indexed Elements in a List**

Sum all even-indexed elements in a list.

```java
int sum = IntStream.range(0, numbers.size())  // Generate indices from 0 to size-1
                .filter(i -> i % 2 == 0)             // Keep only even indices
                .map(numbers::get)                   // Get the elements at those indices
                .sum();                              // Sum them up
```

### **Simulate a Voting System Using Streams**

Given a list of votes, count occurrences of each candidate and determine the winner.

```java
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public class ElectionWinner {
    public static void main(String[] args) {
        List<String> votes = List.of("Alice", "Bob", "Alice", "Charlie", "Bob", "Alice", "Bob", "Bob");

        // Count occurrences of each candidate
        Map<String, Long> voteCount = votes.stream()
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

        // Determine the winner (candidate with max votes)
        String winner = voteCount.entrySet().stream()
                .max(Map.Entry.comparingByValue()) // Get the entry with the highest count
                .map(Map.Entry::getKey)           // Extract the candidate's name
                .orElse("No votes");

        System.out.println("Vote counts: " + voteCount);
        // Output: Vote counts: {Alice=3, Bob=4, Charlie=1}

        System.out.println("Winner: " + winner);
        // Output: Winner: Bob
    }
}
```
