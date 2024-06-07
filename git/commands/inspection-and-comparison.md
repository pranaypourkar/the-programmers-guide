# Inspection and Comparison

## git log

### Description

It is used to view the commit history of a Git repository. It shows a list of commits made to the repository, including details such as commit hash, author, date, and commit message. `git log` is highly customizable with various options to filter and format the output according to the needs.

### Usage

```sh
git log [<options>] [<revision range>] [[--] <path>…​]
```

#### Options

`--oneline`: Shows each commit as a single line.

`--graph`: Displays an ASCII graph of the branch and merge history.

`--decorate`: Adds branch and tag names to the commit display.

`--stat`: Shows the file changes (number of insertions and deletions) introduced by each commit.

`-p` or `--patch`: Shows the patch (diff) introduced by each commit.

`--author=<author>`: Filters commits by a specific author.

`--since=<date>`: Filters commits newer than a specific date.

`--until=<date>`: Filters commits older than a specific date.

`--grep=<pattern>`: Filters commits with a commit message that matches the given pattern

`-n <number>`: Limits the number of commits to show.

```
git log --oneline
git log --graph
git log --decorate
git log --stat
git log -p
git log --author="Author Name"
git log --since="2023-01-01"
git log --until="2023-12-31"
git log --grep="bug fix"
git log -n 10
```

### What It Does

1. **Displays Commit History**: Shows a list of commits with details such as commit hash, author, date, and commit message.
2. **Filters Commits**: Allows filtering commits by author, date, message, and more.
3. **Formats Output**: Provides various options to format the output, including graphs, pretty print, and custom formats.

{% hint style="info" %}
**Custom Formatting**: You can customize the output format using the `--pretty=format` option. For example:

```
git log --pretty=format:"%h - %an, %ar : %s"
```

**Filtering**: Combining multiple filters (author, date, message) can help you narrow down the commit history to relevant commits.

```
git log --author="Jane Doe" --since="2023-01-01" --until="2023-12-31" --grep="feature"
```

**File History**: Viewing the commit history for a specific file is useful for understanding how a file has evolved over time.

```
git log path/to/file
```
{% endhint %}

### Common Use Cases

```git
-- View the Commit History
-- Shows the commit history for the current branch
git log

-- View the Commit History for a Specific File
git log path/to/file

-- View a Graph of the Commit History
-- Displays the commit history as a graph of branches and merges
git log --graph

-- Pretty Print the Commit History
-- Shows each commit on a single line
git log --pretty=oneline

-- Filter Commits by Author
git log --author="Author Name"

-- Filter Commits by Date Range
git log --since="2023-01-01" --until="2023-12-31"

-- Show Changes Introduced by Each Commit
-- Displays the diffs introduced by each commit
git log -p
```

### Example Output

When running `git log`

<figure><img src="../../.gitbook/assets/image (170).png" alt="" width="479"><figcaption></figcaption></figure>



## git show

### Description

It is used to display detailed information about Git objects such as commits, tags, and blobs. It provides a combination of the functionalities of `git log` and `git diff`, showing the commit details along with the diff introduced by that commit. It is particularly useful for viewing the content changes and metadata of a specific commit or object.

### Usage

```sh
git show [<options>] <object>
```

#### Options

`--pretty=<format>`: Specifies the format for displaying commit information. Possible values include `oneline`, `short`, `medium`, `full`, `fuller`, `email`, and `raw`.

`-q` or `--quiet`: Suppresses diff output.

`--name-only`: Shows only the names of changed files.

`--name-status`: Shows the names and status of changed files.

`--stat`: Shows the stats of changes (number of insertions and deletions) introduced by the commit.

```
git show --pretty=short <commit-hash>
git show -q <commit-hash>
git show --name-only <commit-hash>
git show --name-status <commit-hash>
git show --stat <commit-hash>
```

### What It Does

