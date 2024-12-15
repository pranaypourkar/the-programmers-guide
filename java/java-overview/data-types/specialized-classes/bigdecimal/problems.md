# Problems

## Problem 1

Given an array, **arr**, of **n** real number strings. Task is to sort them in descending order. Note that each number must be printed in the exact same format as it is given in input, meaning that .1 is printed as .1, and 0.1 is printed as 0.1. If two numbers represent numerically equivalent values (e.g. .1 is equivalent to 0.1), then they must be listed in the same order as they were received in the input).

{% hint style="info" %}
1 <= n <= 300

Each element of **arr** has atmost 250 digits.

```
 Sample Input
 9
 -101
 50
 0
 55.6
 90
 0.13
 .13
 01.34
 000.000

Sample Output
 90
 55.6
 50
 01.34
 0.13
 .13
 0
 000.000
 -101
```
{% endhint %}

```java
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        String[] s = new String[n];
        for (int i = 0; i < n; i++) {
            s[i] = sc.next();
        }
        sc.close();

        System.out.println(Arrays.toString(s));
        Arrays.sort(s, (o1, o2) -> {
            // Convert strings to BigDecimal for comparison
            BigDecimal bd1 = new BigDecimal(o1);
            BigDecimal bd2 = new BigDecimal(o2);
            // Sort in descending order
            return bd2.compareTo(bd1);
        });

        for (int i = 0; i < n; i++) {
            System.out.println(s[i]);
        }
```





