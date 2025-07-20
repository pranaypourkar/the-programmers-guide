# Greedy Programming

## About

Greedy programming is an approach used to **solve optimization problems**. In greedy algorithms, we build a solution **step by step**, always choosing the option that **offers the most immediate benefit** or seems best at that moment.

* You don’t reconsider earlier decisions.
* The hope is that local choices lead to a **globally optimal** solution.

It’s like trying to reach the peak of a hill by always climbing the steepest nearby path.

{% hint style="success" %}
The key idea is to **choose the best possible option at every stage**, without reconsidering previous choices.
{% endhint %}

## When Can We Use Greedy Algorithms ?

We can use greedy algorithms **only when a problem satisfies specific properties**. Not every problem can be solved this way. To ensure greedy works and gives the correct (optimal) result, the problem **must satisfy two conditions**:

#### **1. Greedy Choice Property**

This means:

> We can make a **choice at each step** that looks best **at that moment**, and that choice is part of the **overall optimal solution**.

* Once we make the greedy choice, we don’t go back or undo it.
* The idea is: **"Making a locally best choice now will lead to a globally best solution."**

**Example: Activity Selection**

* If we always pick the activity that ends earliest (locally best), we leave more room for future activities, which turns out to be globally optimal.

#### **2. Optimal Substructure**

This means:

> The **optimal solution to the whole problem** can be built from **optimal solutions to its subproblems**.

* Once we make a greedy choice, the remaining problem is **smaller**, and solving it optimally gives us the full answer.
* There’s **no need to look back** or check alternate paths.

**Example: Fractional Knapsack**

* If we always choose the item with highest value-to-weight ratio, the remaining part of the knapsack problem is again of the same type (but smaller).

## **How to Know If a Problem is Greedy-Safe ?**

Before using a greedy algorithm, ask:

* Can I break the problem into steps?
* At each step, is there a clearly best option?
* If I always choose that, do I get the correct final result?

If **yes to all**, greedy will work. If **no**, consider dynamic programming or backtracking.

## Use Case: Activity Selection Problem (Non-overlapping Intervals)

We are given `n` activities with their start and end times. You must **select the maximum number of activities** that can be performed **by a single person**, assuming that a person can only work on a **non-overlapping activity** at a time.

#### **Input Example**

```java
start[] = {1, 3, 0, 5, 8, 5};
end[]   = {2, 4, 6, 7, 9, 9};
```

### Brute Force Approach

Try **all subsets** of activities, check if they are **non-overlapping**, and return the size of the largest valid subset.

#### Steps

1. Generate all subsets of the activities.
2. For each subset:
   * Check if activities do not overlap (i.e., end time of one <= start of next).
3. Track the maximum number of non-overlapping activities found.

```java
public class ActivitySelectionBruteForce {

    static int maxActivities = 0;

    public static void main(String[] args) {
        int[] start = {1, 3, 0, 5, 8, 5};
        int[] end =   {2, 4, 6, 7, 9, 9};

        int n = start.length;
        boolean[] selected = new boolean[n];
        generateSubsets(start, end, selected, 0);
        System.out.println("Max non-overlapping activities (Brute Force) = " + maxActivities);
    }

    static void generateSubsets(int[] start, int[] end, boolean[] selected, int index) {
        if (index == start.length) {
            checkValid(start, end, selected);
            return;
        }

        // Include this activity
        selected[index] = true;
        generateSubsets(start, end, selected, index + 1);

        // Exclude this activity
        selected[index] = false;
        generateSubsets(start, end, selected, index + 1);
    }

    static void checkValid(int[] start, int[] end, boolean[] selected) {
        List<Integer> indices = new ArrayList<>();
        for (int i = 0; i < selected.length; i++) {
            if (selected[i]) indices.add(i);
        }

        // Sort selected by end time
        indices.sort((a, b) -> end[a] - end[b]);

        for (int i = 1; i < indices.size(); i++) {
            int prev = indices.get(i - 1);
            int curr = indices.get(i);
            if (start[curr] < end[prev]) {
                return; // Overlapping
            }
        }

        maxActivities = Math.max(maxActivities, indices.size());
    }
}
```

#### Time Complexity

* Generating all subsets: O(2ⁿ)
* Checking validity of each: O(n)
* Total: O(n \* 2ⁿ)

