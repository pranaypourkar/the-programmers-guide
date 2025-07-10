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

Depending on the base image (Ubuntu, Alpine, OpenJDK, etc.), you’ll typically find:

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





