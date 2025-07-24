# Container Filesystem

## About

A container filesystem is a **combination of image layers and a runtime writable layer**. It provides a full Linux file system experience inside a containerized environment, isolated from the host and from other containers.

The filesystem seen inside a container is:

* **Composed of layers** defined by the container image
* **Immutable in its base layers**
* **Overlaid with a writable layer** at runtime for file modifications
* **Ephemeral**, meaning changes do not persist across container restarts unless backed by external storage

## **Layered Image Filesystem Internals**

Each container image consists of multiple **read-only layers**. These are stacked in order and form the base of the filesystem. When a container runs:

* The container runtime (e.g., CRI-O in OpenShift) **creates a new top writable layer**
* All file operations inside the container interact with this top writable layer

If a process **reads a file**, it fetches it from the topmost layer where it exists

* If modified, it is copied from the lower layer into the writable layer (copy-on-write)
* If created, it exists only in the writable layer
* If deleted, it is masked in the writable layer

This filesystem stack is managed by a **union or overlay filesystem** (like `overlayfs`), abstracted by the container runtime.

## **Lifecycle and Persistence Characteristics**

Because the writable layer is created at **container start** and destroyed at **container exit**, the container’s default filesystem has these properties:

* **Non-persistent**: Any files written to default paths like `/`, `/tmp`, or `/var` are lost after the pod is deleted or restarted
* **Non-shared**: Files written inside one container are not accessible to another container (even within the same pod), unless explicitly shared via volumes
* **Isolated**: Container filesystem has no direct visibility into the host file system

This design enforces **statelessness** in containers and mandates use of **volumes** for persistence.

## **Filesystem Layout: What Exists Inside a Container**

Depending on the base image (Ubuntu, Alpine, OpenJDK, etc.), we’ll typically find:

* `/`: Root directory
* `/tmp`: Temporary files
* `/var`: Application data, logs
* `/etc`: Configuration files (read-only)
* `/usr`: Binaries and libraries
* `/home`: User home directory (optional)
* `/proc`, `/sys`, `/dev`: Pseudo-filesystems mounted by the runtime

Everything outside mounted volumes is within the ephemeral **container layer stack**.

### **The Role of `/tmp`**

The `/tmp` directory is almost universally present and writable. It is used by:

* Java and Spring Boot for temporary files
* Compilers, installers, and CLI tools
* Temporary downloads, caches, and extracted content

Spring Boot, by default, writes uploaded multipart files to `/tmp`.

However:

* It exists only in the container's ephemeral layer
* Once the pod restarts, the contents of `/tmp` are lost
* It should not be used to store anything that must survive restarts or be accessed across replicas

## **Filesystem with Volumes: Overlay Behavior**

When a volume is mounted into a container in OpenShift or Kubernetes, it interacts with the container’s existing filesystem in a very specific way. This behavior is important to understand because it affects what the application can see and access at the mount path.

By default, every container has a complete Linux-like filesystem derived from the image it is built from. This includes standard directories such as `/app`, `/etc`, `/tmp`, `/usr`, and so on.

However, when we mount a volume into a specific path inside the container (for example, mounting a PersistentVolumeClaim to `/data`), the system performs what is known as a **bind mount**. This action **overrides** whatever was present in that path inside the original container image.

This means:

* The mounted volume becomes the new content of that directory inside the container.
* The original files or folders at that mount path (as defined in the image) are **hidden** or **masked**.
* Only the data present in the volume is now visible to the application.

This behavior is part of how **overlay or union filesystems** work in container runtimes. The volume effectively **replaces** that section of the image's filesystem during runtime.

{% hint style="success" %}
Suppose our container image has a directory `/config` that contains some pre-built default configuration files. We then mount a `ConfigMap` to `/config`.

Now:

* The original files in `/config` that were part of the image are no longer visible.
* Only the files from the ConfigMap are available in `/config` inside the running container.

If the ConfigMap contains fewer files than what was in the image, the missing files from the image will not be accessible anymore.

This behavior is important to keep in mind because:

1. If we accidentally mount a volume to a path that already contains important files from the image, we will lose access to those files during runtime.
2. If our application depends on pre-existing configuration files, scripts, or binaries at a path where we mount a volume, those resources will be hidden unless we ensure the volume includes everything needed.
3. Mounting over sensitive paths like `/etc`, `/usr`, or `/lib` can cause containers to fail at runtime due to missing system files or broken dependencies.
{% endhint %}

## **Filesystem Security Context and Permissions**

When we run containers in OpenShift, they are **not allowed to run as root by default**. This means the filesystem inside the container is subject to specific **user, group, and permission rules**, which can affect whether the container can read from or write to certain directories.

This is controlled through the **Security Context** and the **filesystem permissions** applied to mounted volumes and internal paths.

#### **Why OpenShift Does Not Allow Root Containers by Default**

OpenShift follows **Security-Enhanced Linux (SELinux)** and other policies to isolate workloads and prevent privilege escalation. As a result:

* Containers are assigned **random, non-root UIDs** at runtime.
* The container runs as a user that is **not known in the container’s `/etc/passwd`** file.
* The container cannot access files or directories that require root privileges unless explicitly permitted.

This is done to improve isolation and reduce risk.

#### **What Problems Can Arise**

Because the container runs as a random UID, it might face permission issues when trying to:

* Write to a directory that expects a specific user (e.g., owned by `root`)
* Access mounted volumes that are not readable or writable by the container’s UID
* Use directories with restrictive permissions (e.g., `/var`, `/data`, `/logs`)

For example:

* A Spring Boot app that writes to `/data/uploads` will fail if that directory is not writable by the UID the container is using.
* A PVC mounted to `/cache` might be inaccessible if it is owned by `root:root` and does not grant group or world write permissions.

#### **Understanding File Ownership Inside Containers**

Linux files and directories have:

* A **user owner**
* A **group owner**
* A **set of permissions**: read, write, execute for user, group, and others

When a container tries to write to a path:

* The process checks if the current UID has write permission
* If the container's UID does not match the file or directory’s owner, and group/others also lack write permissions, the write will fail

#### **Security Context in OpenShift Pod Specifications**

OpenShift allows we to define a **security context** in our pod/deployment YAML to control how the container interacts with the filesystem.

Key fields:

* `runAsUser`: Specify a fixed UID instead of a random one
* `fsGroup`: Assigns a group ID to the container and mounted volumes
  * All mounted volumes will be owned by this group
  * The container gains group-level access
* `runAsNonRoot`: Ensures container does not run as UID 0
* `readOnlyRootFilesystem`: Makes the entire container filesystem read-only except for explicitly writable volumes

#### **fsGroup: How It Solves Write Access Issues**

If we mount a PVC and the container cannot write to it, setting `fsGroup` helps.

Example:

```yaml
securityContext:
  fsGroup: 1000
```

This makes all mounted volumes accessible to group `1000`, and the container process is added to this group.

This is especially useful when:

* The storage backend (like NFS) does not support dynamic UID mapping
* Our app image does not run as root
* We need a consistent way to grant write access to volume

#### **Pre-configuring Permissions with Init Containers**

If fine-grained control is needed, we can use an **init container** to prepare the volume before the main app starts.

The init container can:

* Run as root (if allowed)
* Create directories
* Set correct ownership (`chown`) and permissions (`chmod`)

This prepares the mounted volume so that the application container (running as non-root) can write to it.

