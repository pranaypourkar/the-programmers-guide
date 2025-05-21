# Rebase develop branch on main branch

## About

When we **rebase the `develop` branch onto the `main` branch**, we are telling Git:

> “Take all the commits from `develop`, and replay them **on top of** the latest `main` branch.”

Instead of merging `main` into `develop`, rebasing **moves** the base of the `develop` branch to the tip of `main`.

## What Actually Happens Internally?

Let’s say we have this commit history:

```
main:    A---B---C
                  \
develop:           D---E---F
```

Now someone has pushed new commits to `main`:

```
main:    A---B---C---G---H
```

We now rebase `develop` on `main`:

```bash
git checkout develop
git rebase main
```

Git will:

1. Take the commits `D`, `E`, `F`
2. Re-apply them **on top of** `H`
3. Create new commits `D'`, `E'`, `F'` (new hashes)

Resulting in:

```
main:    A---B---C---G---H
                          \
develop:                    D'--E'--F'
```

## Why Rebase Instead of Merge ?

**1. Clean Linear History:**\
Rebasing avoids unnecessary merge commits, giving you a **straightforward, linear commit history** that is easier to read and understand.

**2. Easier Debugging with `git bisect`:**\
Linear histories help tools like `git bisect` work more reliably.

**3. Avoiding Merge Conflicts Repeatedly:**\
Rebasing regularly reduces the number of merge conflicts you face later.

**4. Better Context During Code Review:**\
Since each commit is replayed in order, reviewers can see exactly what changed in each commit.

## Important Considerations

**1. Only Rebase Local or Feature Branches:**\
Never rebase a **shared branch** (like `main`, or a branch others have pulled) unless we coordinate with our team. Rebasing **rewrites history**, which causes problems for others.

**2. Resolve Conflicts Carefully:**\
During rebase, if there are conflicts, Git will stop and ask us to resolve them, then continue the rebase.

```bash
git status  # shows conflicted files
# fix the files
git add <fixed files>
git rebase --continue
```

## Typical Workflow

Here’s the safe and standard way to rebase `develop` on top of `main`:

```bash
# 1. Checkout develop branch
git checkout develop

# 2. Make sure main is up to date
git fetch origin
git checkout main
git pull origin main

# 3. Switch back and rebase
git checkout develop
git rebase main
```

If all goes well, now our `develop` is based on the latest `main`.

## Command: `git checkout develop` followed by `git rebase main`

This will **rebase `develop` on top of `main`**.

* It **does not merge** `main` into `develop`.
* Instead, it **takes all commits from `develop`** (that are not in `main`) and **re-applies them one-by-one on top of `main`**.
* This **rewrites the commit history** of `develop`.

In effect:\
`develop = main + (replayed commits from old develop)`\
This makes it **look like we started develop from the tip of main in develop**.

## Command: `git checkout develop` followed by `git merge main`

This will **merge `main` into `develop`**.

* It creates a **new merge commit** on `develop` that combines both histories.
* It **preserves the exact historical path** of both branches.
* This does **not rewrite history**, it's safe for shared branches.

In effect:\
We are saying: “I want the content and history of both `develop` and `main`, and I want to move forward from there with a new merge commit.”
