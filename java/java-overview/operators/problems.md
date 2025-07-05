# Problems

## 1. Operators

Why both print same values?

```java
for (i = 0;i<10;i++) {
  System.out.print(i);
}
System.out.println();
for (i=0;i<10;++i) {
  System.out.print(i);
}

// 0123456789
// 0123456789
```

Both `i++` and `++i` **increment the value of `i` by 1**, but the **difference lies in when the increment happens** in expressions — **not in loops like `for` where the value isn't used during increment.**

{% hint style="success" %}
* `i++` → **Post-increment**: Increments `i` after the value is used
* `++i` → **Pre-increment**: Increments `i` before the value is used
{% endhint %}

But in a `for` loop:

```java
for (i = 0; i < 10; i++)  // or ++i
```

The **increment expression (`i++` or `++i`) happens after each iteration**, and its return value is **not used anywhere** in the loop control itself.

So both loops behave the same:

1. Initialize `i = 0`
2. Check condition `i < 10`
3. Execute `System.out.print(i)`
4. Increment `i` (post or pre — doesn’t matter because value isn't used)
5. Repeat

If we wrote something like:

```java
int x = i++;
int y = ++i;
```

Here, the difference matters:

* `x = i++`: assigns the value of `i` to `x`, **then increments** `i`
* `y = ++i`: increments `i`, **then assigns** the new value to `y`

