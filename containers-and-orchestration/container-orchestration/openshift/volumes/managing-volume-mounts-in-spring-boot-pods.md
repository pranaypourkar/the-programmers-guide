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

A **ConfigMap** in OpenShift is a key-value store used to manage **non-sensitive configuration data** independently from container images.

By mounting a ConfigMap as a **volume** into a **Spring Boot pod**, we can:

* Externalize application configuration
* Avoid rebuilding images for configuration changes
* Support environment-specific setups (e.g., dev, test, prod)
* Override default configurations such as `application.properties`, YAML files, logging configurations, or arbitrary static files

### **Internal Flow of Mounting a ConfigMap as a Volume**

1. A **ConfigMap** is defined containing configuration content (e.g., `application.properties`).
2. The ConfigMap is **mounted into a directory inside the container’s file system** using a volume and volumeMount.
3. Spring Boot is configured to load its config files from that directory.
4. On container startup, Spring Boot reads the file(s) as if they were on the local file system.

This approach allows runtime reconfiguration **without rebuilding the image**, and even supports **rolling updates** on config changes.

### **Spring Boot Configuration Mechanism**

Spring Boot supports **external configuration** through various sources in a specific order:

1. Command-line arguments
2. Environment variables
3. `application.properties` or `application.yml` files on the classpath
4. Files in directories specified using `spring.config.location`

Mounting a ConfigMap into a path like `/config` and then pointing Spring Boot to load from there lets we **override default values inside the JAR**.

### Use Case: Inject externalized `application.properties` into a Spring Boot application

#### **Create `application.properties`**

Create a file named `application.properties` with the following content:

```properties
server.port=8081
app.title=Spring Boot ConfigMap Demo
logging.level.root=DEBUG
```

This file will be injected into the container through a ConfigMap.

#### **Create the ConfigMap**

Create a ConfigMap from the file:

```bash
kubectl create configmap spring-config --from-file=application.properties
```

This creates a ConfigMap named `spring-config` where the key is `application.properties` and the value is the content of the file.

We can verify:

```bash
kubectl describe configmap spring-config
```

Or use a YAML definition instead:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: spring-config
data:
  application.properties: |
    server.port=8081
    app.title=Spring Boot ConfigMap Demo
    logging.level.root=DEBUG
```

Apply it with:

```bash
kubectl apply -f configmap.yaml
```

#### **Modify Spring Boot Application**

Ensure the Spring Boot app:

1. Reads configuration from an **external directory**
2. Has a controller that uses the `app.title` value

**Controller Example:**

```java
@RestController
public class ConfigDemoController {

    @Value("${app.title:Default Title}")
    private String appTitle;

    @GetMapping("/title")
    public String getTitle() {
        return appTitle;
    }
}
```

**Important:** This value must be picked up from the ConfigMap file mounted in the pod.

#### **Step 4: Create Deployment with Volume Mount**

Create a deployment that:

* Mounts the ConfigMap into `/config`
* Tells Spring Boot to load config from `/config/application.properties`

**springboot-deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springboot
  template:
    metadata:
      labels:
        app: springboot
    spec:
      containers:
        - name: springboot-container
          image: your-registry/springboot-app:latest
          args: ["--spring.config.location=file:/config/"]
          ports:
            - containerPort: 8081
          volumeMounts:
            - name: config-volume
              mountPath: /config
              readOnly: true
      volumes:
        - name: config-volume
          configMap:
            name: spring-config
```

Apply it:

```bash
kubectl apply -f springboot-deployment.yaml
```

#### **Expose the Application**

```bash
kubectl expose deployment springboot-app --type=NodePort --port=8081
```

Or in OpenShift:

```bash
oc expose deployment springboot-app --port=8081
```

Get the URL:

```bash
oc get route
```

#### **Test the Endpoint**

Access:

```
http://<route-or-nodeport-url>/title
```

Expected output:

```
Spring Boot ConfigMap Demo
```

