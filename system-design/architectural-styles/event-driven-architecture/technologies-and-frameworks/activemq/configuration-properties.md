# Configuration Properties

## **Connection Properties**

These properties configure how your application connects to the **ActiveMQ broker**, either remote or embedded. Proper configuration ensures reliable communication between your application and the messaging system.

<table data-full-width="true"><thead><tr><th width="166.43145751953125">Property</th><th width="477.11376953125">Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.activemq.broker-url</code></td><td>Specifies the <strong>URI of the ActiveMQ broker</strong> that our application should connect to. This can be a simple TCP URI, or a failover URI to enable high availability.</td><td><p><code>spring.activemq.broker-url=tcp://localhost:61616</code><br></p><p><code>spring.activemq.broker-url=failover:(tcp://localhost:61616,tcp://backup:61616)</code></p></td></tr><tr><td><code>spring.activemq.user</code></td><td>The <strong>username</strong> used to authenticate with the broker. Required if the broker has security enabled.</td><td><code>spring.activemq.user=admin</code></td></tr><tr><td><code>spring.activemq.password</code></td><td>The <strong>password</strong> for the above user to authenticate with the broker. Keep this secure and do not hardcode it in source files.</td><td><code>spring.activemq.password=admin123</code></td></tr><tr><td><code>spring.activemq.in-memory</code></td><td>If set to <code>true</code>, Spring Boot will create an <strong>embedded (in-memory) ActiveMQ broker</strong> for local development or testing purposes. Not used in production.</td><td><code>spring.activemq.in-memory=true</code></td></tr></tbody></table>

## **Security and Serialization**

These properties manage how objects are deserialized from messages received from ActiveMQ. **Improper configuration can lead to security vulnerabilities**, such as arbitrary code execution during deserialization.

<table data-full-width="true"><thead><tr><th width="190.65020751953125">Property</th><th>Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.activemq.packages.trust-all</code></td><td>When set to <code>true</code>, all incoming serialized Java objects are <strong>trusted for deserialization</strong>. This is <strong>insecure and risky</strong> in production.</td><td><code>spring.activemq.packages.trust-all=true</code> (only for development/testing)</td></tr><tr><td><code>spring.activemq.packages.trusted</code></td><td>Defines a <strong>comma-separated list of package names</strong> whose classes are trusted for deserialization. This is the <strong>secure approach</strong>.</td><td><code>spring.activemq.packages.trusted=com.myapp.model,com.myapp.dto</code></td></tr></tbody></table>

















