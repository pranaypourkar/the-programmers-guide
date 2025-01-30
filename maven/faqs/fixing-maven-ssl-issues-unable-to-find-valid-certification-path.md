# Fixing Maven SSL Issues: Unable to Find Valid Certification Path

## About

When Maven fails to resolve an artifact due to an SSL issue, we may encounter an error like:

```lua
PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```

This usually means that the certificate used by the remote repository (e.g., Artifactory, Nexus, etc.) is not trusted by our Java runtime (JDK). To fix this, we need to import the missing certificate into the Java **cacerts** keystore.

## Steps to Fix

### Solution 1: Install Certificate

#### **1. Download the certificate**

If we haven't already, download the certificate (e.g., `artifactory-nginx-jfrog-apps-local.pem`).

#### **2. Import the certificate into the Java keystore**

Run the following command:

```sh
sudo keytool -importcert -alias artifactory-cert \
-keystore /Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/lib/security/cacerts \
-file /Users/pranayp/Downloads/artifactory-nginx-jfrog-apps-local.pem
```

{% hint style="info" %}
Update the path as needed
{% endhint %}

**Explanation of flags:**

* `-importcert` → Imports a certificate into a keystore.
* `-alias artifactory-cert` → Gives a unique alias to the certificate.
* `-keystore <path>` → Specifies the Java keystore file (`cacerts` is the default keystore used by Java).
* `-file <path>` → The location of the downloaded certificate.

#### **3. Enter the keystore password**

* The default password for Java's `cacerts` keystore is **`changeit`** unless it has been modified.

#### **4. Verify the import**

Run:

```sh
keytool -list -keystore /Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/lib/security/cacerts | grep artifactory-cert
```

If we see `artifactory-cert` in the output, the certificate has been successfully imported.

#### **5. Restart Maven and try again**

Run:

```sh
mvn clean install
```

If the issue was due to the missing certificate, this should now work.

### Solution 2: Use `JAVA_OPTS`  to specify external certificate

Instead of modifying the Java keystore, we can temporarily specify a custom truststore in our Maven command:

```sh
mvn clean install -Djavax.net.ssl.trustStore=/path/to/truststore -Djavax.net.ssl.trustStorePassword=changeit
```

This is useful if we don't want to modify the global Java keystore.
