# Set 3 - Strings

## &#x20;1. Check whether a string is a Palindrome

A string is said to be a palindrome if it is the same if we start reading it from left to right or right to left.

{% hint style="info" %}
Example

**Input:** str = “abccba” \
**Output:** Yes

**Input:** str = “someString”\
**Output:** No&#x20;
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



