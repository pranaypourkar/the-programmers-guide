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

### Description

It is used to search through the contents of files in a Git repository. It is similar to the Unix `grep` command but specifically optimized for searching within a Git repository. This command is useful for finding specific text patterns, code snippets, or occurrences of keywords across your codebase.

### Usage

```sh
git grep [<options>] <pattern> [-- <paths>…​]
```

### Options

`-i`: Perform a case-insensitive search.

`-n`: Show line numbers of matches.

`-c`: Count the number of matches in each file.

`-v`: Invert match to show lines that do not match the pattern.

`-l`: Show only the names of files containing matches.

`-L`: Show only the names of files not containing matches.

`--and`: Combine multiple patterns with a logical AND

`--or`: Combine multiple patterns with a logical OR.

`--not`: Exclude matches for a pattern

`--recurse-submodules`: Search in submodules recursively

```
git grep -i "search_term"
git grep -n "search_term"
git grep -c "search_term"
git grep -v "search_term"
git grep -l "search_term"
git grep -L "search_term"
git grep --and -e "pattern1" -e "pattern2"
git grep --or -e "pattern1" -e "pattern2"
git grep --not -e "exclude_pattern"
git grep --recurse-submodules "search_term"
```

{% hint style="info" %}
**Regular Expressions**: `git grep` supports basic regular expressions. You can use them to perform more complex searches.

<pre><code><strong>git grep "search_[a-z]+"
</strong></code></pre>

**Combining Options**: You can combine multiple options to refine your search further.

<pre><code><strong>git grep -i -n -- "pattern" -- path/to/dir
</strong></code></pre>

**Exclude Binary Files**: `git grep` automatically excludes binary files from the search, ensuring that the output remains readable.
{% endhint %}

### What It Does

1. **Searches for Patterns**: Finds occurrences of a specified pattern in the files tracked by Git.
2. **Filters by Path**: Limits the search to specific directories or files if paths are provided.
3. **Supports Various Options**: Offers a range of options to customize the search, such as case-insensitivity, counting matches, and showing line numbers.

### Common Use Cases

```
-- Search for a Pattern in the Repository
-- Finds all occurrences of search_term in the repository
git grep "search_term"

-- Search in a Specific Directory or File
-- Limits the search to the specified directory or file
git grep "search_term" -- path/to/directory
git grep "search_term" -- path/to/file.txt

-- Search Case-Insensitive
-- Performs a case-insensitive search for search_term
git grep -i "search_term"

-- Count the Number of Matches
-- Displays the number of matches in each file
git grep -c "search_term"

-- Show Line Numbers
-- Shows the line numbers of matches in the output
git grep -n "search_term"
```

### Example Workflow

```
-- finds all occurrences of "TODO" in the repository
git grep "TODO"

-- searches for "main" in src/main.c
git grep "main" -- src/main.c

-- case-insensitive search for "error"
git grep -i "error"

-- count the number of matches for "def" in each file
git grep -c "def"

-- show line numbers for each match of "function"
git grep -n "function"
```

### Example Output

When running `git grep "search_term"`

<figure><img src="../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="395"><figcaption></figcaption></figure>

## git fsck

### Description

It is used to perform an integrity check on a Git repository. It verifies the connectivity and validity of the objects in the database, ensuring that everything is intact and that there are no corrupted objects. This command is particularly useful for diagnosing issues within the repository, such as broken links between commits, missing objects, and other potential data integrity problems.

### Usage

```sh
git fsck [<options>]
```

#### Options

`--full`: Perform a full check, including looking for missing objects.

`--unreachable`: Print objects that are unreachable from any of the reference nodes.

`--lost-found`: Write dangling objects into `.git/lost-found`

`--name-objects`: Show object names

`--progress`: Show progress information during the check.

`--strict`: Enable more strict checking

`--dangling`: Show dangling objects

```
git fsck --full
git fsck --unreachable
git fsck --lost-found
git fsck --name-objects
git fsck --progress
git fsck --strict
git fsck --dangling
```

### What It Does

1. **Verifies Object Connectivity**: Ensures that all objects referenced by commits, trees, and other objects are present and properly linked.
2. **Checks Object Validity**: Validates the contents of each object to make sure they are correct and uncorrupted.
3. **Reports Issues**: Identifies and reports any issues found during the integrity check, such as dangling commits, missing blobs, or corrupted objects.

{% hint style="info" %}
**Dangling Objects**: These are objects (commits, blobs, trees) that are not reachable from any reference. They are not necessarily a problem but might indicate orphaned changes.

**Missing Objects**: These indicate corruption or incomplete transfer of the repository and need to be addressed to ensure the repository's integrity.

**Lost and Found**: Objects written to the `.git/lost-found` directory are still in the repository but are not reachable by any branch or tag. You can inspect these objects to determine if they are needed.
{% endhint %}

### Common Use Cases

```
-- Basic integrity check on the repository, reporting any issues found
git fsck

-- Performs a more thorough check, including looking for missing objects and ensuring all objects are correctly linked.
git fsck --full

-- Shows progress information during the integrity check, useful for large repositories
git fsck --progress
```

### Example Output

When running `git fsck`

<figure><img src="../../.gitbook/assets/image (4) (1) (1).png" alt="" width="476"><figcaption></figcaption></figure>

