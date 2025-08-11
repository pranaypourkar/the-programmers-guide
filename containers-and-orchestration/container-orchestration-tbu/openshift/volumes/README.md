# Volumes

## About

In OpenShift, **Volumes** provide **persistent or shared storage** to containers. While containers are ephemeral (i.e., data inside a container is lost once the container is stopped or restarted), Volumes help in **retaining data** beyond the container lifecycle.

## **Purpose of Volumes**

* Preserve data across container restarts and failures.
* Share data between containers in the same pod.
* Store logs, configuration, or application data.
* Enable stateful workloads like databases.

## Volume Types in OpenShift

In OpenShift, a **volume type** defines **how and where** data is stored and managed for a container or a pod. The choice of volume type impacts **data persistence, availability, portability, and performance**. OpenShift supports a wide range of volume types to cater to different application and infrastructure needs.

Below are the key volume types supported in OpenShift:

### **1. emptyDir**

This volume is created **empty** when a pod starts and exists as long as the pod is running. All containers in the pod can read and write to the same storage. Once the pod is deleted, the data in the `emptyDir` is lost.

It is useful for:

* Temporary scratch space.
* Inter-container communication within the same pod.
* Caching or buffering intermediate results.

It resides on the **node’s disk** and does **not persist across pod rescheduling** to another node.

{% hint style="success" %}
An **`emptyDir`** volume is **shared among all containers** **within the same pod**, not across different pods.
{% endhint %}

### **2. hostPath**

This volume maps a **file or directory on the host node’s filesystem** directly into the pod. It allows containers to access host-level files or storage.

Use cases include:

* Access to Docker daemon or other host resources.
* Debugging or troubleshooting tools.
* Specialized hardware interfacing.

It is **not recommended** for production in multi-node clusters due to tight coupling with the host node. It creates portability and security risks.

### **3. PersistentVolumeClaim (PVC)**

This is the most **production-ready and recommended** volume type in OpenShift. A PVC is a request for storage by a user, and it is backed by a PersistentVolume (PV), which is a cluster-managed storage resource.

It supports:

* Dynamic or static provisioning.
* Long-lived and stable storage.
* Reusability across application restarts and rescheduling.

PVCs are highly flexible and support integration with **cloud storage, block storage, NFS, and CSI drivers**.

### **4. configMap**

A `configMap` is a special type of volume used to **inject configuration data** into containers. It is mounted as a file or environment variable and is **read-only**.

It is commonly used for:

* Application properties.
* Environment-specific configuration.
* Key-value text-based settings.

Changes to the configMap may not reflect dynamically unless the container or pod is restarted, depending on how the application reads the config.

### **5. secret**

Similar to configMap, but used for **sensitive data** like passwords, tokens, or keys. This volume is **base64-encoded**, mounted as a file, and is **read-only**.

It helps in:

* Securing credentials.
* Managing access control.
* Avoiding hardcoding of secrets inside applications.

Secrets are stored in etcd and should be encrypted at rest for better security.

### **6. downwardAPI**

This volume type allows a pod to **expose its metadata or resource limits** to the container at runtime via files. It can provide information such as:

* Pod name
* Namespace
* Labels
* CPU or memory limits

It is helpful for observability and telemetry use cases where the application behavior depends on pod-level context.

### **7. projected**

A projected volume allows **combining multiple sources** into a single volume mount point. These sources can be:

* ConfigMap
* Secret
* downwardAPI
* ServiceAccountToken

It helps in simplifying access when the application needs multiple types of injected data in one location.

### **8. nfs (Network File System)**

This mounts a directory from an **NFS server** into the pod. It allows:

* Shared access across multiple pods.
* Centralized storage.
* Scalability for read-heavy workloads.

NFS volumes require a properly configured external server. They support all access modes, including **ReadWriteMany**, and are good for shared stateful workloads.

#### **9. CSI (Container Storage Interface)**

CSI is a standardized plugin model to support **third-party storage providers**. OpenShift supports various CSI drivers for cloud (AWS EBS, Azure Disk, GCP PD) and on-prem storage solutions (Ceph, Portworx, etc).

