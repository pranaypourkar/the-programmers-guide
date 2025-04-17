# JPA Fundamentals

## About

JPA (Java Persistence API) is more than just annotations and queries — it provides a complete framework for managing the **lifecycle of Java objects** and synchronizing them with a relational database.

## Entities and the Persistence Context

An **entity** is a lightweight, persistent domain object that represents a table in the database.

When we persist or retrieve entities in JPA, they live inside something called the **persistence context**, which acts like a mini in-memory database for tracking and managing those entities.

{% hint style="success" %}
An Entity in JPA is a Java class mapped to a database table.
{% endhint %}

### What is a Persistence Context ?

* It is a kind of **cache** that keeps track of all the entities we’ve loaded or saved within a single transaction/session.
* If we load the same entity twice, JPA will return the same object instance.
* Changes to entities are automatically detected and synchronized to the database (this is called **dirty checking**).

## EntityManager

The `EntityManager` is the main interface used to interact with JPA.

It provides methods to

* Create or remove entities
* Find or load entities by ID
* Execute queries
* Manage transactions (in some cases)

#### Key Methods

* `persist(entity)` → Save a new entity
* `find(Entity.class, id)` → Fetch an entity by its primary key
* `merge(entity)` → Update an existing entity
* `remove(entity)` → Delete an entity
* `createQuery(...)` → Execute JPQL queries

## Entity Lifecycle States

An entity in JPA can exist in different states during its lifecycle. These states control the interaction between the entity and the persistence context, and they help manage the process of saving, updating, deleting, and retrieving entities from the database.

The JPA lifecycle states are as follows:

1. **New (Transient)**
2. **Managed (Persistent)**
3. **Detached**
4. **Removed**

### 1. New (Transient) State

An entity in the **New** state is created in memory but **not yet associated** with a persistence context (i.e., it is not yet persisted in the database).

**Key characteristics**

* The entity is not managed by JPA.
* It has no database identity because it doesn't have an associated record in the database yet.
* If we try to persist it, JPA will assign it a database identity.

**Example**

```java
Employee employee = new Employee("John", "Doe");  // Newly created object
// employee is now in the "New" state
```

**Transition to Managed State**\
To transition this entity to the **Managed** state, we need to call `persist()` using the `EntityManager`.

```java
entityManager.persist(employee);  // Now the entity becomes Managed
```

### 2. Managed (Persistent) State

When an entity is in the **Managed** state, it is associated with a **persistence context**, and any changes made to the entity will be tracked by JPA. JPA automatically synchronizes these changes to the database (either when the transaction is committed or when explicitly flushed).

**Key characteristics**

* JPA is **aware** of the entity, and any modifications to it are **automatically persisted** to the database at commit time.
* The entity is cached within the persistence context.
* If you modify the entity, JPA detects the changes (this is known as **dirty checking**) and will update the database when the transaction is committed.

**Example**

```java
entityManager.persist(employee);  // Now the entity is in the "Managed" state
employee.setFirstName("Johnathan");
// The change is tracked, and it will be synchronized with the DB later
```

**Transition to Detached or Removed:**

* **Detached:** The entity becomes detached from the persistence context (e.g., after the transaction is committed and the persistence context is closed).
* **Removed:** The entity is deleted from the database by calling `remove()`.

### 3. Detached State

An entity becomes **Detached** when it is no longer managed by the persistence context. This typically happens after the transaction ends or the persistence context is closed. The entity can still be used, but JPA no longer tracks it for changes.

**Key characteristics**

* The entity is no longer associated with the persistence context.
* Any changes made to the entity **will not** be automatically saved to the database.
* It can still be reattached to a persistence context if needed (e.g., by calling `merge()`).

**Example**

```java
entityManager.persist(employee);  // Entity is in "Managed" state
entityManager.flush();  // Flush changes to the DB and close the transaction
// After the transaction is completed, employee is now in "Detached" state
```

**Reattaching Detached Entities:** If you want to reattach a detached entity to the persistence context (so changes can be tracked again), you can use the `merge()` method:

```java
Employee reattachedEmployee = entityManager.merge(employee);  // Now it's reattached
```

**Transition to Managed:**\
The entity can be reattached to the persistence context using `merge()`, bringing it back to the **Managed** state.

### 4. Removed State

An entity is in the **Removed** state when it has been marked for deletion and is scheduled to be deleted from the database. Once an entity is removed, it is no longer part of the persistence context and will be deleted when the transaction is committed.

**Key characteristics**

* Once removed, the entity is **not available** for further operations unless it is **reinserted**.
* The entity is marked for deletion, and its corresponding database row is deleted when the transaction is committed.
* It cannot be updated or persisted again until it is recreated as a new entity.

**Example**

```java
entityManager.remove(employee);  // The entity is marked for removal
```

**Transition from Removed:**

* Once an entity is removed, it cannot transition back to the **Managed** state.
* If you want to persist it again, you would need to create a new instance and persist it.

## Persistence Unit

A **Persistence Unit** is a logical grouping of:

* **Entity classes**
* **Configuration metadata**
* **Database connection details**
* And other properties required by the **JPA provider** (like Hibernate)

It's the **core definition of how JPA should behave** for a given application or module.

A **persistence unit** is traditionally declared in a file called `persistence.xml`, but in Spring (especially Spring Boot), this is now mostly replaced by **Java-based or Spring Boot property-based configuration**.

### Why Persistence Unit Exists ?

The **Java EE specification** required a standard way to define:

* Which entities are to be managed
* Which datasource to use
* Which JPA implementation to use
* How transactions are handled

Thus, the **`persistence.xml`** was introduced.

It allows:

* Reusability (we can define multiple units)
* Vendor-agnostic configuration
* Container-managed deployment

### Traditional `persistence.xml` Structure

Located in:

```
src/main/resources/META-INF/persistence.xml
```

#### Example

```xml
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             version="2.2">
  <persistence-unit name="myPersistenceUnit" transaction-type="RESOURCE_LOCAL">
    <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
    <class>com.example.model.Employee</class>
    <properties>
      <property name="javax.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
      <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/mydb"/>
      <property name="javax.persistence.jdbc.user" value="root"/>
      <property name="javax.persistence.jdbc.password" value="password"/>
      <property name="hibernate.hbm2ddl.auto" value="update"/>
      <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL5Dialect"/>
    </properties>
  </persistence-unit>
</persistence>
```

### How it works internally?

When the application starts:

* The JPA provider scans `META-INF/persistence.xml`
* It identifies the persistence unit(s)
* It builds a `PersistenceUnitInfo` object
* Then creates the `EntityManagerFactory` based on it

### Do we still need `persistence.xml` in Spring Boot?

**No.** In **Spring Boot**, the need for `persistence.xml` is removed because:

* Spring Boot **auto-configures** the datasource, JPA provider, and entity scanning.
* Entities are discovered from your classpath.
* Configuration is handled via `application.properties` or `application.yml`.

Instead of `persistence.xml`, we write

```properties
# application.properties

spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=secret

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

Behind the scenes, Spring Boot **creates a default persistence unit** and configures `EntityManagerFactory` using this info.

## Transaction Management

JPA requires a **transaction** to:

* Persist new entities
* Update or delete existing ones
* Run any modifying query

In a Java EE or Spring environment, this is usually handled using `@Transactional`.

Without a transaction:

* Reads may work
* Writes will often fail or behave unpredictably
