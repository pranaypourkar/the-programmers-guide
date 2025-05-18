# Fast-forward vs No-fast-forward

## About

When merging branches in Git, the term **fast-forward** or **no-fast-forward** (`--no-ff`) describes **how Git integrates the changes** from one branch into another.

They **do not affect the code content**, but **how Git writes commit history** during the merge.

## What Is a Fast-Forward Merge ?

A **fast-forward merge** happens **when the branch being merged in is directly ahead of the current branch**, with **no divergent history**. Git doesn’t need to create a new commit — it simply **moves the pointer** forward.

#### Visual Before Merge

```
main:  A -- B -- C
                   \
                 (feature): D -- E
```

If `main` is at `C` and you merge `feature`, and no new commits exist on `main`, Git will just move `main` forward.

#### After Fast-Forward Merge

```
main:  A -- B -- C -- D -- E
```

No merge commit is created.

#### Command

```bash
git checkout main
git merge feature
```

If `main` hasn't diverged, Git does a fast-forward by default.

## What Is a No-Fast-Forward Merge ?

A **no-fast-forward merge** forces Git to **always create a merge commit**, even if a fast-forward is possible.

This makes the **merge operation explicit in the history**, preserving the fact that a merge occurred and from which branch.

#### Visual Before

```
main:       A -- B -- C
                       \
                      (feature): D -- E
```

**After no-ff merge**

```
main:        A -- B -- C ------ M
                        \       /
                         D -- E
```

Now there is a **merge commit `M`**, showing the integration point.

#### Command:

```bash
git checkout main
git merge --no-ff feature
```

## Settings to Enforce Behavior

#### Always do no-fast-forward merges:

```bash
git config --global merge.ff false
```

This is useful in organizations that want **explicit merge tracking**.
