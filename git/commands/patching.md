# Patching

## git apply

### Description

It is used to apply a patch to files and/or to the index. Patches are typically created using the `git diff` or `git format-patch` commands and can represent changes between different states of the repository. This command allows you to take these patches and apply them to your working directory or staging area.

### Usage

```sh
git apply [<options>] [<patch>...]
```

#### Options

`--check`: Check if the patch can be applied cleanly without actually applying it.

`--index`: Apply the patch to the index (staging area) as well as the working directory.

`--reverse`: Apply the patch in reverse (undo the changes).

`--whitespace=<action>`: Handle whitespace errors; `<action>` can be `nowarn`, `warn`, `fix`, or `error`

`--reject`: Leave the rejected hunks in corresponding `.rej` files instead of applying them partially.

`--apply`: Explicitly apply the patch (default action).

```
git apply --check patchfile.patch
git apply --index patchfile.patch
git apply --reverse patchfile.patch
git apply --whitespace=fix patchfile.patch
git apply --reject patchfile.patch
git apply --apply patchfile.patch
```

### What It Does

1. **Applies Patches**: Reads a patch file and applies the changes it contains to the working directory or index.
2. **Supports Various Options**: Allows for customization of how the patch is applied, such as applying it in reverse or with fuzz tolerance.

### Common Use Cases

```
-- Apply a Patch to the Working Directory
-- Applies the changes in patchfile.patch to the files in the working directory
git apply patchfile.patch

-- Apply a Patch with Fuzz Tolerance
-- Applies the patch even if there are minor differences (fuzz tolerance) and fixes whitespace errors.
git apply --apply --whitespace=fix patchfile.patch

-- Dry Run
-- Checks if the patch can be applied cleanly without actually applying it.
git apply --check patchfile.patch
```

### Example Workflow

```
-- Create a patch file using git diff or git format-patch
-- This creates a patch file with the current differences in the working directory.
git diff > my_changes.patch

-- Apply the Patch
-- Applies the changes from my_changes.patch to your working directory
git apply my_changes.patch

-- Check Before Applying
-- checks if the patch can be applied cleanly without actually applying it
git apply --check my_changes.patch

-- Fix Whitespace Errors
-- applies the patch and fixes any whitespace errors encountered
git apply --whitespace=fix my_changes.patch
```

### Example Output

When running `git apply patchfile.patch.` This indicates that the patch could not be applied cleanly to `file.c` at line 10.

<figure><img src="../../.gitbook/assets/image (1).png" alt="" width="308"><figcaption></figcaption></figure>

## git am

### Description



### Usage



