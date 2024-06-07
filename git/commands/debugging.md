# Debugging

## git bisect

### Description

It is used to perform a binary search to find the commit that introduced a bug or issue in the codebase. By systematically checking out and testing commits, `git bisect` helps to narrow down the exact commit where the problem started. This process significantly speeds up the debugging process, especially in large projects with many commits.

### Usage

```sh
git bisect [<subcommand> | <options>]
```

```
-- Start the Bisecting Process
git bisect start

-- Mark a Commit as Bad
-- Marks the current commit (or specified commit) as containing the bug
git bisect bad [<commit>]

-- Mark a Commit as Good
-- Marks the current commit (or specified commit) as not containing the bug
git bisect good [<commit>]

-- Skip a Commit
-- Skips the current commit (or specified commit) if it can't be tested (e.g., doesn't compile)
git bisect skip [<commit>]

-- Visualize the Bisecting Process
git bisect visualize

-- Reset the Bisecting Process
-- Ends the bisecting process and returns to the original branch
git bisect reset
```

{% hint style="info" %}
**Good and Bad Commits**: The process requires to identify one commit where the bug is present (`bad`) and one where the bug is not present (`good`). This helps narrow down the range of commits to search.

**Automating Tests**: We can automate the bisecting process by using scripts. `git bisect run` allows to provide a script that will automatically test each commit and mark it as good or bad based on the script's exit status.

```
git bisect run ./test-script.sh
```

**Skipping Commits**: If we encounter a commit that cannot be tested (e.g., it doesn't compile or crashes), we can skip it. `git bisect` will choose another commit to test.
{% endhint %}

### Example Workflow

```
-- Start the Bisecting Process
git bisect start

-- Mark the Current Commit as Bad
-- This is the commit where we know the bug is present
git bisect bad

-- Mark an Older Commit as Good
-- This is a commit where we know the bug is not present.
git bisect good <known-good-commit>

-- Test the Suggested Commit
-- git bisect will now check out a commit halfway between the good and bad commits. We test this commit (e.g., run your tests or check if the bug is present) and then mark it as good or bad.

-- If the commit is good
git bisect good

-- If the commit is bad
git bisect bad

-- If the commit cannot be tested (e.g., it doesn't compile)
git bisect skip

--Repeat:
-- Continue the process until git bisect identifies the first bad commit. git bisect will narrow down the commit range step by step until it finds the problematic commit. 

-- Reset the Bisecting Process:
-- Once we have identified the bad commit, reset the bisecting process
git bisect reset
```

### Example Output

During the bisecting process

<figure><img src="../../.gitbook/assets/image (174).png" alt="" width="543"><figcaption></figcaption></figure>

## git grep





## git fsck