This confirms that:

* The application read config from the mounted `/config/application.properties`
* The ConfigMap is functioning correctly

## 3. Mounting Secrets as Volumes

A **Secret** in OpenShift is a Kubernetes object used to store **sensitive data** such as:

* Database credentials
* API keys
* OAuth tokens
* TLS certificates

Mounting Secrets as **volumes** into a **Spring Boot pod** enables the application to **securely access sensitive configuration** at runtime without hardcoding or baking credentials into container images.

Secrets are base64-encoded and are mounted into the container’s file system as **plain files**. These files can then be read by the Spring Boot application as needed.

### **Internal Behavior of Secret Volumes**

1. A Secret object is created, containing key-value pairs.
2. The pod declares a `volume` from the secret and a corresponding `volumeMount` to define the mount path.
3. Kubernetes injects the contents of each secret key as a **separate file** in the specified directory.
4. Spring Boot (or other application logic) reads the secrets from disk, either during startup or on demand.

Each key becomes a file with the key as filename and the value as its contents.

### **When to Use Secrets as Volumes**

* When we do **not** want to expose sensitive data through environment variables.
* When external libraries or tools (e.g., database clients, messaging clients, TLS consumers) expect config as files.
* When we want to **rotate secrets dynamically** (e.g., mount a new TLS cert).

### Use Case: Injecting Database Credentials into a Spring Boot App

#### **Create the Kubernetes Secret**

**Imperative Method (using CLI)**

```bash
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=secret123
```

This creates a Secret named `db-credentials` with two keys: `username` and `password`.

**Declarative YAML Alternative**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
data:
  username: YWRtaW4=        # base64 encoded "admin"
  password: c2VjcmV0MTIz    # base64 encoded "secret123"
```

#### **Mount the Secret into the Spring Boot Pod**

**Deployment YAML Snippet**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springboot-app
  template:
    metadata:
      labels:
        app: springboot-app
    spec:
      containers:
        - name: springboot-container
          image: myregistry/springboot-app:latest
          volumeMounts:
            - name: db-secret-volume
              mountPath: /secrets
              readOnly: true
          env:
            - name: SPRING_CONFIG_ADDITIONAL_LOCATION
              value: "file:/secrets/"
      volumes:
        - name: db-secret-volume
          secret:
            secretName: db-credentials
```

#### **Spring Boot Code to Read Credentials**

We can use either:

**Option 1: `@Value` with `file:` syntax**

**`application.properties`**

```properties
spring.datasource.url=jdbc:mysql://mysql:3306/mydb
spring.datasource.username=${file:/secrets/username}
spring.datasource.password=${file:/secrets/password}
```

Spring Boot will read the contents of the file `/secrets/username` and `/secrets/password`.

Make sure to pass `SPRING_CONFIG_ADDITIONAL_LOCATION=file:/secrets/` as an environment variable or as a `--spring.config.additional-location` argument in our container.

**Option 2: Read files programmatically**

```java
import java.nio.file.Files;
import java.nio.file.Paths;

@Service
public class DbCredentialService {

    public String getUsername() throws IOException {
        return Files.readString(Paths.get("/secrets/username")).trim();
    }

    public String getPassword() throws IOException {
        return Files.readString(Paths.get("/secrets/password")).trim();
    }
}
```

We can then use this service in our DB configuration or elsewhere.

#### **Configure our DataSource (Optional)**

If we are manually configuring our `DataSource`, we can use the credential service above:

```java
@Bean
public DataSource dataSource(DbCredentialService credentialService) throws IOException {
    DataSourceBuilder<?> dataSourceBuilder = DataSourceBuilder.create();
    dataSourceBuilder.url("jdbc:mysql://mysql:3306/mydb");
    dataSourceBuilder.username(credentialService.getUsername());
    dataSourceBuilder.password(credentialService.getPassword());
    return dataSourceBuilder.build();
}
```