CSI volumes support:

* Dynamic provisioning
* Snapshots and cloning
* Advanced storage policies

CSI is the preferred model for modern storage integrations in OpenShift

### **10. cloud-specific volumes**

OpenShift supports volumes specific to cloud platforms:

* AWS EBS
* Azure Disk
* GCE Persistent Disk
* OpenStack Cinder

These are used for dynamically provisioned PVCs using storage classes specific to the platform.

### **11. ephemeral volumes**

These are volumes that do not persist beyond the lifecycle of a pod and include types like:

* `emptyDir`
* `ephemeral`
* `memory-backed tmpfs`

They are good for non-critical temporary data but unsuitable for databases or persistent applications.

### Comparison

<table data-full-width="true"><thead><tr><th>Volume Type</th><th>Persistent Across Pod Restarts</th><th>Shared Across Pods</th><th>Backed by External Storage</th><th>Read/Write Access</th><th>Typical Use Cases</th><th>Notes</th></tr></thead><tbody><tr><td><strong>emptyDir</strong></td><td>No</td><td>No (within same pod only)</td><td>No</td><td>Read-Write</td><td>Temporary storage, inter-container cache</td><td>Data deleted when pod is deleted</td></tr><tr><td><strong>hostPath</strong></td><td>Yes (if same node)</td><td>No</td><td>No</td><td>Read-Write</td><td>Access to host files, diagnostics</td><td>Tied to node; not portable or secure for production</td></tr><tr><td><strong>PersistentVolumeClaim (PVC)</strong></td><td>Yes</td><td>Yes (based on access mode)</td><td>Yes</td><td>RWO, ROX, RWX</td><td>Databases, app data, production workloads</td><td>Most flexible and production-ready option</td></tr><tr><td><strong>configMap</strong></td><td>No</td><td>No</td><td>No</td><td>Read-Only</td><td>Injecting config data</td><td>Designed for small text-based data</td></tr><tr><td><strong>secret</strong></td><td>No</td><td>No</td><td>No</td><td>Read-Only</td><td>Injecting passwords, tokens</td><td>Data is base64 encoded and should be encrypted</td></tr><tr><td><strong>downwardAPI</strong></td><td>No</td><td>No</td><td>No</td><td>Read-Only</td><td>Exposing pod metadata or resource limits</td><td>Helpful for self-aware containers</td></tr><tr><td><strong>projected</strong></td><td>No</td><td>No</td><td>No</td><td>Read-Only</td><td>Combining configMap, secret, etc., in one volume</td><td>Simplifies volume management</td></tr><tr><td><strong>nfs</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>RWX supported</td><td>Shared data access across pods, logs, shared state</td><td>Requires external NFS server</td></tr><tr><td><strong>CSI</strong></td><td>Yes</td><td>Yes (based on access mode)</td><td>Yes</td><td>RWO, RWX supported</td><td>Cloud &#x26; on-prem persistent storage, snapshots</td><td>Requires installation of appropriate CSI driver</td></tr><tr><td><strong>cloud-specific</strong> (EBS, GCE PD, Azure Disk, etc.)</td><td>Yes</td><td>No (usually)</td><td>Yes</td><td>RWO mostly</td><td>Dynamic provisioning in cloud-native apps</td><td>Managed by cloud, integrated with storage classes</td></tr><tr><td><strong>ephemeral / memory-backed (e.g., tmpfs)</strong></td><td>No</td><td>No</td><td>No</td><td>Read-Write</td><td>Lightweight scratch data, short-lived apps</td><td>Stored in memory; fast but non-persistent</td></tr></tbody></table>

## Persistent Volumes (PV) and Claims (PVC)

In OpenShift, **Persistent Volumes (PV)** and **Persistent Volume Claims (PVC)** provide a standardized way to manage **persistent storage** for stateful workloads such as databases, file stores, or user data.

#### **1. Problem with Container Storage**

By default:

