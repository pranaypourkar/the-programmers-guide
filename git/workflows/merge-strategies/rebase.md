# Rebase

## About

Git rebase is a mechanism that **reapplies commits on top of another base tip**, allowing us to **relocate changes** in history as if they had been made at a different point in time.

It **does not merge histories**. Instead, it **transplants the work** we have done onto a new base — as if our changes were made starting from that point.

In other words, **rebasing is a history-rewriting operation**. It reconstructs our branch from a new point in the project’s timeline.

{% hint style="success" %}
Git is a distributed version control system. Every commit has a pointer to its **parent(s)**, forming a **directed acyclic graph** (DAG). When branches diverge and change, they can be brought together by:

* **Merging**: Preserves both histories as-is, introducing a new “merge commit” that connects the timelines.
* **Rebasing**: Discards the old base and replays changes from one branch onto a new one, making it look like they always began from there.
{% endhint %}

{% hint style="info" %}
Imagine two people, Alice and Bob, working on a document.

* Alice starts writing a new section based on version 1.
* Bob, meanwhile, updates the document to version 2.
* Now Alice’s section is “based on the old version.”

If Alice **merges**, the document shows two authors' efforts coming together — but with side notes of when and how they diverged.

If Alice **rebases**, she takes her section and **rewrites it as if she had started writing on version 2** all along.

No history of divergence remains — just a smooth narrative.
{% endhint %}

## How Rebase Works Internally ?

Rebase is a sequence of three steps:

1. **Identify the Fork Point**\
   Find the last common commit between the current branch and the target branch.
2. **Extract Your Commits**\
   Take all commits after the fork point in your branch and treat them as patches.
3. **Replay on Top of New Base**\
   Apply each patch on top of the tip of the target branch in order.

This results in:

* A new set of commits (with new hashes).
* A linearized history with no merge commits.

This is fundamentally **a history rewrite operation** — not a content merge.

{% hint style="warning" %}
**Never rebase a branch others have pulled from.**\
Because rebasing changes commit hashes, it invalidates the original timeline. Everyone else’s branch becomes incompatible — they now refer to commits that “don’t exist.”

Force pushing a rebased branch can **overwrite collaborators’ work** unless coordinated properly.

Use rebase for **private or feature branches** where you control the timeline.
{% endhint %}

We are working in a Git repository with two branches:

```
A---B---C         (main)
     \
      D---E---F   (feature)
```

* **`main` branch**: contains commits `A → B → C`
* **`feature` branch**: was created from commit `B`, and has commits `D → E → F`
* `feature` has diverged because new commits (`C`) have been added to `main` after `feature` was created.

#### What Happens During a Rebase ?

The command:

```bash
git checkout feature
git rebase main
```

tells Git:

> "Take the commits from the `feature` branch that are **not in** `main` (i.e., `D`, `E`, `F`), and **replay them on top of** the latest commit in `main` (i.e., `C`)."

#### Step-by-Step Breakdown

1. Git finds the **common ancestor** of `main` and `feature`, which is commit `B`.
2. Git creates **patches** (internal changes) for each of the commits on `feature` after `B`:\
   → patches for `D`, `E`, and `F`.
3. Git **checks out `main`** (commit `C`), and **applies those patches** one by one on top of it.
4. New commit hashes are generated for the rebased commits — Git doesn't reuse `D`, `E`, `F`; it creates new ones (let's say `D'`, `E'`, `F'`).

#### Resulting History

After rebasing:

```
A---B---C---D'---E'---F'   (feature)
            ^
           (rebased)
```

* `feature` now appears **as if it was developed on top of the latest `main`**.
* History is linear — no merge commits.
* Old commits `D`, `E`, `F` are no longer part of the branch history.

#### Equivalent Merge (for contrast)

Had we used:

```bash
git checkout feature
git merge main
```

We'd get:

```
A---B---------C              (main)
     \          \
      D---E---F---M      (feature)
```

* `M` is a **merge commit** with two parents: `C` and `F`
* We retain full context of both branches’ histories
* History is **non-linear**, with more branching complexity

## Practical Use Cases

### 1. **Keeping a Feature Branch Up to Date Without Polluting History**

**Problem**: You're working on a feature branch for several days or weeks. In the meantime, your main branch (usually `main` or `develop`) continues to evolve with other features or bug fixes from the team. You want to bring in those updates to avoid conflicts later, but you don’t want merge commits cluttering your history every time you sync.

**Why Rebase Works Well**:\
Rebasing allows you to _replay_ your work on top of the latest state of `main`, as if your work had started from the current version of the codebase. This produces a clean, linear history.

**Effect**:\
Instead of introducing merge commits and branching noise, rebasing keeps your branch’s commit history aligned with the project’s ongoing state — as if you were always up-to-date.

```bash
## Use Case: Sync our feature branch (feature/login) with develop, keeping a linear history.

# Make sure you're on your feature branch
git checkout feature/login

# Rebase your branch on top of latest develop
git fetch origin
git rebase origin/develop

# If conflicts occur, Git will stop and ask us to resolve them. After resolving:
git add <conflicted-files>
git rebase --continue

# If we want to abort the rebase:
git rebase --abort
```