### Greedy Approach

Always pick the **activity that ends earliest** (among the remaining), because this allows the most room for future activities.

#### Steps

1. Pair up start and end times.
2. Sort activities based on their **end times**.
3. Initialize:
   * `count = 1` (select the first activity).
   * `lastEnd = end time of first activity`.
4. For each subsequent activity:
   * If `start time >= lastEnd`, select it and update `lastEnd`.

```java
import java.util.*;

class Activity {
    int start, end;
    Activity(int s, int e) {
        start = s;
        end = e;
    }
}

public class ActivitySelectionGreedy {
    public static void main(String[] args) {
        int[] start = {1, 3, 0, 5, 8, 5};
        int[] end   = {2, 4, 6, 7, 9, 9};

        List<Activity> activities = new ArrayList<>();
        for (int i = 0; i < start.length; i++) {
            activities.add(new Activity(start[i], end[i]));
        }

        // Step 1: Sort by end time
        activities.sort(Comparator.comparingInt(a -> a.end));

        int count = 1;
        int lastEnd = activities.get(0).end;

        for (int i = 1; i < activities.size(); i++) {
            if (activities.get(i).start >= lastEnd) {
                count++;
                lastEnd = activities.get(i).end;
            }
        }

        System.out.println("Max non-overlapping activities (Greedy) = " + count);
    }
}
```

#### Time Complexity

* Sorting: O(n log n)
* Selection: O(n)
* Total: O(n log n)

## **Greedy vs Brute Force vs Dynamic Programming**

<table data-full-width="true"><thead><tr><th width="131.4322509765625">Approach</th><th width="340.86456298828125">Description</th><th width="133.46441650390625">Memory Usage</th><th width="103.28985595703125">Speed</th><th>Recomputes Subproblems</th></tr></thead><tbody><tr><td>Brute Force</td><td>Try all combinations</td><td>High</td><td>Slow</td><td>Yes</td></tr><tr><td>Dynamic Programming</td><td>Break into subproblems and store results</td><td>Medium</td><td>Moderate</td><td>No</td></tr><tr><td>Greedy</td><td>Choose the best local option at each step</td><td>Low</td><td>Fast</td><td>No (no recomputation)</td></tr></tbody></table>

## Tips to Build Greedy Algorithms

Designing greedy algorithms can be tricky. The key is to identify whether a greedy strategy will work for the given problem. Here are some practical tips and steps to help you build a greedy algorithm:

#### **1. Understand the Problem Thoroughly**

Before jumping into a greedy approach:

* Read the problem carefully.
* Identify **constraints**, **goals**, and **edge cases**.
* Ask: "What is being optimized?" (e.g., cost, time, value, size)

#### **2. Look for a Greedy Strategy**

Try to find a **local decision** that seems to help reach the global goal. This is the **core of greedy**.

Ask yourself:

* Can I make a decision now that seems best?
* Is that decision safe (i.e., will it not affect the rest of the solution)?

#### **3. Define the Greedy Choice Clearly**

Be specific:

* What is the **greedy choice** you will make at each step?
* Based on what metric will you choose it? (e.g., smallest, largest, most efficient)

**Example**: In job scheduling, pick the job with the **earliest finish time**.

#### **4. Prove the Greedy Choice Works**

This is the most important and often missed part.

* You must be able to prove that the greedy choice leads to the **optimal solution**.
* Check if the problem has:
  * **Greedy Choice Property**
  * **Optimal Substructure**

If either fails, the greedy approach may not give the correct result.

#### **5. Think About Sorting**

Many greedy problems require:

* Sorting elements by **a specific key**, like weight/value, start/end time, cost/time ratio, etc.
* Sorting helps process elements in the best order for the greedy decision.

#### **6. Watch Out for Special Cases**

Greedy algorithms can sometimes fail for edge cases:

* Ties between elements
* Very small or very large inputs
* Repeated values or negative values

Be sure to test these in your solution.

#### **7. Try by Example**

Before coding:

* Try small examples by hand.
* Follow your greedy idea step by step.
* See if it leads to the correct and optimal answer.

#### **8. Don’t Force It**

Not all problems can be solved using greedy.\
If your greedy logic fails in even one case, it’s not the right approach.

In that case, try:

* **Dynamic Programming**
* **Backtracking**
* **Divide and Conquer**



