# SQL AST

## About

**SQL AST (Abstract Syntax Tree)** is an internal representation of a SQL query in the form of a tree structure. In Hibernate, it represents the **intermediate form** of a query before it is translated into raw SQL.

In Hibernate, when we write a query using **JPQL**, **HQL**, or the **Criteria API**, that query doesn't go directly to the database. Instead, Hibernate performs a series of transformations to convert the query into valid SQL tailored to your database dialect. One of the most important internal representations in this process is the **SQL AST (Abstract Syntax Tree)**.

The SQL AST is a structured, tree-based representation of the SQL query. It separates **query logic** from the **actual SQL string generation**, giving Hibernate more control, flexibility, and safety during query processing.

## Purpose of SQL AST

The main reasons Hibernate uses a SQL AST layer include:

* **Separation of concerns**: SQL AST decouples high-level query structures (JPQL, HQL, Criteria) from low-level SQL string generation.
* **Database independence**: Queries can be defined once and then compiled into database-specific SQL using dialects.
* **Optimization**: SQL AST allows Hibernate to analyze and optimize queries before generating SQL.
* **Extensibility**: Developers or tool builders can plug into the query pipeline for custom behavior or transformation.

## Hibernate Query Translation Pipeline

Hibernate uses a **multi-step translation process** when executing queries:

1. **Parsing Phase**:
   * JPQL or HQL is parsed into an intermediate representation called the **Semantic Query Model (SQM)**.
   * SQM focuses on understanding the meaning of the query at the object/entity level.
2. **Semantic Model Resolution**:
   * Hibernate resolves the entities, attributes, associations, and types used in the query.
3. **SQL AST Generation**:
   * The resolved SQM is translated into a **SQL AST**.
   * This AST captures the structure of the SQL query: selects, joins, predicates, groupings, etc.
   * The AST is still database-agnostic.
4. **SQL Rendering**:
   * The SQL AST is traversed and rendered into a native SQL string using Hibernate’s SQL dialect (e.g., for PostgreSQL, MySQL).
   * At this stage, Hibernate adds things like aliases, join conditions, pagination (LIMIT/OFFSET), etc.
5. **Execution**:
   * The final SQL string is executed via JDBC using Hibernate's query engine.

## Core Components of SQL AST

Some of the important components in Hibernate’s SQL AST include:

* **SelectStatement**: Represents the entire SQL select query.
* **FromClause**: Represents the source tables and their joins.
* **SelectClause**: Defines which columns or expressions are being selected.
* **Predicate**: Represents the WHERE clause conditions.
* **OrderByClause**: Defines ordering logic.
* **GroupByClause**: Handles grouping for aggregation.
* **Parameters**: Bindable values used in WHERE, HAVING, etc.

These components form a tree structure that represents the entire SQL query logically, and Hibernate then serializes it into SQL text.

## Example: JPQL to SQL AST to SQL (Hibernate)

#### JPQL Query

```java
TypedQuery<User> query = entityManager.createQuery(
    "SELECT u FROM User u WHERE u.status = :status", User.class);
query.setParameter("status", "ACTIVE");
```

#### Step 1: Semantic Query Model (SQM)

Hibernate parses the JPQL string into an **SQM (Semantic Query Model)** which captures entity-level intent.

* **Entity**: `User`
* **Alias**: `u`
* **Predicate**: `u.status = :status`
* **Selection**: `u` (the whole entity)

The SQM is still **abstract and ORM-focused**, not yet SQL-specific.

#### Step 2: SQL AST (Hibernate Internal Representation)

Hibernate converts the SQM to a **SQL AST**, which is a structured, database-agnostic representation of what the SQL **should do**, not how it looks.

**Key SQL AST Components:**

* **SelectStatement**
  * **SelectClause**
    * Fields: `id`, `name`, `email`, `status`, etc.
  * **FromClause**
    * Table: `users` (mapped from `User` entity)
    * Alias: `u`
  * **WhereClause (Predicate)**
    * `status = ?` (parameter placeholder)

**Internally it might look like (conceptually):**

```plaintext
SelectStatement
├── SelectClause: u.id, u.name, u.email
├── FromClause: users AS u
└── WhereClause:
      └── ComparisonPredicate
           ├── Column: u.status
           └── Parameter: :status
```

Note: The AST is **not a string** but a tree of Java objects representing SQL components.

## How Hibernate Benefits from SQL AST ?

1. **Dialect-aware SQL generation**\
   SQL AST is rendered into native SQL only at the final stage. This means dialect-specific SQL differences (e.g., pagination syntax) can be handled properly without affecting how the query was defined.
2. **Reusable logic for multiple output targets**\
   The same SQL AST can be rendered differently:
   * One way for SQL logging
   * Another way for execution
   * Yet another way for query plan analysis
3. **Better handling of query complexity**\
   Nested queries, subqueries, correlated joins, derived tables, and window functions are easier to model using ASTs.
4. **Query plan optimization**\
   Hibernate can analyze the structure of the AST to detect unnecessary joins, redundant selects, or optimize predicate ordering.

## SQL AST in Hibernate 6+

Starting in Hibernate 6, the **SQL AST layer was made a formal and central part** of query generation. Before that, SQL strings were built more directly and with less structure. The changes introduced:

* A clear SQL AST model (new interfaces and classes)
* Better separation of the AST from the rendering logic
* Support for reusable components and improved query debugging

This redesign significantly improves maintainability and consistency in how queries are interpreted and executed.