* Containers are ephemeral: data is lost on restart or deletion.
* Applications that require persistent data (e.g., MySQL) need storage outside the container.

#### **2. What is a Persistent Volume (PV)?**

* A **cluster-level storage resource**.
* Represents **pre-provisioned** or **dynamically created** storage.
* Created by administrators or provisioned automatically.
* Not bound to a specific pod.

**Example:**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv001
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/data"
```

#### **3. What is a Persistent Volume Claim (PVC)?**

* A **request** for storage by a user or developer.
* Specifies size and access mode.
* Automatically gets bound to a matching PV.
* Used in the **Pod definition** to mount the storage.

**Example:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

#### **4. Binding Process**

* PVC is submitted by a developer.
* OpenShift matches it with an available PV based on:
  * Access mode (RWO, RWX, ROX)
  * Requested size
  * Storage class
* Once matched, they are **bound** and **linked** until the PVC is deleted.

## Access Modes

**Access Modes** define how a **Persistent Volume (PV)** can be mounted by **Pods** in an OpenShift cluster. They determine **who can read and/or write** to a volume and **from how many nodes** the volume can be accessed simultaneously.

### **Purpose of Access Modes**

* Controls **concurrency** and **sharing behavior** of storage.
* Helps determine whether a volume can be:
  * Mounted by one pod or many pods.
  * Read-only or read-write.
  * Shared across nodes or limited to one.

### **Types of Access Modes**

OpenShift supports the following access modes, depending on the **underlying storage backend**:

#### **a. ReadWriteOnce (RWO)**

* The volume can be **mounted as read-write by only one node**.
* Multiple pods on the same node can access it, but not across nodes.
* Most common mode; supported by block storage like AWS EBS, GCE Persistent Disks, etc.

**Use Cases:**

* Stateful applications like databases.
* Applications needing write access from a single instance.

#### **b. ReadOnlyMany (ROX)**

* The volume can be **mounted as read-only by many nodes**.
* Useful when multiple pods need to **read shared data**, like configs or reference files.

**Use Cases:**

* Shared documentation or training data.
* Serving static content in a distributed app.

#### **c. ReadWriteMany (RWX)**

* The volume can be **mounted as read-write by many nodes**.
* Allows **concurrent read-write access** from multiple pods across nodes.
* Requires a shared storage backend like NFS, GlusterFS, CephFS, or CSI drivers that support RWX.

**Use Cases:**

* Shared logs or files across a fleet of pods.
* Multi-instance applications that need common read/write access.

### **Access Mode vs Mount Behavior**

* Access mode is defined **on the PersistentVolume (PV)** and **requested by the PersistentVolumeClaim (PVC)**.
* The actual mount behavior is dictated by **what the underlying storage supports**.
* A PVC with a certain access mode will only bind to a PV that supports that access mode.

### **Access Modes and Storage Backends**

| Storage Type              | RWO | ROX | RWX |
| ------------------------- | --- | --- | --- |
| AWS EBS                   | Yes | No  | No  |
| GCE Persistent Disk       | Yes | No  | No  |
| Azure Disk                | Yes | No  | No  |
| NFS                       | Yes | Yes | Yes |
| GlusterFS                 | Yes | Yes | Yes |
| CephFS                    | Yes | Yes | Yes |
| OpenShift Data Foundation | Yes | Yes | Yes |

### **Access Mode Compatibility**

* We cannot bind a PVC requesting RWX to a PV that only supports RWO.
* The access mode must be **compatible** both ways.

## Reclaim Policies

**Reclaim Policies** define what happens to a **Persistent Volume (PV)** when the **Persistent Volume Claim (PVC)** that is bound to it is deleted.

### **Available Reclaim Policies**

OpenShift supports the following reclaim policies on Persistent Volumes:

#### **a. Retain**

* The **PV and its data are retained** even after the PVC is deleted.
* Volume becomes **Released**, but **not available** for new PVCs until manually reset.
* Administrator must manually:
  * Review data.
  * Clean or preserve it.
  * Reclaim or delete the PV.

**Use Cases:**

* Critical data where human review is necessary before deletion.
* Scenarios needing data archival or manual migration.
* When data is valuable and accidental deletion must be prevented.

**Behavior:**

1. PVC is deleted.
2. PV enters "Released" phase.
3. Admin can manually reclaim or delete the PV and underlying data.

#### **b. Delete**

* **PV and its underlying storage** are **automatically deleted** when the PVC is deleted.
* Applies only to **dynamically provisioned volumes**.
* Works well with cloud-based backends like AWS EBS, Azure Disk, or GCE Persistent Disk.

**Use Cases:**

* Short-lived environments (e.g., CI/CD pipelines, dev/test clusters).
* When data does not need to be retained post-deletion.
* Automates resource cleanup.

**Behavior:**

1. PVC is deleted.
2. PV is deleted automatically.
3. Backend storage (e.g., disk or file share) is also removed.

#### **c. Recycle** _(Deprecated)_

* Attempts to **wipe the volume’s content** (basic deletion) and make the PV available again.
* Uses a simple `rm -rf` strategy.
* Deprecated in favor of external provisioners or StorageClass reclaim handling.

**Use Cases:**

* Not recommended.
* Not used in modern OpenShift setups.

### **Configuration Example**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/data
```

