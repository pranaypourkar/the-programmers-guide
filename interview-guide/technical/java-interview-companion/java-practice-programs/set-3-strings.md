# Set 3 - Strings

## 1. Check whether a string is a Palindrome

A string is said to be a palindrome if it is the same if we start reading it from left to right or right to left.

{% hint style="info" %}
Example

**Input:** str = “abccba”\
**Output:** Yes

**Input:** str = “someString”\
**Output:** No
{% endhint %}

### Method 1: Using naive method of String reversal

By reversing the given string and comparing, we can check if the given string is a palindrome or not.

```java
public static boolean method1(String input) {
        String reverse = "";
        for (int i=input.length() - 1; i>=0; i--) {
            reverse = reverse.concat(String.valueOf(input.charAt(i)));
        }

        return input.equals(reverse);
    }
// Time Complexity - O(N)
// Space Complexity - O(n) where n is the length of the input string. This is because the reverse string is created and stored in a separate string variable, which takes up space in memory proportional to the length of the input string.
```

### Method 2: Using StringBuilders

By reversing the given string using string builders, we can check if the given string is a palindrome or not.

```java
public static boolean method2(String input) {
        StringBuilder sb = new StringBuilder(input);
        return input.contentEquals(sb.reverse());
    }
// Time Complexity - O(n), where n is again the length of the input string str. The primary factor contributing to this time complexity is the reversal of the string 
// Space Complexity - O(n), space required for the StringBuilder is proportional to the length of the input string.   
```

### Method 3: Using iteration over the string

```java
public static boolean method3(String input) {
        for (int i=0; i<input.length()/2; i++) {
            if (input.charAt(i) != input.charAt(input.length() - 1 - i))  {
                return false;
            }
        }
        return true;
    }
// Time Complexity - O(N)
// Space Complexity - O(1)
```

### Method 4: Using recursion

```java
public static boolean method4(String input) {
        return recursion(0,input.length()-1, input);
    }

    private static boolean recursion(int i, int j, String input) {
        if (i > j) {
            return true;
        }

        if (input.charAt(i) != input.charAt(j)) {
            return false;
        }

        return recursion(i+1, j-1, input);
    }
// Time Complexity - O(N) function recursively calls itself for the characters at positions (i+1, j-1) until the pointers i and j cross each other or the characters at the pointers are not equal
// Space Complexity - O(n), where n is the length of the input string. This is because each recursive call creates a new stack frame that stores the current values of the function parameters and local variables. In the worst case, the function call stack may grow as large as n/2 (when the input string is a palindrome), so the space complexity is O(n)
```

## 2. Check whether two strings are anagram

An anagram of a string is another string that contains the same characters, only the order of characters can be different.

### Method 1: Using Sort

```java
private static boolean method1(char[] charArray1, char[] charArray2) {
        // Using sorting and comparison
        Arrays.sort(charArray1);
        Arrays.sort(charArray2);
        return Arrays.equals(charArray1, charArray2);
    }

// Time Complexity - O(N) + O(NlogN) = O(NlogN) 
// Space Complexity - O(1)
```

### Method 2: **Count characters using 2 arrays**

```java
private static boolean method2(char[] charArray1, char[] charArray2) {
        if (charArray1.length != charArray2.length) {
            return false;
        }

        // Using 2 arrays with character count
        int[] count1 = new int[256];
        int[] count2 = new int[256];

        for (int i=0; i<charArray1.length; i++) {
            count1[charArray1[i]]++;
            count2[charArray2[i]]++;
        }

        for (int i=0; i<256; i++) {
            if (count1[i] != count2[i]) {
                return false;
            }
        }

        return true;
    }
    
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 3: **Count characters using 1 array**

```java
private static boolean method3(char[] charArray1, char[] charArray2) {
        if (charArray1.length != charArray2.length) {
            return false;
        }

        int[] count = new int[256];

        for (int i=0; i<charArray1.length; i++) {
            count[charArray1[i]]++;
            count[charArray2[i]]--;
        }

        for (int i = 0; i < 256; i++)
            if (count[i] != 0) {
                return false;
            }
        return true;
    }
    
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 4: **Using HashMap**

```java
private static boolean method4(char[] charArray1, char[] charArray2) {
        Map<Character, Integer> map = new HashMap<>();
        for(char c : charArray1) {
            if (!map.containsKey(c)) {
                map.put(c, 1);
            } else {
                map.put(c, map.get(c) + 1);
            }
        }

        for(char c : charArray2) {
            map.put(c, map.get(c) - 1);
        }

        for(Map.Entry<Character, Integer> characterIntegerEntry : map.entrySet()) {
            if (characterIntegerEntry.getValue() != 0) {
                return false;
            }
        }

        return true;
    }
    
// Time Complexity - O(n)
// Space Complexity - O(n)
```

## Program to reverse a String

<pre><code><strong>Input: str= "Tool"
</strong><strong>Output: "looT"
</strong></code></pre>

### Method 1: Using StringBuilder

