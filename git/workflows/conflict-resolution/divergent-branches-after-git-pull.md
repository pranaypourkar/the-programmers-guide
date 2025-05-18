# Divergent Branches After git pull

## About

Sometimes when we run `git pull`, we see an error like this:

```
hint: You have divergent branches and need to specify how to reconcile them.
fatal: Need to specify how to reconcile divergent branches.
```

{% hint style="info" %}
This means that Our local branch and the remote branch have **diverged** — they both have commits that the other doesn’t. Git doesn’t know how to automatically combine them.
{% endhint %}

## When Does This Happen?

**1. Local Commits + Remote Commits**

We have made commits locally, and meanwhile, someone else has pushed new commits to the remote. Now both have different changes.

**2. Someone Force Pushed to the Branch**

Another developer rewrote the history of the branch using `git push --force`, replacing the previous commits on the remote. Our local branch still has the old history, causing divergence.

Example output when force push has occurred:

```
+ abc123...def456 feature/xyz -> origin/feature/xyz (forced update)
```

The `+` sign and `(forced update)` indicate a force push.

{% hint style="info" %}
Complete logs

{% code overflow="wrap" %}
```log
pranayp@2529 sample-integration-service % git pull
remote: Enumerating objects: 13, done.
remote: Counting objects: 100% (13/13), done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 13 (delta 1), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (13/13), 7.71 KiB | 717.00 KiB/s, done.
From gitlab-url/backend/sample-integration-service
 + 925f13d...65c557b feature/APP-2122-add-default-nickname -> origin/feature/APP-2122-add-default-nickname  (forced update)
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint:
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint:
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
fatal: Need to specify how to reconcile divergent branches.
```
{% endcode %}
{% endhint %}

## How to Fix ?

We need to tell Git how to reconcile the divergent histories. We can do this in one of three ways:

### **Option 1: Merge Strategy**

```bash
git config pull.rebase false
git pull
```

* Git will merge the remote changes into our local branch.
* A merge commit is created.
* Preserves both sets of commits.

### **Option 2: Rebase Strategy**

```bash
git config pull.rebase true
git pull
```

* Git will rebase our local commits on top of the updated remote branch.
* Keeps a clean, linear history.
* Preferred in many modern workflows.

### **Option 3: Fast-Forward Only**

```bash
git config pull.ff only
git pull
```

* Only succeeds if our branch can be fast-forwarded (i.e., no divergence).
* Otherwise, it will fail and ask us to resolve the divergence manually.

## One-Time Fix Without Changing Config

If we just want to resolve the issue once:

```bash
git pull --rebase        # or
git pull --no-rebase     # or
git pull --ff-only
```

## Permanent Solution

To avoid this message in future, set our preferred strategy globally:

```bash
git config --global pull.rebase true       # Always rebase
git config --global pull.rebase false      # Always merge
git config --global pull.ff only           # Only allow fast-forward pulls
```

{% hint style="info" %}
The **default merge strategy for `git pull`** depends on **which configuration is set (or not set)**.

#### Default Behavior (If Not Configured)

If we **haven’t explicitly set `pull.rebase` or `pull.ff`**, Git will:

* Use `git pull --merge` (i.e., perform a merge).
* Allow both fast-forward and non-fast-forward merges.
* If there's divergence, it creates a merge commit.

So, by default:

* No rebase
* Merges remote changes into your local branch
* You might get a merge commit if histories diverge.
{% endhint %}

## When We Don't Care About Local Changes

If we want to discard our local changes and align with remote (e.g., after force push):

```bash
git fetch origin
git reset --hard origin/your-branch-name
```

Use with caution — this **overwrites our local commits**.
