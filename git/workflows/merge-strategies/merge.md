# Merge

## About

**Merging** in Git is the process of combining changes from two branches into one. It's used when we want to integrate work from a feature branch back into the main development branch (e.g., `main`, `develop`, or `release/1.x`) or vice versa.

Merging preserves the **history** of both branches and creates a new commit (called a **merge commit**) that ties them together.

## **How Merge Works in Git ?**

When we run a `git merge`, Git looks for the **common ancestor** of the two branches and compares the changes made on each side from that point.

Example scenario:

* `main` and `feature-x` both originated from commit `A`.
* `main` has commit `B`.
* `feature-x` has commits `C` and `D`.

When we merge `feature-x` into `main`, Git:

* Identifies commit `A` as the common ancestor.
* Applies the changes from commits `C` and `D` onto the current `main`.
* Creates a **new merge commit** `E` with two parents: `B` and `D`.

The resulting history looks like this:

```
A---B---------E (main)
     \       /
      C---D (feature-x)
```

## Types of Merges

### **1. Fast-Forward Merge**

#### **When it happens ?**

A **fast-forward merge** occurs when the current branch has **no new commits** since it diverged from the branch being merged. Git doesn’t need to create a merge commit — it simply moves the pointer forward.

Before:

```
 A---B---C---D (feature)
         ↑
       (main)
```

* `main` is currently pointing to `C`
* `feature` has advanced to `D`
* `main` has no new commits after `C`, so Git can **fast-forward** it to `D`

After:

```
A---B---C---D (main, feature)
```

* Git just advances the `main` pointer to `D`, the tip of the `feature` branch.
* This results in a **linear history**.
* No merge commit is created.

#### **Command**

```bash
git checkout main
git merge feature
```

#### **When to use ?**

* Feature branch is fully ahead of main with no divergence.
* You want clean, simple history.

### **2. No Fast-Forward Merge (`--no-ff`)**

#### **When it happens ?**

We use this when we want to **force Git to create a merge commit**, even if a fast-forward is possible. This helps **preserve the context** of the feature branch.

Before:

```
 A---B---C---D (feature)
         ↑
       (main)
```

* `main` is at commit `C`
* `feature` is ahead by one commit: `D`

After:

```
A---B---C-------E (main)
         \     /
          D---/  (feature)
```

* `E` is a **merge commit** with parents: `C` and `D`
* `main` now includes the full history of the feature
* `feature` still exists (optional to delete)

#### **Explanation**

* Forces a new commit `E` to indicate a merge took place.
* The feature branch’s existence is preserved in history.
* Useful for tracking what was merged and when.

#### **Command**

```bash
git checkout main
git merge --no-ff feature
```

#### **When to use ?**

* We want to preserve the feature branch's identity.
* Our team policy enforces explicit merge commits.
* For audit or traceability reasons.

### **3. Three-Way Merge (Standard Merge with Divergence)**

#### **When it happens ?**

Both the base branch and feature branch have diverged — i.e., each has commits the other doesn’t have.

Before:

```
      E---F (feature)
     /
A---B---C (main)
```

* `B` is the **common ancestor**
* `main` has commits: `B → C`
* `feature` has commits: `B → E → F`

After:

```
      E---F
     /     \
A---B---C---G (main)
            ↑
          (merge commit)
```

* `G` is the **merge commit** with two parents:
  * One from `main` (`C`)
  * One from `feature` (`F`)
* `main` now includes changes from both branches
* History is **non-linear**, but traceable

#### **Command**

```bash
git checkout main
git merge feature
```

#### **When to use ?**

* The branches have diverged.
* We want a complete history of how changes were integrated.
* Most common real-world merge scenario.

### **4. Octopus Merge**

#### **When it happens ?**

Used when merging **more than two branches** at once.

Before:

```
      C (feature1)
     /
A---B
     \
      D (feature2)
       \
        E (feature3)
```

* All three feature branches (`feature1`, `feature2`, `feature3`) diverged from a common base (`B`)
* They have **no conflicting changes**

After:

```
       C  D  E
        \ | /
A---B-----F (main)
          ↑
     (merge commit)
```

* `F` is the **octopus merge commit**
* Has **multiple parents**: `C`, `D`, `E`
* `main` now contains all changes from `feature1`, `feature2`, and `feature3`

#### **Command**

```bash
git merge feature1 feature2
```

#### **When to use ?**

* Automated merges with no conflicts.
* Integrating multiple feature branches at once (e.g., for a release).

### **5. Merge with Conflicts**

#### **When it happens ?**