```java
private static String method1(String input) {
        StringBuilder sb = new StringBuilder(input);
        return sb.reverse().toString();
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 2: Using iteration

```java
private static String method2(String input) {
        String reverse = "";
        for (int i=input.length()-1; i>=0; i--) {
           reverse = reverse.concat(String.valueOf(input.charAt(i)));
        }

        return reverse;
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 3: Using Byte Array

```java
private static String method3(String input) {
        byte[] strAsByteArray = input.getBytes();

        byte[] result = new byte[strAsByteArray.length];

        for (int i = 0; i < strAsByteArray.length; i++) {
            result[i] = strAsByteArray[strAsByteArray.length - i - 1];
        }

        return new String(result);
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 4: Using Arraylist and Streams

```java
private static String method4(String input) {
        char[] inputCharArray = input.toCharArray();
        List<Character> charArrayList = new ArrayList<>();

        for (char c : inputCharArray) {
            charArrayList.add(c);
        }

        Collections.reverse(charArrayList);

        return charArrayList.stream()
                .map(String::valueOf)
                .collect(Collectors.joining());

    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 5: Using StringBuffer

```java
private static String method5(String input) {
        StringBuffer sb = new StringBuffer(input);
        return sb.reverse().toString();
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

### Method 6: Using Stacks

```java
private static String method6(String input) {
        Stack<Character> stack=new Stack<>();

        for(char c:input.toCharArray())
        {
            //pushing all the characters
            stack.push(c);
        }

        String temp="";

        while(!stack.isEmpty())
        {
            //popping all the chars and appending to temp
            temp+=stack.pop();
        }
        return temp;
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```

## 4. Remove Leading Zeros From String

**Input :** 0000012345\
**Output:** 12345

**Input:** 000012345090\
**Output:** 12345090

```java
private static String method1(String input) {
        if (input.length() == 1 || input.charAt(0) != '0') {
            return input;
        }

        int i = 0;

        for (i=0 ;i< input.length() - 2; i++) {
            if ((input.charAt(i) == '0' && input.charAt(i+1) != '0' )){
                break;
            }
        }

        return input.substring(i+1);
    }
// Time Complexity - O(N)
// Space Complexity - O(N)
```



## 5. Find 1st and last digit in a String

**Input :** eightkpfngjsx97twozmbdtxhh\
**Output:** 9 and 7

{% hint style="info" %}
The `'\0'` character is the null character in Java and many other programming languages. It is represented by the Unicode value 0. In Java, it is often used as a sentinel value or placeholder for characters.

In the provided code snippets, `'\0'` is used as an initial value for `firstDigit` and `lastDigit` to indicate that they have not been set to any valid digit yet. Later in the code, if a digit is found, the corresponding variable is updated with the actual digit value.

For example, if no digits are found in the input string, `firstDigit` and `lastDigit` will remain `'\0'`, and the program can use that information to print a message indicating that no digits were found.
{% endhint %}

**Method 1: Traditional Loop**

```java
public class FirstLastDigitFinder {
    public static void main(String[] args) {
        String input = "eightkpfngjsx97twozmbdtxhh";
        findFirstAndLastDigits(input);

        String input2 = "eightkpfngjsx9twozmbdtxhh";
        findFirstAndLastDigits(input2);
    }

    private static void findFirstAndLastDigits(String input) {
        char firstDigit = '\0';
        char lastDigit = '\0';

        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            if (Character.isDigit(ch)) {
                if (firstDigit == '\0') {
                    firstDigit = ch;
                }
                lastDigit = ch;
            }
        }

        if (firstDigit != '\0' && lastDigit != '\0') {
            System.out.println("Input: " + input);
            System.out.println("First Digit: " + firstDigit);
            System.out.println("Last Digit: " + lastDigit);
            System.out.println();
        } else {
            System.out.println("No digits found in the input: " + input);
        }
    }
}
```

**Method 2: Using Regular Expressions**

```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FirstLastDigitFinder {
    public static void main(String[] args) {
        String input = "eightkpfngjsx97twozmbdtxhh";
        findFirstAndLastDigits(input);

        String input2 = "eightkpfngjsx9twozmbdtxhh";
        findFirstAndLastDigits(input2);
    }

    private static void findFirstAndLastDigits(String input) {
        Pattern pattern = Pattern.compile("\\d");
        Matcher matcher = pattern.matcher(input);

        char firstDigit = matcher.find() ? input.charAt(matcher.start()) : '\0';
        char lastDigit = matcher.find() ? input.charAt(matcher.start()) : '\0';

        while (matcher.find()) {
            lastDigit = input.charAt(matcher.start());
        }

        if (firstDigit != '\0' && lastDigit != '\0') {
            System.out.println("Input: " + input);
            System.out.println("First Digit: " + firstDigit);
            System.out.println("Last Digit: " + lastDigit);
            System.out.println();
        } else {
            System.out.println("No digits found in the input: " + input);
        }
    }
}
```

**Method 3: Using Apache Commons Lang**

```java
import org.apache.commons.lang3.StringUtils;

public class FirstLastDigitFinder {
    public static void main(String[] args) {
        String input = "eightkpfngjsx97twozmbdtxhh";
        findFirstAndLastDigits(input);

        String input2 = "eightkpfngjsx9twozmbdtxhh";
        findFirstAndLastDigits(input2);
    }

    private static void findFirstAndLastDigits(String input) {
        String digits = StringUtils.getDigits(input);

        if (!digits.isEmpty()) {
            char firstDigit = digits.charAt(0);
            char lastDigit = digits.charAt(digits.length() - 1);

            System.out.println("Input: " + input);
            System.out.println("First Digit: " + firstDigit);
            System.out.println("Last Digit: " + lastDigit);
            System.out.println();
        } else {
            System.out.println("No digits found in the input: " + input);
        }
    }
}
```
