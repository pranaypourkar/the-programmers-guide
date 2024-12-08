# Problems

## Problem 1

Give a input string as well as start and end index of substring. Task is to reverse the substring starting at index **L** and ending at index **R** in String **S**, and return the final string.

{% hint style="info" %}
Input - abcdefghijkl 2 6 \
Output - abgfedchijkl
{% endhint %}

```java
// This works well for smaller strings. However, it involves creating multiple substrings 
// and performing string concatenation, which can be inefficient for large strings 
// due to the immutable nature of String. Each substring and concatenation creates new objects, 
// leading to higher memory usage and computational overhead.
String left = s.substring(0,L);
String mid = new StringBuffer(s.substring(L,R+1)).reverse().toString();
String right = s.substring(R+1);
String output = left + mid + right;
```

```java
//Better Solution
StringBuffer sb = new StringBuffer(s);
while (L < R) {
  // Swap characters at L and R
  char temp = sb.charAt(L);
  sb.setCharAt(L, sb.charAt(R));
  sb.setCharAt(R, temp);
  L++;
  R--;
}
String output = sb.toString();
```