A merge conflict occurs when two branches modify the **same line** in a file or **delete/rename** the same file differently.

Git cannot automatically decide whose change to keep, so **it stops the merge and asks for manual intervention**.

#### Before Merge:

Let’s say we have a file `greeting.txt`.

```
Content of greeting.txt on main:
Hello from Main!

Content of greeting.txt on feature:
Hello from Feature!
```

#### **Branch Structure:**

```
      C (feature - changes greeting.txt)
     /
A---B---D (main - also changes greeting.txt)
```

* `B` is the common ancestor
* Both `main` and `feature` changed the **same line** in `greeting.txt` in **different ways**

#### Attempting Merge:

```bash
git checkout main
git merge feature
```

Git will now stop and show a **merge conflict**:

#### ✖ Conflict in `greeting.txt`:

```
<<<<<<< HEAD
Hello from Main!
=======
Hello from Feature!
>>>>>>> feature
```

* `HEAD` is our current branch (`main`)
* `feature` is the incoming branch
* We must choose which change to keep (or both)

#### Resolving the Conflict:

We manually edit the file, for example:

```
Hello from Main and Feature!
```

Then:

```bash
git add greeting.txt
git commit
```

Git will now complete the merge by creating a **merge commit**.

#### After Merge:

```
      C
     /
A---B---D---E (main)
         \  /
          (merge commit with conflict resolved)
```

* `E` is the merge commit
* It has two parents: `D` (main) and `C` (feature)
* `greeting.txt` now contains the manually resolved content

{% hint style="info" %}
- The **merge commit** (`E` in our example) is a **new commit created on the current branch we are merging into** (here, `main`).
- Even though we manually resolve conflicts, the merge commit still becomes the **new tip of `main`**.
- This merge commit has **two parents**:
  * The tip of your current branch before merge (`D` on `main`)
  * The tip of the branch you merged in (`C` on `feature`)
{% endhint %}

## **Merge Strategy Options**

Git also offers internal merge **strategies** used behind the scenes:

<table><thead><tr><th width="183.95703125">Strategy</th><th>Description</th></tr></thead><tbody><tr><td><code>recursive</code> (default)</td><td>Standard three-way merge; handles most cases</td></tr><tr><td><code>resolve</code></td><td>Simple strategy, limited capabilities</td></tr><tr><td><code>ours</code></td><td>Keeps the current branch’s changes only</td></tr><tr><td><code>theirs</code></td><td>Keeps the incoming branch’s changes (used in rebasing with strategy options)</td></tr><tr><td><code>octopus</code></td><td>Used when merging more than two branches</td></tr></tbody></table>

Example:

```bash
git merge --strategy=recursive feature
```

## Comparison

<table data-full-width="true"><thead><tr><th>Type</th><th>Merge Commit Created</th><th>Linear History</th><th>Conflict Handling</th><th>Typical Use Case</th></tr></thead><tbody><tr><td>Fast-Forward</td><td>No</td><td>Yes</td><td>No (no divergence)</td><td>Simple merges, clean linear history</td></tr><tr><td>No Fast-Forward</td><td>Yes</td><td>No</td><td>Yes</td><td>Preserve feature branch history</td></tr><tr><td>Three-Way Merge</td><td>Yes</td><td>No</td><td>Yes</td><td>Diverged branches, active collaboration</td></tr><tr><td>Octopus Merge</td><td>Yes (single commit)</td><td>No</td><td>No (fails on conflict)</td><td>Merge multiple branches at once</td></tr><tr><td>Merge with Conflicts</td><td>Yes</td><td>No</td><td>Yes (manual resolution)</td><td>When overlapping changes cause conflicts</td></tr></tbody></table>

## **When to Use Merge ?**

Use `merge` when:

* We want to preserve the full history of both branches.
* Our team prefers **non-destructive history**.
* We are working on long-running branches (e.g., `release/1.x`, `develop`, etc.).
* We want to use **GitLab Merge Requests** or **GitHub Pull Requests** and show clear integration points.

## **Merge vs Rebase**

<table data-full-width="true"><thead><tr><th width="168.67578125">Aspect</th><th>Merge</th><th>Rebase</th></tr></thead><tbody><tr><td>History</td><td>Preserved, non-linear</td><td>Linearized, rewritten</td></tr><tr><td>Merge commit</td><td>Yes</td><td>No (unless explicitly created)</td></tr><tr><td>Conflict handling</td><td>All at once</td><td>One commit at a time</td></tr><tr><td>Use case</td><td>Collaborative workflows, history trace</td><td>Clean history, private feature branches</td></tr></tbody></table>
