# Internals of Git \[TBD]

## Description

Git's internal workings is quite complex, involving a range of data structures and algorithms to manage the repository's history, branches, commits, and more. Here's a high-level overview of some key aspects of Git's internal workings.

## Object Model

The object model in Git is a core component that underpins how Git stores and manages data. In Git, everything is stored as an object, and these objects are content-addressable, meaning they are referenced by a hash of their content. The primary types of objects in Git are blobs, trees, commits, and tags. Here's a detailed look at each of these objects and how they work together.

### Types of Git Objects

#### **1. Blob (Binary Large Object)**

* **Purpose:** Represents the content of a file.
* **Content:** Stores the raw file data (i.e., the contents of a file).
* **Identification:** Identified by a SHA-1 hash of the file content.
* **Metadata:** Does not store any metadata such as the file name or permissions.

<figure><img src="../.gitbook/assets/image (402).png" alt="" width="563"><figcaption></figcaption></figure>

Example of creating a blob:

```
echo "Hello, Git!" > hello.txt
git add hello.txt
# Creates a blob for hello.txt
```

#### **2. Tree**

* **Purpose:** Represents a directory and its contents.
* **Content:** Contains references (hashes) to blobs and other trees, along with the associated metadata (file names, types, and modes).
* **Identification:** Identified by a SHA-1 hash of its contents.

<figure><img src="../.gitbook/assets/image (406).png" alt="" width="563"><figcaption></figcaption></figure>

Example of creating a tree:

```
git write-tree
```

#### **3. Commit**

* **Purpose:** Represents a snapshot of the repository at a point in time.
* **Content:** Contains metadata (author, committer, message), a reference to a tree object (the state of the file system), and references to parent commits.
* **Identification:** Identified by a SHA-1 hash of its contents.

Example of creating a commit:

```
git commit -m "Initial commit"
```

#### **4. Tag**

* **Purpose:** Marks a specific commit as significant, often used to mark release points.
* **Content:** Contains metadata (tagger, message) and a reference to a commit object.
* **Identification:** Identified by a SHA-1 hash of its contents.

Example of creating an annotated tag:

```
git tag -a v1.0 -m "Version 1.0"
```

### How Objects are Stored

* **Content-Addressable Storage:**
  * Git uses SHA-1 hashes to uniquely identify each object. The SHA-1 hash is derived from the content of the object.
  * The content of each object is stored in the `.git/objects` directory in a subdirectory named after the first two characters of the hash, with the remaining characters as the filename.
* **Loose Objects and Packed Objects:**
  * **Loose Objects:** Individual files stored in the `.git/objects` directory. These are typically created during initial commits.
  * **Packed Objects:** Over time, loose objects are packed into packfiles to save space and improve performance. Packfiles are stored in the `.git/objects/pack` directory.

### Object Creation and Relationship

* **Blob Creation:**
  * When we add a file to Git (`git add`), Git creates a blob object containing the file's content.
* **Tree Creation:**
  * When you commit changes (`git commit`), Git creates a tree object representing the directory structure, containing references to blob objects for files and other tree objects for subdirectories.
* **Commit Creation:**
  * A commit object is created referencing the tree object and containing metadata about the commit (author, message, parent commits).
* **Tag Creation:**
  * A tag object is created to reference a specific commit, often annotated with additional information (tagger, message).

### Object Model Visualization

Here's a simple visualization of how these objects might be linked together.

<figure><img src="../.gitbook/assets/image (400).png" alt="" width="374"><figcaption></figcaption></figure>

### Inspecting Git Objects

```
-- List all objects
git rev-list --all --objects

-- View object type and size
git cat-file -t <object-hash>
git cat-file -s <object-hash>

-- View object content
git cat-file -p <object-hash>
```

Reference - [https://towardsdatascience.com/how-git-truly-works-cd9c375966f6](https://towardsdatascience.com/how-git-truly-works-cd9c375966f6)