1. **Displays Commit Information**: Shows details of the specified commit, including author, date, and commit message.
2. **Shows Changes Introduced**: Displays the diff of changes introduced by the specified commit.

{% hint style="info" %}
**Commit Hash**: The commit hash is a unique identifier for each commit. You can get the commit hash from `git log` or other Git commands.

**Filtering Changes**: You can use `git show` in combination with other options to filter and format the output to meet your specific needs.

**Quiet Mode**: Using the `-q` option suppresses the diff output, which can be useful if you're only interested in the commit metadata.

**File Path**: Specifying a file path limits the output to changes made to that file, helping to narrow down the details if a commit affects multiple files.
{% endhint %}

### Common Use Cases

```
-- Show a Specific Commit
-- Displays details and changes for the specified commit
git show <commit-hash>

-- Show the Latest Commit
-- Displays details and changes for the most recent commit on the current branch
git show

-- Show a Specific File Change in a Commit
-- Displays the changes for a specific file in the specified commit
git show <commit-hash> -- <file-path>
```

### Example Workflow

<pre><code>-- View the Latest Commit
git show

-- View a Specific Commit
git show 1a2b3c4d

-- View Only the Changed File Names in a Commit
-- This shows the names of the files changed in the specified commit
git show --name-only 1a2b3c4d

-- View a Specific File's Changes in a Commit
-- This shows the changes introduced to path/to/file.txt in the specified commit
git show 1a2b3c4d -- path/to/file.txt

<strong>-- View Commit Changes with Statistics
</strong><strong>-- This shows the number of insertions and deletions for each file changed in the specified commit
</strong>git show --stat 1a2b3c4d
</code></pre>

### Example Output

When running `git show <commit-hash>`

<figure><img src="../../.gitbook/assets/image (171).png" alt="" width="453"><figcaption></figcaption></figure>

## git blame

### Description

It is used to display the last modification of each line in a file along with the commit, author, and date that introduced the change. This command is particularly useful for identifying who last changed a specific line of code, and when it was changed, which can be valuable for debugging and code review purposes.

### Usage

```sh
git blame [<options>] <file>
```

### Options

`-L <start>,<end>`: Limits the blame output to the specified range of lines

`-w` or `--ignore-whitespace`: Ignores changes in whitespace

`-C`: Detects lines that have been moved or copied within the same file

`-M`: Detects lines that have been moved or copied from other files

`--since=<date>`: Limits the blame output to changes made since the specified date

`--until=<date>`: Limits the blame output to changes made until the specified date

`--show-name`: Shows the file name in the blame output

```
git blame -L 10,20 path/to/file
git blame -w path/to/file
git blame -C path/to/file
git blame -M path/to/file
git blame --since=2023-01-01 path/to/file
git blame --until=2023-12-31 path/to/file
git blame --show-name path/to/file
```

### What It Does

1. **Annotates Each Line**: Displays each line of the file with information about the commit, author, and date of the last modification.
2. **Helps Track Changes**: Identifies who made changes to specific lines and provides context for when and why the changes were made.

{% hint style="info" %}

{% endhint %}

### Common Use Cases

```
-- Blame a File
-- Shows the blame information for each line in the specified file
git blame path/to/file

-- Blame a Specific Range of Lines
-- Limits the blame output to a specific range of lines.
git blame -L <start>,<end> path/to/file

-- Ignore Whitespace Changes
-- Ignores changes in whitespace when assigning blame.
git blame -w path/to/file
```

### Example Workflow

```
-- Blame a File
-- This shows the blame information for each line in README.md
git blame README.md

-- Blame a Specific Range of Lines
-- This limits the blame output to lines 50 through 100 in README.md
git blame -L 50,100 README.md

-- Ignore Whitespace Changes
-- This ignores changes in whitespace when determining blame for README.md
git blame -w README.md
```

### Example Output

When running `git blame path/to/file`

<figure><img src="../../.gitbook/assets/image (172).png" alt="" width="553"><figcaption></figcaption></figure>
