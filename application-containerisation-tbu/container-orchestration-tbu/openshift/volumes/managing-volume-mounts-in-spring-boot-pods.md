# Managing Volume Mounts in Spring Boot Pods

## About

Spring Boot applications running inside containers often require access to:

* Persistent storage (e.g., for file uploads, logs, or databases)
* Externalized configurations (e.g., `application.properties`, YAML files)
* Secrets (e.g., database passwords, tokens)

Kubernetes and OpenShift provide a declarative way to **mount these as volumes** into pods so that applications can access them like regular files.

## **Types of Volume Mounts for Spring Boot Apps**

| Volume Type                 | Purpose                                        |
| --------------------------- | ---------------------------------------------- |
| PersistentVolumeClaim (PVC) | Store and retain application data persistently |
| ConfigMap                   | Inject application configuration files         |
| Secret                      | Inject sensitive data like passwords           |

## 1. Mounting a PersistentVolumeClaim (PVC)

A Spring Boot application may need to:

* Store or access files beyond its container lifecycle.
* Persist logs, uploads, reports, caches, or temporary working data.
* Retain state across pod restarts or re-deployments.

Since containers are ephemeral, persistent storage must be mounted into the pod using a **PVC**.

{% hint style="success" %}
A **PersistentVolumeClaim (PVC)** is a user request for storage. It:

* Specifies size and access requirements (e.g., 10Gi, ReadWriteOnce).
* Is bound to an available **PersistentVolume (PV)** that satisfies the request.
* Abstracts the storage backend from the application (block storage, file system, cloud disk, etc.).
* Is referenced inside the pod to mount the storage.
{% endhint %}

### **Internal Flow of PVC Mounting**

**Step-by-step Kubernetes (OpenShift) mechanics:**

1. **User defines a PVC** in a YAML manifest.
2. The **OpenShift controller** checks for an available **PV** that satisfies the request (capacity, access mode, storage class).
3. If found, the PVC is **bound** to that PV.
4. During **pod scheduling**, the container runtime (like CRI-O) **mounts the volume** from the node (or network) into the pod at the specified path.
5. Inside the container, the mount path behaves like a native directory.

If using **dynamic provisioning**:

* A StorageClass is used.
* A new PV is created on-the-fly using the storage plugin (e.g., AWS EBS, Ceph, NFS).
* The PVC binds to that PV automatically.

### **Access Mode Considerations**

The PVC must have an access mode compatible with how the Spring Boot app is deployed:

* **ReadWriteOnce (RWO)**: One pod on one node can mount as read-write.
* **ReadWriteMany (RWX)**: Multiple pods (across nodes) can mount concurrently.

Use RWX for clustered Spring Boot apps needing shared state (e.g., shared cache or uploads).

{% hint style="info" %}
* **Spring Boot doesn’t manage storage**; it simply uses the file system.
* You must ensure that the mount path exists and has correct permissions.
* Spring Boot must have **read/write permissions** for that path.
* Avoid hardcoding paths in code. Use **externalized configuration** (e.g., environment variables or properties).
{% endhint %}

### **Use Case: File Upload Handling in Spring Boot Using PVC**

We are building a Spring Boot app deployed on OpenShift that:

* Lets users upload files via a REST API.
* Saves these files to `/data/uploads` directory.
* Ensures uploaded files **persist** across pod restarts.

#### **YAML Definitions**

#### **StorageClass** (if using dynamic provisioning)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs  # or another suitable CSI driver
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

#### **PersistentVolumeClaim**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: springboot-upload-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 10Gi
```

#### **Deployment (Spring Boot App Pod + PVC Mount)**

```yaml
yamlCopyEditapiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-file-upload
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springboot-file-upload
  template:
    metadata:
      labels:
        app: springboot-file-upload
    spec:
      containers:
        - name: app
          image: myregistry/springboot-upload:latest
          ports:
            - containerPort: 8080
          volumeMounts:
            - name: upload-storage
              mountPath: /data/uploads
          env:
            - name: FILE_UPLOAD_PATH
              value: /data/uploads
      volumes:
        - name: upload-storage
          persistentVolumeClaim:
            claimName: springboot-upload-pvc
```

#### **Spring Boot Application Code**

#### **application.properties**

```properties
app.upload.dir=${FILE_UPLOAD_PATH:/tmp/uploads}
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=20MB
```

This ensures:

* If `FILE_UPLOAD_PATH` is passed (via env), it’s used.
* Else, defaults to `/tmp/uploads`.

#### **File Upload Controller**

```java
@RestController
@RequestMapping("/upload")
public class FileUploadController {

    @Value("${app.upload.dir}")
    private String uploadDir;

    @PostConstruct
    public void init() throws IOException {
        Files.createDirectories(Paths.get(uploadDir));
    }

    @PostMapping
    public ResponseEntity<String> upload(@RequestParam("file") MultipartFile file) {
        try {
            Path path = Paths.get(uploadDir, file.getOriginalFilename());
            file.transferTo(path.toFile());
            return ResponseEntity.ok("Uploaded: " + path.toString());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to upload file.");
        }
    }
}
```

#### **Expected Behavior**

1. User uploads a file via REST.
2. File is stored under `/data/uploads` inside the container.
3. This directory is mapped to the PVC → meaning file is stored on the persistent volume.
4. If the pod crashes, the file remains available when the pod restarts.

#### **Testing the Workflow**

#### Upload a file using `curl`

```bash
curl -F "file=@test.txt" http://<pod-ip>:8080/upload
```

#### Check if the file persists after a pod restart

```bash
oc delete pod <springboot-pod-name>
oc get pods  # wait for new one to start
oc rsh <new-pod>
ls /data/uploads  # should still contain "test.txt"
```



### **Common Use Cases in Spring Boot**

<table><thead><tr><th width="204.290771484375">Use Case</th><th width="172.2109375">Mount Path</th><th>Notes</th></tr></thead><tbody><tr><td>File uploads</td><td><code>/data/uploads</code></td><td>Must persist even after app restarts</td></tr><tr><td>Exported reports</td><td><code>/data/reports</code></td><td>Can be backed up externally</td></tr><tr><td>Runtime temp storage</td><td><code>/tmp/data</code></td><td>Can use <code>emptyDir</code> or PVC if needed later</td></tr><tr><td>Log file persistence</td><td><code>/var/log/app</code></td><td>Useful for sidecar log shippers</td></tr><tr><td>Caches or binary blobs</td><td><code>/cache/store</code></td><td>Use with <code>ReadWriteMany</code> if clustered</td></tr></tbody></table>



## 2. Mounting ConfigMaps as Volumes





## 3. Mounting Secrets as Volumes











