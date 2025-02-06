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



### **Convert List of Strings to a Single String**

Convert a `List<String>` into a single space-separated `String`.



## **Advanced Problems**

### **Find the Longest Word**

Find the longest word in a `List<String>`.



### **Find the Average Salary of Employees**

Given a `List<Employee>`, calculate the average salary.



### **Group Employees by Department**

Group employees into a `Map<String, List<Employee>>` based on department.



### **Find the Oldest Employee in Each Department**

Find the oldest employee in each department.



### **Find Duplicate Elements in a List**

Find all duplicate elements in a `List<Integer>`.



### **Convert a List of Employees into a Map**

Convert `List<Employee>` into `Map<Integer, String>` where key is `employeeId` and value is `employeeName`.



### **Find the Youngest Employee**

Find the youngest employee in the company.



### **Find the Longest and Shortest Words in a Sentence**

Given a sentence, find the longest and shortest words.



### **Find the Average Age of Employees by Department**

Compute the average age of employees per department.



### **Count the Occurrences of Each Character in a String**

Given a `String`, count occurrences of each character.



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

