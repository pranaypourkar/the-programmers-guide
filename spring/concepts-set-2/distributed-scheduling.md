# Distributed Scheduling

In Spring Boot, if we need to execute tasks at a scheduled time, we can use **@Scheduled** annotation. However, if there are multiple instances of the application and if we want to ensure that a scheduled task runs only once across all instances, in such case we need distributed scheduling.

There are different libraries that support distributed scheduling such as **ShedLock** , **Quartz** , **Akka Scheduler** etc.

### ShedLock

ShedLock is a library which is used for distributed locking in scheduled tasks. It ensures that scheduled tasks (such as cron jobs) are executed only once in a distributed environment, even if the application is running on multiple nodes. It uses an external storage mechanism (like a database or cache) to keep track of running schedulers and acquired locks. ShedLock supports multiple lock providers like JDBC, Redis, Zookeeper etc.

#### How Shedlock Works

* **Lock Provider**: Shedlock relies on a lock provider, which is a bean configured in the Spring Boot application. This bean depends on the type of storage chosen (e.g., database, Redis).
* **Acquiring the Lock**: When a scheduled task is due for execution, each Spring Boot instance tries to acquire a lock for that task through the lock provider.
* **Shared Storage**: Shedlock uses the lock provider to interact with the chosen storage system (e.g., database table or Redis key). If no other instance has already acquired the lock, the current instance can lock it for the task's execution duration.
* **Task Execution**: Once a lock is acquired, only that specific instance proceeds to execute the scheduled task.
* **Releasing the Lock**: After successful task execution, the lock is released using the lock provider, allowing other instances to potentially acquire it for the next scheduled run.

For more details, visit the site - https://github.com/lukas-krecan/ShedLock

#### Use cases

1. Handling Recurring Jobs with External Dependencies:

**Generating and Sending Reports**: If there is a task that involves fetching data from external APIs, generating reports, and sending them via email, scheduler locks ensure only one instance sends those emails, preventing duplicates and potential overload.

**External Data Updates**: Tasks that pull data from external sources and update your database can benefit from scheduler locks to avoid conflicting updates and ensure consistency.

2. Long-Running Tasks with Progress Updates:

**Data Processing and Transformation**: For tasks that involve processing large datasets or lengthy file operations, scheduler locks prevent multiple instances from starting the same work, saving resources and ensuring correct completion.

**Batch Updates**: Tasks that perform batch updates or data migrations can leverage scheduler locks to prevent conflicts and ensure data integrity.

#### Example: Using JDBC (mysql) as a lock provider.

Add the required dependency in pom.xml file.

```xml
<dependency>
    <groupId>net.javacrumbs.shedlock</groupId>
    <artifactId>shedlock-spring</artifactId>
    <version>5.12.0</version>
</dependency>

<dependency>
    <groupId>net.javacrumbs.shedlock</groupId>
    <artifactId>shedlock-provider-jdbc-template</artifactId>
    <version>5.12.0</version>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.31</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

{% hint style="info" %}
With **spring-boot-starter-data-jpa** dependency added and the database configuration properties specified in the`application.yml`, Spring Boot will automatically configure and create a DataSource bean.
{% endhint %}

Access the **mysql** database instance via mysql workbench and create the table manually which is to be used by the SchedulerLock.

<figure><img src="../../.gitbook/assets/image (251).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Note that table structure is created as per documentation given on the site -

[https://github.com/lukas-krecan/ShedLock?tab=readme-ov-file#jdbctemplate](https://github.com/lukas-krecan/ShedLock?tab=readme-ov-file#jdbctemplate)

\
Mysql server instance is created using docker-compose method.

_**docker-compose.yaml**_

```yaml
version: "3.9"
# https://docs.docker.com/compose/compose-file/

services:
  db-mysql:
    container_name: db-mysql
    image: mysql:8.0.29
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
    driver: local

networks:
  default:
    name: company_default
```
{% endhint %}

Create Scheduler lock configuration class **ShedlockConfig.java**

```java
package org.example.config;

import net.javacrumbs.shedlock.core.LockProvider;
import net.javacrumbs.shedlock.provider.jdbctemplate.JdbcTemplateLockProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class ShedlockConfig {
    @Bean
    public LockProvider lockProvider(DataSource dataSource) {
        return new JdbcTemplateLockProvider(
                JdbcTemplateLockProvider.Configuration.builder()
                        .withJdbcTemplate(new JdbcTemplate(dataSource))
                        .usingDbTime()
                        .build()
        );
    }
}
```

{% hint style="info" %}
As per documentation given in the main site, by specifying **usingDbTime()** the lock provider will use UTC time based on the DB server clock. If we do not specify this option, clock from the app server will be used (the clocks on app servers may not be synchronized thus leading to various locking issues). It's strongly recommended to use usingDbTime() option as it uses DB engine specific SQL that prevents INSERT conflicts.
{% endhint %}

Create **ScheduledTasks.java** file which has the logic to be performed at the scheduled time.

```java
package org.example.service;

import lombok.extern.slf4j.Slf4j;
import net.javacrumbs.shedlock.spring.annotation.SchedulerLock;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ScheduledTasks {

    @Scheduled(fixedRate = 60000) // Schedule every minute
    @SchedulerLock(name = "sampleTask", lockAtMostFor = "50m")
    public void sampleTask() {
        log.info("Sample Task Started");
        // Add some logic
        log.info("Sample Task Completed");
    }
}
```

{% hint style="info" %}
The `lockAtMostFor` parameter in ShedLock specifies the maximum duration for which a lock can be held. It is expressed as a duration string, such as `"50m"`, where `m` represents minutes.`lockAtMostFor = "50m"` means that ShedLock will acquire a lock for a maximum duration of 50 minutes. If the task execution exceeds this duration, ShedLock will forcefully release the lock.

This parameter helps prevent potential issues such as deadlocks or long-running tasks holding locks indefinitely, ensuring that locks are released after a reasonable period even if the task encounters unexpected delays or failures.
{% endhint %}

Enable Scheduling and Scheduler lock in the main **application.java** file.

```java
package org.example;

import net.javacrumbs.shedlock.spring.annotation.EnableSchedulerLock;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;


@EnableScheduling
@EnableSchedulerLock(defaultLockAtMostFor = "PT20S")
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class);
    }
}
```

{% hint style="info" %}
Note that **defaultLockAtMostFor** is defined at the @**EnableSchedulerLock** level as well.

ShedLock resolves the lock duration based on the following precedence:

1. If a specific lock duration is provided in the `@SchedulerLock` annotation, it takes precedence over any default lock duration set by `@EnableSchedulerLock`.
2. If no lock duration is provided in the `@SchedulerLock` annotation, but `@EnableSchedulerLock` specifies a default lock duration, ShedLock will use the default lock duration for that task.
3. If neither `@SchedulerLock` nor `@EnableSchedulerLock` specify a lock duration, ShedLock will use its default lock duration, which is 10 minutes.
{% endhint %}

Add the database related properties in the **application.yml** file

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/sample_db
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
```

Run the application and verify the **logs** and **shedlock** table content.

<figure><img src="../../.gitbook/assets/image (253).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/image (254).png" alt=""><figcaption></figcaption></figure>