### 2. **Preparing Clean Commits Before a Pull Request or Merge Request**

**Problem**: During development, you often make multiple small, messy commits (`fix typo`, `oops`, `refactor`, `add test`, etc.). When preparing your branch for review, you want the commit history to be meaningful, concise, and structured.

**Why Rebase Works Well**:\
Using _interactive rebase_ (`git rebase -i`), you can rewrite your history before it is pushed or shared. This allows you to:

* Combine several commits into one (`squash`)
* Edit commit messages to reflect real purpose
* Drop irrelevant or temporary commits

**Effect**:\
A reviewer sees a clean sequence of commits, each with a clear purpose. It makes your work easier to review, audit, and understand. The history appears deliberate, not accidental.

```bash
## Use Case: Squash, reorder, or edit multiple commits for clarity before code review.

# Rebase interactively the last N commits (e.g., last 5 commits)
git rebase -i HEAD~5

# We will get an editor showing a list like:
pick 123abc Add user login form
pick 456def Fix typo
pick 789ghi Add validation
```

We can change `pick` to:

* `squash`: combine commits
* `edit`: modify commit contents
* `reword`: change commit message
* `drop`: remove commit

After saving, Git will apply changes step-by-step.

### 3. **Avoiding Merge Conflicts Later by Resolving Them Early**

**Problem**: When multiple branches change the same code, merge conflicts are inevitable. If you wait until the end of development to merge, conflicts might be large and hard to resolve because of accumulated differences.

**Why Rebase Works Well**:\
Rebasing early and often helps you resolve conflicts in small increments. By frequently rebasing onto the latest base branch, you continuously align with your team’s changes.

**Effect**:\
You deal with smaller, more understandable conflicts along the way, instead of a large, stressful merge crisis at the end of the development cycle.

```bash
## Use Case: Regularly pull in updates from base branch (e.g., main) to avoid big conflicts at the end.

git checkout feature/api-refactor
git fetch origin
git rebase origin/main
```

### 4. **Linear History for Bisecting and Debugging**

**Problem**: When bugs are found in production, using `git bisect` helps locate the exact commit where the bug was introduced. This tool relies on a clean commit history.

**Why Rebase Works Well**:\
With a linear history, each commit only introduces a specific logical change. This makes it easy to test each step and pinpoint the problematic one.

**Effect**:\
Debugging becomes much faster. Each commit becomes a reliable checkpoint in the evolution of your project.

```bash
## Use Case: A clean, sequential history makes git bisect easier and more effective.

# Keep rebasing your feature branch on top of main to maintain linearity
git checkout feature/data-cleanup
git fetch origin
git rebase origin/main
```

### 5. **Integrating Upstream Changes in Forked Repositories**

**Problem**: In open-source or team workflows, you may fork a repository and develop a feature over time. Meanwhile, the upstream repository continues to evolve. Eventually, you want to sync your work with upstream without introducing complex merge paths.

**Why Rebase Works Well**:\
Rebasing your fork or branch onto the updated upstream branch makes it look as if your changes were always made against the latest code — no unnecessary merge bubbles are introduced.

**Effect**:\
When you submit a pull request or merge request, your code appears naturally integrated into the project, and maintainers don't need to wade through unnecessary merge conflicts or unrelated commits.

```bash
## Use Case: You're contributing to an open-source repo. You forked it and want to rebase your changes on top of the latest upstream master.

# Add upstream repo if not done
git remote add upstream https://github.com/original/project.git

# Fetch updates from upstream
git fetch upstream

# Rebase your feature branch on top of upstream/main
git checkout feature/my-contribution
git rebase upstream/main
```

### 6. **Reordering Commits for Logical Clarity**

**Problem**: Sometimes the order of your commits doesn't match the logical flow of the code. You might have added a test before the implementation, or fixed a bug before writing the code that introduced it.

**Why Rebase Works Well**:\
With interactive rebase, you can **reorder** commits to match a logical, cause-and-effect sequence. This improves not just history readability, but also consistency in the project's timeline.

**Effect**:\
The commit history becomes a story: it can be read from top to bottom, and each change builds upon the previous one. This is invaluable for onboarding, documentation, and future debugging.

```bash
## Use Case: Reorder commits for clarity or to group similar changes together.
git rebase -i HEAD~6
```

In the editor, simply move lines up or down to reorder the commits. Git will replay them in that order.

### 7. **Dropping or Fixing Broken or Temporary Commits**

**Problem**: You committed something temporary (e.g., debug logs, experiment, forgotten print statements) and don’t want that in the final project history.

**Why Rebase Works Well**:\
Interactive rebase allows you to remove these commits (`drop`) or edit them in-place (`edit`) to fix issues without creating additional commits.

**Effect**:\
The history appears intentional and clean. There are no embarrassing or confusing commits left behind that need to be explained later.

```bash
## Use Case: We added a commit like Added console.log() or debug version — now you want to remove it.
git rebase -i HEAD~5
```

Then in editor:

```
pick 123abc Added feature
drop 456def Added debug logs
pick 789ghi Final cleanup
```

Save and Git will remove the dropped commit.