### **Reclaim Policy Lifecycle**

| Step                         | Retain Policy       | Delete Policy          |
| ---------------------------- | ------------------- | ---------------------- |
| PVC Created                  | PV is bound         | PV is bound            |
| PVC Deleted                  | PV becomes Released | PV and storage deleted |
| Admin Action Required?       | Yes                 | No                     |
| Data Available Post-Deletion | Yes                 | No                     |

## Volume & VolumeMounts in Pods

In OpenShift, **Volumes** and **VolumeMounts** are used to provide containers inside a pod with access to **external or persistent storage**. This is necessary because containers are ephemeral — their internal file system is wiped on restart.

### **Volume in Pod**

A **Volume** is defined in the **pod specification** and refers to a **storage source** that can be mounted into one or more containers inside the pod.

A volume can be:

* **Ephemeral** (like `emptyDir`)
* **Persistent** (via `persistentVolumeClaim`)
* **Specialized** (like `configMap`, `secret`, `hostPath`, etc.)

**Pod-Level Definition:**

```yaml
spec:
  volumes:
    - name: shared-data
      emptyDir: {}
```

This volume is accessible to all containers in the pod that choose to mount it.

### **VolumeMount in Container**

A **VolumeMount** is a declaration **inside a container spec** that tells:

* Which **volume** to mount
* Where to mount it inside the container's filesystem
* Whether it should be **read-only** or **read-write**

**Container-Level Definition:**

```yaml
spec:
  containers:
    - name: app
      image: myimage
      volumeMounts:
        - name: shared-data
          mountPath: /app/data
```

This mounts the volume named `shared-data` into the `/app/data` directory inside the container.

### **Relationship**

| Element        | Defined At      | Purpose                                              |
| -------------- | --------------- | ---------------------------------------------------- |
| `volumes`      | Pod level       | Declares the available storage sources               |
| `volumeMounts` | Container level | Declares how and where the container uses the volume |

A volume must be:

* Declared once under `volumes` at the pod level.
* Mounted one or more times using `volumeMounts` under container spec.

#### **Example: Using PersistentVolumeClaim**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  volumes:
    - name: my-storage
      persistentVolumeClaim:
        claimName: mypvc
  containers:
    - name: myapp
      image: myimage
      volumeMounts:
        - name: my-storage
          mountPath: /data
```

In this example:

* A volume is created from a **PersistentVolumeClaim**.
* It is mounted at `/data` inside the `myapp` container.

#### **ReadOnly Option**

We can specify the volume mount as **read-only**:

```yaml
volumeMounts:
  - name: my-storage
    mountPath: /data
    readOnly: true
```

#### **Shared Volumes**

Multiple containers in the same pod can **mount the same volume**, which enables:

* **Data sharing**
* **Sidecar patterns** (e.g., log shipping container)
