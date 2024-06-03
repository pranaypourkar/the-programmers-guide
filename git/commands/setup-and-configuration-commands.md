# Setup and Configuration Commands

## git config

### Description

The `git config` command is used to configure Git settings on a global or local project level. It allows to set user preferences and customize Git's behavior.

### Usage

`git config` can be used to set, get, and list configuration variables that control aspects of Git’s operation and look. These variables can be stored at three different levels:

1. **System Level**: Applies to every user on the system and all their repositories.
2. **Global Level**: Applies to the current user and all their repositories.
3. **Local Level**: Applies to the repository in the current working directory. This is the highest priority and overrides the same variables at the system or global level.

### Basic Commands

#### **Setting Configuration Variables**

```git
git config [--system | --global | --local] <key> <value>

-- Example
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

#### **Getting Configuration Variables**

```git
git config [--system | --global | --local] --get <key>

-- Example
git config --global --get user.name
```

#### **Listing Configuration Variables**

```git
git config [--system | --global | --local] --list

-- Example
git config --global --list
```

#### **Unsetting Configuration Variables**

```git
git config [--system | --global | --local] --unset <key>

-- Example
git config --global --unset user.email
```

### Common Configuration Options

```git
-- Set User Information
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

-- Set Default Text Editor
git config --global core.editor "vim"
git config --global core.editor "C:\Users\prana\AppData\Local\Programs\Microsoft VS Code\bin\code"
git config --global core.editor "nano"

-- Set line endings
-- true: for converting LF to CRLF on checkout and CRLF to LF on commit (recommended on Windows).
-- input: for converting CRLF to LF on commit but not changing the files in the working directory (recommended on macOS and Linux).
-- false: to disable line ending conversion.
git config --global core.autocrlf true

-- Set Merge Tool
git config --global merge.tool meld

-- Enable color output
git config --global color.ui auto

-- Set alias
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
```

