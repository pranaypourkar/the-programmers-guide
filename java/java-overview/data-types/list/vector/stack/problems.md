# Example

## Problem 1

Given a string **A** consisting only of **’(‘** and **’)’**. We need to find whether parantheses in **A** is balanced or not ,if it is balanced then print **1** else print **0**.

{% hint style="info" %}
Examples of some correctly **balanced strings** are: “()()”, “((()))”, “((()))”

Examples of some **unbalanced** strings are: “()(“, “(()))”, “((“, “)(“ etc.
{% endhint %}

```java
import java.util.Scanner;
import java.util.Stack;

public class SomeMain {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt(); // number of test cases
        sc.nextLine(); // consume the newline character

        // Loop for each test case
        for (int i = 0; i < n; i++) {
            String str = sc.nextLine();
            Stack<Character> stack = new Stack<>();
            boolean isBalanced = true; // assume the string is balanced initially

            // Traverse through the string
            for (int j = 0; j < str.length(); j++) {
                char ch = str.charAt(j);

                // If it's an opening parenthesis, push it onto the stack
                if (ch == '(') {
                    stack.push(ch);
                }
                // If it's a closing parenthesis, check if the stack is non-empty and top is '('
                else if (ch == ')') {
                    if (stack.isEmpty()) {
                        isBalanced = false; // More closing parentheses
                        break;
                    } else {
                        stack.pop(); // Match found, pop the '('
                    }
                }
            }

            // If the stack is not empty, there are unmatched opening parentheses
            if (!stack.isEmpty()) {
                isBalanced = false;
            }

            // Output the result for this string
            System.out.println(isBalanced ? 1 : 0);
        }

        sc.close();
    }
}
```



